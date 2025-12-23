module Lexer

export TokenType, Token, tokenize

export TOKEN_RITE, TOKEN_SACRIFICE, TOKEN_EOF, TOKEN_INT, TOKEN_IDENT
export TOKEN_LPAREN, TOKEN_RPAREN, TOKEN_LBRACE, TOKEN_RBRACE
export TOKEN_COMMA, TOKEN_SEMICOLON, TOKEN_AT
export TOKEN_PLUS, TOKEN_MINUS, TOKEN_STAR, TOKEN_SLASH, TOKEN_PERCENT, TOKEN_ASSIGN
export TOKEN_LT, TOKEN_GT, TOKEN_QUESTION, TOKEN_COLON

@enum TokenType begin
    # Key-Words
    TOKEN_RITE      # rite
    TOKEN_SACRIFICE # sacrifice
    
    # Identifiers and literals
    TOKEN_IDENT     # x
    TOKEN_INT       # 1
    
    # Symbols
    TOKEN_LPAREN    # (
    TOKEN_RPAREN    # )
    TOKEN_LBRACE    # {
    TOKEN_RBRACE    # }
    TOKEN_COMMA     # ,
    TOKEN_SEMICOLON # ;
    TOKEN_AT        # @
    
    # Operators
    TOKEN_PLUS      # +
    TOKEN_MINUS     # -
    TOKEN_STAR      # *
    TOKEN_SLASH     # /
    TOKEN_PERCENT   # %
    TOKEN_ASSIGN    # =
    TOKEN_LT        # <
    TOKEN_GT        # >
    
    # Ternarys
    TOKEN_QUESTION  # ?
    TOKEN_COLON     # :
    
    TOKEN_EOF       # Fim
end

struct Token
    type::TokenType
    value::String
    line::Int
end

function tokenize(source::String)
    tokens = Token[]
    i = 1
    len = length(source)
    line = 1

    while i <= len
        char = source[i]

        if isspace(char)
            if char == '\n'
                line += 1
            end
            i += 1
            continue
        end

        if isdigit(char)
            start = i
            while i <= len && isdigit(source[i])
                i += 1
            end
            num_str = source[start:i-1]
            push!(tokens, Token(TOKEN_INT, num_str, line))
            continue
        end

        if isletter(char)
            start = i
            while i <= len && (isletter(source[i]) || isdigit(source[i]) || source[i] == '_')
                i += 1
            end
            word = source[start:i-1]
            
            type = if word == "rite"
                TOKEN_RITE
            elseif word == "sacrifice"
                TOKEN_SACRIFICE
            else
                TOKEN_IDENT
            end
            
            push!(tokens, Token(type, word, line))
            continue
        end

        if char == '@'
            push!(tokens, Token(TOKEN_AT, "@", line))
        elseif char == '('
            push!(tokens, Token(TOKEN_LPAREN, "(", line))
        elseif char == ')'
            push!(tokens, Token(TOKEN_RPAREN, ")", line))
        elseif char == '{'
            push!(tokens, Token(TOKEN_LBRACE, "{", line))
        elseif char == '}'
            push!(tokens, Token(TOKEN_RBRACE, "}", line))
        elseif char == ','
            push!(tokens, Token(TOKEN_COMMA, ",", line))
        elseif char == ';'
            push!(tokens, Token(TOKEN_SEMICOLON, ";", line))
        elseif char == '+'
            push!(tokens, Token(TOKEN_PLUS, "+", line))
        elseif char == '-'
            push!(tokens, Token(TOKEN_MINUS, "-", line))
        elseif char == '*'
            push!(tokens, Token(TOKEN_STAR, "*", line))
        elseif char == '/'
            push!(tokens, Token(TOKEN_SLASH, "/", line))
        elseif char == '%'
            push!(tokens, Token(TOKEN_PERCENT, "%", line))
        elseif char == '='
            push!(tokens, Token(TOKEN_ASSIGN, "=", line))
        elseif char == '<'
            push!(tokens, Token(TOKEN_LT, "<", line))
        elseif char == '>'
            push!(tokens, Token(TOKEN_GT, ">", line))
        elseif char == '?'
            push!(tokens, Token(TOKEN_QUESTION, "?", line))
        elseif char == ':'
            push!(tokens, Token(TOKEN_COLON, ":", line))
        
        else
            error("Unknown token in line: $line: '$char'")
        end

        i += 1
    end

    push!(tokens, Token(TOKEN_EOF, "", line))
    return tokens
end

end