module Benchmarks exposing (..)

import Benchmark exposing (Benchmark, benchmark2, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import ModularScale


main : BenchmarkProgram
main =
    program <| suite


config : ModularScale.Config
config =
    { base = [ 12 ]
    , interval = ModularScale.PerfectFifth
    }


config2 : ModularScale.Config
config2 =
    { base = [ 12, 15 ]
    , interval = ModularScale.PerfectFifth
    }


config3 : ModularScale.Config
config3 =
    { base = [ 12, 15, 18 ]
    , interval = ModularScale.PerfectFifth
    }


suite : Benchmark
suite =
    describe "ModularScale get Benchmark"
        [ benchmark2 "Get with 1 base at index 5" ModularScale.get config 5
        , benchmark2 "Get with 1 base at index 50" ModularScale.get config 50
        , benchmark2 "Get with 2 bases at index 5" ModularScale.get config2 5
        , benchmark2 "Get with 2 bases at index 50" ModularScale.get config2 50
        , benchmark2 "Get with 3 bases at index 5" ModularScale.get config3 5
        , benchmark2 "Get with 3 bases at index 50" ModularScale.get config3 50
        ]
