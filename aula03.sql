CREATE TABLE cliente (
  id INTEGER PRIMARY KEY,
  nome VARCHAR(255) NOT NULL
);

CREATE TABLE produtos (
  id INTEGER PRIMARY KEY,
  nome VARCHAR(255) NOT NULL
);

CREATE TABLE vendas (
  id INTEGER PRIMARY KEY,
  data DATE NOT NULL,
  id_cliente INTEGER NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);

CREATE TABLE vendas_produtos (
  id_venda INTEGER NOT NULL,
  id_produto INTEGER NOT NULL,
  quant INTEGER NOT NULL,
  valor_unit DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_venda, id_produto),
  FOREIGN KEY (id_venda) REFERENCES vendas(id),
  FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

CREATE TABLE formas_pagamento (
  id INTEGER PRIMARY KEY,
  nome VARCHAR(255) NOT NULL
);

CREATE TABLE vendas_forma_pagamento (
  id_venda INTEGER NOT NULL,
  id_forma_pagamento INTEGER NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_venda, id_forma_pagamento),
  FOREIGN KEY (id_venda) REFERENCES vendas(id),
  FOREIGN KEY (id_forma_pagamento) REFERENCES formas_pagamento(id)
);



INSERT INTO cliente (id, nome) VALUES
  (1, 'João Silva'),
  (2, 'Maria Santos'),
  (3, 'José Souza');

INSERT INTO produtos (id, nome) VALUES
  (1, 'Camiseta'),
  (2, 'Calça'),
  (3, 'Tênis');

INSERT INTO vendas (id, data, id_cliente) VALUES
  (1, '2022-03-25', 1),
  (2, '2022-04-02', 2),
  (3, '2022-04-05', 3);

INSERT INTO vendas_produtos (id_venda, id_produto, quant, valor_unit) VALUES
  (1, 1, 2, 25.00),
  (1, 2, 1, 50.00),
  (2, 2, 2, 60.00),
  (2, 3, 1, 120.00),
  (3, 1, 3, 20.00),
  (3, 3, 2, 100.00);

INSERT INTO formas_pagamento (id, nome) VALUES
  (1, 'Cartão de Crédito'),
  (2, 'Boleto'),
  (3, 'Dinheiro');

INSERT INTO vendas_forma_pagamento (id_venda, id_forma_pagamento, valor) VALUES
  (1, 1, 50.00),
  (1, 2, 25.00),
  (2, 3, 180.00),
  (3, 1, 60.00),
  (3, 3, 160.00);

select * from vendas_produtos;


select p.id, p.nome, sum(vp.quant) as qtde_total, sum(vp.valor_unit * vp.quant) as valor_total
	from produtos p
		inner join vendas_produtos vp on p.id = vp.id_produto
        inner join vendas v on v.id = vp.id_venda
where v.data >= '2022-04-01' and v.data <= '2022-04-28'
group by p.nome
order by valor_total desc;


select fp.nome, coalesce(sum(vfp.valor), 0) as valor_total
	from formas_pagamento fp
		left join vendas_forma_pagamento vfp on fp.id = vfp.id_forma_pagamento
        left join vendas v on vfp.id_venda = v.id
group by fp.nome
order by valor_total desc;
	
        

SELECT vp.id_venda, p.nome, vp.valor_unit
FROM produtos p
INNER JOIN vendas_produtos vp ON p.id = vp.id_produto;

SELECT *
FROM vendas_forma_pagamento
WHERE id_forma_pagamento = 2;














