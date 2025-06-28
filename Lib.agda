{-# OPTIONS --guardedness #-}

open import Data.String using (String)
open import IO using (IO; pure; _>>_; _>>=_; putStrLn)
open import System.Exit using (exitFailure)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.List using (List; foldr; _∷_; [])

expect : {A : Set} -> String -> Maybe A -> IO A
expect error (just n) = pure n
expect error nothing = do
  putStrLn error
  exitFailure

allJustRec : {A : Set} -> Maybe A -> Maybe (List A) -> Maybe (List A)
allJustRec nothing _ = nothing
allJustRec (just x) nothing = nothing
allJustRec (just x) (just xs) = just (x ∷ xs)

allJust : {A : Set} -> List (Maybe A) -> Maybe (List A)
allJust = foldr allJustRec (just [])
