module Year2021.Day04 (main) where

import Data.List (transpose, (\\))
import Data.List.Split (splitOn)
import Data.Text (Text, strip)
import Data.Text.Conversions (convertText)

-- Plug this into the exe's main to run this day.
main :: IO ()
main = do
    input <- buildInput
    putStr $ show $ play (ballots input) (boards input) []

type Board = [[Int]]

data Input = Input
    { ballots :: [Int]
    , boards :: [Board]
    }

buildInput :: IO Input
buildInput = do
    ballots <- fmap (map (read :: String -> Int) . splitOn ",") getLine
    contents <- getContents
    let strBoards = [splitOn "\n" (convertText (strip $ convertText strBoard :: Text)) | strBoard <- splitOn "\n\n" contents]
    let boards = [buildBoard strBoard | strBoard <- strBoards]
    return
        Input
            { ballots = ballots
            , boards = boards
            }

buildBoard :: [String] -> Board
buildBoard str = [map (read :: String -> Int) (words line) | line <- str]

singleDimWin :: [Int] -> Bool
singleDimWin = all (== -1)

hasWin :: Board -> Bool
hasWin board = or [singleDimWin rs || singleDimWin cs | rs <- board, cs <- transpose board]

mark :: Int -> Board -> Board
mark x board = [[if num == x then -1 else num | num <- line] | line <- board]

score :: Int -> Board -> Int
score x board = (sum [sum ([num | num <- line, num /= -1]) | line <- board]) * x

play :: [Int] -> [Board] -> [Int] -> [Int]
play _ [] wscores = wscores
play bls brds wscores =
    case [mrk | mrk <- mrks, hasWin mrk] of
        [] -> play newbls mrks wscores -- Just play again, now without the evaluated ballot and with the marked boards.
        xs -> play newbls (mrks \\ xs) (wscores ++ [score bl x | x <- xs]) -- Play again, but with the winners removed and scores for the winners added.
  where
    bl = head bls
    mrks = [mark bl brd | brd <- brds]
    newbls = drop 1 bls
