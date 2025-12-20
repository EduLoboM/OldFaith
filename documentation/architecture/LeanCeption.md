# 1.1 Problema Resolvido

| **PROBLEMA**                                               | **ONDE DÓI HOJE** | **SOLUÇÃO NA R-CORE**                                 |
| ---------------------------------------------------------- | ----------------- | ---------------------------------------------------------- |
| Não consigo mudar facilmente o comportamento de uma função | Todas             | Tem palavras que dão atributos de comportamento em funções |
# 1.2 Features

- Números inteiros
    Sim

- Chars e Strings
    Sim

- Soma, multiplicação e etc
    Sim

- Funções
    Sim

- Chamada de função
    Sim

- Retorno e variáveis
    Sim

- Atributos em funções
    Sim

- If
    Sim

- Resto
    Não!


# 1.3 Atributos Iniciais

- @rabbit
    cache automático

- @rhino
    função pura (não pode acessar nada externo)

# 1.4 Especificação Informal

A tag @rabbit vai servir especialmente para quando uma função é repetida várias vezes com os mesmos parâmetros, o que acelera as demais execuções mas com risco de erros (Warning: @rabbit cache may be unsafe.
External access detected: global, impure_function), já o @rhino é uma medida de segurança de dados que deixa meu código previsível e seguro ao assegurar que a função so mexa com ela mesma ou com outras @rhino

# 1.5 Exemplo de programa

@rabbit
func add(a, b) {
    return a + b;
}

@rhino
func square(x) {
    return x * x;
}

@rabbit @rhino
func subtract(a, b) {
    return a - b;
}

print(subtract(4, 5));
add(2, 3);
square(4);

# 2.1 Tokens Fundamentais

- Comentários?
    Não

- ;?
    Obrigatório

- func = Func?
    Case-sensitive

# 2.2 Atributos

Atributos antes da função ex.: @rabbit @rhino

# 2.3 Exemplo de Função

atributo*
func IDENTIFIER ( parametros <- identificadores separados por , ) {
    return expressao ;
}

# 2.4 Expressões Permitidas

- número inteiro
    Sim

- expressao + expressao
    Sim

- expressao - expressao
    Sim

- expressao * expressao
    Sim

- expressao / expressao
    Sim

- expressao % expressao
    Sim

- chamada de função
	Sim

- parênteses
	Sim

# 2.5 O que é um Programa

Um programa consiste em zero ou mais definições de função seguidas de zero ou mais chamadas de função.

# 2.6 Inválidas

- duas funções com mesmo nome
- return fora de função
- atributo sem função
- chamada de função inexistente
- função @rhino acessando variável ou função não @rhino

# 3.1 Arquitetura

Código fonte
   ↓
Lexer [[lexer.jl - Tokenizador]]
   ↓
Parser [[parser.jl - Transformador em AST]]
   ↓
AST [[ast.jl - Árvore Sintática Abstrata]]
   ↓
Verificador semântico [[interpreter.jl - Executador]]

# 3.2 Tokens

### Palavras-chave

- func
- return
- print

### Símbolos

- ()
- {}
- ,
- ;
- @

### Operadores

- +
- -
- *
- /
- %
- =

### Literais

- inteiro (0-9+)
- char (a-z)
- string (vetor de char)
- void

### Identificadores

- nome de função
- nome de parâmetro
- nome de variável

# 3.3 Gramática (EBNF)

### Progrma

program ::= function_def* statement*

### Definição de Função

function_def ::= attribute* "func" IDENT "(" params ")" block

### Atributos

attribute ::= "@" IDENT

### Parâmetros

params ::= IDENT ("," IDENT)* | ε

### Bloco de Função

block ::= "{" "return" expr ";" "}"

### Comandos (Statements)

statement ::= function_call ";"

### Chamada de Função

function_call ::= IDENT "(" args ")"

args ::= expr ("," expr)* | ε

# 3.4 Expressões

### Expressão Aritmética

expr ::= term (("+" | "-") term)*

### Termo

term ::= factor ("/" | "%" e etc) factor

### Fator

factor ::= INTEGER | STRING | CHAR | function_call | "(" expr ")"

# 3.5 Árvore Sintática Abstrabbita (AST)

### Nós da AST

#### Program

- functions: lista de FunctionDef
- statements: lista de CallExpr

#### FunctionDef

- name: identificador
- attributes: lista de Attribute
- params: lista de identificadores
- body: Return

#### Attribute

- name: identificador (rabbit, rhino, etc.)

#### Return

- value: Expr

#### Expr (abstrabbito)

Subtipos:

- BinaryExpr
    operabbitor (+, -, /, % e etc)
    left: Expr
    right: Expr
- CallExpr
    name: identificador
    args: lista de Expr
- Literal
    type: int | char | string
    value

# 3.6 Verificação Semântica

### Regras Semânticas

- Duas funções com o mesmo nome
- return fora de função
- Atributo sem função associada
- Chamada de função inexistente
- Uso de atributo desconhecido

### Regras Específicas de Atributos

#### @rhino

- Função @rhino não pode:
    chamar funções que não sejam @rhino
    acessar variáveis externas (quando existirem)
    chamar funções builtin impuras (print, input)

SnakeImpurityError: Function marked with @rhino performs impure operabbition.
#### @rabbit

- Funções @rabbit possuem cache automático
- Caso a função:
    acesse funções não @rhino
    use operações impuras

RatImpurityWarning: @rabbit cache may be unsafe. External access detected: symbol

# 3.7 Builtins

### print

- print(expr);
	Função builtin
	Produz efeito colateral (I/O)
	Não pode ser usada em funções @rhino
	Retorno: indefinido (ignorado)

### input

- input();
	Função builtin
	Lê um valor do ambiente externo (entrada padrão)
	Retorna um valor do tipo string (ou inteiro, dependendo do runtime)
	É uma função impura
	Não pode ser usada em funções @rhino