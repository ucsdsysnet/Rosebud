module Hardware.PipelineDSL.Module (
    input,
    output,
    verilogM
) where

import Hardware.PipelineDSL.HW
import Hardware.PipelineDSL.Verilog 
import Control.Monad.Trans.Writer.Lazy
import Control.Monad.Trans.Class (lift)
import Data.List (intercalate)

data Port = InputPort String Int | OutputPort String
type SignalM = Signal ()
type ModuleM = WriterT [Port] (HW ())

input :: String -> Int -> ModuleM SignalM
input n w = do
    tell $ [InputPort n w]
    return (Alias n w)

output :: String -> SignalM -> ModuleM ()
output n s = do
    tell $ [OutputPort n]
    lift $ sigalias' n s
    return ()

verilogM :: String -> ModuleM a -> String
verilogM name m = interface ++ code ++ "endmodule" where
    pp (InputPort s w) = "input logic [" ++ (show $ w - 1) ++ ":0] " ++ s
    pp (OutputPort s) = "output " ++ s
    hw = runWriterT m
    ((_, ports), _) = rHW $ hw
    interface = "module " ++ name ++ "(input logic clk, input logic rst_n, " ++ (intercalate ", " $ map pp ports) ++ ");"
    code = toVerilog hw
