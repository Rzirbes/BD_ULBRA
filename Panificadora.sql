-- Criação da tabela Produtos
CREATE TABLE Produtos (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100),
  Categoria VARCHAR(100)
);

-- Criação da tabela Ingredientes
CREATE TABLE Ingredientes (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100)
);

-- Criação da tabela Receitas
CREATE TABLE Receitas (
  ID INT PRIMARY KEY,
  ID_Produto INT,
  ID_Ingrediente INT,
  Quantidade DECIMAL(10,2),
  FOREIGN KEY (ID_Produto) REFERENCES Produtos(ID),
  FOREIGN KEY (ID_Ingrediente) REFERENCES Ingredientes(ID)
);

-- Criação da tabela Producao
CREATE TABLE Producao (
  ID INT PRIMARY KEY,
  ID_Produto INT,
  DataProducao DATE,
  QuantidadeProduzida INT,
  FOREIGN KEY (ID_Produto) REFERENCES Produtos(ID)
);

-- Criação da tabela EstoqueIngredientes
CREATE TABLE EstoqueIngredientes (
  ID_Ingrediente INT,
  Quantidade DECIMAL(10,2),
  FOREIGN KEY (ID_Ingrediente) REFERENCES Ingredientes(ID)
);

-- Criação da tabela EstoqueProdutos
CREATE TABLE EstoqueProdutos (
  ID_Produto INT,
  Quantidade INT,
  FOREIGN KEY (ID_Produto) REFERENCES Produtos(ID)
);

-- adicionando tempo de validade
ALTER TABLE produtos ADD tempo_validade DATE;



-- Inserindo dados na tabela Produtos
INSERT INTO Produtos (ID, Nome, Categoria, tempo_validade)
VALUES 
  (1, 'Pão Francês', 'Pães', '2023-05-31'),
  (2, 'Bolo de Chocolate', 'Bolos', '2023-06-05'),
  (3, 'Croissant', 'Pães', '2023-05-31'),
  (4, 'Torta de Morango', 'Tortas', '2023-06-10');

-- Inserindo dados na tabela Ingredientes
INSERT INTO Ingredientes (ID, Nome)
VALUES 
  (1, 'Ovos'),
  (2, 'Chocolate em pó'),
  (3, 'Manteiga'),
  (4, 'Farinha de trigo');

-- Inserindo dados na tabela Receitas
INSERT INTO Receitas (ID, ID_Produto, ID_Ingrediente, Quantidade)
VALUES 
  (1, 2, 1, 4),
  (2, 2, 2, 4),
  (3, 2, 3, 2),
  (4, 2, 4, 3);

-- Inserindo dados na tabela Producao
INSERT INTO Producao (ID, ID_Produto, DataProducao, QuantidadeProduzida)
VALUES 
  (1, 1, '2023-05-25', 100),
  (2, 2, '2023-05-25', 10),
  (3, 3, '2023-05-26', 50),
  (4, 4, '2023-05-26', 20),
  (5, 4, '2023-03-25', 20);

-- Inserindo dados na tabela EstoqueIngredientes
INSERT INTO EstoqueIngredientes (ID_Ingrediente, Quantidade)
VALUES 
  (1, 500),
  (2, 200),
  (3, 100),
  (4, 300);

-- Inserindo dados na tabela EstoqueProdutos
INSERT INTO EstoqueProdutos (ID_Produto, Quantidade)
VALUES 
  (1, 50),
  (2, 20),
  (3, 30),
  (4, 15);



-- Criação da tabela Categorias
CREATE TABLE Categorias (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100)
);

-- Inserindo dados na tabela Categorias
INSERT INTO Categorias (ID, Nome)
VALUES 
  (1, 'Pães'),
  (2, 'Bolos'),
  (3, 'Tortas');

-- Alterando a tabela Produtos para referenciar a tabela Categorias
ALTER TABLE Produtos
ADD ID_Categoria INT,
ADD FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID);

-- Removendo a coluna Categoria da tabela Produtos
ALTER TABLE Produtos
DROP COLUMN Categoria;



-- Atualizando a tabela Produtos para adicionar as categorias
UPDATE Produtos
SET ID_Categoria = 1
WHERE ID IN (1, 3); -- Atualizando os produtos com ID 1 e 3 para a categoria "Pães"

UPDATE Produtos
SET ID_Categoria = 2
WHERE ID = 2; -- Atualizando o produto com ID 2 para a categoria "Bolos"

UPDATE Produtos
SET ID_Categoria = 3
WHERE ID = 4; -- Atualizando o produto com ID 4 para a categoria "Tortas"


-- Exibir quantos produtos há para cada categoria; 
SELECT c.nome as categoria, count(p.id) as quantos_prod
	FROM categorias c 
    JOIN produtos p on p.ID_Categoria = c.ID
GROUP BY c.nome

-- Exibir todos os produtos, quais ingredientes e em que quantidade são  utilizados para produzi-lo; 
SELECT p.Nome AS produto, i.Nome AS ingrediente, r.Quantidade
    FROM Produtos p
    JOIN Receitas r ON r.ID_Produto = p.ID
    JOIN Ingredientes i ON r.ID_Ingrediente = i.ID;

-- Exibir qual a quantidade produzida de cada produto dos últimos 30 dias; 
SELECT p.Nome as produto, pr.QuantidadeProduzida as quantidade_produzina, pr.DataProducao
	FROM produtos p
    JOIN producao pr ON p.ID = pr.ID_Produto
WHERE pr.DataProducao > (current_date() - 30)
ORDER BY pr.DataProducao;

-- Se for dobrada a produção para o próximo mês, quanto de ingrediente será  necessário. 
            --calcula a quantidade usada no mes passado
SELECT r.ID_Ingrediente, SUM(r.Quantidade) AS QuantidadeTotal
    FROM Receitas r
    JOIN Producao pr ON r.ID_Produto = pr.ID_Produto
WHERE pr.DataProducao > (current_date() - 30)
GROUP BY r.ID_Ingrediente;

            --calcula quanto precisa de ingredientes se dobrar a producao
SELECT r.ID_Ingrediente, SUM(r.Quantidade) * 2 AS QuantidadeNecessaria
    FROM Receitas r
    JOIN Producao pr ON r.ID_Produto = pr.ID_Produto
WHERE pr.DataProducao > (current_date() - 30)
GROUP BY r.ID_Ingrediente;



INSERT INTO Ingredientes (ID, Nome)
VALUES (7, 'Farinha de Amêndoa');

-- Inserir novo ingrediente 2
INSERT INTO Ingredientes (ID, Nome)
VALUES (5, 'Leite de Coco');

-- Inserir novo ingrediente 3
INSERT INTO Ingredientes (ID, Nome)
VALUES (6, 'Açúcar Mascavo');


-- Mostrar os ingredientes que nunca foram utilizados; 
SELECT i.Nome AS ingrediente
    FROM Ingredientes i
    LEFT JOIN Receitas r ON i.ID = r.ID_Ingrediente
WHERE r.ID_Ingrediente IS NULL;