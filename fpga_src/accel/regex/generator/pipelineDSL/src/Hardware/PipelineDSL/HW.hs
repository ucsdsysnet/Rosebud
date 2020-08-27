module Hardware.PipelineDSL.HW (
    sig,
    sign,
    sigalias,
    sigalias',
    HW (..),
    Signal (..),
    SigMap (..),
    MOps (..),
    BOps (..),
    UOps (..),
    CmpOp (..),
    Reg (..),
    RegC (..),
    Lut (..),
    HWName (..),
    Comb (..),
    simplify,
    getSignalWidth,
    rHW,
    mkReg,
    mkNReg,
    mkNRegX,
    mkRegI,
    queryRefs,
    mapSignal,
    addC,
    width,
    mkLut
) where

import Control.Monad
import Control.Applicative
import Data.Monoid hiding (Sum)
import Control.Monad.Fix
import Data.Ix (range)
import Control.Monad.Trans.RWS.Lazy hiding (Sum)
import Data.Maybe (fromMaybe)
import qualified Data.Semigroup as S

data CmpOp = Equal | NotEqual | LessOrEqual | GreaterOrEqual | Less | Greater
data MOps = Or | And | Sum | Mul | Concat
data BOps = Sub | Cmp CmpOp
data UOps = Not | Neg | Signum | Abs | PickBit Int

-- use this name in generated code, pick any, use exactly this one or like this one
-- with suffix to avoid conflicts
data HWName = HWNNoName | HWNExact String | HWNLike String

-- AST representation
data Signal a = Alias String Int -- name, width
            | Lit Int -- toInteger, width can be fixed or any (value, width)
            | SigRef Int HWName (Signal a)
            | ExtRef a (Signal a)   -- signal reference managed outside of HW monad
            | UnaryOp UOps (Signal a)
            | MultyOp MOps [(Signal a)]
            | BinaryOp BOps (Signal a) (Signal a)
            | Undef
            | RegRef Int (Reg a) -- register, inserts 1 clock delay
            | LutRef Int (Lut a)
            | WidthHint Int (Signal a)


getSignalWidth :: Signal a -> Int
getSignalWidth s = getSignalWidth' [] s where
    -- first [Int] arg allows refs to reference themselves
    -- without creating circular dependencies
    getSignalWidth' r (SigRef ref _ s) = if elem ref r then 0 else getSignalWidth' (ref:r) s
    getSignalWidth' r (MultyOp _ []) = undefined -- never happens
    getSignalWidth' r (MultyOp Concat s) = foldr (+) 0 $ map (getSignalWidth' r) s
    getSignalWidth' r (MultyOp _ s) = maximum $ map (getSignalWidth' r) s
    getSignalWidth' _ (BinaryOp (Cmp _) _ _) = 1
    getSignalWidth' r (BinaryOp _ s1 s2) = max (getSignalWidth' r s1) (getSignalWidth' r s2)
    getSignalWidth' _ (UnaryOp (PickBit _) _) = 1
    getSignalWidth' r (UnaryOp _ s) = getSignalWidth' r s
    getSignalWidth' _ (Lit v) = reprWidth v
    getSignalWidth' r (Alias _ s) = s
    getSignalWidth' _ (WidthHint s _) = s
    getSignalWidth' _ (RegRef _ (Reg [] _ _)) = 0
    getSignalWidth' r (RegRef ref' (Reg s _ _)) = if elem ref' r then 0 else
        maximum $ map ((getSignalWidth'  (ref':r)) . snd) s
    getSignalWidth' _ (LutRef _ (Lut _ [] _ _)) = 0
    getSignalWidth' r (LutRef ref' (Lut _ s _ _)) = if elem ref' r then 0 else
        maximum $ map ((getSignalWidth'  (ref':r)) . snd) s
    getSignalWidth' r Undef = 0
    getSignalWidth' r (ExtRef _ s) = getSignalWidth' r s

mapSignal :: (Signal a -> Signal a) -> Signal a -> Signal a
mapSignal f s =  mapSignal' (f s) where
    -- mapSignal aplies the transformation, mapSignal' does structure-preserving traversing
    mapSignal' (MultyOp op s) = MultyOp op $ map (mapSignal f) s
    mapSignal' (BinaryOp op s1 s2) = BinaryOp op (mapSignal f s1) (mapSignal f s2)
    mapSignal' (UnaryOp op s) = UnaryOp op (mapSignal f s)
    mapSignal' (SigRef n name s) = SigRef n name (mapSignal f s)
    mapSignal' (WidthHint w s) = WidthHint w (mapSignal f s)
    mapSignal' x = x

rewrite :: (Signal a -> Signal a) -> Signal a -> Signal a
rewrite f s =  f $ rewrite' (f s) where
    -- rewrite aplies the transformation, rewrite' does structure-preserving traversing
    rewrite' (MultyOp op s) = f $ MultyOp op $ map (rewrite f) s
    rewrite' (BinaryOp op s1 s2) = f $ BinaryOp op (rewrite f s1) (rewrite f s2)
    rewrite' (UnaryOp op s) = f $ UnaryOp op (rewrite f s)
    rewrite' (SigRef n name s) = f $ SigRef n name (rewrite f s)
    rewrite' (WidthHint w s) = f $ WidthHint w (rewrite f s)
    rewrite' x = x

queryRefs :: Signal a -> [a]
queryRefs (ExtRef x _) = [x]
queryRefs (SigRef _ _ s) = queryRefs s
queryRefs (MultyOp _ s) = concat $ map queryRefs s
queryRefs (BinaryOp _ s1 s2) = (queryRefs s1) ++ (queryRefs s2)
queryRefs (UnaryOp _ s) = queryRefs s
queryRefs (WidthHint _ s) = queryRefs s
queryRefs _ = []

