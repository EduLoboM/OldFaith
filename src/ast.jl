module AST

    abstract type ASTNode end

    abstract type Expression <: ASTNode end

    abstract type Statement <: ASTNode end

    export ASTNode, Expression, Statement
    export Literal, Variable, BinaryExpression, CallExpression, TernaryExpression

    export RiteDef, Program
    
    struct Literal <: Expression
        value::Any
    end

    struct Variable <: Expression
        name::String
    end

    struct BinaryExpression <: Expression
        left::Expression
        operator::Symbol
        right::Expression
    end

    struct CallExpression <: Expression
        name::String
        arguments::Vector{Expression}
    end

    struct TernaryExpression <: Expression
        condition::Expression
        true_expression::Expression
        false_expression::Expression
    end

    struct RiteDef <: Statement
        name::String
        params::Vector{String}
        attributes::Vector{String}
        body::Expression
    end

    struct Program <: ASTNode
        rites::Vector{RiteDef}
        script::Vector{ASTNode}
    end
    
end