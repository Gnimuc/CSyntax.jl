using CSyntax.CSwitch
using Test

include("vsSwitch.jl")
@testset "CSwitch" begin
    @testset "fall through" begin
        @test switch_with_fallthrough(1) == Int[1, 2, 3, 4]
        @test switch_with_fallthrough(3) == Int[3, 4]
        @test switch_with_fallthrough(100) == Int[4]
    end
    @testset "leading default" begin
        @test switch_with_leading_default(1) == Int[1, 2, 3]
        @test switch_with_leading_default(3) == Int[3]
        @test switch_with_leading_default(100) == Int[4, 1, 2, 3]
    end
    @testset "with expressions" begin
        @test switch_with_expressions(1) == Int[1, 2, 3, 4]
        @test switch_with_expressions(3) == Int[3, 4]
        @test switch_with_expressions(100) == Int[4]
    end
    @testset "with break" begin
        @test switch_with_break(1) == Int[1]
        @test switch_with_break(3) == Int[3]
        @test switch_with_break(100) == Int[4]
    end
    @testset "enums" begin
        @enum test t=1 f=2
        tester = t
        @cswitch tester begin
            @case t
            x = 1
            break
            @case f
            x = 2
            break
        end
        @test x == 1
    end
end
