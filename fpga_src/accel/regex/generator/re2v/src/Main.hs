{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Attoparsec.ByteString.Char8
import Data.ByteString.Char8 (pack)
import Hardware.PipelineDSL
import Data.Char (ord)
import Control.Monad.Trans.Reader
import Control.Monad.Trans.Class (lift)
import Control.Monad.Fix
import Control.Monad (forM)
import System.Environment (getArgs)
import System.Exit (exitFailure)

data Re = Exact Char | Class Bool [ClassEntry] | Grp [[QRe]] | Any deriving (Show)
data QRe = QRe Re Quantifier deriving (Show)
data ClassEntry = ExactCE Char | RangeCE Char Char deriving (Show)
data Quantifier = QNoMoreThan Int | QAtLeast Int | QExact Int Int deriving (Show)
type SignalR = Signal ()

captureGrp = Grp <$> ("(" *> (re1 ")|") <* ")")
anyC = "." *> pure Any
escaped = Exact <$> ("\\" *> anyChar)

notThese p = Exact <$> (satisfy $ notFrom p) where
    notFrom :: [Char] -> Char -> Bool
    notFrom p c = all (/= c) p

-- character class examples: [ab] [0-9a-z] [^a-bc] [a\]]
classC = Class <$> choice [inverted, not_inverted] <*> content <* "]" where
    escaped = choice [notChar ']', "\\" *> anyChar]
    range = RangeCE <$> escaped <*> (char '-' <* anyChar)
    single = ExactCE <$> escaped
    inverted = "[^" *> pure True
    not_inverted = "[" *> pure False
    content = many1 $ choice [range, single]

-- quantifiers * ? {n,} {n,p}
quantifier = choice [s, p, q, atleast, nomorethan, range, exactrange] where
    s = "*" *> (pure $ QAtLeast 0)
    p = "+" *> (pure $ QAtLeast 1)
    q = "?" *> (pure $ QExact 0 1)
    atleast = QAtLeast <$> ("{" *> decimal <* ",}")
    nomorethan = QNoMoreThan <$> ("{," *> decimal <* "}")
    range = QExact <$> ("{" *> decimal <* ",") <*> (decimal <* "}")
    exactrange = do
        n <- "{" *> decimal <* "}"
        return $ QExact n n 

-- try to parse with quantifier, if fails use default {1,1}
withQuantifier r = QRe <$> r <*> choice [quantifier, (pure $ QExact 1 1)]

exactC = notThese ")"

re1 p = sepBy (many1 c) $ "|" where
    c = choice $ map withQuantifier [escaped, classC, captureGrp, anyC, notThese p]
re = re1 "|"

classHWCondition c inv s = inverted inv where
    inverted True = not' $ or' $ map cond c
    inverted _ = or' $ map cond c
    cond (ExactCE c) = eq s $ charL c
    cond (RangeCE charl charh) = and' [condh, condl] where
        condh = BinaryOp (Cmp LessOrEqual) s $ charL charh
        condl = BinaryOp (Cmp GreaterOrEqual) s $ charL charl

type ReHW = ReaderT SignalR (HW ())

or' = MultyOp Or
and' = MultyOp And
charL c = Lit (ord c)
eq = BinaryOp (Cmp Equal)
not' = UnaryOp Not
neq s r = not' $ eq s r

toHW (Exact c) = singleCharMatch $ eq $ charL c
toHW Any = singleCharMatch $ \_ -> Lit 1 -- this case can be optimized
toHW (Class i e) = singleCharMatch $ classHWCondition e i
toHW (Grp m) = toHW' m

toHW' :: [[QRe]] -> SignalR -> ReHW SignalR
toHW' rs p = do
    ms <- forM rs $ \s -> do
        let quantify (QRe r q) = applyQuantifier q (toHW r)
        (m, _) <- (chain $ map quantify s) p
        return m
    return $ or' ms

singleCharMatch :: (SignalR -> SignalR) -> SignalR -> ReHW SignalR
singleCharMatch match prev = do
    s <- ask
    let cond = and' [prev, match s]
    lift $ mkReg [(cond, Lit 1), (not' cond, Lit 0)]

-- loop NFA
loop :: (SignalR -> ReHW SignalR) -> SignalR -> ReHW SignalR
loop r p = mfix $ \feedback -> r $ or' [feedback, p]

-- chain sequential NFAs
chain :: [(SignalR -> ReHW SignalR)] -> SignalR -> ReHW (SignalR, [SignalR]) 
chain [] p = pure (p, [])
chain [r] p = do
    m <- r p
    return (m, [m])
chain (r:rs) p = do
    m <- r p
    (m', ms) <- chain rs m
    return (m', m:ms)

--
applyQuantifier :: Quantifier -> (SignalR -> ReHW SignalR) -> SignalR -> ReHW SignalR
applyQuantifier (QExact 1 1) r p = r p
applyQuantifier (QAtLeast 1) r p = loop r p
applyQuantifier (QAtLeast 0) r p = do
    m <- (loop r) p
    return $ or' [m, p]
applyQuantifier (QAtLeast n) r p = do
    (m, _) <- (chain $ (replicate (n - 1) r) ++ [loop r]) p
    return m
applyQuantifier (QExact n h) r p = do
    (m, _) <- (chain $ replicate (n) r) p
    (_, ms) <- (chain $ replicate (h - n) r) m
    return $ or' (m:ms)
applyQuantifier (QNoMoreThan n) r p = do
    (_, ms) <- (chain $ replicate n r) p
    return $ or' (p:ms)

re2v r = verilogM "re" $ do
    i <- input "in" 8
    m <- lift $ runReaderT (toHW' r (Lit 1)) i
    output "match" m

main :: IO ()
main = do
    a <- getArgs
    case a of
        (r:[]) -> case parseOnly re $ pack r of
            (Right r) -> putStrLn $ re2v r
            _ -> putStrLn "Cannot parse regular expression." >> exitFailure
        _ -> putStrLn "Usage re2v <regular expression>. For example: re2v 'aa(re.)[^abc-9]|t'" >> exitFailure 
