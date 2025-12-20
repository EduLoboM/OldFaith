module Parser

using Main.AST
using Main.Lexer

export parse_program

mutable struct ParserState
    tokens::Vector{Token}
    pos::Int
end

function current(p::ParserState)
    if p.pos > length(p.tokens)
        return Token(TOKEN_EOF, "", 0)
    end
    return p.tokens[p.pos]
end

function next(p::ParserState, type::TokenType)
    t = current(p)
    if t.type == type
        p.pos += 1
        return t
    else
        error("Syntax error in line $(t.line): Expected $type, found $(t.type)")
    end
end

function parse_factor(p::ParserState)
    t = current(p)

    if t.type == TOKEN_INT
        next(p, TOKEN_INT)
        return Literal(parse(Int, t.value))
    
    elseif t.type == TOKEN_LPAREN
        next(p, TOKEN_LPAREN)
        expr = parse_expression(p)
        next(p, TOKEN_RPAREN)
        return expr

    elseif t.type == TOKEN_IDENT

        name = t.value
        next(p, TOKEN_IDENT)
        
        if current(p).type == TOKEN_LPAREN
            next(p, TOKEN_LPAREN)
            args = Expression[]
            if current(p).type != TOKEN_RPAREN
                push!(args, parse_expression(p))
                while current(p).type == TOKEN_COMMA
                    next(p, TOKEN_COMMA)
                    push!(args, parse_expression(p))
                end
            end
            next(p, TOKEN_RPAREN)
            return CallExpression(name, args)
        else
            return Variable(name)
        end
        
    else
        error("Parsing error in line $(t.line): Expected number or identifier, found $(t.type)")
    end
end

function parse_term(p::ParserState)
    left = parse_factor(p)

    while current(p).type in [TOKEN_STAR, TOKEN_SLASH, TOKEN_PERCENT]
        op_token = current(p)
        next(p, op_token.type)
        right = parse_factor(p)
        
        op_sym = Symbol(op_token.value)
        left = BinaryExpression(left, op_sym, right)
    end

    return left
end

function parse_additive(p::ParserState)
    left = parse_term(p)

    while current(p).type in [TOKEN_PLUS, TOKEN_MINUS]
        op_token = current(p)
        next(p, op_token.type)
        right = parse_term(p)
        
        op_sym = Symbol(op_token.value)
        left = BinaryExpression(left, op_sym, right)
    end

    return left
end

function parse_comparison(p::ParserState)
    left = parse_additive(p)

    if current(p).type in [TOKEN_LT, TOKEN_GT]
        op_token = current(p)
        next(p, op_token.type)
        right = parse_additive(p)
        
        op_sym = Symbol(op_token.value)
        return BinaryExpression(left, op_sym, right)
    end

    return left
end

function parse_expression(p::ParserState)
    cond = parse_comparison(p)

    if current(p).type == TOKEN_QUESTION
        next(p, TOKEN_QUESTION)
        true_expr = parse_expression(p)
        next(p, TOKEN_COLON)
        false_expr = parse_expression(p)
        
        return TernaryExpression(cond, true_expr, false_expr)
    end

    return cond
end


function parse_function(p::ParserState)
    attributes = String[]
    while current(p).type == TOKEN_AT
        next(p, TOKEN_AT)
        attr_name = next(p, TOKEN_IDENT).value
        push!(attributes, attr_name)
    end

    next(p, TOKEN_FUNC)
    name = next(p, TOKEN_IDENT).value
    
    next(p, TOKEN_LPAREN)
    params = String[]
    if current(p).type == TOKEN_IDENT
        push!(params, next(p, TOKEN_IDENT).value)
        while current(p).type == TOKEN_COMMA
            next(p, TOKEN_COMMA)
            push!(params, next(p, TOKEN_IDENT).value)
        end
    end
    next(p, TOKEN_RPAREN)

    next(p, TOKEN_LBRACE)
    next(p, TOKEN_RETURN)
    
    body_expr = parse_expression(p)
    
    next(p, TOKEN_SEMICOLON)
    next(p, TOKEN_RBRACE)

    return FunctionDef(name, params, attributes, body_expr)
end


function parse_program(tokens::Vector{Token})
    p = ParserState(tokens, 1)
    
    functions = FunctionDef[]
    script = ASTNode[]

    while current(p).type != TOKEN_EOF
        if current(p).type == TOKEN_AT || current(p).type == TOKEN_FUNC
            push!(functions, parse_function(p))
        else
            break 
        end
    end

    return Program(functions, script)
end

end