{-# OPTIONS --guardedness  #-}

module Day02 where
  module impl where
    open import Data.Bool using (Bool; false; _xor_; _∧_)
    open import Data.Char.Base as Char using (Char; _≈ᵇ_)
    open import Data.List using (List; _∷_; []; length; filterᵇ; map; head; drop)
    open import Data.Maybe using (Maybe; just;  _>>=_)
    open import Data.Nat.Show using (readMaybe)
    open import Data.Nat using (ℕ; suc; _≤ᵇ_)
    open import Data.String using (String; toList; lines; linesByᵇ; words)
    open import Lib using (allJust)

    record Constraint : Set where
        field
            low : ℕ
            high : ℕ
            char : Char
            password : List Char

    -- Solve A (check character occurences within bounds) --
    countOccurences : Char -> List Char -> ℕ
    countOccurences c s = length (filterᵇ (_≈ᵇ_ c) s)

    schemeA : Constraint -> Bool
    schemeA v = ((Constraint.low v) ≤ᵇ actual) ∧ (actual ≤ᵇ (Constraint.high v)) where
        actual = countOccurences (Constraint.char v) (Constraint.password v)

    -- Solve B (check only one position has reference character, 1-based indexing) --
    checkCharAtPosition : ℕ -> Char -> List Char -> Bool
    checkCharAtPosition _ _ [] = false
    checkCharAtPosition 0 _ (x ∷ xs) = false
    checkCharAtPosition (suc 0) c (x ∷ xs) = (c ≈ᵇ x)
    checkCharAtPosition (suc n) c (x ∷ xs) = checkCharAtPosition n c xs

    atLowerPosition : Constraint -> Bool
    atLowerPosition v = checkCharAtPosition (Constraint.low v) (Constraint.char v) (Constraint.password v)

    atHigherPosition : Constraint -> Bool
    atHigherPosition v = checkCharAtPosition (Constraint.high v) (Constraint.char v) (Constraint.password v)

    schemeB : Constraint -> Bool
    schemeB v = ((atLowerPosition v) xor (atHigherPosition v))

    -- Parse input --
    parseConstraint : String → Maybe Constraint
    parseConstraint input = do
      let ws = words input
      limitString <- head ws
      charString <- head (drop 1 ws)
      passwordString <- head (drop 2 ws)

      let limits = linesByᵇ (_≈ᵇ_ '-') limitString
      lowerLimitString <- head limits
      higherLimitString <- head (drop 1 limits)
      low <- readMaybe 10 lowerLimitString
      high <- readMaybe 10 higherLimitString

      char <- head (toList charString)
      let password = toList passwordString

      just record { low = low; high = high; char = char; password = password }

    toConstraints : String -> Maybe (List Constraint)
    toConstraints input = allJust (map parseConstraint (lines input))

  module io where
    open import Data.List using (length; filterᵇ)
    open import Data.Nat.Show using (show)
    open import Data.String using (String)
    open import Data.Unit using (⊤)
    open import IO using (IO; _>>_; _>>=_; putStrLn)
    open import Lib using (expect)
    open import System.Exit using (exitSuccess)

    day02 : String -> IO ⊤
    day02 input = do
      constraints <- expect "bla" (impl.toConstraints input)
      putStrLn (show (length (filterᵇ impl.schemeA constraints)))
      putStrLn (show (length (filterᵇ impl.schemeB constraints)))
      exitSuccess
