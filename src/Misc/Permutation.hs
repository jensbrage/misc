-- Copyright © 2016, Jens Brage
module Misc.Permutation
  ( isPermutation
  , induce
  , reduce )
  where
-- A permutation on [ 0 .. n - 1 ] is bijective on [ 0 .. n - 1 ].
    isPermutation :: Int -> ( Int -> Int ) -> Bool
    isPermutation n f = sort ( map f [ 0 .. n - 1 ] ) == [ 0 .. n - 1 ]
-- Auxiliary function, trasposition.
    swap :: Int -> Int -> Int
    swap k x
      | x == 0 = k
      | x == k = 0
      | otherwise = x
-- Auxiliary function, conjugation.
    shift :: Int -> ( Int -> Int ) -> Int -> Int
    shift k f = ( + k ) . f . ( + ( - k ) )
-- If l is a shuffle of [ 0 .. n - 1 ], then f = induce l is a permutation of [ 0 .. n - 1 ] such that reduce n f == l.
    induce :: [ Int ] -> Int -> Int
    induce [] = id
    induce ( k : l ) = swap k . shift 1 ( induce l )
-- If f is a permutation of [ 0 .. n - 1 ], then l = reduce n f is a shuffle of [ 0 .. n - 1 ] such that map ( induce l ) [ 0 .. n - 1 ] == map f [ 0 .. n - 1 ].
    reduce :: Int -> ( Int -> Int ) -> [ Int ]
    reduce n f = k : reduce ( n - 1 ) ( shift ( - 1 ) ( f . swap k ) )
      where
        k :: Int
        k = f 0
