# tests/benchmark_tribonnaci.jl
include("../src/ast.jl")
include("../src/lexer.jl")
include("../src/parser.jl")
include("../src/interpreter.jl")

using .AST
using .Lexer
using .Parser
using .Interpreter

code = """
@rabbit
func trib(n) {
    return n < 3 ? 1 : trib(n-1) + trib(n-2) + trib(n-3);
}
"""

println("=======================================")
println("      R-Core - TRIBONNACI BENCHMARK    ")
println("=======================================\n")

println("--- 1. Lexer ---")
tokens = tokenize(code)
for t in tokens
    println("  $t")
end

println("\n--- 2. Parser ---")
program = parse_program(tokens)

func = program.functions[1]
println("  Function Name: ", func.name)
println("  Attributes Found: ", func.attributes)
println("  Parameters: ", func.params)
println("  Body:")
println("  ", func.body)

println("\n--- 3. Interpreter ---")
funcs = execute_program(program)

println("  Iniciando cálculo de trib(30) com @rabbit ativado...")
println("  Cronometrando...")

call = CallExpression("trib", Expression[Literal(30)])
ambiente_vazio = Dict{String,Any}()

@time begin
    resultado = Interpreter.evaluate(call, ambiente_vazio, funcs)
end

println("\n  >> RESULTADO FINAL: ", resultado)
println("====================================")
println(" IT WORKED! Rabbit saved the day!🐇 ")
println("====================================")