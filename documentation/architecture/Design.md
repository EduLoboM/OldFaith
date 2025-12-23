Este documento explica as escolhas de arquitetura e engenharia por trás da Old Faith. O objetivo da linguagem é ser uma ferramenta educacional para estudo de compiladores, focando em legibilidade e conceitos modernos.

## 1. A Linguagem Host: Por que Julia?
Escolhemos implementar a Old Faith em Julia por três motivos principais:
1.  Multiple Dispatch: O Interpretador (src/interpreter.jl) usa o despacho múltiplo para eliminar grandes blocos de switch/case. O método evaluate(::Literal) é separado de evaluate(::BinaryExpression), tornando o código limpo e modular.
2.  Expressividade: A sintaxe matemática do Julia facilita a escrita do Parser.
3.  Performance: Embora seja um interpretador tree-walk (lento por natureza), rodar em cima do JIT do Julia garante uma performance base aceitável.

## 2. O Parser: Recursive Descent
Optamos por um Parser de Descida Recursiva (escrito à mão) em vez de usar geradores de parser (como YACC ou Bison).
* Motivo: É a forma mais didática de entender como a Precedência de Operadores funciona. A hierarquia de funções (parse_additive chama parse_term) reflete visualmente a árvore matemática.

## 3. O Diferencial: Identificadores
A Old Faith não é apenas uma calculadora. Ela introduz conceitos de Metaprogramação e Segurança de forma explícita através de "etiquetas" (tags) antes dos ritos.

### @shamura
* Conceito: Memoization (Cache).
* Design: Em vez de o compilador decidir magicamente quando otimizar, o usuário deve pedir explicitamente. Isso ensina o custo/benefício de armazenar estados.
* Implementação: Um Dict global armazena (NomeRito, Argumentos) => Resultado. Antes de executar, o interpretador verifica esse cofre.

### @kallamar - Em desenvolvimento
* Conceito: Pureza Funcional e Sandbox.
* Design: Um rito marcado como @kallamar não pode acessar escopo global. Garante previsibilidade.

### @leshy - Planejado
* Conceito: Paralelismo e Threads.
* Design: Representa o Caos. Permite que blocos de código rodem em paralelo, exigindo controle de concorrência.

### @narinder - Planejado
* Conceito: Assincronismo (Async/Await).
* Design: Representa a Morte ("Aquele Que Espera"). Pausa a execução do rito atual sem travar a thread principal até que uma tarefa termine.

### @heket - Planejado
* Conceito: Orçamento (Budget/Fome).
* Design: Impõe limites físicos à execução (ex: max loop iterations, timeout). O interpretador deve decrementar um contador a cada instrução e lançar erro se o budget acabar.

## 4. Arquitetura do Interpretador
Utilizamos um modelo Tree-Walk (percorrer a árvore AST).
* Vantagem: Simples de implementar e debugar. A estrutura da AST (src/ast.jl) é mapeada diretamente para a execução.
* Desvantagem: Mais lento que Bytecode, mas suficiente para o propósito educacional (benchmark do Tribonacci rodando em <0.01s com @shamura).