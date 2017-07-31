module ModularScale exposing (Config, Interval(..), get, getEm)

{-| A library for generating numerical values derived from musical intervals. With these you'll be able to easily create proportionally related font-sizes, line-height, element dimensions.

Based on the idea found at <a target="_blank" href="http://www.modularscale.com/">modularscale.com</a>


# Configuration

@docs Config


# Get a value

@docs get

@docs getEm


# Interval or custom ratio

@docs Interval

-}


{-| Create the `config` for your scale. I recommend not using more than two base values, and often one is enough. Using more values dilutes the scale too much and the range of generated values will get too narrow.

    config : ModularScale.Config
    config =
        { base = [ 12, 15 ]
        , interval = PerfectFifth
        }

-}
type alias Config =
    { base : List Int
    , interval : Interval
    }


{-| Return the base value multiplied at a modular scale index. You'll probably want to create a helper function like this.

    ms : Int -> String
    ms x =
        toString (ModularScale.get config x) ++ "px"

    h1 [ style [ ( "font-size", ms 4 ) ] ] [ text "Foo" ]

-}
get : Config -> Int -> Float
get { base, interval } index =
    if List.length base == 1 then
        base
            |> List.head
            |> Maybe.withDefault 0
            |> (\x -> toFloat x * getEm interval index)
    else
        getRecursive index (intervalToRatio interval) (List.map toFloat base)


getRecursive : Int -> Float -> List Float -> Float
getRecursive index interval base =
    if index == -1 then
        base
            |> List.minimum
            |> Maybe.withDefault 0
    else
        let
            min =
                base
                    |> List.minimum
                    |> Maybe.withDefault 0

            applyScale x =
                if x == min then
                    x * interval
                else
                    x

            updatedBase =
                List.map applyScale base
        in
        getRecursive (index - 1) interval updatedBase


{-| Get the multiplication factor at a given index of the scale
-}
getEm : Interval -> Int -> Float
getEm interval index =
    intervalToRatio interval ^ toFloat index


{-| -}
type Interval
    = MinorSecond -- 1.067
    | MajorSecond -- 1.125
    | MinorThird -- 1.2
    | MajorThird -- 1.25
    | PerfectFourth -- 1.33
    | AugFourth -- 1.414
    | PerfectFifth -- 1.5
    | MinorSixth -- 1.6
    | GoldenSection -- 1.618
    | MajorSixth -- 1.667
    | MinorSeventh -- 1.778
    | MajorSeventh -- 1.875
    | Octave -- 2
    | MajorTenth -- 2.5
    | MajorEleventh -- 2.667
    | MajorTwelfth -- 3
    | DoubleOctave -- 4
    | Ratio Float -- custom


intervalToRatio : Interval -> Float
intervalToRatio interval =
    case interval of
        MinorSecond ->
            1.067

        MajorSecond ->
            1.125

        MinorThird ->
            1.2

        MajorThird ->
            1.25

        PerfectFourth ->
            1.33

        AugFourth ->
            1.414

        PerfectFifth ->
            1.5

        MinorSixth ->
            1.6

        GoldenSection ->
            1.618

        MajorSixth ->
            1.667

        MinorSeventh ->
            1.778

        MajorSeventh ->
            1.875

        Octave ->
            2

        MajorTenth ->
            2.5

        MajorEleventh ->
            2.667

        MajorTwelfth ->
            3

        DoubleOctave ->
            4

        Ratio x ->
            x
