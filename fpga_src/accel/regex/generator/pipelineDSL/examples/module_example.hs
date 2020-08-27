import Hardware.PipelineDSL

main = putStrLn $ verilogM "add_one" $ do
    i <- input "in1" 5
    output "out1" $ i + 1
