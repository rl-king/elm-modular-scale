module Benchmarks exposing (..)

import Benchmark exposing (Benchmark, benchmark1, benchmark2, benchmark3, describe)
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
    describe "ModularScale Benchmark)"
        [ benchmark2 "getEm" ModularScale.getEm ModularScale.PerfectFifth 2
        , benchmark2 "Get 1 base index 5" ModularScale.get config 5
        , benchmark2 "Get 2 bases index 5" ModularScale.get config2 5
        , benchmark2 "Get 3 bases index 5" ModularScale.get config3 5
        ]
