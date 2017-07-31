module Tests exposing (..)

import Expect exposing (..)
import Fuzz exposing (..)
import ModularScale exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "The ModularScale module"
        [ describe "Get single base, variable base"
            [ Test.fuzz Fuzz.float "Fuzz get returns a Float" <|
                \randomFloat ->
                    randomFloat
                        |> (\x -> x * 1.5 ^ 5)
                        |> Expect.equal (get { base = [ randomFloat ], interval = PerfectFifth } 5)
            ]
        , describe "Get single base negtive index, variable base"
            [ Test.fuzz Fuzz.float "Fuzz get returns a Float" <|
                \randomFloat ->
                    randomFloat
                        |> (\x -> x * 1.5 ^ -6)
                        |> Expect.equal (get { base = [ randomFloat ], interval = PerfectFifth } -6)
            ]
        , describe "Get single base variable index"
            [ Test.fuzz Fuzz.int "Fuzz get returns a Float" <|
                \randomInt ->
                    1
                        |> (\x -> x * 1.5 ^ toFloat randomInt)
                        |> Expect.equal (get { base = [ 1 ], interval = PerfectFifth } randomInt)
            ]
        , describe "Get multi base"
            [ Test.test "Fuzz get returns a Float" <|
                \_ ->
                    Expect.equal (get { base = [ 1, 1.2 ], interval = PerfectFifth } 6) 3.375
            ]
        , describe "Get multi base negative index"
            [ Test.test "Fuzz get returns a Float" <|
                \_ ->
                    Expect.equal (get { base = [ 1, 1.2 ], interval = PerfectFifth } -6) 0.2962962962962963
            ]
        ]
