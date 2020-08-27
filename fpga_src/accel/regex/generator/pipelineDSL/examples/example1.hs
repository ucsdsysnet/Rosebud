import Control.Monad
import Control.Applicative
import Data.List (intercalate) -- nub function removes duplicates
import Data.Monoid ( (<>) )
import Control.Monad.Fix
import Data.Ix (range)

import Hardware.PipelineDSL

eq = BinaryOp (Cmp Equal)
not' = UnaryOp Not
neq s r = not' $ eq s r

t2 :: PipeM ()
t2 = do
    m <- sigp $ Alias "data1" 32
    u <- sigp 899
    let
        en = Alias "en" 1
    d <- stagen "d0" $ pPort (Alias "data1en" 1) (Alias "data1" 32)
    d1 <- stagen "d1" $ d + 7 + d -- 1
    d2 <- stagen "d2" $ d1 + 19 -- 2
    d3 <- stageConditional "d3" (neq d 13) $ d - 13 + d2 -- 3
    d4 <- stagen "d4" d3
    d5 <- stageEnN "d5" en d4

    return ()

-- how to run icarus verilog
-- iverilog x.v -g2005-sv -o x && vvp x

main = do
    -- putStr $ toSMT_LIBv2 t2
    putStr $ verilog t2
