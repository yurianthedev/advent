{-# LANGUAGE ImportQualifiedPost #-}

module Year2021.Day05 (day05) where

import Data.List.Split (splitOn)
import Data.Map.Strict qualified as Map

type Board = Map.Map (Int, Int) Int

type Point = (Int, Int)

type Segment = (Point, Point)

day05 :: IO ()
day05 = do
    segments <- buildInput
    let board = buildBoard 999
    let marked = foldl (flip (uncurry mark)) board segments
    print (howManyGe2 marked)

buildInput :: IO [Segment]
buildInput = do
    lns <- fmap lines getContents
    return [(case map (\s -> case map (read :: String -> Int) (splitOn "," s) of [a, b] -> (a, b)) (splitOn " -> " line) of [a, b] -> (a, b)) | line <- lns]

buildBoard :: Int -> Board
buildBoard n = Map.fromList [((i, j), 0) | i <- [0 .. n], j <- [0 .. n]]

isRect :: Segment -> Bool
isRect ((x1, y1), (x2, y2)) = x1 == x2 || y1 == y2

mark :: Point -> Point -> Board -> Board
mark a b board
    | a == b = newBoard
    | otherwise = mark newA b newBoard
  where
    newBoard = Map.adjust (+ 1) a board
    newA = case (a, b) of
        ((x1, y1), (x2, y2)) -> (newCoord x1 x2, newCoord y1 y2)

newCoord :: Int -> Int -> Int
newCoord x1 x2 = if xmod /= 0 then x1 + 1 * (xmod `div` abs xmod) else x1
  where
    xmod = x2 - x1

howManyGe2 :: Board -> Int
howManyGe2 b = length $ Map.keys (Map.filter (>= 2) b)
