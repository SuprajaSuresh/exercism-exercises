{-# LANGUAGE OverloadedStrings #-}

module Sgf (parseSgf) where

import qualified Data.Attoparsec.Text as A
import qualified Data.Map as M
import qualified Data.Text as T
import Control.Applicative (pure, many, (*>), (<*), (<$>), (<*>))
import Data.Attoparsec.Text
  ( Parser
  , skipSpace
  , parseOnly
  , char
  , many1
  , takeWhile1
  , choice
  , notInClass
  , satisfy
  )
import Data.Char (isUpper, isSpace)
import Data.Map (Map)
import Data.Text (Text)
import Data.Tree (Tree(..))

type GameNode = Map Text [Text]

{-
http://www.red-bean.com/sgf/sgf4.html

2.1. EBNF Definition

  Collection = GameTree { GameTree }
  GameTree   = "(" Sequence { GameTree } ")"
  Sequence   = Node { Node }
  Node       = ";" { Property }
  Property   = PropIdent PropValue { PropValue }
  PropIdent  = UcLetter { UcLetter }
  PropValue  = "[" CValueType "]"
  CValueType = (ValueType | Compose)
  ValueType  = (None | Number | Real | Double | Color | SimpleText |
                Text | Point  | Move | Stone)

White space (space, tab, carriage return, line feed, vertical tab and so on) may
appear anywhere between PropValues, Properties, Nodes, Sequences and GameTrees.

Formatting:
Soft line break: linebreaks preceded by a "\" (soft linebreaks are converted to
                 "", i.e. they are removed)
Hard line breaks: any other linebreaks encountered

Escaping: "\" is the escape character. Any char following "\" is inserted
verbatim (exception: whitespaces still have to be converted to space!).
Following chars have to be escaped, when used in Text: "]", "\" and ":"
(only if used in compose data type).

-}
parseSgf :: Text -> Maybe (Tree GameNode)
parseSgf = either (const Nothing) Just . parseOnly pGameTree

sp :: Parser a -> Parser a
sp p = skipSpace *> p <* skipSpace

t :: Char -> Parser Char
t = sp . char

pGameTree :: Parser (Tree GameNode)
pGameTree = t '(' *> (Node <$> pNode <*> pForest) <* t ')'

pForest :: Parser [Tree GameNode]
pForest =
  choice
  [ mkSingleton <$> pNode <*> pForest
  , many pGameTree ]

mkSingleton :: GameNode -> [Tree GameNode] -> [Tree GameNode]
mkSingleton node forest = [Node node forest]

pNode :: Parser GameNode
pNode = t ';' *> (M.fromList <$> many pProperty)

pProperty :: Parser (Text, [Text])
pProperty = (,) <$> pPropIdent <*> many1 pPropValue

pPropIdent :: Parser Text
pPropIdent = sp (takeWhile1 isUpper)

pPropValue :: Parser Text
pPropValue = sp (char '[' *> pTextValue <* char ']')

pTextValue :: Parser Text
pTextValue = T.concat <$> many p
  where
    p = choice
        [ takeWhile1 (notInClass "]\\\t\v\r\n")
        , char '\\' *> choice [ char '\n' *> pure T.empty, A.take 1 ]
        , satisfy isSpace *> pure " "
        ]
