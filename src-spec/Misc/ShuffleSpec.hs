-- Copyright © 2016, Jens Brage
module Misc.ShuffleSpec
  ( spec )
  where
    import Misc.Shuffle
    import System.Random
    import Test.Hspec
    import Test.QuickCheck
    spec :: Spec
    spec =
        describe "shuffleR" $
            it "generates shuffles" $ property $
                \ n -> n >= 0 ==> prop_isShuffle n
    prop_isShuffle :: Int -> Int -> Bool
    prop_isShuffle n g =
        let ( l , g ) = shuffleR n ( mkStdGen g ) in
        isShuffle n l
