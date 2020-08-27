module Hardware.PipelineDSL.Debug (
    printPipeStages
) where

import Hardware.PipelineDSL.Pipeline
import Hardware.PipelineDSL.Verilog

instance Show Reg where
    show (Reg s) = intercalate "\n" v where
        v = map pr s
        pr (en, r) = (vcode en) ++ " : " ++ (vcode r)

printPipeStages m = unlines (map printStg stgs) where
    printStg (i, x) = intercalate "\n" [decl] where
        s = "stage  : id "  ++ (pipeStageName x) ++ " * " ++ show (i) 
        name = (pipeStageName x)
        decl = s ++ "\nlogic [31:0] " ++ name ++ ";"

    stgs = smStages $ rHW m