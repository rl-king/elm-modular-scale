module ModularScale exposing (Config, Interval(..), get)

{-| A library for generating numerical values derived from musical intervals. This will get you proportionally related font-sizes, line-height, element dimensions, ect.

Based on the idea found at <a target="_blank" href="http://www.modularscale.com/">modularscale.com</a>.


# Configuration

@docs Config


# Get a value

@docs get


# Interval or custom ratio

@docs Interval

-}

import List exposing (..)


{-| Create the `config` for your scale. I recommend not using more than two base values, and often one is enough. Using more values dilutes the scale too much and the range of generated values might get too narrow.

    config : Config
    config =
        { base = [ 1, 1.2 ]
        , interval = PerfectFifth
        }

-}
type alias Config =
    { base : List Float
    , interval : Interval
    }


{-| Return the value at an index of the scale based on the provided base(s).

    config =
        { base = [ 1 ]
        , interval = PerfectFifth
        }

    get config 5

    --> 7.59375

You'll probably want to create a helper function like this.

    ms : Int -> String
    ms x =
        toString (get config x) ++ "em"

Which you'll use like this.

    h1 [ style [ ( "font-size", ms 4 ) ] ][ text "Foo" ]

-}
get : Config -> Int -> Float
get { base, interval } index =
    case base of
        [] ->
            0

        [ x ] ->
            x * intervalToRatio interval ^ toFloat index

        xs ->
            getRecursive index (intervalToRatio interval) xs


getRecursive : Int -> Float -> List Float -> Float
getRecursive index interval base =
    case index of
        0 ->
            base
                |> List.minimum
                |> Maybe.withDefault 0

        _ ->
            let
                ( target, updatedIndex, indexIsNegative ) =
                    case index < 0 of
                        True ->
                            ( List.maximum base |> Maybe.withDefault 0, index + 1, True )

                        False ->
                            ( List.minimum base |> Maybe.withDefault 0, index - 1, False )

                applyScale x =
                    if x == target && indexIsNegative then
                        x / interval
                    else if x == target then
                        x * interval
                    else
                        x

                updatedBase =
                    List.map applyScale base
            in
            getRecursive updatedIndex interval updatedBase


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
