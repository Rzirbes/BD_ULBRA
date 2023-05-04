

CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  endereco VARCHAR(200) NOT NULL
);

CREATE TABLE exemplares (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_livro INTEGER REFERENCES livros(id),
  isbn VARCHAR(20) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  disponibilidade BOOLEAN NOT NULL,
  quantidade_total INT NOT NULL,
  quantidade_disponivel INT NOT NULL,
  quantidade_locado INT NOT NULL,
  CONSTRAINT fk_exemplares_livros FOREIGN KEY (id_livro) REFERENCES livros (id) ON DELETE CASCADE
);

CREATE TABLE categorias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  descricao TEXT
);

CREATE TABLE editoras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL
);

CREATE TABLE autores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  nacionalidade VARCHAR(100) NOT NULL
);

CREATE TABLE livros_autores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_livro INTEGER REFERENCES livros(id),
  id_autor INTEGER REFERENCES autores(id),
  CONSTRAINT fk_livros_autores_livros FOREIGN KEY (id_livro) REFERENCES livros (id) ON DELETE CASCADE,
  CONSTRAINT fk_livros_autores_autores FOREIGN KEY (id_autor) REFERENCES autores (id) ON DELETE CASCADE
);

CREATE TABLE livros_categorias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_categoria INTEGER REFERENCES categorias(id),
  id_livro INTEGER REFERENCES livros(id),
  CONSTRAINT fk_livros_categorias_categorias FOREIGN KEY (id_categoria) REFERENCES categorias (id) ON DELETE CASCADE,
  CONSTRAINT fk_livros_categorias_livros FOREIGN KEY (id_livro) REFERENCES livros (id) ON DELETE CASCADE
);

CREATE TABLE livros (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  ISBN VARCHAR(20) NOT NULL,
  num_paginas INTEGER NOT NULL,
  id_editora INTEGER REFERENCES editoras(id) ON DELETE SET NULL,
  CONSTRAINT fk_livros_editoras FOREIGN KEY (id_editora) REFERENCES editoras (id) ON DELETE SET NULL
);

CREATE TABLE emprestimos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INTEGER REFERENCES clientes(id),
  id_exemplar INTEGER REFERENCES exemplares(id),
  data_aluguel DATE NOT NULL,
  data_devolucao DATE NOT NULL,
  data_devolucao_real DATE,
  status VARCHAR(20) NOT NULL,
  CONSTRAINT fk_emprestimo_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id) ON DELETE CASCADE,
  CONSTRAINT fk_emprestimo_exemplares FOREIGN KEY (id_exemplar) REFERENCES exemplares (id) ON DELETE CASCADE
);


INSERT INTO clientes (nome, email, telefone, endereco)
VALUES
('João Silva', 'joao.silva@example.com', '(11) 9999-9999', 'Rua A, 123'),
('Maria Santos', 'maria.santos@example.com', '(11) 8888-8888', 'Rua B, 456'),
('Pedro Oliveira', 'pedro.oliveira@example.com', '(11) 7777-7777', 'Rua C, 789');

INSERT INTO editoras (nome)
VALUES
('Editora A'),
('Editora B'),
('Editora C');

INSERT INTO categorias (nome, descricao)
VALUES
('Romance', 'Livros que contam histórias de amor e relacionamentos.'),
('Suspense', 'Livros que envolvem mistérios e tensão.'),
('Ficção Científica', 'Livros que exploram conceitos científicos e tecnológicos.');

INSERT INTO autores (nome, nacionalidade)
VALUES
('Machado de Assis', 'Brasil'),
('George Orwell', 'Inglaterra'),
('Gabriel García Márquez', 'Colômbia');

INSERT INTO livros (titulo, ISBN, num_paginas, id_editora)
VALUES
('Dom Casmurro', '978-85-8041-009-0', 256, 1),
('1984', '978-0-14-139304-9', 336, 2),
('Cem Anos de Solidão', '978-85-359-0278-2', 432, 3);

