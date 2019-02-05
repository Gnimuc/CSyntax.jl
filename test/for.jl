using CSyntax.CFor
using Test

function for_basic()
    x = 0
    @cfor i=0 i<10 i+=1 begin
        x += 1
    end
    x
end

function for_continue()
    x = 0
    @cfor i=0 i<10 i+=1 begin
        i == 1 && continue
        x == 1 && (x = 1;)
    end
    x
end

function for_break()
    x = 0
    @cfor i=0 i<10 i+=1 begin
        i == 2 && break
        x = i
    end
    x
end

function for_nested()
    A = Matrix(undef, 3, 5)
    @cfor i=1 i<=3 i+=1 begin
        @cfor j=1 j<=5 j+=1 begin
            A[i,j] = i + j
        end
    end
    A
end



@testset "for-loops" begin
    @test for_basic() == 10
    @test for_continue() == 0
    @test for_break() == 1
    @test vec(for_nested()) == [2,3,4,3,4,5,4,5,6,5,6,7,6,7,8]
end
