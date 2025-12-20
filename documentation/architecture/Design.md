Este documento explica as escolhas de arquitetura e engenharia por trás da R-Core Lang. O objetivo da linguagem é ser uma ferramenta educacional para estudo de compiladores, focando em legibilidade e conceitos modernos.

## 1. A Linguagem Host: Por que Julia?
Escolhemos implementar a R-Core em Julia por três motivos principais:
1.  Multiple Dispatch: O Interpretador (src/interpreter.jl) usa o despacho múltiplo para eliminar grandes blocos de switch/case. O método evaluate(::Literal) é separado de evaluate(::BinaryExpression), tornando o código limpo e modular.
2.  Expressividade: A sintaxe matemática do Julia facilita a escrita do Parser.
3.  Performance: Embora seja um interpretador tree-walk (lento por natureza), rodar em cima do JIT do Julia garante uma performance base aceitável.

## 2. O Parser: Recursive Descent
Optamos por um Parser de Descida Recursiva (escrito à mão) em vez de usar geradores de parser (como YACC ou Bison).
* Motivo: É a forma mais didática de entender como a Precedência de Operadores funciona. A hierarquia de funções (parse_additive chama parse_term) reflete visualmente a árvore matemática.

## 3. O Diferencial: @rabbit e @rhino
A R-Core Lang não é apenas uma calculadora. Ela introduz conceitos de Metaprogramação e Segurança de forma explícita através de "etiquetas" (tags) antes das funções.

### @rabbit
* Conceito: Memoization (Cache).
* Design: Em vez de o compilador decidir magicamente quando otimizar, o usuário deve pedir explicitamente. Isso ensina o custo/benefício de armazenar estados.
* Implementação: Um Dict global armazena (NomeFunção, Argumentos) => Resultado. Antes de executar, o interpretador verifica esse cofre.

### @rhino - Em desenvolvimento
* Conceito: Pureza Funcional e Sandbox.
* Design: Uma função marcada como @rhino não pode acessar escopo global. Garante previsibilidade.

## 4. Arquitetura do Interpretador
Utilizamos um modelo Tree-Walk (percorrer a árvore AST).
* Vantagem: Simples de implementar e debugar. A estrutura da AST (src/ast.jl) é mapeada diretamente para a execução.
* Desvantagem: Mais lento que Bytecode, mas suficiente para o propósito educacional (benchmark do Tribonacci rodando em <0.01s com @rabbit).