module ModularScale exposing (Config, Interval, get, getEm)


type alias Config =
    { base : Float
    , interval : Interval
    }


get : Config -> Int -> Float
get config index =
    getEm config index * config.base


getEm : Config -> Int -> Float
getEm config index =
    intervalToRatio config.interval ^ toFloat index


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


type Interval
    = MinorSecond
    | MajorSecond
    | MinorThird
    | MajorThird
    | PerfectFourth
    | AugFourth
    | PerfectFifth
    | MinorSixth
    | GoldenSection
    | MajorSixth
    | MinorSeventh
    | MajorSeventh
    | Octave
    | MajorTenth
    | MajorEleventh
    | MajorTwelfth
    | DoubleOctave
    | Ratio Float
