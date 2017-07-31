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
        "This tool will help you create balanced font size combinations and is also great for margins, padding, line-height."


config : ModularScale.Config
config =
    { base = [ 12, 17 ]
    , interval = PerfectFifth
    }


ms : Int -> String
ms x =
    toString (ModularScale.get config x) ++ "px"


modularScaleList : Int -> List ( Int, String )
modularScaleList length =
    List.map (\x -> ( x, ms x )) (List.range -10 length)


view : Model -> Html msg
view model =
    div
        [ style
            [ ( "background-color", "#eee" )
            , ( "width", ms 15 )
            , ( "margin", ms 3 ++ " auto" )
            , ( "padding", ms 1 ++ " " ++ ms 4 )
            ]
        ]
        [ h1 [ style [ ( "font-size", ms 4 ) ] ] [ text model.title ]
        , h2 [ style [ ( "font-size", ms 2 ) ] ] [ text model.subtitle ]
        , p [ style [ ( "font-size", ms 1 ) ] ] [ text model.body ]
        , strong [ style [ ( "font-size", ms 1 ) ] ] [ text "A sample of values being generated" ]
        , dl [ style [ ( "font-size", ms 1 ) ] ] <| List.concat <| List.map modularScaleValue <| modularScaleList 20
        ]


modularScaleValue : ( Int, String ) -> List (Html msg)
modularScaleValue ( index, size ) =
    [ dt [] [ text <| "Index " ++ toString index ]
    , dd [] [ text <| toString size ]
    ]
