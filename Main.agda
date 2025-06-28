{-# OPTIONS --guardedness #-}

open import Data.List using (List; head; drop; _∷_; [])
open import Data.String using (String; _++_)
open import IO using (Main; run; IO; pure; _>>_; _>>=_; putStrLn; readFiniteFile)
open import System.Environment using (getArgs)
open import System.Exit using (exitSuccess; exitFailure)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Unit.Base using (⊤)

open import Day01 using (day01)
open import Day02 using (day02)
open import Lib using (expect)

usage : String -> String
usage error = error ++ "\nUsage: day<XX> <input-file>"

solveDay : String -> String -> IO ⊤
solveDay "day01" = day01
solveDay "day02" = Day02.io.day02
solveDay _ _ = expect (usage "There is no such day") nothing

main : Main
main = run do
  args <- getArgs
  day <- expect (usage "Not enough arguments.") (head args)
  filename <- expect (usage "Not enough arguments.") (head (drop 1 args))
  content <- readFiniteFile filename
  solveDay day content
  exitSuccess
