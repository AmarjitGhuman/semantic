{-# LANGUAGE FlexibleInstances #-}
module Category where

import Term
import Control.Comonad.Cofree
import Data.Set

-- | A standardized category of AST node. Used to determine the semantics for
-- | semantic diffing and define comparability of nodes.
data Category =
  -- | A literal key-value data structure.
  DictionaryLiteral
  -- | A non-standard category, which can be used for comparability.
  | Other String
  deriving (Eq, Show)

-- | The class of types that have categories.
class Categorizable a where
  categories :: a -> Set String

instance Categorizable annotation => Categorizable (Term a annotation) where
  categories (annotation :< _) = categories annotation

-- | Test whether the categories from the categorizables intersect.
comparable :: Categorizable a => a -> a -> Bool
comparable a b = catsA == catsB || (not . Data.Set.null $ intersection catsA catsB)
  where
    catsA = categories a
    catsB = categories b
