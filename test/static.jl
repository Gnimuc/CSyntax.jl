using CSyntax.CStatic
using Test

function cstatic_basic()
    @cstatic x=1 begin
        x += 1
    end
end

function cstatic_scope()
    w = false
    @cstatic x=30 y=40 begin
        x += 1
        y -= 1
        w = true
    end
    x = 10
    @cstatic x=3.1415 begin
       x *= 2
    end
    return x, w
end

@testset "CStatic" begin
    for i = 1:10
        @test cstatic_basic() == i + 1
    end
    @test cstatic_scope() == (10, true)
end
