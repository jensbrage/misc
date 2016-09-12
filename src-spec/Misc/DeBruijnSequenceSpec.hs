-- Copyright © 2016, Jens Brage
module Misc.DeBruijnSequenceSpec
  ( spec )
  where
    import Data.List
    import Data.List.Split
    import Data.Set
    import Misc.DeBruijnSequence
    import System.Random
    import Test.Hspec
    import Test.QuickCheck
-- Auxiliary predicate accepting lists with unique elements.
    unique :: Ord a => [ a ] -> Set a -> Bool
    unique [ ] s = True
    unique ( x : xs ) s = notMember x s && unique xs ( Data.Set.insert x s )
-- Auxilliary predicate, see https://en.wikipedia.org/wiki/De_Bruijn_sequence.
    prop_deBruijnSequence :: Ord a => Int -> [ a ] -> Bool
    prop_deBruijnSequence n as = unique ( divvy n 1 ( as ++ take ( n - 1 ) as ) ) empty
-- Auxiliary description.
    spec_deBruijnSequence :: Int -> Int -> Spec
    spec_deBruijnSequence k n = do
        let kss = deBruijnSequences k n ( mkStdGen 0 )
        describe ( "deBruijnSequences " ++ show k ++ " " ++ show n ) $ do
            it ( "generates ( " ++ show k ++ " ! ) ^ ( " ++ show k ++ " ^ ( " ++ show n ++ " - 1 ) ) sequences" ) $
                length kss `shouldBe` ( length (permutations [ 0 .. k - 1 ] ) ) ^ ( k ^ ( n - 1 ) )
            it "generates unique sequences" $
                unique kss empty
            it "generates de Bruijn sequences" $
                all ( prop_deBruijnSequence n ) kss
-- Specification with examples from https://en.wikipedia.org/wiki/De_Bruijn_sequence.
    spec :: Spec
    spec = do
        spec_deBruijnSequence 2 1
        spec_deBruijnSequence 2 3
        spec_deBruijnSequence 2 5
