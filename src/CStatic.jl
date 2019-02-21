module CStatic

export @cstatic

# ref: https://github.com/JuliaLang/julia/issues/15056#issuecomment-183937358
macro cstatic(exprs...)
    prologue = Expr(:block)
    epilogue = Expr(:block)
    ret = length(exprs) > 2 ? Expr(:tuple) : first(exprs).args[1]
    for expr in exprs[1:end-1]
        Meta.isexpr(expr, :(=)) || throw(ArgumentError("syntax mismatch! should be `@cstatic x1=1 x2=2 ... xn=n expr`."))
        local_sym, init_expr = expr.args
        global_sym = gensym("static_$local_sym")
        Base.eval(__module__, Expr(:(=), global_sym, init_expr))
        push!(prologue.args, Expr(:global, global_sym))
        push!(prologue.args, Expr(:local, Expr(:(=), local_sym, global_sym)))
        push!(epilogue.args, Expr(:(=), global_sym, local_sym))
        length(exprs) > 2 && push!(ret.args, local_sym)
    end
    push!(epilogue.args, ret)
    push!(prologue.args, exprs[end])
    append!(prologue.args, epilogue.args)
    return esc(Expr(:let, Expr(:block), prologue))
end

end # module
