{-# LANGUAGE OverloadedStrings #-}
module Frequency (frequency) where

import Control.Parallel.Strategies (parMap, rseq)
import Data.Char (isLetter, toLower)
import Data.List.Split (chunksOf)
import Data.List (foldl')
import Data.Ratio ((%))
import qualified Data.Map.Strict as M
import qualified Data.Text as T

frequency :: Int -> [T.Text] -> M.Map Char Int
frequency workers texts = reducer . mapper $ texts
  where
    chunkSize = ceiling (length texts % workers)
    union = M.unionsWith (+)
    mapper = parMap rseq (foldl' (T.foldl' freq) M.empty) . chunksOf chunkSize
    freq m c | isLetter c = M.insertWith (+) (toLower c) 1 m
             | otherwise  = m
    reducer xs@(_:_:_:_) = reducer . parMap rseq union . chunksOf 2 $ xs
    reducer xs           = union xs
