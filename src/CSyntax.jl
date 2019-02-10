module CSyntax

using CEnum

include("CSwitch.jl")
using .CSwitch

include("CFor.jl")
using .CFor

include("CRef.jl")
using .CRef

# add @c as an alias of @cref
@eval const $(Symbol("@c")) = $(Symbol("@cref"))
export @c

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
