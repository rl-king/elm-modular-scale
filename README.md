# 📏 Elm Modular Scale
A library for generating numerical values derived from musical intervals. A tool that will help you create proportionally related values to be used as font sizes, element widths, line height, ect.

Based on the idea found at <a target="_blank" href="http://www.modularscale.com/">modularscale.com</a>

## Config
Create the `config` for your scale. I recommend not using more than two base values, and often one is enough. Using more values dilutes the scale too much and the range of generated values might get too narrow.

    config : Config
    config =
        { base = [ 1, 1.2 ]
        , interval = PerfectFifth
        }

## Get value
Return the value at an index of the scale based on the provided base(s).

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