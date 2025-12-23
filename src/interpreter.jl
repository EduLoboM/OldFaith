module Interpreter
using Main.AST
export execute_program

const RiteTable = Dict{String, RiteDef}

const Environment = Dict{String, Any}

const ShamuraCache = Dict{Tuple{String, Vector{Any}}, Any}()

function evaluate(expr::Literal, env::Environment, rites::RiteTable)
    return expr.value
end

function evaluate(expr::Variable, env::Environment, rites::RiteTable)
    if haskey(env, expr.name)
        return env[expr.name]
    else
        error("Blasphemy: The spirits do not know the name '$(expr.name)'.")
    end
end

function evaluate(expr::BinaryExpression, env::Environment, rites::RiteTable)
    left = evaluate(expr.left, env, rites)
    right = evaluate(expr.right, env, rites)
    
    op = expr.operator
    if op == :+ return left + right
    elseif op == :- return left - right
    elseif op == :* return left * right
    elseif op == :/ return div(left, right)
    elseif op == :% return left % right
    elseif op == :< return left < right
    elseif op == :> return left > right
    else error("Forbidden Geometry: Unknown operator $op")
    end
end

function evaluate(expr::TernaryExpression, env::Environment, rites::RiteTable)
    condition = evaluate(expr.condition, env, rites)
    if condition == true
        return evaluate(expr.true_expression, env, rites)
    else
        return evaluate(expr.false_expression, env, rites)
    end
end

function evaluate(expr::CallExpression, env::Environment, rites::RiteTable)
    rite_name = expr.name
    
    if !haskey(rites, rite_name)
        error("False Idol: The Rite '$rite_name' has not been sanctified.")
    end
    
    rite_def = rites[rite_name]
    
    args_values = [evaluate(arg, env, rites) for arg in expr.arguments]
    
    use_cache = "shamura" in rite_def.attributes
    cache_key = (rite_name, args_values)
    
    if use_cache && haskey(ShamuraCache, cache_key)
        return ShamuraCache[cache_key]
    end

    new_env = Environment()
    for (i, param_name) in enumerate(rite_def.params)
        new_env[param_name] = args_values[i]
    end
    
    result = evaluate(rite_def.body, new_env, rites)
    
    if use_cache
        ShamuraCache[cache_key] = result
    end
    
    return result
end

function execute_program(program::Program)

    rites = RiteTable()
    for r in program.rites
        rites[r.name] = r
    end
    
    empty!(ShamuraCache)
    
    return rites
end

end