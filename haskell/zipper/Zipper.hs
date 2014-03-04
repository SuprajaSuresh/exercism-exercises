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

data Direction = ZL | ZR deriving (Show, Eq)

-- | A zipper for a binary tree.
data Zipper a =
  Z { zFocus     :: BinTree a
    , zParent    :: Maybe (Direction, Zipper a)
    } deriving (Show, Eq)

-- | Get a zipper focussed on the root node.
fromTree :: BinTree a -> Zipper a
fromTree t = Z { zFocus = t, zParent = Nothing }

-- | Get the complete tree from a zipper.
toTree :: Zipper a -> BinTree a
toTree z = maybe (zFocus z) toTree (up z)

-- | Get the value of the focus node.
value :: Zipper a -> a
value = btValue . zFocus

-- | Get the left child of the focus node, if any.
left :: Zipper a -> Maybe (Zipper a)
left z = f `fmap` btLeft (zFocus z)
  where f t = Z { zFocus = t, zParent = Just (ZL, z) }

-- | Get the right child of the focus node, if any.
right :: Zipper a -> Maybe (Zipper a)
right z = f `fmap` btRight (zFocus z)
  where f t = Z { zFocus = t, zParent = Just (ZR, z) }

-- | Get the parent of the focus node, if any.
up :: Zipper a -> Maybe (Zipper a)
up z = f `fmap` zParent z
  where
    t = zFocus z
    f (dir, p) = case dir of
      ZL -> p { zFocus = pt { btLeft  = Just t } }
      ZR -> p { zFocus = pt { btRight = Just t } }
      where pt = zFocus p

-- | Set the value of the focus node.
setValue :: a -> Zipper a -> Zipper a
setValue v z = z { zFocus = (zFocus z) { btValue = v } }

-- | Replace a left child tree.
setLeft :: Maybe (BinTree a) -> Zipper a -> Zipper a
setLeft l z = z { zFocus = (zFocus z) { btLeft = l } }

-- | Replace a right child tree.
setRight :: Maybe (BinTree a) -> Zipper a -> Zipper a
setRight r z = z { zFocus = (zFocus z) { btRight = r } }
