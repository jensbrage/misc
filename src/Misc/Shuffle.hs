-- Copyright © 2016, Jens Brage
module Misc.Shuffle
  ( isShuffle
  , shuffleR )
  where
    import System.Random
-- A shuffle is a categorified factorial.
    isShuffle :: Int -> [ Int ] -> Bool
    isShuffle 0 l = [] == l
    isShuffle n ( k : l ) = 0 <= k && k < n && isShuffle ( n - 1 ) l
-- Generate a shuffle, see https://en.wikipedia.org/wiki/Random_permutation.
    shuffleR :: RandomGen g => Int -> g -> ( [ Int ] , g )
    shuffleR 0 g = ( [] , g )
    shuffleR n g =
        let ( k , g ) = randomR ( 0 , n - 1 ) g in
        let ( l , g ) = shuffleR ( n - 1 ) g in
        ( k : l , g )
-- Plural variant of shuffleR, producing an infinite list of shuffles instead of returning a new generator.
    shuffles :: RandomGen g => Int -> g -> [ [ Int ] ]
    shuffles n g =
        let ( l , g ) = shuffleR n g in
        l : shuffles n g
