Marcamos um tipo de dado padrão, o nó ASTNode, e herdando dele temos a expression e o statement que são o principal bloco de construção da árvore dele vem os seguintes tipos que são depois exportados:

- Literal - Expression
	- Contém os valores de número interno

- Variable - Expression
	- Contém o nome da variável

- BinaryExpression - Expression
	- Contém na esquerda o lado esquerdo da equação, na direita contem o lado direito da equação e também o operador da equação

- CallExpression - Expression
	- A chamada de uma variável em uma expressão

- TernaryExpression - Expression
	- Uma condição If que guarda a condição e os stateaments de true e false

- FunctionDef - Statement
	- Contém o nome da função, seus parâmetros, atributos e expressão

- Program - ASTNode
	- Contém um vetor de funções e um vetor dos ASTnodes 
