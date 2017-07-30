module Tests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import ModularScale exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "The ModularScale module"
        [ describe "ModularScale.getEm"
            [ Test.fuzz2 Fuzz.int Fuzz.float "Fuzz getEm returns a Float" <|
                \randomInt randomFloat ->
                    randomInt
                        |> (\x -> randomFloat ^ toFloat x)
                        |> Expect.equal (getEm (Ratio randomFloat) randomInt)
            ]
        ]
