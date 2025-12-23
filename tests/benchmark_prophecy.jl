# tests/benchmark_prophecy.jl
include("../src/ast.jl")
include("../src/lexer.jl")
include("../src/parser.jl")
include("../src/interpreter.jl")

using .AST
using .Lexer
using .Parser
using .Interpreter

code = """
@shamura
rite prophecy(n) {
    n < 3 ? sacrifice 1 : sacrifice prophecy(n-1) + prophecy(n-2) + prophecy(n-3);
}
"""

println("=======================================")
println("      Old Faith - PROPHECY RITE        ")
println("=======================================\n")

println("--- 1. Lexer (Doutrinador) ---")
tokens = tokenize(code)
for t in tokens
    println("  $t")
end

println("\n--- 2. Parser (Escriba) ---")
program = parse_program(tokens)

rite = program.rites[1]
println("  Rite Name: ", rite.name)
println("  Attributes Found: ", rite.attributes)
println("  Parameters: ", rite.params)
println("  Body:")
println("  ", rite.body)

println("\n--- 3. Interpreter (Executor da Fé) ---")
rites = execute_program(program)

println("  Iniciando ritual de profecia com a benção de @shamura...")
println("  Cronometrando...")

call = CallExpression("prophecy", Expression[Literal(30)])
altar_vazio = Dict{String,Any}()

@time begin
    resultado = Interpreter.evaluate(call, altar_vazio, rites)
end

println("\n  >> RESULTADO FINAL: ", resultado)
println("==========================================")
println(" GLORY TO THE LAMB! Shamura remembers. 🕷️ ")
println("==========================================")
