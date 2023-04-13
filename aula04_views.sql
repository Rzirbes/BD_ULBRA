CREATE TABLE produtos (
  id INT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  saldo INT NOT NULL
);

-- Cria a tabela orcamentos
CREATE TABLE orcamentos (
  id INT PRIMARY KEY,
  data DATE NOT NULL,
  status ENUM('em orçamento', 'vendido', 'cancelado') NOT NULL
);

-- Cria a tabela orcamentos_itens
CREATE TABLE orcamentos_itens (
  id_produto INT NOT NULL,
  id_orcamento INT NOT NULL,
  valor_unit DECIMAL(10,2) NOT NULL,
  quantidade INT NOT NULL,
  valor_total_item DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_produto, id_orcamento),
  FOREIGN KEY (id_produto) REFERENCES produtos(id),
  FOREIGN KEY (id_orcamento) REFERENCES orcamentos(id)
);

-- Inserindo dados na tabela produtos
INSERT INTO produtos (id, nome, valor, saldo) VALUES
(1, 'Produto A', 100.00, 50),
(2, 'Produto B', 200.00, 100),
(3, 'Produto C', 300.00, 200);

-- Inserindo dados na tabela orcamentos
INSERT INTO orcamentos (id, data, status) VALUES
(1, '2022-01-01', 'em orçamento'),
(2, '2022-01-02', 'vendido'),
(3, '2022-01-03', 'cancelado');

-- Inserindo dados na tabela orcamentos_itens
INSERT INTO orcamentos_itens (id_produto, id_orcamento, valor_unit, quantidade, valor_total_item) VALUES
(1, 1, 100.00, 5, 500.00),
(2, 1, 200.00, 2, 400.00),
(1, 2, 100.00, 10, 1000.00),
(3, 2, 300.00, 5, 1500.00),
(2, 3, 200.00, 1, 200.00),
(3, 3, 300.00, 3, 900.00);


CREATE VIEW relatorio_orcamentos
AS
select count(p.id) as id_produto, 
		p.nome as produto, 
        sum(oi.quantidade) as qunatidade_estoque, 
        o.status as status_orcamento, 
        sum(oi.valor_total_item) as valor_total_item, 
        o.data as data_orcamento, o.status  
	from orcamentos o
		left join orcamentos_itens oi on o.id = oi.id_orcamento
		left join produtos p on p.id = oi.id_produto
group by o.id, p.id;

select * from relatorio_orcamentos;

select produto, status_orcamento
	from relatorio_orcamentos;
    
select produto, valor_total_item, data_orcamento, status
        from relatorio_orcamentos
where data_orcamento >= '2022-01-01' and data_orcamento <= '2022-01-31';

select produto, qunatidade_estoque, status
	from relatorio_orcamentos
where produto = 'Produto A' and status != 'vendido';

select id_produto, produto, qunatidade_estoque, status, data_orcamento
	from relatorio_orcamentos
where status = 'em orçamento' and data_orcamento >= '2022-01-01' and data_orcamento <= '2022-01-31'
order by id_produto desc;

select * from produtos;

update produtos set valor = valor * 0.8
where id not in (select id_produto from orcamentos_itens
					where id_produto=produtos.id);
        

        
        
        
        
        
        
        
        
        