-- apply some rewrite rules to improve readability of generated verilog
-- use mapSignal to apply rules recursively
simplify :: Signal a -> Signal a
simplify = rewrite smpl where
    smpl (UnaryOp Not (Lit 1)) = 0
    smpl (UnaryOp Not (Lit 0)) = 1
    smpl (UnaryOp Not (UnaryOp Not s)) = s

    smpl (MultyOp Concat [s]) = s

    smpl (MultyOp Or s) = if (any (not . f0) s) then r1 else r where
        r = case (filter f1 s) of 
            [] -> 1
            [x] -> x
            x -> MultyOp Or x

    smpl (MultyOp And s) = r where
        r = case (filter f0 s) of 
            [] -> 1
            [x] -> x
            x -> MultyOp And x
 
    smpl x = x

    f1 (Lit 0) = False
    f1 _ = True
    f0 (Lit 1) = False
    f0 _ = True

    r0 = Lit 0
    r1 = Lit 1

{-
-- convert user type to Signal representation
-- for example (a, b)
class ToSignal a where
    toSignal :: a -> Signal
    fromSignal :: Signal -> a
-}

instance Num (Signal a) where
    abs = UnaryOp Abs
    negate = UnaryOp Neg
    (*) x y = MultyOp Mul [x, y]
    (+) x y = MultyOp Sum [x, y]
    (-) = BinaryOp Sub
    signum = UnaryOp Signum
    fromInteger x = Lit (fromInteger x)

data Comb a = Comb { ciid :: Int
                    , cisignal :: Signal a
                    , ciname :: HWName
                    , cideclare :: Bool } -- do we need to declare this signal

-- condition/value pairs, initial(reset) value, optional name
data Reg a = Reg [(Signal a, Signal a)] (Signal a) HWName

-- input, lookup/value pairs, default value, optional name
data Lut a = Lut (Signal a) [(Signal a, Signal a)] (Signal a) HWName

-- add additional conditions to existing reg
data RegC a = RegC Int [(Signal a, Signal a)]

-- HW accumulator type
data SigMap a = SigMap { smSignals :: [Comb a]
                       , smRegs :: [(Int, Reg a)]
                       , smLuts :: [(Int, Lut a)]
                       , smRegCs :: [RegC a] }
instance S.Semigroup (SigMap a) where
    (<>) (SigMap s1 s2 s3 s4) (SigMap s1' s2' s3' s4') = SigMap (s1 <> s1') (s2 <> s2') (s3 <> s3') (s4 <> s4')

instance Monoid (SigMap a) where
    mempty = SigMap [] [] [] []

type HW a = RWS (SigMap a) (SigMap a) Int

rHW m = (a, sigs) where
    r@(a, _, sigs) = runRWS m sigs 0

-- creates reference
sig :: Signal a -> HW a (Signal a)
sig inputSignal = sig' inputSignal HWNNoName True

sign :: String -> Signal a -> HW a (Signal a)
sign name inputSignal = sig' inputSignal (HWNLike name) True

sigalias :: String -> Signal a -> HW a (Signal a)
sigalias name inputSignal = sig' inputSignal (HWNExact name) True

sigalias' :: String -> Signal a -> HW a (Signal a)
sigalias' name inputSignal = sig' inputSignal (HWNExact name) False

sig' :: Signal a -> HWName -> Bool -> HW a (Signal a)
sig' inputSignal name decl = do
    n <- get
    put $ n + 1
    tell $ mempty {smSignals = [Comb n inputSignal name decl]}
    return $ SigRef n name inputSignal

mkRef :: Signal a -> HW a (Signal a, Int)
mkRef s = do
    r <- sig s
    let (SigRef i _ _) = r
    return (r, i)

mkReg :: [(Signal a, Signal a)] -> HW a (Signal a)
mkReg = mkReg' HWNNoName 0
mkNReg n = mkReg' (HWNExact n) 0
mkNRegX n = mkReg' (HWNExact n) Undef

mkRegI p i = mkReg' HWNNoName i p

mkReg' :: HWName -> Signal a -> [(Signal a, Signal a)]  -> HW a (Signal a)
mkReg' name reset_value reginput = do
    n <- get
    rc <- smRegCs <$> ask
    put $ n + 1
    let 
        thisR (RegC n' cc) = if n' == n then cc else []
        tc = concat $ map thisR rc -- additional conditions added using addC function
        r = Reg (reginput ++ tc) reset_value name

    tell $ mempty {smRegs = [(n, r)]}
    return $ RegRef n r

mkLut' :: HWName -> Signal a -> Signal a -> [(Signal a, Signal a)]  -> HW a (Signal a)
mkLut' name input default_value lutpairs = do
    n <- get
    put $ n + 1
    let 
        r = Lut input lutpairs default_value name

    tell $ mempty {smLuts = [(n, r)]}
    return $ LutRef n r

mkLut = mkLut' HWNNoName

-- add additional condition/value pairs to existing reg
-- used mostly in FSM logic
-- very unsafe pattern matching
addC :: Signal a -> [(Signal a, Signal a)] -> HW a ()
addC (RegRef i _) c = tell $ mempty {smRegCs = [RegC i c]}

width = WidthHint

-- compute the necessary number of bits to represent a number
reprWidth :: Int -> Int
reprWidth i = rw' 1 1 where
    rw' n v =
        if i <= v then
            n
        else
            rw' (n + 1) (v * 2)
