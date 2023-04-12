create database exercicio_livro;

create table cidade(

	id int primary key auto_increment not null,
    nome varchar(100),
    uf varchar(100)
    
);



create table cliente(

	id int primary key auto_increment not null,
    nome varchar(100),
    endereco varchar(100),
    id_cidade int not null,
    
    foreign key (id_cidade) references cidade(id)
    
);



create table autor(

	id int primary key auto_increment not null,
    nome varchar(100),
    id_cidade int not null,
    
    foreign key (id_cidade) references cidade(id)
    
);



create table categoria(

	id int primary key auto_increment not null,
    nome varchar(100),
    descricao varchar(100)
    
);



create table livros(

	id int primary key auto_increment not null,
    titulo varchar(100),
    id_autor int not null,
    numero_folhas int not null,
    editora varchar(100),
    valor decimal(6,2),
    id_categoria int not null,
    
    foreign key (id_autor) references autor(id),
    foreign key (id_categoria) references categoria(id)
    
);



create table venda(

	id_livro int not null,
    id_cliente int not null,
    qtde int not null,
    data_venda date not null,
    
    foreign key (id_livro) references livros(id),
    foreign key (id_cliente) references cliente(id)
    
);

-- Tabela Cidade
INSERT INTO cidade (nome, uf) VALUES
('São Paulo', 'SP'),
('Rio de Janeiro', 'RJ'),
('Belo Horizonte', 'MG'),
('Brasília', 'DF');

-- Tabela Cliente
INSERT INTO cliente (nome, endereco, id_cidade) VALUES
('João da Silva', 'Rua A, 123', 1),
('Maria dos Santos', 'Rua B, 456', 2),
('Pedro Oliveira', 'Rua C, 789', 3),
('Ana Paula Souza', 'Rua D, 321', 4);

-- Tabela Autor
INSERT INTO autor (nome, id_cidade) VALUES
('Machado de Assis', 2),
('Clarice Lispector', 1),
('Carlos Drummond de Andrade', 3),
('Jorge Amado', 4);

-- Tabela Categoria
INSERT INTO categoria (nome, descricao) VALUES
('Romance', 'Livros que tratam sobre amor e paixão'),
('Ficção Científica', 'Livros que exploram possibilidades científicas'),
('Autoajuda', 'Livros que ajudam a melhorar a vida pessoal'),
('Banco de dados', 'Livros que falam sobre programação');

-- Tabela Livros
INSERT INTO livros (titulo, id_autor, numero_folhas, editora, valor, id_categoria) VALUES
('POO Ulbra', 1, 300, 'Companhia das Letras', 30.50, 5),
('Banco de dados Ulbra', 1, 200, 'Companhia das Letras', 30.50, 5),
('A Hora da Estrela', 2, 150, 'Rocco', 25.90, 1),
('O Sentimento do Mundo', 3, 180, 'Nova Fronteira', 20.99, 1),
('Gabriela, Cravo e Canela', 4, 250, 'Companhia das Letras', 35.00, 1);

-- Tabela Venda
INSERT INTO venda (id_livro, id_cliente, qtde, data_venda) VALUES
(1, 3, 2, '2022-03-21'),
(2, 1, 1, '2022-04-20'),
(3, 3, 3, '2022-02-28'),
(4, 4, 2, '2022-05-10');

alter table livros
	add constraint fk_categoria
    foreign key (id_categoria)
    references categoria(id)
    on delete cascade;
    
    
 -- consulta todas as vendas   
select * from venda;

select * from cliente;

select * from livros;
  
   -- consulta total de vendas  
select count(*) as total_vendas
from venda;


 -- consulta total de vendas em um dia específico
select count(*) as total_vendas
from venda
where data_venda >= '2022-04-19';


-- consulta livros de uma categoria específica
select l.titulo, l.valor, l.id_categoria, c.nome, c.descricao
	from livros l
    inner join categoria c on c.id = l.id_categoria
where c.id = 5;


-- consulta livros e autor com livros acima de valor específico
select l.titulo, l.id_autor, a.nome, l.valor
	from livros l
    inner join autor a on a.id = l.id_autor
where l.valor > 25.99;

-- consulta todos os clientes
select * from cliente;


-- consulta nome do cliente com cidade e uf
select c.nome, ci.nome, ci.uf
	from cliente c
    inner join cidade ci on ci.id = c.id_cidade;


-- consulta nome e livro por vendas
select c.nome, l.titulo, v.id_livro, v.id_cliente
	from cliente c
    inner join venda v on c.id = v.id_cliente
    inner join livros l on l.id = v.id_livro;
    
-- consulta nome do livro que foram vendidos depois de data específica
select l.id, l.titulo
	from livros l 
    inner join venda v on l.id = v.id_livro
where v.data_venda > '2022-03-01';


-- consulta nome dos 5 livro que mais foram vendidos
select l.titulo, a.nome, v.qtde, sum(v.qtde) as total_venda
	from livros l
	inner join autor a on a.id = l.id_autor
    inner join venda v on l.id = v.id_livro
group by l.id
order by total_venda desc
limit 5;

-- consulta nome do cliente que comprou livro específico
select c.nome, l.titulo
	from livros l
    inner join venda v on l.id = v.id_livro
    inner join cliente c on c.id = v.id_cliente
where l.titulo = 'Dom casmurro';

-- consulta vendas feitas no dia de hoje
select * from venda
where data_venda = current_date();


-- buscando o livro com valor mais alto
select titulo as livro, max(valor) as mais_alto
from livros
group by titulo
order by mais_alto desc
limit 1;

-- liste os 5 clientes que mais compraram no mês de fevereiro
select c.nome, sum(l.valor * v.qtde) as total_gasto
	from cliente c
		inner join venda v on c.id = v.id_cliente
        inner join livros l on l.id = v.id_livro
where data_venda >= '2022-03-01' and data_venda <= '2022-03-31'
group by c.nome
order by total_gasto desc
limit 5;

select c.nome, l.valor, v.data_venda, v.qtde
	from cliente c
    inner join venda v on c.id = v.id_cliente
    inner join livros l on l.id = v.id_livro;


-- maria dos santos 122
-- pedro oliveira 51.49
-- ana paula 131


    
