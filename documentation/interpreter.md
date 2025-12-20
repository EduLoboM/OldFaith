O Interpretador percorre a árvore AST gerada pelo Parser e executa as instruções. Ele usa o sistema de Multiple Dispatch do Julia para trabbitar cada tipo de nó (Literal, Binary, Call) de forma diferente.

```mermaid
graph TD
    Interpreter[Motor de Execução]:::runner

    %% Estruturas
    FuncTable[FunctionTable]:::static
    Env[Environment]:::dynamic
    RatC[RatCache]:::cache

    %% Relações
    Interpreter -->|Lê Receitas| FuncTable
    Interpreter -->|Lê/Grava Variáveis Locais| Env
    Interpreter -->|Salva Resultados| RatC

    %% Descrições
    DescTable["Dict: Nome -> AST (Somente Leitura)"] --> FuncTable
    DescEnv["Dict: Variável -> Valor (Cria um novo por função)"] --> Env
    DescCache["Dict: (Func, Args) -> Resultado (Memória Global do @rabbit)"] --> RatC
```
Gráfico 1: Arquitetura de memória

```mermaid

graph LR

    %% Entrada
    Input[AST Node]:::input --> Dispatch{Qual o Tipo?}:::logic

    %% Caminhos
    Dispatch -->|Literal| Lit["Retorna valor"]:::result
    
    Dispatch -->|Variable| Var["Busca no Environment"]:::process
    Var --> ResVar[Valor da Var]:::result

    Dispatch -->|Binary| Bin["Calcula Esq & Dir"]:::process
    Bin --> Math["Aplica Operador"]:::process
    Math --> ResBin[Resultado Matemático]:::result

    Dispatch -->|Ternary| Tern["Avalia Condição"]:::process
    Tern -->|True| BranchA["Executa Lado True"]:::process
    Tern -->|False| BranchB["Executa Lado False"]:::process

```
Gráfico 2: Ciclo do evaluate (multiple dispatch)

```mermaid
graph TD

    Start["Call: func(n)"]:::start --> CheckFunc{Função Existe?}:::check
    CheckFunc -- Sim --> Args[Calcular Argumentos]:::calc
    
    %% O Ponto Chave
    Args --> CheckRat{Tem @rabbit?}:::check
    
    %% Caminho do RATO
    CheckRat -- SIM --> CheckCache{Está no Cache?}:::cachehit
    CheckCache -- SIM --> ReturnCache[Retorna Valor Imediato]:::endnode
    
    %% Caminho Lento (Cálculo)
    CheckCache -- NÃO --> CalcReal
    CheckRat -- NÃO --> CalcReal
    
    subgraph Execution [Execução Real]
        CalcReal[Criar Novo Environment]:::calc
        CalcReal --> RunBody[Rodar Corpo da Função]:::calc
    end
    
    RunBody --> ShouldSave{Tem @rabbit?}:::check
    ShouldSave -- Sim --> Save[Salvar no RatCache]:::save
    Save --> Return[Retornar Resultado]:::endnode
    ShouldSave -- Não --> Return
```
gráfico 3: Lógica do @rabbit