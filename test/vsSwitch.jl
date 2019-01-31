# Copyright (c) 2014: Daniel C. Jones
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# the following tests are copied from Switch.jl.

# basic switch constructs
function switch_with_fallthrough(x::Int)
    xs = Int[]
    @switch x begin
        @case 1
            push!(xs, 1)

        @case 2
            push!(xs, 2)

        @case 3
            push!(xs, 3)

        @default
            push!(xs, 4)
    end
    return xs
end

# fallthrough with weird default case placement
function switch_with_leading_default(x::Int)
    xs = Int[]
    @switch x begin
        @default
            push!(xs, 4)

        @case 1
            push!(xs, 1)

        @case 2
            push!(xs, 2)

        @case 3
            push!(xs, 3)
    end
    return xs
end


# switching with expressions
function switch_with_expressions(x::Int)
    xs = Int[]
    @switch x + 1 begin
        @case 1 + 1
            push!(xs, 1)

        @case 2 + 1
            push!(xs, 2)

        @case 3 + 1
            push!(xs, 3)

        @default
            push!(xs, 4)
    end
    return xs
end

# switching with breaks
function switch_with_break(x::Int)
    xs = Int[]
    @switch x begin
        @case 1
            push!(xs, 1)
            break

        @case 2
            push!(xs, 2)
            break

        @case 3
            push!(xs, 3)
            break

        @default
            push!(xs, 4)
    end
    return xs
end
