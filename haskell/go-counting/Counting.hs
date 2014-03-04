module Counting ( Color(..), territories, territoryFor ) where

import Data.Set (Set)
import Data.List (sort)
import Data.Maybe (listToMaybe)
import Control.Monad.State.Strict

import Control.Applicative
import qualified Data.IntMap as M
import qualified Data.Set as S

type Coord = (Int, Int)

data Color = Black
           | White
           deriving (Show, Eq, Ord)

data Board = Board { bCols   :: !Int
                   , bRows   :: !Int
                   , bUF     :: UF }

data Parent = Root { pColor  :: !BoardColor }
            | Leaf { pParent :: !Int }

-- Nothing if the node borders multiple colors
-- Just c where c is the color assigned to this region
-- (may be Nothing during processing)
type BoardColor = Maybe (Maybe Color)

-- This is a union-find like data structure, the difference is that
-- roots must be empty and they carry a color.
type UF = M.IntMap Node

data Node = Node { nIdent :: !Int
                 , nRoot  :: !Parent
                 , nEmpty :: !Bool
                 }

-- | Returns the coordinates (1 based, top left is (1,1)) of of the points
--   in each territory along with who "owns" the territory. A territory is
--   owned by one of the players if that player's stones are the only
--   stones adjacent to the territory.
territories :: [[Char]] -> [(Set Coord, Maybe Color)]
territories = go . fromList
  where
    go b@(Board { bUF = uf }) =
      evalState (mapM f . M.toList . territoryMap $ b) uf
    f (i, coords) = do
      Node { nRoot = Root { pColor = c }} <- fetch i
      return (coords, join c)

-- | Returns the territory that contains the coordinate along with the
--   owner of the territory. If the coordinate does not point to an empty
--   location returns Nothing.
territoryFor :: [[Char]] -> Coord -> Maybe (Set Coord, Maybe Color)
territoryFor inputBoard coord =
  listToMaybe [ r | r <- territories inputBoard, coord `S.member` fst r ]

singleton :: Int -> Maybe Color -> Node
singleton ident color = Node { nIdent = ident
                             , nRoot  = Root (Just color)
                             , nEmpty = color == Nothing
                             }

union :: Int -> Int -> State UF ()
union a b = do
  r1 <- findRoot a
  r2 <- findRoot b
  merge r1 r2
  where
    merge x@(Node { nIdent = xi, nRoot = Root { pColor = xc }, nEmpty = xe })
          y@(Node { nIdent = yi, nRoot = Root { pColor = yc }, nEmpty = ye })
      | xi == yi || not (xe || ye) = return ()
      | otherwise = do
        case sort [ nIdent n | n <- [x, y], nEmpty n] of
          (r:_) -> do
            let c = mergeColor xc yc
            update x r c
            update y r c
          _ -> return ()
    merge _ _ = error "merge did not find two roots"
    update x@(Node { nIdent = xi, nRoot = Root { pColor = xc } }) r c
      | not (nEmpty x) = return ()
      | xi /= r = modify $
        M.insert xi (x { nRoot = Leaf { pParent = r } })
      | xc /= c = modify $
        M.insert xi (x { nRoot = Root { pColor = c } })
      | otherwise = return ()
    update _ _ _ = error "update of non-root"

fetch :: Int -> State UF Node
fetch a = (M.! a) <$> get

-- | Find root with path compression.
findRoot :: Int -> State UF Node
findRoot a = do
  r <- fetch a
  case nRoot r of
    Root _ -> return r
    Leaf b -> do
      r' <- findRoot b
      let root = nIdent r'
      when (root /= b) . modify $
        M.insert a (r { nRoot = Leaf root })
      return r'

mergeColor :: BoardColor -> BoardColor -> BoardColor
mergeColor ma mb = do
  a <- ma
  b <- mb
  let ab = a <|> b
  guard (ab == (b <|> a))
  return ab

territoryMap :: Board -> M.IntMap (Set Coord)
territoryMap b@(Board { bCols = cols, bRows = rows, bUF = uf }) =
  evalState (foldM f M.empty [0 .. rows * cols - 1]) uf
  where
    f m i = do
      a <- fetch i
      if nEmpty a
        then do
          r <- nIdent <$> findRoot i
          return (M.insertWith S.union r (coord i) m)
        else return m
    coord = S.singleton . fromIndex b

fromIndex :: Board -> Int -> Coord
fromIndex (Board { bCols = cols }) i =
  let (q, r) = i `quotRem` cols in (r + 1, q + 1)

solve :: Board -> Board
solve board@(Board { bCols = cols, bRows = rows, bUF = uf }) =
  board { bUF = execState mergeAll uf }
  where
    mergeAll = do
      sequence_ [ mergeSeq [r .. r + cols - 1]
                | r <- [0, cols .. (rows - 1) * cols] ]
      sequence_ [ mergeSeq [c, c + cols .. rows * cols - 1]
               | c <- [0..cols - 1] ]
    mergeSeq xs = sequence_ $ zipWith union xs (tail xs)

fromList :: [[Char]] -> Board
fromList xss = solve $
  Board { bCols = length (head xss)
        , bRows = length xss
        , bUF     = M.fromList . zipWith go [0..] . map fromChar $ concat xss
        }
  where
    go i color = (i, singleton i color)
    fromChar c = case c of
      'B' -> Just Black
      'W' -> Just White
      _   -> Nothing
