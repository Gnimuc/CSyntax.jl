module CSyntax

include("CSwitch.jl")
using .CSwitch

include("CFor.jl")
using .CFor

"""
PrefixIncrement Operator
"""
macro +(x)
    @gensym tmp
    quote
        tmp = $(esc(x))
        $(esc(x)) += 1
        tmp
    end
end
@eval const $(Symbol("@++")) = $(Symbol("@+"))

"""
PrefixDecrement Operator
"""
macro -(x)
    @gensym tmp
    quote
        tmp = $(esc(x))
        $(esc(x)) -= 1
        tmp
    end
end
# @-- is invalid

export @+, @++, @-



end # module
