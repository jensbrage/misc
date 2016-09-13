-- Copyright © 2016, Jens Brage
module Misc.DeBruijnSequence
( deBruijnSequences
, deBruijnSequenceIO ) where
  import Data.List.Split
  import Data.Set
  import System.Random
  import System.Random.Shuffle
-- Auxiliary function generating non-repetitive candidate sequences.
  candidateSequences :: Ord a => Int -> [ a ] -> Set [ a ] -> [ [ a ] ] -> [ [ a ] ]
  candidateSequences _ as _ [] = [ reverse as ]
  candidateSequences n as s ( xs : xss ) =
    xs >>=
    \ a ->
      let as' = a : as in
      let as'' = take n as' in
      if notMember as'' s
        then candidateSequences n as' ( insert as'' s ) xss
        else []
-- Auxiliary function generating a sequence of shuffles of a list.
  shuffles :: RandomGen g => [ a ] -> g -> [ [ a ] ]
  shuffles xs = Prelude.map ( shuffle xs ) . chunksOf s . randomRs ( 0 , s ) where
      s :: Int
      s = length xs - 1
-- There are ( ( k ! ) ^ ( k ^ ( n - 1 ) ) ) / ( k ^ n ) de Bruijn sequences or ( k ! ) ^ ( k ^ ( n - 1 ) ) when counting cyclic multiplicities, or what amounts to the same, linear de Bruijn sequences. The latter are more convenient to deal with when attempting to generate a random de Bruijn sequence, suggesting that we generate k ^ ( n - 1 ) permutations of [ 0 .. k - 1 ] to enumerate them. It is however easier to generate the candidate sequences of length k ^ n + n - 1 and then filter out the cyclic sequences of order n. See https://en.wikipedia.org/wiki/De_Bruijn_sequence for references.
  deBruijnSequences :: RandomGen g => Int -> Int -> g -> [ [ Int ] ]
  deBruijnSequences k n =
    Prelude.map ( take ( k ^ n ) )
    . Prelude.filter ( \ xs -> take ( n - 1 ) xs == drop ( k ^ n ) xs )
    . candidateSequences n [] empty
    . take ( k ^ n + n - 1 )
    . shuffles [ 0 .. k - 1 ]
-- Singular form with IO for GHCi.
  deBruijnSequenceIO :: Int -> Int -> IO [ Int ]
  deBruijnSequenceIO k n = return . head . deBruijnSequences k n =<< newStdGen
