-- Copyright © 2016, Jens Brage
module Misc.PermutationSpec
  ( spec )
  where
    import Data.IntMap.Strict
    import Misc.Permutation
    import Misc.Shuffle
    import System.Random
    import Test.Hspec
    import Test.QuickCheck
    prop_isPermutation :: Int -> Bool
    prop_isPermutation n = all isPermutation ( permutations [ 0 .. n - 1 ] )
-- If l is a shuffle of [ 0 .. n - 1 ], then f = induce l is a permutation of [ 0 .. n - 1 ] such that reduce n f == l.
    prop_induce :: Int -> Int -> Bool
    prop_induce n g =
        let ( l , g ) = shuffleR n ( mkStdGen g ) in
        let f = induce l in
        isPermutation n f && reduce n f == l
-- If f is a permutation of [ 0 .. n - 1 ], then l = reduce n f is a shuffle of [ 0 .. n - 1 ] such that map ( induce l ) [ 0 .. n - 1 ] == map f [ 0 .. n - 1 ].
    prop_reduce :: Int -> ( Int -> Int ) -> Bool
    prop_reduce n f =
        let l = reduce f n in
        isShuffle l && map ( induce l ) [ 0 .. n - 1 ] == map f [ 0 .. n - 1 ]
-- Auxiliary function, using IntMap to represent permutations as functions.
    permutation :: Int -> [ Int ] -> Int -> Int
    permutation n ks = fromList ( zip [ 0 .. n - 1 ] p ) !
-- Auxiliary proposition, supplying prop_reduce with functions.
    prop_reduces :: Int -> Bool -- n >= 0
    prop_reduces n =
        all
          ( prop_reduce n . permutation n )
          ( permutations [ 0 .. n - 1 ] )
    spec :: Spec
    spec =
        describe "isPermutation" $
            it "recognizes permutations" $ property $
                \ n -> n >= 0 ==> prop_isPermutation n
        describe "induce" $
            it "induces permutations" $ property $
                \ n -> n >= 0 ==> prop_induce n
        describe "reduce" $
            it "reduce permutations to shuffles" $ property $
                \ n -> n >= 0 ==> prop_reduces n
