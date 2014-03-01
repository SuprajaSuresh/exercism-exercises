module Strain (keep, discard) where

keep :: (a -> Bool) -> [a] -> [a]
keep f = go
  where
    go []         = []
    go (x:xs)
      | f x       = x : go xs
      | otherwise = go xs

discard :: (a -> Bool) -> [a] -> [a]
discard = keep . (not .)
