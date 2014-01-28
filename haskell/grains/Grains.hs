module Grains (square, total) where

square :: (Integral a) => Int -> a
square = (2 ^) . pred

total :: Integer
total = pred $ 2 ^ (64 :: Int)
