import Hardware.PipelineDSL
import Data.Char
import Control.Monad
import Control.Monad.Trans.Class (lift)

(.==) = BinaryOp (Cmp Equal)
(.!=) = BinaryOp (Cmp NotEqual)
(.!) o n = UnaryOp (PickBit n) o
reg = mkReg []
regn n = mkNReg n []

decr x = x .= x - 1
wait1 = wait $ Lit 1
l1 = Lit 1
l0 = Lit 0
chrToS n = width 8 (Lit (ord n))

fpgaSpeed = 50000000
uartBaudRate = 9600
uartDelayClocks = quot fpgaSpeed uartBaudRate

jmp l = goto l 1

loop a = do
    l <- label
    a
    jmp l

waitD = do
    counter <- lift $ reg
    wait_some <- task $ do
        wait1
        c <- decr counter
        goto c $ counter .!= 0
        wait1

    let
        waitn n = do
            counter .= width 16 ((fromIntegral n) - 2)
            call wait_some
    return waitn

waitMsD delay1ms = do
    counter <- lift $ reg
    wait_some <- task $ do
        c <- label
        delay1ms
        decr counter
        goto c $ counter .!= 0
    let
        waitn n = do
            counter .= width 16 (n - 2)
            call wait_some
    return waitn

main = putStrLn $ toVerilog $ do
    chr <- reg
    dout <- regn "doutx"

    fsm $ do
        dout .= l1
        waitn <- waitD

        let
            baudDelay = waitn uartDelayClocks
            delay1ms = waitn $ quot fpgaSpeed 1000

        waitMs <- waitMsD delay1ms

        putc' <- task $ do
            dout .= l0
            forM [0..7] $ \n -> do
                baudDelay
                dout .= chr .! n
            baudDelay
            dout .= l1
            waitn $ uartDelayClocks * 5

        let
            putc n = do
                chr .= chrToS n
                call putc'

            printLnUART m = do
                forM m $ \c -> do
                    putc c

        loop $ do
            printLnUART "Hello\n"
            waitMs 400
            
        return ()
