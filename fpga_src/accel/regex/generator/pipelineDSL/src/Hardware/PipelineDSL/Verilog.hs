-- | Verilog code generation
module Hardware.PipelineDSL.Verilog (
    toVerilog,
) where

import Data.List (intercalate)
import Data.Maybe (fromMaybe)

import Hardware.PipelineDSL.HW

mOpsSign Or = " | "
mOpsSign And = " & "
mOpsSign Sum = " + "
mOpsSign Mul = " * "

bOpsSign Sub = " - "
bOpsSign (Cmp Equal) = " == "
bOpsSign (Cmp NotEqual) = " != "
bOpsSign (Cmp LessOrEqual) = " <= "
bOpsSign (Cmp GreaterOrEqual) = " >= "
bOpsSign (Cmp Less) = " < "
bOpsSign (Cmp Greater) = " > "

uOpsSign Not = "~"
uOpsSign Neg = "-"

vcode :: Signal a -> String
vcode = vcode' . simplify . simplify . simplify . simplify  where
    vcode' (SigRef n HWNNoName _) = "sig_" ++ (show n)
    vcode' (SigRef _ (HWNExact n) _) = n
    vcode' (SigRef _ (HWNLike n) _) = n ++ "_" ++ (show n)
    vcode' (MultyOp Concat ops) = "{" ++ intercalate ", " (map vcode' ops) ++ "}"
    vcode' (MultyOp o ops) = "(" ++ intercalate (mOpsSign o) (map vcode' ops) ++ ")"
    vcode' (BinaryOp o op1 op2) = "(" ++ (vcode' op1) ++ (bOpsSign o) ++ (vcode' op2) ++ ")"

    vcode' (UnaryOp (PickBit n) op) = (vcode' op) ++ "[" ++ (show n) ++ "]"
    vcode' (UnaryOp o op@(Alias _ _)) = (uOpsSign o)  ++ (vcode' op)
    vcode' (UnaryOp o op@(SigRef _ _ _)) = (uOpsSign o)  ++ (vcode' op)
    vcode' (UnaryOp o op@(RegRef _ _)) = (uOpsSign o)  ++ (vcode' op)
    vcode' (UnaryOp o op@(LutRef _ _)) = (uOpsSign o)  ++ (vcode' op)
    vcode' (UnaryOp o op) = (uOpsSign o) ++ "(" ++ (vcode' op) ++ ")"

    vcode' (Lit val) = "'d" ++ (show val)
    vcode' (Alias n _) = n
    vcode' (WidthHint w (Lit val)) = (show w) ++ "'d" ++ (show val)
    vcode' (WidthHint _ s) = vcode' s
    vcode' Undef = "'x"
    vcode' (ExtRef _ n) = vcode' n
    vcode' (RegRef n (Reg _ _ name)) = regname n name
    vcode' (LutRef n (Lut _ _ _ name)) = lutname n name

print_width 1 = ""
print_width n = "[" ++ (show $ n - 1) ++ ":0] "

printSigs s = unlines (map printStg stgs) where
    printStg (Comb i x name declare) = intercalate "\n" [decl] where
        width = getSignalWidth x
        sig = case name of
            HWNNoName -> "sig_" ++ (show i)
            HWNLike n -> n ++ "_" ++ (show i)
            HWNExact n -> n
        decl' = "\n\nlogic " ++ (print_width width) ++ sig ++ ";\n"
        assign = "assign " ++ sig ++ " = " ++ vcode x ++ ";"
        decl = (if declare then decl' else "\n") ++ assign
    stgs = smSignals s

toVerilog m = toVerilog' s where
    (_, s) = rHW m

hwname t i HWNNoName = t ++ (show i)
hwname t i (HWNLike n) = t ++ n ++ "_" ++ (show i)
hwname t _ (HWNExact n) = n

regname = hwname "reg_"
lutname = hwname "lut_"

printLuts s = (unlines $ map printLut luts) where
    luts = smLuts s

    printLut (i, x@(Lut input value_pairs default_value mname)) = intercalate "\n" [decl] where
        width = maximum $ map (getSignalWidth . snd) value_pairs

        lut = lutname i mname

        cond (e, v) =
            (vcode e) ++ " : " ++ lut ++ " = " ++ (vcode v) ++ ";"
        caseassigns = intercalate "\n        " $ map cond value_pairs

        decl = "\nlogic " ++ (print_width width) ++ lut ++ ";\n" ++
            "always_comb begin\n" ++
            "    unique case (" ++ (vcode input) ++ ")\n        " ++
            caseassigns ++
            "\n        default: " ++ lut ++ " = " ++ (vcode default_value) ++ ";" ++
            "\n    endcase\n" ++
            "end\n\n"

toVerilog' s = (printSigs s) ++  (printLuts s) ++ (unlines $ map printStg stgs)  where
    stgs = smRegs s

    printStg (i, x@(Reg c reset_value mname)) = intercalate "\n" [decl] where
        width = maximum $ map (getSignalWidth . snd) c

        reg = regname i mname

        cond (e, v) =
            "if (" ++ (vcode e) ++ ")\n" ++
            "            " ++ reg ++ " <= " ++ (vcode v) ++ ";"
        condassigns = intercalate "\n        else " $ map cond c

        decl = "\nlogic " ++ (print_width width) ++ reg ++ ";\n" ++
            "always @(posedge clk or negedge rst_n) begin\n" ++
            "    if (rst_n == 0) begin\n" ++
            "        " ++ reg ++ " <= " ++ (vcode reset_value) ++ ";\n" ++
            "    end else begin\n        " ++ condassigns ++
            "\n    end" ++  "\nend"
