module CRef

export @cref

macro cref(ex)
    Meta.isexpr(ex, :call) || throw(ArgumentError("not a function call expression."))
    prologue = Expr(:block)
    epilogue = Expr(:block)
    func_expr = Expr(:call, first(ex.args))
    for arg in ex.args[2:end]
        if Meta.isexpr(arg, :&)
            refee = arg.args[]
            ref_sym = gensym("cref")
            push!(prologue.args, Expr(:(=), ref_sym, Expr(:call, :Ref, refee)))
            push!(func_expr.args, ref_sym)
            push!(epilogue.args, Expr(:(=), refee, Expr(:ref, ref_sym)))
        else
            push!(func_expr.args, arg)
        end
    end
    func_ret = gensym("cref_ret")
    push!(prologue.args, Expr(:(=), func_ret, func_expr))
    append!(prologue.args, epilogue.args)
    push!(prologue.args, func_ret)
    return esc(prologue)
end

end # module
