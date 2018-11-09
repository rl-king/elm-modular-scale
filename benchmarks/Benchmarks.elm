module Benchmarks exposing (main)

import Benchmark exposing (Benchmark, benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import ModularScale


main : BenchmarkProgram
main =
    program <| suite


config : ModularScale.Config
config =
    ModularScale.config [ 12 ] ModularScale.PerfectFifth


config2 : ModularScale.Config
config2 =
    ModularScale.config [ 12, 15 ] ModularScale.PerfectFifth


config3 : ModularScale.Config
config3 =
    ModularScale.config [ 12, 15, 18 ] ModularScale.PerfectFifth


suite : Benchmark
suite =
    describe "ModularScale get Benchmark"
        [ benchmark "Get with 1 base at index 5" (\_ -> ModularScale.get config 5)
        , benchmark "Get with 1 base at index 50" (\_ -> ModularScale.get config 50)
        , benchmark "Get with 2 bases at index 5" (\_ -> ModularScale.get config2 5)
        , benchmark "Get with 2 bases at index 50" (\_ -> ModularScale.get config2 50)
        , benchmark "Get with 3 bases at index 5" (\_ -> ModularScale.get config3 5)
        , benchmark "Get with 3 bases at index 50" (\_ -> ModularScale.get config3 50)
        , benchmark "Get with 3 bases at index 100" (\_ -> ModularScale.get config3 100)
        , benchmark "Get with 3 bases at index 200" (\_ -> ModularScale.get config3 200)
        ]
