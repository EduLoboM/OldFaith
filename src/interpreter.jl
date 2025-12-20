module Interpreter
using Main.AST
export execute_program

const FunctionTable = Dict{String, FunctionDef}

const Environment = Dict{String, Any}

const RatCache = Dict{Tuple{String, Vector{Any}}, Any}()

function evaluate(expr::Literal, env::Environment, funcs::FunctionTable)
    return expr.value
end

function evaluate(expr::Variable, env::Environment, funcs::FunctionTable)
    if haskey(env, expr.name)
        return env[expr.name]
    else
        error("Erro: Variable '$(expr.name)' not found.")
    end
end

function evaluate(expr::BinaryExpression, env::Environment, funcs::FunctionTable)
    left = evaluate(expr.left, env, funcs)
    right = evaluate(expr.right, env, funcs)
    
    op = expr.operator
    if op == :+ return left + right
    elseif op == :- return left - right
    elseif op == :* return left * right
    elseif op == :/ return div(left, right)
    elseif op == :% return left % right
    elseif op == :< return left < right
    elseif op == :> return left > right
    else error("Operador desconhecido: $op")
    end
end

function evaluate(expr::TernaryExpression, env::Environment, funcs::FunctionTable)
    condition = evaluate(expr.condition, env, funcs)
    if condition == true
        return evaluate(expr.true_expression, env, funcs)
    else
        return evaluate(expr.false_expression, env, funcs)
    end
end

function evaluate(expr::CallExpression, env::Environment, funcs::FunctionTable)
    func_name = expr.name
    
    if !haskey(funcs, func_name)
        error("Erro: Function '$func_name' doesn't exist.")
    end
    
    func_def = funcs[func_name]
    
    args_values = [evaluate(arg, env, funcs) for arg in expr.arguments]
    
    use_cache = "rabbit" in func_def.attributes
    cache_key = (func_name, args_values)
    
    if use_cache && haskey(RatCache, cache_key)
        return RatCache[cache_key]
    end

    new_env = Environment()
    for (i, param_name) in enumerate(func_def.params)
        new_env[param_name] = args_values[i]
    end
    
    result = evaluate(func_def.body, new_env, funcs)
    
    if use_cache
        RatCache[cache_key] = result
    end
    
    return result
end

function execute_program(program::Program)

    funcs = FunctionTable()
    for f in program.functions
        funcs[f.name] = f
    end
    
    empty!(RatCache)
    
    return funcs
end

end