CREATE TABLE Livros (
    id INT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    editora VARCHAR(100) NOT NULL,
    ano_publicacao INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Exemplares (
    id INT NOT NULL AUTO_INCREMENT,
    edicao VARCHAR(20) NOT NULL,
    num_paginas INT NOT NULL,
    data_aquisicao DATE NOT NULL,
    condicao VARCHAR(20) NOT NULL,
    livro_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (livro_id) REFERENCES Livros(id)
);

CREATE TABLE Emprestimos (
    id INT NOT NULL AUTO_INCREMENT,
    data_inicio DATE NOT NULL,
    data_devolucao DATE NOT NULL,
    situacao VARCHAR(20) NOT NULL,
    exemplar_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (exemplar_id) REFERENCES Exemplares(id)
);

CREATE TABLE Usuarios (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Categorias (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Livro_Categoria (
    livro_id INT NOT NULL,
    categoria_id INT NOT NULL,
    PRIMARY KEY (livro_id, categoria_id),
    FOREIGN KEY (livro_id) REFERENCES Livros(id),
    FOREIGN KEY (categoria_id) REFERENCES Categorias(id)
);


INSERT INTO Livros (titulo, autor, editora, ano_publicacao) VALUES
("Dom Casmurro", "Machado de Assis", "Editora ABC", 1899),
("O Hobbit", "J.R.R. Tolkien", "Editora XYZ", 1937),
("Harry Potter e a Pedra Filosofal", "J.K. Rowling", "Editora QWERTY", 1997);

INSERT INTO Exemplares (edicao, num_paginas, data_aquisicao, condicao, livro_id) VALUES
("1ª Edição", 250, "2005-05-01", "Bom", 1),
("3ª Edição", 310, "2012-08-15", "Regular", 1),
("2ª Edição", 300, "2007-10-20", "Bom", 2),
("1ª Edição", 320, "2010-04-05", "Ótimo", 3),
("2ª Edição", 400, "2013-11-30", "Bom", 3);

INSERT INTO Emprestimos (data_inicio, data_devolucao, situacao, exemplar_id) VALUES
("2022-03-01", "2022-03-15", "Finalizado", 1),
("2022-03-10", "2022-04-10", "Atrasado", 2),
("2022-03-20", "2022-04-05", "Em andamento", 3);

INSERT INTO Usuarios (nome, endereco, telefone, email) VALUES
("João da Silva", "Rua A, 123", "(11) 9999-9999", "joao.silva@gmail.com"),
("Maria Santos", "Rua B, 456", "(11) 8888-8888", "maria.santos@hotmail.com");

INSERT INTO Categorias (nome, descricao) VALUES
("Romance", "Livros que contam histórias de amor"),
("Fantasia", "Livros com elementos imaginários e mágicos"),
("Infantil", "Livros para crianças");

INSERT INTO Livro_Categoria (livro_id, categoria_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 2),
(3, 3);


--crud de livros
DROP PROCEDURE inserir_livro;

DELIMITER $$
CREATE PROCEDURE crud_livro(
    IN novo_titulo VARCHAR(100),
    IN novo_autor VARCHAR(100),
    IN nova_editora VARCHAR(100),
    IN novo_ano_publicacao INT,
    IN oper CHAR(1),
    IN id_livro INT
    
)
BEGIN
    IF (oper = 'I') THEN
        INSERT INTO Livros (titulo, autor, editora, ano_publicacao)
        VALUES (novo_titulo, novo_autor, nova_editora, novo_ano_publicacao);
    ELSEIF (oper = 'U') THEN
        UPDATE Livros
        SET titulo = novo_titulo, autor = novo_autor, editora = nova_editora, ano_publicacao = novo_ano_publicacao
        WHERE id = id_livro;
    ELSEIF (oper = 'D') THEN
        DELETE FROM Livros WHERE id = id_livro;
    ELSE
        SELECT 'Operação inválida. Informe I para inserir, U para atualizar ou D para deletar.' AS ERROR;
    END IF;
END $$
DELIMITER ;

CALL inserir_livro('dom casmurro', 'eu autor', 'livraria', 2022, 'I', 1);
CALL inserir_livro('seu casmurro', 'autor eu', 'livraria Ulbra', 2022, 'U', 4);
CALL inserir_livro('seu casmurro', 'autor eu', 'livraria Ulbra', 2022, 'D', 4);

SELECT * FROM Livros;


--crud uduarios
DROP PROCEDURE crud_usuarios

DELIMITER $$
CREATE PROCEDURE crud_usuarios(
    IN novo_nome VARCHAR(100),
    IN novo_endereco VARCHAR(100),
    IN novo_telefone VARCHAR(100),
    IN novo_email VARCHAR(100),
    IN oper CHAR(1),
    IN id_usuario INT
    
)
BEGIN
    IF (oper = 'I') THEN
        INSERT INTO Usuarios (nome, endereco, telefone, email)
        VALUES (novo_nome, novo_endereco, novo_telefone, novo_email);
    ELSEIF (oper = 'U') THEN
        UPDATE Usuarios
        SET nome = novo_nome, endereco = novo_endereco, telefone = novo_telefone, email = novo_email
        WHERE id = id_usuario;
    ELSEIF (oper = 'D') THEN
        DELETE FROM Usuarios WHERE id = id_usuario;
    ELSE
        SELECT 'Operação inválida. Informe I para inserir, U para atualizar ou D para deletar.' AS ERROR;
    END IF;
END $$
DELIMITER ;

CALL crud_usuarios('Romulo', 'rua araça', '51 909090', 'Romulo@.com', 'I', 1);
CALL crud_usuarios('Romulo casmurro', 'rua araça eu', '51 909090', 'Romulo@.com', 'U', 3);
CALL crud_usuarios('', '', '', '', 'D', 3);


SELECT * FROM Usuarios;

drop view contagem_de_livros;
CREATE VIEW contagem_de_livros
AS
SELECT Livros.id as id_livro, Livros.id, Livros.titulo, Livros.autor, Livros.editora, Livros.ano_publicacao,
       Exemplares.edicao, Exemplares.num_paginas, Exemplares.data_aquisicao, Exemplares.condicao,
       Emprestimos.data_inicio, Emprestimos.data_devolucao, Emprestimos.situacao,
       Usuarios.nome, Usuarios.endereco, Usuarios.telefone, Usuarios.email,
       Categorias.nome AS categoria_nome, Categorias.descricao AS categoria_descricao
FROM Livros
LEFT JOIN Exemplares ON Livros.id = Exemplares.livro_id
LEFT JOIN Emprestimos ON Exemplares.id = Emprestimos.exemplar_id
LEFT JOIN Usuarios ON Emprestimos.id_usuario = Usuarios.id
LEFT JOIN Livro_Categoria ON Livros.id = Livro_Categoria.livro_id
LEFT JOIN Categorias ON Livro_Categoria.categoria_id = Categorias.id;

SELECT titulo, situacao
	FROM contagem_de_livros;

UPDATE Emprestimos
SET situacao = 'disponivel'
WHERE situacao IS NULL OR situacao = 'finalizado';


SELECT count(id_livro) as quant_livros, titulo, Coalesce(situacao, 'Disponível') as situacao
	FROM contagem_de_livros
WHERE situacao is null
GROUP BY id_livro

UNION

SELECT count(id_livro) as quant_livros, titulo, situacao
	FROM contagem_de_livros
WHERE situacao = 'finalizado'
GROUP BY id_livro
ORDER BY quant_livros DESC;


CREATE VIEW usuarios_por_situacao_emprestimo
AS
SELECT Livros.id as id_livro, Usuarios.nome as Locador, Livros.titulo as titulo, Emprestimos.data_inicio, Emprestimos.data_devolucao, Emprestimos.situacao
	FROM Usuarios
		INNER JOIN Emprestimos ON Usuarios.id = Emprestimos.id_usuario
        INNER JOIN Exemplares ON Emprestimos.exemplar_id = Exemplares.id
        INNER JOIN Livros ON Exemplares.livro_id = Livros.id;
        


SELECT locador, titulo, situacao
	FROM usuarios_por_situacao_emprestimo;	

DELIMITER //
CREATE PROCEDURE EmprestarLivro(
    IN p_exemplar_id INT,
    IN p_usuario_id INT,
    IN p_data_inicio DATE,
    IN p_data_devolucao DATE
)
BEGIN
    DECLARE v_exemplar_condicao VARCHAR(20);
    DECLARE v_emprestimo_situacao VARCHAR(20);
    DECLARE v_disponivel INT;
    DECLARE v_emprestimo_id INT;
    
    -- Verifica se o exemplar está disponível para empréstimo
    SELECT situacao INTO v_exemplar_condicao FROM Emprestimos WHERE id = p_exemplar_id;
    IF v_exemplar_condicao != 'disponivel' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O exemplar não está disponível para empréstimo';
    END IF;
    
    -- Verifica se o usuário já possui algum empréstimo em andamento
    SELECT COUNT(*) INTO v_disponivel FROM Emprestimos WHERE id_usuario = p_usuario_id AND situacao = 'emprestado';
    IF v_disponivel > 0 THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Usuário já possui um empréstimo em andamento';
    END IF;
    
    -- Cria um novo empréstimo
    INSERT INTO Emprestimos (data_inicio, data_devolucao, situacao, exemplar_id) VALUES (p_data_inicio, p_data_devolucao, 'emprestado', p_exemplar_id);
    SET v_emprestimo_id = LAST_INSERT_ID();
    
    -- Atualiza a situação do exemplar
    UPDATE Exemplares SET condicao = 'emprestado' WHERE id = p_exemplar_id;
    
    
    SELECT 'Empréstimo realizado com sucesso' AS mensagem;
END //

DELIMITER ;

CALL EmprestarLivro(1, 3, '2023-04-13', '2023-05-13');
	