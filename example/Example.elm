module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import ModularScale exposing (..)


main : Program Never Model msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = \x y -> model
        }


type alias Model =
    { title : String
    , subtitle : String
    , body : String
    }


model : Model
model =
    Model "Elm Modular Scale"
        "Usable values derived from musical intervals"
        "A tool that will help you create proportionally related values to be used as font sizes, element widths, line height, ect. "


config : ModularScale.Config
config =
    { base = [ 1, 1.2 ]
    , interval = PerfectFifth
    }


ms : Int -> String
ms x =
    toString (get config x) ++ "em"


modularScaleList : Int -> List ( Int, String )
modularScaleList length =
    List.map (\x -> ( x, ms x )) (List.range 0 length)


view : Model -> Html msg
view model =
    div
        [ style
            [ ( "background-color", "#f0f0f0" )
            , ( "font-family", "Helvetica, Arial, sans-serif" )
            , ( "width", ms 16 )
            , ( "margin", ms 3 ++ " auto" )
            , ( "padding", ms 1 ++ " " ++ ms 4 )
            , ( "line-height", ms 3 )
            ]
        ]
        [ h1 [ style [ ( "font-size", ms 4 ) ] ] [ text model.title ]
        , h2 [ style [ ( "font-size", ms 3 ) ] ] [ text model.subtitle ]
        , p [ style [ ( "font-size", ms 1 ) ] ] [ text model.body ]
        , h3 [ style [ ( "font-size", ms 2 ) ] ] [ text "A sample of values being generated" ]
        , ul [ style [ ( "font-size", ms 1 ) ] ] <| List.map modularScaleValue <| modularScaleList 20
        ]


modularScaleValue : ( Int, String ) -> Html msg
modularScaleValue ( index, size ) =
    li [] [ text ("Index " ++ toString index ++ " : " ++ size) ]
