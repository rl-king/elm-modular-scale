module ModularScale exposing
    ( Config
    , config
    , get
    , Interval(..)
    )

{-| A library for generating numerical values derived from musical intervals. This will get you proportionally related font-sizes, line-height, element dimensions, ect.

Based on the idea found at <a target="_blank" href="http://www.modularscale.com/">modularscale.com</a>.


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


type Config
    = Config
        { negativeValues : Array Float
        , positiveValues : Array Float
        , base : List Float
        , interval : Interval
        }


{-| Create the `config` for your scale. It's recommended to not use more than two base values, and often one is enough. Using more values dilutes the scale too much and the range of generated values might get too narrow.

    config : Config
    config =
        ModularScale.config [ 1, 1.2 ] ModularScale.PerfectFifth

-}
config : List Float -> Interval -> Config
config base interval =
    Config
        { positiveValues =
            Array.fromList <|
                List.map (generate base interval) (List.range 0 100)
        , negativeValues =
            (Array.fromList << List.reverse) <|
                List.map (generate base interval) (List.range -50 0)
        , base = base
        , interval = interval
        }


get : Config -> Int -> Float
get (Config conf) index =
    if index >= 0 && index < 51 then
        Maybe.withDefault 0 <|
            Array.get index conf.positiveValues

    else if index < 0 && index > -51 then
        Maybe.withDefault 0 <|
            Array.get (negate index) conf.negativeValues

    else
        generate conf.base conf.interval index


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
        rem (get config x)

    style : List Style
    style =
        [ fontSize (ms 4) ]

-}
generate : List Float -> Interval -> Int -> Float
generate base interval index =
    let
        ratio =
            intervalToRatio interval
    in
    if index >= 0 then
        (Maybe.withDefault 0 << List.head << List.drop index << List.sort) <|
            List.concatMap (\i -> List.map (\x -> x * ratio ^ toFloat i) base) (List.range 0 index)

    else
        (Maybe.withDefault 0 << List.head << List.drop index << List.sort) <|
            List.concatMap (\i -> List.map (\x -> x * ratio ^ toFloat i) base) (List.range index 0)


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
