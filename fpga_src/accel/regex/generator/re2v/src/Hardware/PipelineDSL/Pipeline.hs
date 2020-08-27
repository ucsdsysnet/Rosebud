module Hardware.PipelineDSL.Pipeline (
    sigp,
    stage,
    stagen,
    HW (..),
    PipeM (..),
    PStage (..),
    StgMap (..),
    Reg (..),
    LogicStage (..),
    ASTHook (..),
    getSignalWidth,
    rPipe,
    rHW,
    pPort,
    IPortNB (..),
    stageEn,
    stageEnN,
    stageConditional,
    verilog
) where

import Control.Monad
import Control.Applicative
import Data.Monoid ( (<>) )
import Control.Monad.Fix
import Data.Ix (range)
import Control.Monad.Trans.RWS.Lazy hiding (Sum)
import Data.Monoid hiding (Sum)
import Data.Maybe (fromMaybe, catMaybes)
import Hardware.PipelineDSL.HW hiding (Signal)
import qualified Hardware.PipelineDSL.HW as HW
import Control.Monad.Trans.Class (lift)
import Hardware.PipelineDSL.Verilog
import qualified Data.Semigroup as S

data PStage = PStage { pipeStageId :: Int
                     , pipeStageSignal :: Signal
                     , pipeStagePass :: Signal
                     , pipeStageStageNum :: Int
                     , pipeStageUpstreamStages :: [PStage]
                     , pipeStageDownstreamStages :: [PStage]
                     , pipeStageRdy :: Signal
                     , pipeStageName :: String
                     , pipeStageDelaysNum :: Int
                     , pipeStageBufferDepth :: Int
                     , pipeStageLogicStages :: [Signal] }

data IPortNB = IPortNB { portEn :: Signal
                       , portData :: Signal }

data ASTHook = Stage LogicStage
             | PipelineStage PStage
             | IPipePortNB IPortNB
             | Cond Signal Signal -- conditional signal valid, value
type Signal = HW.Signal ASTHook
-- list all pipeline stages that are inputs for a given signal

filterHooks f s = catMaybes $ map f $ queryRefs s

queryUpstreamStages :: Signal -> [PStage]
queryUpstreamStages = filterHooks pipef

queryIPipePortNBs :: Signal -> [IPortNB]
queryIPipePortNBs = filterHooks portf

queryUpstreamLStages :: Signal -> [LogicStage]
queryUpstreamLStages = filterHooks lstgf

pipef (PipelineStage p) = Just p
pipef _ = Nothing
portf (IPipePortNB p) = Just p
portf _ = Nothing
lstgf (Stage p) = Just p
lstgf _ = Nothing

-- longest distance to current stage
-- shorter paths need to be compensated
-- returns 0 if there is no paths connecting specifid stage
downstreamDist :: Int -> Signal -> Int
downstreamDist stgid sig = r stgidPaths where
    -- get all stages and distances
    -- returns an array of pairs: [(distance, stage)]
    allStgsDist sig = c ++ n where
        t = queryUpstreamStages sig
        c = map ((,) 0) t
        n = map (\(x, y) -> (x + 1, y)) $ concat $ map (allStgsDist . pipeStageSignal) t
    stgidPaths = filter (\(_, s) -> (pipeStageId s) == stgid) $ allStgsDist sig
    r [] = 0
    r x = maximum $ map fst x

data StgMap = StgMap { smStages :: [(Int, PStage)] }

instance S.Semigroup StgMap where
    (<>) (StgMap s) (StgMap s') = StgMap (s <> s')

instance Monoid StgMap where
    mempty = StgMap []
    mappend = (<>)

type PipeM = RWST PipeCtrl StgMap Int (HW ASTHook)

data PipeCtrl = PipeCtrl { pipeCtrlStages :: [(Int, PStage)]}

data PipeStageLogic = PipeStageLogic { pslRdy  :: Signal
                                     , pslDep  :: Signal
                                     , pslDe   :: Signal
                                     , pslRdyn :: Signal
                                     , pslTake :: Signal -- flop enable signal
                                     , pslTakeNext :: Signal
                                     , pslDrop :: Signal
                                     , pslDropNext :: Signal
                                     , pslClr :: Signal }

