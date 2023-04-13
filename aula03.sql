CREATE TABLE produtos (
    id_produto INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE vendas (
    id_venda INT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);




INSERT INTO produtos (id_produto, nome, preco, descricao)
VALUES
    (1, 'Camiseta', 29.90, 'Camiseta de algodão 100%'),
    (2, 'Calça Jeans', 99.90, 'Calça jeans masculina'),
    (3, 'Tênis', 149.90, 'Tênis de corrida');
    
    
INSERT INTO clientes (id_cliente, nome, email, endereco, telefone)
VALUES
    (1, 'João Silva', 'joao.silva@email.com', 'Rua A, 123', ''),
    (2, 'Maria Santos', 'maria.santos@email.com', 'Rua B, 456', ''),
    (3, 'Pedro Souza', 'pedro.souza@email.com', 'Rua C, 789', '');
    
INSERT INTO pedidos (id_pedido, id_cliente, data_pedido, valor_total)
VALUES
    (4, 1, '2023-04-10', 60.80),
    (5, 2, '2023-04-11', 250.80),
    (6, 3, '2023-04-12', 300.70);
    
INSERT INTO vendas (id_venda, id_pedido, id_produto, quantidade)
VALUES
    (8, 4, 1, 2),
    (9, 5, 3, 1),
    (10, 6, 1, 5),
    (11, 4, 2, 1),
    (12, 5, 3, 2),
    (13, 6, 2, 3),
    (14, 4, 3, 2);
    
    

-- exercício 01
select c.nome, sum(p.valor_total) as valor_total, count(p.id_pedido) as quantidade_total
	from clientes c
		join pedidos p on c.id_cliente = p.id_cliente
        join vendas v on p.id_pedido = v.id_pedido
group by c.nome
having count(p.id_pedido) >=3;


-- exercício 02
select p.descricao, p.nome, avg(p.preco) as media_valor, sum(v.quantidade) as quantidade_total
	from produtos p
		left join vendas v on p.id_produto = v.id_produto
group by p.nome

--exercicio 03

-- Cria a tabela Produto
CREATE TABLE Produto (
id INT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
descricao TEXT,
preco DECIMAL(10,2) NOT NULL,
id_fornecedor INT NOT NULL,
FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id)
);

-- Cria a tabela Fornecedor
CREATE TABLE Fornecedor (
id INT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
cnpj VARCHAR(14) NOT NULL,
telefone VARCHAR(20) NOT NULL,
email VARCHAR(50) NOT NULL
);

-- Cria a tabela Venda
CREATE TABLE Venda (
id INT PRIMARY KEY,
id_fornecedor INT NOT NULL,
data_venda DATE NOT NULL,
valor_total DECIMAL(10,2) NOT NULL,
FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id)
);

-- Cria a tabela venda_produto
CREATE TABLE venda_produto (
id_venda INT NOT NULL,
id_produto INT NOT NULL,
quantidade_vendida INT NOT NULL,
FOREIGN KEY (id_venda) REFERENCES Venda(id),
FOREIGN KEY (id_produto) REFERENCES Produto(id)
);

-- Popula a tabela Fornecedor
INSERT INTO Fornecedor (id, nome, cnpj, telefone, email)
VALUES
(1, 'Fornecedor 1', '11111111111111', '(11)1111-1111', 'fornecedor1@exemplo.com'),
(2, 'Fornecedor 2', '22222222222222', '(22)2222-2222', 'fornecedor2@exemplo.com'),
(3, 'Fornecedor 3', '33333333333333', '(33)3333-3333', 'fornecedor3@exemplo.com');

-- Popula a tabela Produto
INSERT INTO Produto (id, nome, descricao, preco, id_fornecedor)
VALUES
(1, 'Produto 1', 'Descrição do produto 1', 100.00, 1),
(2, 'Produto 2', 'Descrição do produto 2', 200.00, 1),
(3, 'Produto 3', 'Descrição do produto 3', 300.00, 2),
(4, 'Produto 4', 'Descrição do produto 4', 400.00, 2),
(5, 'Produto 5', 'Descrição do produto 5', 500.00, 3),
(6, 'Produto 6', 'Descrição do produto 6', 600.00, 3);

-- Popula a tabela Venda
INSERT INTO Venda (id, id_fornecedor, data_venda, valor_total)
VALUES
(1, 1, '2022-03-20', 300.00),
(2, 2, '2022-03-21', 800.00),
(3, 3, '2022-03-22', 1500.00);

-- Popula a tabela venda_produto
INSERT INTO venda_produto (id_venda, id_produto, quantidade_vendida)
VALUES
(1, 1, 3),
(1, 2, 2),
(2, 3, 2),
(2, 4, 1),
(2, 5, 3),
(3, 5, 2),
(3, 6, 1);
  
  
select f.nome as fornecedor, p.nome as produto, sum(vp.quantidade_vendida) as total_unidade_vendida
	from Fornecedor f
    inner join Venda v on f.id = v.id_fornecedor
    inner join venda_produto vp on vp.id_venda = v.id
    inner join Produto p on p.id = vp.id_produto
group by f.id, p.id
having sum(vp.quantidade_vendida) >= 2;




-- exercicio 04

CREATE TABLE Departamento (
  id INT PRIMARY KEY,
  nome VARCHAR(50)
);

CREATE TABLE Funcionario (
  id INT PRIMARY KEY,
  nome VARCHAR(50),
  salario DECIMAL(10, 2),
  id_departamento INT,
  FOREIGN KEY (id_departamento)
    REFERENCES Departamento(id)
);

INSERT INTO Departamento (id, nome) VALUES
  (1, 'Vendas'),
  (2, 'Marketing'),
  (3, 'Financeiro');

INSERT INTO Funcionario (id, nome, salario, id_departamento) VALUES
  (1, 'João', 4500.00, 1),
  (2, 'Maria', 5500.00, 1),
  (3, 'Pedro', 4000.00, 2),
  (4, 'Ana', 4800.00, 2),
  (5, 'José', 5200.00, 3),
  (6, 'Carla', 3200.00, 3);


select d.nome, f.nome, avg(f.salario) as media_salario
	from Departamento d
		left join Funcionario f on d.id = f.id_departamento
group by d.id, f.id
having avg(f.salario) > 5000.00 and f.salario > 5000.00;



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    