INSERT INTO exemplares (id_livro, isbn, estado, disponibilidade, quantidade_total, quantidade_disponivel, quantidade_locado)
VALUES
(4, '978-85-8041-009-0', 'Novo', true, 4, 1, 3),
(5, '978-85-8041-009-0', 'Usado', false, 4, 0, 4),
(7, '978-0-14-139304-9', 'Novo', true, 5, 2, 3),
(8, '978-85-359-0278-2', 'Usado', true, 6, 3, 3);

INSERT INTO livros_autores (id_livro, id_autor)
VALUES
(6, 1),
(5, 2),
(4, 3);

INSERT INTO livros_categorias (id_livro, id_categoria)
VALUES
(6, 1),
(5, 2),
(4, 1);

INSERT INTO emprestimos (id_cliente, id_exemplar, data_aluguel, data_devolucao, status)
VALUES
(1, 17, '2023-04-01', '2023-04-08', 'Pendente'),
(2, 18, '2023-04-05', '2023-04-12', 'Pendente'),
(3, 19, '2023-04-10', '2023-04-17', 'Pendente');


-- uma view que mostra os livros que tem pelo menos um exemplar disponível

CREATE VIEW livros_disponiveis
AS
SELECT DISTINCT livros.id AS id_livro, livros.titulo as titulo, exemplares.quantidade_disponivel,
	CASE exemplares.disponibilidade
	WHEN TRUE THEN 'disponível'
		ELSE 'não disponível'
	END AS disponibilidade
	FROM livros
		LEFT JOIN exemplares ON livros.id = exemplares.id_livro


SELECT livros.titulo, COUNT(livros_autores.id_autor)
  FROM livros
    INNER JOIN livros_autorore ON livros.id = livros_autores.id_livro
  GROUP BY livros.id
  HAVING COUNT(livros_autores.id_autor) >= 2

--view que mostra os emprestimos atrasados

CREATE VIEW emprestimos_atrasados AS

SELECT clientes.id, clientes.nome, exemplares.id as id_exemplar, livros.titulo, emprestimos.data_devolucao, emprestimos.data_devolucao_real
	FROM clientes
		JOIN emprestimos ON emprestimos.id_cliente = clientes.id
        JOIN exemplares ON exemplares.id = emprestimos.id_exemplar
        JOIN livros ON livros.id = exemplares.id_livro
WHERE emprestimos.data_devolucao < CURRENT_DATE();


--livros mais emprestados 

CREATE VIEW livros_mais_emprestados
AS
SELECT livros.id, livros.titulo, count(emprestimos.id) AS num_emprestimos
	FROM livros
		JOIN exemplares ON exemplares.id_livro = livros.id
		JOIN emprestimos ON emprestimos.id_exemplar = exemplares.id
GROUP BY livros.id
ORDER BY num_emprestimos DESC
LIMIT 5;


-- lista a quantia de emprestimos por clientes
CREATE VIEW emprestimos_por_clientes
AS
SELECT clientes.id, clientes.nome, count(*) AS num_emprestimos
	FROM clientes 
		JOIN emprestimos ON clientes.id = emprestimos.id_cliente
GROUP BY clientes.id
ORDER BY num_emprestimos DESC;


-- lista os clientes que estão com emprestimos atrasados
CREATE VIEW clientes_emprestimos_atrasado
AS
SELECT clientes.id, clientes.nome, exemplares.id as id_exemplar, livros.titulo, SUM(DATEDIFF(CURRENT_DATE(), emprestimos.data_devolucao)) AS dias_atrasados
	FROM clientes
		JOIN emprestimos ON emprestimos.id_cliente = clientes.id
        JOIN exemplares ON exemplares.id = emprestimos.id_exemplar
        JOIN livros ON livros.id = exemplares.id_livro
WHERE emprestimos.data_devolucao < CURRENT_DATE();

-- lista a situação por livros

CREATE VIEW situacao_por_livro_e_exemplar
AS
SELECT livros.id AS id_livro, 
       exemplares.id AS id_exemplar, 
       livros.titulo, 
       COALESCE(exemplares.quantidade_emprestado, 0) AS quantidade_emprestado,
       SUM(COALESCE(exemplares.quantidade, 0) - COALESCE(exemplares.quantidade_emprestado, 0)) AS quantidade_disponível
