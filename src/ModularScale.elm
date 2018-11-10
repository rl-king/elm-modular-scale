module ModularScale exposing
    ( Config
    , config
    , get
    , Interval(..)
    )

{-| Generating numerical values derived from musical intervals. Use this to generate proportionally related font-sizes, line-height, element dimensions, ect.

Based on the idea found at [http://www.modularscale.com/](modularscale.com).


# Configuration

@docs Config
@docs config


# Get a value

@docs get


# Interval or custom ratio

@docs Interval

-}

import Array exposing (Array)
import List exposing (..)


{-| Stores the base(s) and `Interval`
-}
type Config
    = Config
        { negativeValues : Array Float
        , positiveValues : Array Float
        , base : List Float
        , interval : Interval
        }


{-| Create the `Config` for your scale. It's recommended to not use more than two base values, and often one is enough. Using more values dilutes the scale too much and the range of generated values might get too narrow.

    config : Config
    config =
        ModularScale.config [ 1, 1.2 ] ModularScale.PerfectFifth

-}
config : List Float -> Interval -> Config
config base interval =
    Config
        { positiveValues = generate base interval 50
        , negativeValues = generate base interval -50
        , base = base
        , interval = interval
        }


{-| Return the value at an index of the scale based on the provided base(s).

    config : Config
    config =
        ModularScale.config [ 1 ] ModularScale.PerfectFifth

    get config 5

    --> 7.59375

You'll probably want to create a helper function like this.

    ms : Int -> String
    ms x =
        String.fromFloat (get config x) ++ "em"

Which you'll use like this.

    h1 [ style [ ( "font-size", ms 4 ) ] ] [ text "Foo" ]

Or, if you're using elm-css

    ms : Int -> Css.Rem
    ms x =
        \divisor -> remainderBy divisor (get config x)

    style : List Style
    style =
        [ fontSize (ms 4) ]

-}
get : Config -> Int -> Float
get (Config conf) index =
    Maybe.withDefault 0 <|
        if index >= 0 && index <= 50 then
            Array.get index conf.positiveValues

        else if index < 0 && index >= -50 then
            Array.get (abs index) conf.negativeValues

        else
            Array.get (abs index) <|
                generate conf.base conf.interval index


generate : List Float -> Interval -> Int -> Array Float
generate base interval index =
    let
        ratio =
            intervalToRatio interval
    in
    if index >= 0 then
        (Array.fromList << List.sort) <|
            List.foldr (\i acc -> List.map (\b -> b * ratio ^ toFloat i) base ++ acc) [] <|
                List.range 0 index

    else
        (Array.fromList << List.drop (List.length base - 1) << List.reverse << List.sort) <|
            List.foldr (\i acc -> List.map (\b -> b * ratio ^ toFloat i) base ++ acc) [] <|
                List.range index 0


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
