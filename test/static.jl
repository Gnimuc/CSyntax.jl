using CSyntax.CStatic
using Test

function cstatic_basic()
    @cstatic x=0 begin
        x += 1
    end
end

function cstatic_scope()
    w = false
    x1, y1 = @cstatic x=30 y=40 begin
        x += 1
        y -= 1
        w = true
    end
    x = 10
    x2 = @cstatic x=3.1415 begin
       x *= 2
    end
    return x, w, x1, y1, x2
end

@testset "CStatic" begin
    for i = 1:10
        @test cstatic_basic() == i
    end
    cstatic_scope()
    cstatic_scope()
    @test cstatic_scope() == (10, true, 33, 37, 25.132)
end
