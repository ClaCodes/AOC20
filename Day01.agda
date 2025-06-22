{-# OPTIONS --guardedness #-}

open import Data.List using (List; map; cartesianProduct; zip; foldr; _∷_; [])
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Unit.Base using (⊤)
open import Data.Nat.Show using (show; readMaybe)
open import Data.Nat using (ℕ; _*_; _+_; _≟_)
open import Data.Product.Base using (_×_; uncurry′; _,_)
open import Data.String.Base using (String; lines; unlines)
open import IO using (IO; pure; _>>_; _>>=_; putStr; putStrLn)
open import Relation.Nullary using (yes; no)
open import System.Exit using (exitSuccess; exitFailure)

open import Lib using (expect)


pairwiseSum : List ℕ -> List ℕ -> List ℕ
pairwiseSum as bs = map (uncurry′ _+_) (cartesianProduct as bs)

pairwiseProduct : List ℕ -> List ℕ -> List ℕ
pairwiseProduct as bs = map (uncurry′ _*_) (cartesianProduct as bs)

tripleSum : List ℕ -> List ℕ -> List ℕ -> List ℕ
tripleSum as bs cs = pairwiseSum (pairwiseSum as bs) cs

tripleProduct : List ℕ -> List ℕ -> List ℕ -> List ℕ
tripleProduct as bs cs = pairwiseProduct (pairwiseProduct as bs) cs

compareA : List ℕ -> List (ℕ × ℕ)
compareA ns = zip (pairwiseSum ns ns) (pairwiseProduct ns ns)

compareB : List ℕ -> List (ℕ × ℕ)
compareB ns = zip (tripleSum ns ns ns) (tripleProduct ns ns ns)

searcher : (ℕ × ℕ) → Maybe ℕ → Maybe ℕ
searcher (a , b) n with a ≟ 2020
searcher (a , b) n | yes _ = just b
searcher (a , b) n | no _  = n

solveA : List ℕ -> Maybe ℕ
solveA ns = foldr searcher nothing (compareA ns)

solveB : List ℕ -> Maybe ℕ
solveB ns = foldr searcher nothing (compareB ns)

checkNat : String → IO ℕ
checkNat s with readMaybe 10 s
... | (just x) = pure x
... | nothing = do
  putStr "Invalid number: "
  putStrLn s
  exitFailure

day01 : String -> IO ⊤
day01 input = do
  numbers <- IO.List.mapM checkNat (lines input)
  solutionA <- expect "Could not find solution for part A" (solveA numbers)
  putStrLn (show solutionA)
  solutionB <- expect "Could not find solution for part B" (solveB numbers)
  putStrLn (show solutionB)
  exitSuccess
