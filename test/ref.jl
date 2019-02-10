using CSyntax.CRef
using Test

function cref_basic(x, y, z)
    z[] += 1
    return x, y, z
end

mutable struct FooCRef
    x
    y
end

@testset "CRef" begin
    x, y, z = 1, 2, 3
    @cref cref_basic(x, y, &z)
    @test z == 4

    f = FooCRef(10,20)
    @cref cref_basic(x, y, &f.x)
    @test f.x == 11
end
