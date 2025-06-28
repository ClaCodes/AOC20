{-# OPTIONS --guardedness #-}

open import Data.String using (String)
open import IO using (IO; pure; _>>_; _>>=_; putStrLn)
open import System.Exit using (exitFailure)
open import Data.Maybe using (Maybe; just; nothing)

expect : {A : Set} -> String -> Maybe A -> IO A
expect error (just n) = pure n
expect error nothing = do
  putStrLn error
  exitFailure
