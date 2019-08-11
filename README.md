# CSyntax

[![Build Status](https://travis-ci.com/Gnimuc/CSyntax.jl.svg?branch=master)](https://travis-ci.com/Gnimuc/CSyntax.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/Gnimuc/CSyntax.jl?svg=true)](https://ci.appveyor.com/project/Gnimuc/CSyntax-jl)
[![Codecov](https://codecov.io/gh/Gnimuc/CSyntax.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Gnimuc/CSyntax.jl)

This package provides several macros for making life easier when translating C code to Julia.

## Installation
```
pkg> add CSyntax
```

## Submodules
### CRef
This module provides a macro `@cref`/`@c` for emulating C's `&`(address) operator:
```julia
julia> using CSyntax.CRef

julia> function foo(x)
           x[] += 1
           return x
       end
foo (generic function with 1 method)

julia> x = 0
0

julia> @cref foo(&x)
Base.RefValue{Int64}(1)

julia> x
1
```
It's very useful when calling C-bindings from Julia. Comparing the following Julia code
```julia
vbo = GLuint(0)
@c glGenBuffers(1, &vbo)
glBindBuffer(GL_ARRAY_BUFFER, vbo)
glBufferData(GL_ARRAY_BUFFER, 9 * sizeof(GLfloat), points, GL_STATIC_DRAW)
```
to
```c
GLuint vbo;
glGenBuffers(1, &vbo);
glBindBuffer(GL_ARRAY_BUFFER, vbo);
glBufferData(GL_ARRAY_BUFFER, 9 * sizeof(GLfloat), points, GL_STATIC_DRAW);
```
they're nearly identical aside from the `@c` macro. Without this, one need to manually edit the code at least 3 more times and life will be quickly burning in the hell:
```julia
vboID = Ref{GLuint}(0)
glGenBuffers(1, vboID)
glBindBuffer(GL_ARRAY_BUFFER, vboID[])
# errors are waiting for you unless you dereference vboID correctly in every place hereafter
```

Note, everything after `&` will be treated as scalar except one dimensional arrays indexing in which case the corresponding pointer address will be retrieved, for example:
```julia
A = rand(10)
@c foo(a, b, &A[n]) # ==> foo(a, b, pointer(A) + n * Core.sizeof(eltype(A)))
```
but
```julia
A = rand(10)
@c foo(a, b, &A)
# this is not array indexing, so the result is
# A_cref = Ref(A)
# foo(a, b, A_cref)
# A = A_cref[]
```


### CStatic
This submodule provides a `@cstatic` macro for emulating C's static syntax:
```julia
function foo()
    @cstatic i=0 begin
        for n = 1:10
            i += 1
        end
    end
end
```
vs
```c
int foo(void) {
    static int i = 0;
    for (int n = 0; n < 10; n++) {
        i++;
    }
    return i;
}
```
`@cstatic` will return a tuple of current state of the input arguments, but note that jumping
out from the `@cstatic` block (e.g. `return`, `goto`, etc.) is currently not supported,
state changes before jumping will be lost.

### CFor
This submodule provides a `@cfor` macro for emulating C's for-loops syntax:

```julia
julia> using CSyntax.CFor

julia> x = 0
0

julia> @cfor i=0 i<10 i+=1 begin
           global x += 1
       end

julia> x
10

# @cfor with @++
julia> using CSyntax: @++

julia> @cfor i=0 i<10 @++(i) begin
           i > 5 && continue  # well, this is actually illegal in C
           global x += 1
       end

julia> x
16

julia> let
           global j
           @cfor nothing (j > 3) j-=1 begin
               global x += 1
           end
       end

julia> x
23
```

### CSwitch
This submodule provides C-like switch statement with the "falling through" behavior.
It is inspired by [`dcjones`](https://github.com/dcjones)'s package [Switch.jl](https://github.com/dcjones/Switch.jl) which has died out since Julia v0.5. Anyway, it has been resurrected here.

```julia
julia> using CSyntax.CSwitch

julia> @enum test t=1 f=2

julia> tester = t
t::test = 1

julia> @cswitch tester begin
           @case t
               x = 1
               break
           @case f
               x = 2
               break
       end

julia> x
1
```
### CEnum
[CEnum.jl](https://github.com/JuliaInterop/CEnum.jl) is also integrated in this package.
```julia
julia> @enum Foo a = 1 b = 2 c = 1
ERROR: LoadError: ArgumentError: values for Enum Foo are not unique
Stacktrace:
 [1] @enum(::LineNumberNode, ::Module, ::Any, ::Vararg{Any,N} where N) at ./Enums.jl:128
in expression starting at REPL[12]:1

julia> using CSyntax.CEnum

julia> @cenum(Bar, d = 1, e = 2, f = 1)

julia> d == f
true
```

## TODO?
- [ ] `@cmacro`? how to correctly handle recursive macro expansion rules?
- [ ] `@cdo-while`? it's very trivial to implement but not very useful I guess
- [ ] `@cstar`? `*` aka the so called indirection operator