rPipe f = (a', sigs, sm) where
    stgs = smStages sm
    pipectrl = PipeCtrl stgs
    m = runRWST f pipectrl 0 -- Pipe
    r@((a', _, sm), _, sigs) = runRWS m () 0 -- HW

verilog :: PipeM a -> String
verilog f = toVerilog m where
    stgs = smStages sm
    pipectrl = PipeCtrl stgs
    m = runRWST f pipectrl 0 -- Pipe
    r@((_ , _, sm), _, w) = runRWS m w 0 -- HW


sigp :: Signal -> PipeM Signal
sigp s = lift $ sig s

pPort :: Signal -> Signal -> Signal
pPort en s = ExtRef (IPipePortNB $ IPortNB {portData = s, portEn = en}) s

data LogicStage = LogicStage { lsCtrl :: PipeStageLogic
                             , lsSignal :: Signal
                             , lsReg :: Signal }

stageControl name input vld rdy downstreamStages = mfix $ \me -> do
    let
        or' = MultyOp Or
        and' = MultyOp And
        not' = UnaryOp Not

        upstreamStages = queryUpstreamLStages input
        upstreamPorts = queryIPipePortNBs input
        rdy' = and' [rdy, (and' (map (pslRdy . lsCtrl) $ upstreamStages))]
        deUpStgs = map (pslDe . lsCtrl) $ upstreamStages
        deUIPortNBs = map portEn upstreamPorts
        dep' = and' $ deUpStgs ++ deUIPortNBs
        drp = not' vld
        ExtRef (Stage mestg) _ = me
        take' = and' [rdy', dep', not' drp, or' [not' $ pslDe $ lsCtrl mestg, takenext']]
        dsLStgs = concat $ map queryUpstreamLStages downstreamStages
        takenext' = and' $ map (pslTake . lsCtrl) $ dsLStgs
        dropnext' = and' $ map (pslDrop . lsCtrl) $ dsLStgs
        declr = and' [not' take', (or' [takenext', dropnext'])]
        clr = and' [not' take', (or' [takenext', dropnext'])]

    dereg <- mkNReg (name ++ "_dereg") [(take', 1), (declr, 0)]
    reg <- mkNRegX (name ++ "_lstgr") [(take', input), (clr, Undef)]
    sign (name ++ "_take") take'
    sign (name ++ "_rdy") rdy'
    
    let
        ctrl = PipeStageLogic
            { pslRdy = rdy'
            , pslDep = dep'
            , pslDe  = dereg
            , pslRdyn = and' $ map (pslRdy . lsCtrl) $ dsLStgs
            , pslTake = take'
            , pslTakeNext = takenext'
            , pslDrop = drp
            , pslDropNext = dropnext'
            , pslClr = clr }
    return $ ExtRef (Stage $ LogicStage ctrl input reg) reg

stage :: Signal -> PipeM Signal
stage = stage' Nothing 1 0 1

stagen :: String -> Signal -> PipeM Signal
stagen name s = stage' (Just name) 1 0 1 s

stageEn :: Signal -> Signal -> PipeM Signal
stageEn en s = stage' Nothing en 0 1 s

stageEnN :: String -> Signal -> Signal -> PipeM Signal
stageEnN name en s = stage' (Just name) en 0 1 s

stageConditional :: String -> Signal -> Signal -> PipeM Signal
stageConditional name cnd s = stage' (Just name) 1 0 cnd s

stage' :: (Maybe String) -> Signal -> Int -> Signal -> Signal -> PipeM Signal
stage' mname rdySignal bufferdepth vld inputSignal = do
    np <- get
    pipectrl <- ask
    put $ np + 1

    let
        stgs = pipeCtrlStages pipectrl
        -- calculate distances to stages that depend on current stage
        dsDistances = map (downstreamDist np) (map pipeStageSignal downstreamStages)
        passDistances = map (downstreamDist np) (map pipeStagePass downstreamStages)
        ndelays = case dsDistances ++ passDistances of
            [] -> 0
            s -> maximum s

        -- get list of downstreamStages at distance d
        pickDsByDistance d = map (head . pipeStageLogicStages . fst) $
            filter (\x -> (snd x) == d) (zip downstreamStages dsDistances) 

        ds = mapSignal mapR inputSignal
        vld' = mapSignal mapR vld
        mapR (ExtRef (PipelineStage p) _) = ls !! dist where
            ls = pipeStageLogicStages p
            dist = downstreamDist (pipeStageId p) inputSignal
        mapR x = x

        upstreamStages = queryUpstreamStages inputSignal

        stageid = case map pipeStageStageNum $ upstreamStages of
            [] -> 0
            x -> 1 + (maximum x)

        allStagesInPipeline = map snd stgs
        
        hasMeUpstream s = elem np $ map pipeStageId $ pipeStageUpstreamStages s
        downstreamStages = filter hasMeUpstream allStagesInPipeline
       
        name = fromMaybe ("stg_" ++ (show np)) mname
        stageControl' = stageControl name

    let
        f ds s = stageControl' s 1 1 ds
    r <- lift $ stageControl' ds vld' rdySignal (pickDsByDistance 0)
    ls <- lift $ foldMapM f (map pickDsByDistance [1..ndelays]) r

    let
        self = PipelineStage stg
        stg = PStage    { pipeStageId = np
                        , pipeStageSignal = inputSignal
                        , pipeStagePass = vld
                        , pipeStageStageNum = stageid
                        , pipeStageUpstreamStages = upstreamStages
                        , pipeStageDownstreamStages = downstreamStages
                        , pipeStageRdy = rdySignal
                        , pipeStageName = name
                        , pipeStageDelaysNum = ndelays
                        , pipeStageBufferDepth = bufferdepth
                        , pipeStageLogicStages = r:ls }
    tell $ mempty {smStages = [(np, stg)]}
    return $ ExtRef self $ r

-- iterate over [x] in Monad context
-- passes results of each iteration to the next one
-- returns results of all actions in a list
foldMapM _ [] _ = pure []
foldMapM f [x] p = do
    t <- f x p
    return [t]
foldMapM f (x:xn) p = do
    t <- f x p
    ((:) t) <$> foldMapM f xn t
