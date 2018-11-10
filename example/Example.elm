module Example exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import ModularScale exposing (Interval(..), get)



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { base : String
    , interval : Interval
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "1, 1.2" PerfectFifth, Cmd.none )



-- UPDATE


type Msg
    = OnBaseInput String
    | SelectInterval Interval


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnBaseInput input ->
            ( { model | base = input }, Cmd.none )

        SelectInterval interval ->
            ( { model | interval = interval }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = ""
    , body =
        [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
    let
        base =
            String.split "," model.base
                |> List.filterMap (String.toFloat << String.trim)

        config =
            ModularScale.config base model.interval
    in
    main_ []
        [ viewControls model
        , viewText config
        ]


viewControls : Model -> Html Msg
viewControls model =
    div
        [ style "width" "100%"
        , style "max-width" "800px"
        , style "box-sizing" "border-box"
        , style "margin" "1rem auto"
        , style "padding" "1rem 0"
        , style "display" "flex"
        , style "align-items" "center"
        , style "justify-content" "center"
        ]
        [ input
            [ onInput OnBaseInput
            , value model.base
            , style "padding" ".25rem"
            , style "width" "5rem"
            , style "font-size" "0.875rem"
            , style "margin-right" "1rem"
            ]
            []
        , select
            [ on "change" <|
                Decode.map SelectInterval <|
                    Decode.map intervalFromValue targetValue
            ]
            (List.map (viewIntervalOption model.interval) intervalList)
        ]


viewIntervalOption : Interval -> Interval -> Html Msg
viewIntervalOption current interval =
    option
        [ value (intervalToString interval)
        , selected (current == interval)
        ]
        [ text (intervalToString interval) ]


viewText : ModularScale.Config -> Html Msg
viewText config =
    div
        [ style "background-color" "#f0f0f0"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "width" "100%"
        , style "box-shadow" "8px 8px 0 0 #ccc"
        , style "max-width" "800px"
        , style "box-sizing" "border-box"
        , style "margin" (ms config 1 ++ " auto")
        , style "padding" (ms config 4)
        , style "line-height" (ms config 3)
        ]
        [ h1
            [ style "font-size" (ms config 4)
            , style "line-height" (ms config 0)
            ]
            [ text title ]
        , h2
            [ style "font-size" (ms config 3)
            , style "line-height" (ms config 1)
            ]
            [ text subtitle ]
        , p
            [ style "font-size" (ms config 1)
            , style "line-height" (ms config 1)
            ]
            [ text body ]
        , h3
            [ style "font-size" (ms config 2)
            , style "line-height" (ms config 1)
            ]
            [ text "A sample of values being generated" ]
        , ul [ style "font-size" (ms config 1) ] <|
            List.map viewScaleValue <|
                viewScaleList config 20
        ]


viewScaleList : ModularScale.Config -> Int -> List ( Int, String )
viewScaleList config length =
    List.map (\x -> ( x, ms config x )) (List.range -5 length)


viewScaleValue : ( Int, String ) -> Html msg
viewScaleValue ( index, size ) =
    li [] [ text ("Index " ++ String.fromInt index ++ " : " ++ size) ]


ms : ModularScale.Config -> Int -> String
ms config x =
    String.fromFloat (get config x) ++ "em"



-- TEXT


title : String
title =
    "Fusce rhoncus pharetra purus vel ornare"


subtitle : String
subtitle =
    "Nunc volutpat vitae eros id facilisis. Nam convallis quam sed elit facilisis congue."


body : String
body =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam nunc nisi, iaculis nec placerat sed, fermentum sit amet ante. Vivamus facilisis ultricies neque, eu imperdiet est fermentum at. Sed vitae enim eu ante dignissim tincidunt elementum vitae libero. Vestibulum feugiat dolor risus, at imperdiet eros dictum vitae. Pellentesque ut tellus sit amet mauris efficitur consequat. Integer vitae enim vel sem venenatis pretium et ut augue. Ut nec cursus libero, vel pellentesque nunc."



-- INTERVAL


intervalList : List Interval
intervalList =
    [ MinorSecond -- 1.067
    , MajorSecond -- 1.125
    , MinorThird -- 1.2
    , MajorThird -- 1.25
    , PerfectFourth -- 1.33
    , AugFourth -- 1.414
    , PerfectFifth -- 1.5
    , MinorSixth -- 1.6
    , GoldenSection -- 1.618
    , MajorSixth -- 1.667
    , MinorSeventh -- 1.778
    , MajorSeventh -- 1.875
    , Octave -- 2
    , MajorTenth -- 2.5
    , MajorEleventh -- 2.667
    , MajorTwelfth -- 3
    , DoubleOctave -- 4
    , Ratio 0 -- custom
    ]


intervalToString : Interval -> String
intervalToString interval =
    case interval of
        MinorSecond ->
            "MinorSecond"

        MajorSecond ->
            "MajorSecond"

        MinorThird ->
            "MinorThird"

        MajorThird ->
            "MajorThird"

        PerfectFourth ->
            "PerfectFourth"

        AugFourth ->
            "AugFourth"

        PerfectFifth ->
            "PerfectFifth"

        MinorSixth ->
            "MinorSixth"

        GoldenSection ->
            "GoldenSection"

        MajorSixth ->
            "MajorSixth"

        MinorSeventh ->
            "MinorSeventh"

        MajorSeventh ->
            "MajorSeventh"

        Octave ->
            "Octave"

        MajorTenth ->
            "MajorTenth"

        MajorEleventh ->
            "MajorEleventh"

        MajorTwelfth ->
            "MajorTwelfth"

        DoubleOctave ->
            "DoubleOctave"

        Ratio x ->
            "Ratio"


intervalFromValue : String -> Interval
intervalFromValue interval =
    case interval of
        "MinorSecond" ->
            MinorSecond

        "MajorSecond" ->
            MajorSecond

        "MinorThird" ->
            MinorThird

        "MajorThird" ->
            MajorThird

        "PerfectFourth" ->
            PerfectFourth

        "AugFourth" ->
            AugFourth

        "PerfectFifth" ->
            PerfectFifth

        "MinorSixth" ->
            MinorSixth

        "GoldenSection" ->
            GoldenSection

        "MajorSixth" ->
            MajorSixth

        "MinorSeventh" ->
            MinorSeventh

        "MajorSeventh" ->
            MajorSeventh

        "Octave" ->
            Octave

        "MajorTenth" ->
            MajorTenth

        "MajorEleventh" ->
            MajorEleventh

        "MajorTwelfth" ->
            MajorTwelfth

        "DoubleOctave" ->
            DoubleOctave

        _ ->
            Ratio 0
