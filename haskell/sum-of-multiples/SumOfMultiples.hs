module SumOfMultiples (sumOfMultiplesDefault, sumOfMultiples) where
import qualified Data.Set as S

sumOfMultiples :: Integral a => [a] -> a -> a
sumOfMultiples xs x = S.foldl' (+) 0 . S.unions . map multiples $ xs
  where multiples n = S.fromDistinctAscList . takeWhile (<x) . iterate (+n) $ n

sumOfMultiplesDefault :: Integral a => a -> a
sumOfMultiplesDefault = sumOfMultiples [3, 5]
