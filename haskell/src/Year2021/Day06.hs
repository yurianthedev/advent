module Year2021.Day06 (run) where

import Data.Char (digitToInt, isDigit)
import System.IO (isEOF)

run :: IO ()
run = do
    fishes <- readInput
    let cald = calcFirst fishes
    print $ sum $ calcStages 255 cald

readInput :: IO [Int]
readInput = do
    done <- isEOF
    if done
        then return []
        else do
            newInput <- getChar
            input <- readInput
            if isDigit newInput
                then return (digitToInt newInput : input)
                else return input

calcFirst :: [Int] -> [Int]
calcFirst = foldl (\cald x -> take x cald ++ [(cald !! x) + 1] ++ drop (x + 1) cald) [0, 0, 0, 0, 0, 0, 0, 0, 0]

calcStages :: Int -> [Int] -> [Int]
calcStages n stages = foldl (\m d -> let i = (d + 7) `mod` 9 in (take i m ++ [(m !! i) + (m !! (d `mod` 9))] ++ drop (i + 1) m)) stages [1 .. n]

-- Inefficient version.

-- incDay :: [Int] -> [Int]
-- incDay fishes = fishes >>= calcFish

-- calcFish :: Int -> [Int]
-- calcFish 0 = [6, 8]
-- calcFish x = [x - 1]
