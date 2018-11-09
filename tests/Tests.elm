module Tests exposing (config, suite)

import Expect exposing (..)
import Fuzz exposing (..)
import ModularScale exposing (..)
import Test exposing (..)


config : ModularScale.Config
config =
    ModularScale.config [ 1 ] ModularScale.PerfectFifth


config2 : ModularScale.Config
config2 =
    ModularScale.config [ 1, 1.2 ] ModularScale.PerfectFifth


config3 : Float -> ModularScale.Config
config3 base =
    ModularScale.config [ base ] ModularScale.PerfectFifth


suite : Test
suite =
    describe "The ModularScale module"
        [ describe "Get single base, variable base"
            [ Test.fuzz Fuzz.float "Fuzz get returns a Float" <|
                \randomFloat ->
                    randomFloat
                        |> (\x -> x * 1.5 ^ 5)
                        |> Expect.within (Expect.Absolute 0.000001) (get (config3 randomFloat) 5)
            ]
        , describe "Get single base negtive index, variable base"
            [ Test.fuzz Fuzz.float "Fuzz get returns a Float" <|
                \randomFloat ->
                    randomFloat
                        |> (\x -> x * 1.5 ^ -6)
                        |> Expect.within (Expect.Absolute 0.000001) (get (config3 randomFloat) -6)
            ]
        , describe "Get single base variable index"
            [ Test.fuzz Fuzz.int "Fuzz get returns a Float" <|
                \randomInt ->
                    1
                        |> (\x -> x * 1.5 ^ toFloat randomInt)
                        |> Expect.within (Expect.Absolute 0.000001) (get config randomInt)
            ]
        , describe "Get multi base"
            [ Test.test "Fuzz get returns a Float" <|
                \_ ->
                    Expect.within (Expect.Absolute 0.000001) (get config2 6) 3.375
            ]
        , describe "Get multi base negative index"
            [ Test.test "Fuzz get returns a Float" <|
                \_ ->
                    Expect.within (Expect.Absolute 0.000001) (get config2 -6) 0.2962962962962963
            ]
        ]
