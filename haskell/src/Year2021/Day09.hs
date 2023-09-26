module Year2021.Day09 (run, star1, star2) where

import Data.Array as Array (Array, elems, listArray, (!))
import Data.Char (digitToInt, isDigit)
import Data.List (sort)
import Data.Set (fromList, toList)
import System.IO (isEOF)
import Prelude hiding (Left, Right)

type HeightMap = Array.Array Int (Array.Array Int Int)

-- Check if the current (m, n) coords is the lowest number.
-- Relies heavily on fast indexing.
isLowPoint :: Int -> Int -> HeightMap -> Int -> Int -> Bool
isLowPoint m n xxs i j = up && right && down && left
  where
    current = xxs ! i ! j
    left = (j == 0) || ((xxs ! i ! (j - 1)) > current)
    right = (j == n - 1) || ((xxs ! i ! (j + 1)) > current)
    up = (i == 0) || ((xxs ! (i - 1) ! j) > current)
    down = (i == m - 1) || ((xxs ! (i + 1) ! j) > current)

findLowPoints :: HeightMap -> [(Int, Int)]
findLowPoints xxs = [(i, j) | i <- [0 .. m - 1], j <- [0 .. n - 1], isLp i j]
  where
    m = length xxs
    n = length (head $ elems xxs)
    isLp = isLowPoint m n xxs

parseInput :: IO HeightMap
parseInput =
    parseInput' >>= \xxs ->
        let m = length xxs
         in return $ Array.listArray (0, m - 1) xxs
  where
    parseInput' = do
        done <- isEOF
        if done
            then return []
            else do
                ln <- getLine
                let
                    n = length ln
                    lnInts = Array.listArray (0, n - 1) [digitToInt ch | ch <- ln, isDigit ch]
                rest <- parseInput'
                return (lnInts : rest)

star1 :: HeightMap -> Int
star1 xxs =
    let lowPoints = findLowPoints xxs
     in sum [(xxs ! i ! j) + 1 | (i, j) <- lowPoints]

type Basin = [(Int, Int)]

-- Low means the "origin" of the basin is the lowest point.
data From = Low | Up | Right | Down | Left

wall :: Int
wall = 9

findBasinFromLow :: (Int, Int) -> HeightMap -> Basin
findBasinFromLow pair xxs = toList . fromList $ findBasinFromLow' pair Low
  where
    m = length xxs
    n = length (head $ elems xxs)
    get (i, j) = xxs ! i ! j
    pairIfNotWall :: Basin -> (Int, Int) -> Basin
    pairIfNotWall basin pair'
        | get pair' >= wall = []
        | otherwise = pair' : basin
    up (i, j)
        | i == 0 = []
        | otherwise = findBasinFromLow' (i - 1, j) Down
    down (i, j)
        | i == m - 1 = []
        | otherwise = findBasinFromLow' (i + 1, j) Up
    left (i, j)
        | j == 0 = []
        | otherwise = findBasinFromLow' (i, j - 1) Right
    right (i, j)
        | j == n - 1 = []
        | otherwise = findBasinFromLow' (i, j + 1) Left
    maybeSide j
        | j < snd pair = [left]
        | j > snd pair = [right]
        | otherwise = [left, right]
    findBasinFromLow' :: (Int, Int) -> From -> Basin
    findBasinFromLow' pair' Low = pairIfNotWall ([up, right, down, left] >>= ($ pair')) pair'
    findBasinFromLow' pair'@(_, j) Up = pairIfNotWall ((down : maybeSide j) >>= ($ pair')) pair'
    findBasinFromLow' pair'@(_, j) Down = pairIfNotWall ((up : maybeSide j) >>= ($ pair')) pair'
    findBasinFromLow' pair' Right = pairIfNotWall ([up, down, left] >>= ($ pair')) pair'
    findBasinFromLow' pair' Left = pairIfNotWall ([up, down, right] >>= ($ pair')) pair'

star2 :: HeightMap -> Int
star2 xxs = do
    let lowPoints = findLowPoints xxs
    product . take 3 . reverse . sort $
        [length bas | lp <- lowPoints, let bas = findBasinFromLow lp xxs]

run :: IO ()
run = do
    xxs <- parseInput
    let res1 = star1 xxs
        res2 = star2 xxs
    putStrLn $ "Day 9 results: [star1: " ++ show res1 ++ "] [star2: " ++ show res2 ++ "]"
