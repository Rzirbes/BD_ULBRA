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
  id_produto INT NOT NULL,
  id_fornecedor INT NOT NULL,
  data_venda DATE NOT NULL,
  quantidade_vendida INT NOT NULL,
  valor_total DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_produto) REFERENCES Produto(id),
  FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id)
);

INSERT INTO Fornecedor (id, nome, cnpj, telefone, email)
VALUES
  (1, 'Fornecedor A', '12345678900001', '(11) 1111-1111', 'fornecedor.a@example.com'),
  (2, 'Fornecedor B', '12345678900002', '(22) 2222-2222', 'fornecedor.b@example.com'),
  (3, 'Fornecedor C', '12345678900003', '(33) 3333-3333', 'fornecedor.c@example.com');
  
INSERT INTO Produto (id, nome, descricao, preco, id_fornecedor)
VALUES
  (1, 'Produto A', 'Descrição do produto A', 10.50, 1),
  (2, 'Produto B', 'Descrição do produto B', 20.00, 2),
  (3, 'Produto C', 'Descrição do produto C', 5.99, 1),
  (4, 'Produto D', 'Descrição do produto D', 100.00, 3),
  (5, 'Produto E', 'Descrição do produto E', 50.00, 2);
  
INSERT INTO Venda (id, id_produto, id_fornecedor, data_venda, quantidade_vendida, valor_total)
VALUES
  (1, 1, 1, '2022-03-01', 50, 525.00),
  (2, 2, 2, '2022-03-02', 30, 600.00),
  (3, 3, 1, '2022-03-03', 20, 119.80),
  (4, 4, 3, '2022-03-04', 150, 15000.00),
  (5, 5, 2, '2022-03-05', 70, 3500.00),
  (6, 1, 2, '2022-03-06', 100, 1050.00),
  (7, 4, 1, '2022-03-07', 80, 8000.00),
  (8, 5, 3, '2022-03-08', 10, 500.00);
  
  
select f.nome as fornecedor, p.nome as produto, sum(v.quantidade_vendida) as total_unidade_vendida
	from Fornecedor f
    inner join Venda v on f.id = v.id_fornecedor
    inner join Produto p on p.id = v.id_produto
group by f.id, p.id
having sum(v.quantidade_vendida) >= 100;




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



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    