module Tests exposing (suite)

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
        -- [ fuzz (Fuzz.floatRange -200 200) "Fuzz base positive index" <|
        --     \base ->
        --         (base * 1.5 ^ 5)
        --             |> Expect.within (Expect.Absolute 0.000001) (get (config3 base) 5)
        -- , fuzz (Fuzz.floatRange -200 200) "Fuzz base negative index" <|
        --     \base ->
        --         (base * 1.5 ^ -6)
        --             |> Expect.within (Expect.Absolute 0.000001) (get (config3 base) -6)
        -- [ fuzz Fuzz.int "Fuzz index" <|
        --     \index ->
        --         (1.5 ^ toFloat index)
        --             |> Expect.within (Expect.Absolute 0.000001) (get config index)
        [ test "Get with positive index returns correct value" <|
            \_ ->
                Expect.within (Expect.Absolute 0.000001) (get config2 6) 3.375
        , test "Get with negative index returns correct value" <|
            \_ ->
                Expect.within (Expect.Absolute 0.000001) (get config2 -6) 0.2962962962962963
        ]
