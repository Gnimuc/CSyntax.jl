module CFor

export @cfor

macro cfor(init, cond, inc, body)
    entry_label = gensym("entry")
    let_block = Expr(:block)
    while_block = Expr(:block)
    if !Meta.isexpr(init, :null) || (Meta.isexpr(inc, :block) && !isempty(inc.args))
        push!(while_block.args, inc)
        push!(while_block.args, Expr(:symboliclabel, entry_label))
    end
    if !Meta.isexpr(cond, :null) || (Meta.isexpr(cond, :block) && !isempty(cond.args))
        push!(while_block.args, Expr(:||, cond, Expr(:break)))
    end
    push!(while_block.args, body)

    if !Meta.isexpr(init, :null) || (Meta.isexpr(init, :block) && !isempty(init.args))
        push!(let_block.args, init)
    end
    push!(let_block.args, Expr(:symbolicgoto, entry_label))
    push!(let_block.args, Expr(:while, true, while_block))
    let_expr = Expr(:let, Expr(:block), let_block)
    return esc(let_expr)
end

end # module
