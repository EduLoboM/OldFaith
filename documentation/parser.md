``` mermaid
graph TD
    %% --- O Fluxo Principal (A Descida Recursiva) ---
    %% Usamos retângulos padrão []
    A[parse_expression] -->|Chama| B[parse_comparison]
    B -->|Chama| C[parse_additive]
    C -->|Chama| D[parse_term]
    D -->|Chama| E[parse_factor]

    %% --- As Explicações (Notas Laterais) ---
    %% Usamos o formato >...] que parece uma bandeira/nota
    %% E linhas pontilhadas -.- para mostrar que são apenas anotações
    
    NoteA["Resolve Ternário ( ? : )"] -.- A
    NoteB["Resolve Comparação ( < > )"] -.- B
    NoteC["Resolve Somas ( + - )"] -.- C
    NoteD["Resolve Multiplicação ( * / )"] -.- D
    NoteE["Resolve Números, Variáveis e ( )"] -.- E
```
Gráfico 1: Síntese da lógica do parser.jl

Daqui pra frente para melhor explicar a lógica desse programa vamos udar de exemplo a função @rabbit addmult(a, b, c) que tem a tag @rabbit e retorna os valores de a + b * c

``` mermaid
graph LR
    Input[Lista de Tokens] -->|parse_program| Loop{Enquanto não EOF}
    Loop -->|Encontra @ ou func| Func[parse_function]
    
    Func -->|Lê Atributos| AttrList["@rabbit"]
    Func -->|Lê Assinatura| Sig["func addmult(a,b,c)"]
    Func -->|Lê Corpo| Expr[parse_expression]
    
    Expr -->|Chama| Additive["1 + (2 * 3)"]
    Additive -->|Chama| Term[2 * 3]
    
    Func -->|Monta| Node[Nó FunctionDef]
    Node -->|Adiciona na| AST["Árvore Final (Program)"]
```
Gráfico 2: como o programa interpreta addmult(1, 2, 3)

```mermaid
graph TD

    %% 1. A Raiz (A Função)
    Func[FunctionDef: addmult]:::root

    %% 2. O Atributo (A GRANDE MUDANÇA)
    %% Visualmente, é uma etiqueta ligada à definição
    TagRabbit[@rabbit]:::attr
    Func --> TagRabbit

    %% 3. Metadados normais
    Params[Params: a, b, c]:::meta
    Func --> Params

    %% 4. O Corpo (Idêntico ao anterior)
    RootPlus[BinaryExpression: +]:::op
    Func --> RootPlus

    %% 5. A Matemática
    VarA(Variable: a):::var
    RootPlus --> VarA

    SubMult[BinaryExpression: *]:::op
    RootPlus --> SubMult

    VarB(Variable: b):::var
    VarC(Variable: c):::var
    SubMult --> VarB
    SubMult --> VarC
```
Gráfico 3: como fica a árvore final de addmult(a, b, c)

