

SET autocommit = 0;

SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

INSERT INTO setores(nome) VALUES ('devops');
SET @id_setor = LAST_INSERT_ID(); -- Obtém o último ID inserido em "setores"
INSERT INTO funcionarios (nome, salario, id_setor) VALUES ('Anita', 0, @id_setor);

COMMIT;

SELECT * FROM setores;
SELECT * FROM funcionarios;
DELETE FROM funcionarios WHERE id = '';
DELETE FROM setores WHERE id = '';

CREATE TABLE pessoas (
  num_pessoa INT NOT NULL,
  nome_email VARCHAR(100) NOT NULL,
  PRIMARY KEY (num_pessoa)
);

START TRANSACTION;

INSERT INTO pessoas
(num_pessoa, nome_email)
VALUES
(78360, 'rst.marcondes@smail.com'),
(78361, 'jcc.meirelles@jmail.com'),
(78362, 'mjk.amadeus@imail.com');

COMMIT;

SELECT * FROM pessoas;





