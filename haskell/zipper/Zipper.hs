module Zipper (
    BinTree(..),
    Zipper,

    fromTree,
    toTree,

    value,
    left,
    right,
    up,

    setValue,
    setLeft,
    setRight
) where

-- | A binary tree.
data BinTree a = BT {
    btValue :: a                 -- ^ Value
  , btLeft  :: Maybe (BinTree a) -- ^ Left child
  , btRight :: Maybe (BinTree a) -- ^ Right child
} deriving (Eq, Show)

data ZParent a = ZL { zValue :: a
                    , zRight :: Maybe (BinTree a) }
               | ZR { zValue :: a
                    , zLeft  :: Maybe (BinTree a) }
               deriving (Show, Eq)

-- | A zipper for a binary tree.
data Zipper a =
  Z { zFocus :: BinTree a
    , zPath  :: [ZParent a]
    } deriving (Show, Eq)

-- | Get a zipper focussed on the root node.
fromTree :: BinTree a -> Zipper a
fromTree t = Z { zFocus = t, zPath = [] }

-- | Get the complete tree from a zipper.
toTree :: Zipper a -> BinTree a
toTree z = maybe (zFocus z) toTree (up z)

-- | Get the value of the focus node.
value :: Zipper a -> a
value = btValue . zFocus

-- | Get the left child of the focus node, if any.
left :: Zipper a -> Maybe (Zipper a)
left z = f `fmap` btLeft p
  where
    p = zFocus z
    f t = Z { zFocus = t
            , zPath = ZL { zValue = btValue p, zRight = btRight p } : zPath z }

-- | Get the right child of the focus node, if any.
right :: Zipper a -> Maybe (Zipper a)
right z = f `fmap` btRight p
  where
    p = zFocus z
    f t = Z { zFocus = t
            , zPath = ZR { zValue = btValue p, zLeft = btLeft p } : zPath z }

-- | Get the parent of the focus node, if any.
up :: Zipper a -> Maybe (Zipper a)
up z = case zPath z of
  p:ps -> Just $ case p of
    ZL v r -> Z (BT v here r) ps
    ZR v l -> Z (BT v l here) ps
  []   -> Nothing
  where
    here = Just (zFocus z)

-- | Set the value of the focus node.
setValue :: a -> Zipper a -> Zipper a
setValue v z = z { zFocus = (zFocus z) { btValue = v } }

-- | Replace a left child tree.
setLeft :: Maybe (BinTree a) -> Zipper a -> Zipper a
setLeft l z = z { zFocus = (zFocus z) { btLeft = l } }

-- | Replace a right child tree.
setRight :: Maybe (BinTree a) -> Zipper a -> Zipper a
setRight r z = z { zFocus = (zFocus z) { btRight = r } }
