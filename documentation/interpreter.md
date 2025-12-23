O Interpretador percorre a árvore sagrada (AST) e executa a vontade dos Bispos. Ele usa o sistema de Multiple Dispatch do Julia para tratar cada tipo de oferenda (Literal, Binary, Call) de forma apropriada.

```mermaid
graph TD
    Interpreter[Executor da Fé]:::runner

    %% Estruturas
    RiteTable[RiteTable]:::static
    Env[Altar Local]:::dynamic
    ShamuraC[ShamuraCache]:::cache

    %% Relações
    Interpreter -->|Lê Ritos| RiteTable
    Interpreter -->|Manipula Elementos Locais| Env
    Interpreter -->|Consulta a Sabedoria| ShamuraC

    %% Descrições
    DescTable["Dict: Nome -> AST (Escrituras Sagradas)"] --> RiteTable
    DescEnv["Dict: Variável -> Valor (Novo Altar por rito)"] --> Env
    DescCache["Dict: (Rito, Args) -> Resultado (Memória de Shamura)"] --> ShamuraC
```
Gráfico 1: Arquitetura da Fé

```mermaid

graph LR

    %% Entrada
    Input[AST Node]:::input --> Dispatch{Qual a Natureza?}:::logic

    %% Caminhos
    Dispatch -->|Literal| Lit["Revela Valor"]:::result
    
    Dispatch -->|Variable| Var["Busca no Altar"]:::process
    Var --> ResVar[Valor da Var]:::result

    Dispatch -->|Binary| Bin["Combina Forças"]:::process
    Bin --> Math["Realiza Operação"]:::process
    Math --> ResBin[Resultado]:::result

    Dispatch -->|Ternary| Tern["Julga Condição"]:::process
    Tern -->|True| BranchA["Caminho da Luz"]:::process
    Tern -->|False| BranchB["Caminho das Trevas"]:::process

```
Gráfico 2: Ciclo de Avaliação

```mermaid
graph TD

    Start["Call: rite(n)"]:::start --> CheckRite{Rito Existe?}:::check
    CheckRite -- Sim --> Args[Preparar Oferendas]:::calc
    
    %% O Ponto Chave
    Args --> CheckShamura{Tem benção de @shamura?}:::check
    
    %% Caminho do Coelho
    CheckShamura -- SIM --> CheckCache{Shamura Lembra?}:::cachehit
    CheckCache -- SIM --> ReturnCache[Receber Profecia Imediata]:::endnode
    
    %% Caminho Lento (Cálculo)
    CheckCache -- NÃO --> CalcReal
    CheckShamura -- NÃO --> CalcReal
    
    subgraph Execution [Ritual Completo]
        CalcReal[Erguer Novo Altar]:::calc
        CalcReal --> RunBody[Realizar o Rito]:::calc
    end
    
    RunBody --> ShouldSave{Tem @shamura?}:::check
    ShouldSave -- Sim --> Save[Consagrar na Memória de Shamura]:::save
    Save --> Return[Sacrificar Resultado]:::endnode
    ShouldSave -- Não --> Return
```
Gráfico 3: Lógica de @shamura