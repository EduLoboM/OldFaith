# 1.1 Problema Resolvido

| **PROBLEMA**                                               | **ONDE DÓI HOJE** | **SOLUÇÃO NA Old Faith**                                 |
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

- @shamura
    - cache automático

- @kallamar
    - não pode acessar nada externo

- @heket
    - budget de funções

- @leshy
    - paralelismo (caos, threads)

- @narinder
    - async/await (espera de promessas)

# 1.4 Especificação Informal

A tag @shamura vai servir especialmente para quando um rito é repetido várias vezes com os mesmos parâmetros, o que acelera as demais execuções mas com risco de erros, já o @kallamar é uma medida de segurança de dados que deixa meu código previsível e seguro ao assegurar que o rito so mexa com ele mesmo ou com outros @kallamar

# 1.5 Exemplo de programa

@shamura
rite add(a, b) {
    sacrifice a + b;
}

@kallamar
rite square(x) {
    sacrifice x * x;
}

@shamura @kallamar
rite subtract(a, b) {
    sacrifice a - b;
}

print(subtract(4, 5));
add(2, 3);
square(4);

# 2.1 Tokens Fundamentais

- Comentários?
    Não

- ;?
    Obrigatório

- rite = Rite?
    Case-sensitive

# 2.2 Atributos

Atributos antes do rito ex.: @shamura @kallamar

# 2.3 Exemplo de Função

atributo*
rite IDENTIFIER ( parametros <- identificadores separados por , ) {
    sacrifice expressao ;
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

- chamada de rito
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

- rite
- sacrifice
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

- nome de rito
- nome de parâmetro
- nome de variável

# 3.3 Gramática (EBNF)

### Progrma

program ::= rite_def* statement*

### Definição de Função

rite_def ::= attribute* "rite" IDENT "(" params ")" block

### Atributos

attribute ::= "@" IDENT

### Parâmetros

params ::= IDENT ("," IDENT)* | ε

### Bloco de Função

block ::= "{" "sacrifice" expr ";" "}"

### Comandos (Statements)

statement ::= rite_call ";"

### Chamada de Função

rite_call ::= IDENT "(" args ")"

args ::= expr ("," expr)* | ε

# 3.4 Expressões

### Expressão Aritmética

expr ::= term (("+" | "-") term)*

### Termo

term ::= factor ("/" | "%" e etc) factor

### Fator

factor ::= INTEGER | STRING | CHAR | rite_call | "(" expr ")"

# 3.5 Árvore Sintática Abstrata (AST)

### Nós da AST

#### Program

- rites: lista de RiteDef
- script: lista de ASTNode

#### RiteDef

- name: identificador
- attributes: lista de Attribute
- params: lista de identificadores
- body: Expression

#### Attribute

- name: identificador (shamura, kallamar, etc.)

#### Return

- value: Expr

#### Expr (abstrato)

Subtipos:

- BinaryExpr
    operator (+, -, /, % e etc)
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

# 3.7 Builtins

### print

- print(expr);
	Função builtin
	Produz efeito colateral (I/O)
	Retorno: indefinido (ignorado)

### input

- input();
	Função builtin
	Lê um valor do ambiente externo (entrada padrão)
	Retorna um valor do tipo string (ou inteiro, dependendo do runtime)
	É uma função impura