FROM livros	
    LEFT JOIN exemplares ON livros.id = exemplares.id_livro
GROUP BY exemplares.id;


-- preocedure para emprestar livro

DELIMITER //
  CREATE PROCEDURE empresta_livro(
    IN novo_id_cliente INT,
      IN novo_id_exemplar INT,
      IN nova_data_aluguel DATE, 
      IN nova_data_devolucao DATE,
      IN novo_status VARCHAR(50)
  )
  BEGIN
    
    IF NOT EXISTS(
      SELECT id FROM exemplares
          WHERE id = novo_id_exemplar AND disponibilidade = TRUE
    )THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exemplar não disponível';
    END IF;
      
    INSERT INTO emprestimos (id_cliente, id_exemplar, data_aluguel, data_devolucao, status)
      VALUES (novo_id_cliente, novo_id_exemplar, nova_data_aluguel, nova_data_devolucao, novo_status);
      
    IF (SELECT quantidade_disponivel FROM exemplares WHERE id = novo_id_exemplar) = 0 THEN
      UPDATE exemplares SET disponibilidade = FALSE WHERE id = novo_id_exemplar;
    END IF;
      
  END //
DELIMITER ;
    
CALL empresta_livro(1, 3, '2023-04-15', '2023-04-30', 'pendente');

-- procedure para devolução de livro e atualização da disponibilidade do exemplar

DELIMITER //
  CREATE PROCEDURE devolucao_de_livro(
    IN exemplar_id INT
  )
  BEGIN 
    UPDATE exemplares SET disponibilidade = TRUE WHERE id = exemplar_id;
  END //
DELIMITER ;

CALL devolucao_de_livro(2);




-- alterar a quantidade de exemplares

DELIMITER //
  CREATE PROCEDURE alterar_quantidade_exemplar(
    IN id_exemplar INT,
    IN nova_quantidade INT
  )
  BEGIN 
    UPDATE exemplares SET quantidade = nova_quantidade,
                        SET quantidade_disponivel = nova_quantidade
      WHERE exemplares.id = id_exemplar;
  END // 
DELIMITER ;



CALL alterar_quantidade_exemplar(3, 4);


-- procedure de crud de clientes 

DELIMITER //
  CREATE PROCEDURE crud_clientes(
    IN id_cliente INT,
    IN novo_nome VARCHAR(100),
    IN novo_email VARCHAR(100),
      IN novo_telefone VARCHAR(20),
      IN novo_endereco VARCHAR(100),
      IN oper VARCHAR(1)
  )
  BEGIN 

    IF(oper = 'I') THEN
      INSERT INTO clientes (nome, email, telefone, endereco)
      VALUES
      (novo_nome, novo_email, novo_telefone, novo_endereco);
    ELSEIF(oper = 'U') THEN
      UPDATE clientes 
        SET nome = novo_nome,
          email = novo_email,
                  telefone = novo_telefone,
                  endereco = novo_endereco
                  WHERE clientes.id = id_cliente;
    ELSEIF(oper = 'D') THEN
      DELETE FROM clientes WHERE id = id_cliente;
    ELSE 
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'informe I para inserir, U para atualizar ou D para deletar:';
    END IF;
  END // 
DELIMITER ;

CALL crud_clientes(6, 'José', 'romulo@.com', '41 90909090', 'Rua A, número 40', 'I');


-- uma trigger que define a data de devolução automaticamente para 15 dias após o emprestimo

DELIMITER //
  CREATE TRIGGER emprestimos_set_data_devolucao
  BEFORE INSERT ON emprestimos
  FOR EACH ROW
  BEGIN
    SET NEW.data_devolucao = DATE_ADD(NEW.data_aluguel, INTERVAL 15 DAY);
  END //
DELIMITER ;

INSERT INTO emprestimos (id_cliente, id_exemplar, data_aluguel, status)
VALUES (1, 5, '2023-04-17', 'alugado');
