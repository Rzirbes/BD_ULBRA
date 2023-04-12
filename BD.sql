create table produtos (
	id int primary key auto_increment not null,
	descricao varchar(100), 
	preco decimal(5,2) not null,
	nome_categoria varchar(100),
	descricao_categoria varchar(100)

);

create table cidades (
	id int primary key auto_increment not null,
    nome varchar(100),
    uf varchar(100)
	
);

create table filiais (
	id int primary key auto_increment not null,
    nome varchar(100),
    endereco varchar(100),
    id_cidade int not null,
    
    foreign key (id_cidade) references cidades (id)

);

create table empregados (
	id int primary key auto_increment not null,
    nome varchar(100) not null,
    endereco varchar(100),
    id_cidade int not null,
    carteira_trabalho varchar(100),
    rg varchar(100) not null,
    cpf varchar(100) not null, 
    salario decimal(10,2),
    id_filial int not null,
    
    foreign key (id_cidade) references cidades(id),
    foreign key (id_filial) references filiais(id)

);


create table vende (
	id_produto int not null,
    id_filial int not null,
    
    foreign key (id_produto) references produtos(id),
    foreign key (id_filial) references filiais(id)
    
);

-- Inserindo 4 linhas na tabela produtos
INSERT INTO produtos (descricao, preco, nome_categoria, descricao_categoria) 
VALUES ('Camiseta branca', 29.90, 'Roupas', 'Camisetas'),
       ('Calça jeans', 99.90, 'Roupas', 'Calças'),
       ('Tênis esportivo', 149.90, 'Calçados', 'Tênis'),
       ('Celular', 199.90, 'Eletrônicos', 'Smartphones');

-- Inserindo 4 linhas na tabela cidades
INSERT INTO cidades (nome, uf) 
VALUES ('Arroio do Sal', 'RS'),
       ('Cachoeirinha', 'RS');

-- Inserindo 4 linhas na tabela filiais
INSERT INTO filiais (nome, endereco, id_cidade) 
VALUES ('Loja 1', 'Rua A, 123', 1),
       ('Loja 2', 'Rua B, 456', 2),
       ('Loja 3', 'Rua C, 789', 3),
       ('Loja 4', 'Rua D, 1011', 4);
       
select * from cidades;

-- Inserindo 4 linhas na tabela empregados
INSERT INTO empregados (nome, endereco, id_cidade, carteira_trabalho, rg, cpf, salario, id_filial) 
VALUES 
       ('João Paulo', 'Rua Y, 456', 5, '987654321', '7654321', '987.654.321-00', 2000.00, 2),
       ('Pedro Paulo', 'Rua Z, 789', 5, '555444333', '4443332', '555.444.333-00', 1500.00, 3),
       ('Paulo Paulo', 'Rua W, 1011', 6, '111222333', '2221110', '111.222.333-00', 3000.00, 4);

-- Inserindo 4 linhas na tabela vende

select * from filiais;

INSERT INTO vende (id_produto, id_filial) 
VALUES (9, 1),
       (12, 3),
       (11, 3),
       (10, 4);
 
 
 -- consulta do produto mais caro
select descricao, preco
from produtos
order by preco desc
limit 1;

-- consulta da média dos preços dos produtos

select avg(preco) from produtos;

select * from filiais;
select * from vende;

select p.descricao, v.id_produto, v.id_filial, f.nome
	from produtos p
    inner join vende v on p.id = v.id_produto
    inner join filiais f on f.id = v.id_filial
where f.id = 3;

select e.nome, e.rg, e.salario, c.nome, c.uf
	from empregados e
    inner join cidades c on c.id = e.id_cidade
where c.uf = "RS" and e.salario > 1500.00;

