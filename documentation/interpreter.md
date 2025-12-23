O Interpretador percorre a árvore sagrada (AST) e executa a vontade dos Bispos. Ele usa o sistema de Multiple Dispatch do Julia para tratar cada tipo de oferenda (Literal, Binary, Call) de forma apropriada.

```mermaid
graph TD
    Interpreter[Interpretador]:::runner

    %% Estruturas
    RiteTable[RiteTable]:::static
    Env[Ambiente]:::dynamic
    ShamuraC[ShamuraCache]:::cache

    %% Relações
    Interpreter -->|Consulta Ritos| RiteTable
    Interpreter -->|Lê/Escreve Variáveis| Env
    Interpreter -->|Consulta Cache| ShamuraC

    %% Descrições
    DescTable["Dict: Nome -> AST (Definições de Funções)"] --> RiteTable
    DescEnv["Dict: Variável -> Valor (Escopo Local)"] --> Env
    DescCache["Dict: (Rito, Args) -> Resultado (Cache de Memoização)"] --> ShamuraC
```
Gráfico 1: Arquitetura da Fé

```mermaid

graph LR

    %% Entrada
    Input[AST Node]:::input --> Dispatch{Tipo do Nó?}:::logic

    %% Caminhos
    Dispatch -->|Literal| Lit["Retorna Valor"]:::result
    
    Dispatch -->|Variable| Var["Busca Variável"]:::process
    Var --> ResVar[Valor da Var]:::result

    Dispatch -->|Binary| Bin["Operação Binária"]:::process
    Bin --> Math["Executa Operação"]:::process
    Math --> ResBin[Resultado]:::result

    Dispatch -->|Ternary| Tern["Avalia Condição"]:::process
    Tern -->|True| BranchA["Ramo True"]:::process
    Tern -->|False| BranchB["Ramo False"]:::process

```
Gráfico 2: Ciclo de Avaliação

```mermaid
graph TD

    Start["Call: rite(n)"]:::start --> CheckRite{Rito Definido?}:::check
    CheckRite -- Sim --> Args[Avaliar Argumentos]:::calc
    
    %% O Ponto Chave
    Args --> CheckShamura{Tem @shamura?}:::check
    
    %% Caminho do Coelho
    CheckShamura -- SIM --> CheckCache{Está no Cache?}:::cachehit
    CheckCache -- SIM --> ReturnCache[Retornar Cache]:::endnode
    
    %% Caminho Lento (Cálculo)
    CheckCache -- NÃO --> CalcReal
    CheckShamura -- NÃO --> CalcReal
    
    subgraph Execution [Execução do Rito]
        CalcReal[Criar Novo Ambiente]:::calc
        CalcReal --> RunBody[Executar Corpo]:::calc
    end
    
    RunBody --> ShouldSave{Tem @shamura?}:::check
    ShouldSave -- Sim --> Save[Salvar no Cache]:::save
    Save --> Return[Retornar Resultado]:::endnode
    ShouldSave -- Não --> Return
```
Gráfico 3: Lógica de @shamura