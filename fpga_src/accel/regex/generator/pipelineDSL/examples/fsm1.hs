import Hardware.PipelineDSL

(.==) = BinaryOp (Cmp Equal)
(.!=) = BinaryOp (Cmp NotEqual)
cc = MultyOp Concat
decr x = x .= x - 1
wait1 = wait $ 1

main = putStrLn $ toVerilog $ do
    let s1 = (Alias "sig" 2)
    p <- mkReg []
    counter <- mkReg []

    xx <- mkReg []

    fsm $ do

        wait_some <- task $ do
            wait1
            c <- decr counter
            goto c $ counter .!= 0
            wait1

        let
            waitn n = do
                counter .= width 32 (n - 2)
                call wait_some

        p .= 3
        waitn 10
        p .= 18
        waitn 67
        p .= 31
        waitn 13
        p .= 72
        xx .= cc [p, counter]

        return ()
