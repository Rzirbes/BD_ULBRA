
CREATE TABLE Produtos (
  Prd_Falta INT NOT NULL,
  Prd_Qtd_estoque INT NOT NULL,
  Prd_Codigo INT PRIMARY KEY,
  Prd_Descricao VARCHAR(100) NOT NULL,
  Prd_Valor DECIMAL(10,2) NOT NULL,
  Prd_Status VARCHAR(20) NOT NULL
);

CREATE TABLE Orcamentos (
  Orc_Codigo INT PRIMARY KEY,
  Orc_Data DATE NOT NULL,
  Orc_Status VARCHAR(20) NOT NULL
);

CREATE TABLE Orcamentos_Produtos (
  Orp_Qtd INT NOT NULL,
  Orp_Valor DECIMAL(10,2) NOT NULL,
  Orc_Codigo INT,
  Prd_Codigo INT,
  Orp_Status VARCHAR(20) NOT NULL,
  PRIMARY KEY (Orc_Codigo, Prd_Codigo),
  FOREIGN KEY (Orc_Codigo) REFERENCES Orcamentos(Orc_Codigo),
  FOREIGN KEY (Prd_Codigo) REFERENCES Produtos(Prd_Codigo)
);



-- Inserindo dados na tabela Produtos
INSERT INTO Produtos (Prd_Falta, Prd_Qtd_estoque, Prd_Codigo, Prd_Descricao, Prd_Valor, Prd_Status)
VALUES
  (5, 20, 1, 'Notebook Dell', 3500.00, 'Ativo'),
  (2, 10, 2, 'Mouse sem fio', 50.00, 'Ativo'),
  (1, 5, 3, 'Teclado mecânico', 200.00, 'Inativo');

-- Inserindo dados na tabela Orcamentos
INSERT INTO Orcamentos (Orc_Codigo, Orc_Data, Orc_Status)
VALUES
  (1, '2023-05-01', 'Pendente'),
  (2, '2023-05-02', 'Aprovado'),
  (3, '2023-05-03', 'Rejeitado');

-- Inserindo dados na tabela Orcamentos_Produtos
INSERT INTO Orcamentos_Produtos (Orp_Qtd, Orp_Valor, Orc_Codigo, Prd_Codigo, Orp_Status)
VALUES
  (2, 7000.00, 1, 1, 'Pendente'),
  (1, 50.00, 1, 2, 'Aprovado'),
  (4, 800.00, 2, 3, 'Rejeitado'),
  (3, 10500.00, 2, 1, 'Aprovado'),
  (5, 1000.00, 3, 2, 'Pendente'),
  (2, 400.00, 3, 3, 'Rejeitado');


  CREATE TABLE Status (
  Codigo INT PRIMARY KEY,
  Descricao VARCHAR(50)
);

-- Inserção dos valores possíveis para o status na tabela Status
INSERT INTO Status (Codigo, Descricao)
VALUES
  (1, 'Pendente'),
  (2, 'Cancelado'),
  (3, 'Aprovado'),
  (4, 'Rejeitado');
  

-- Alteração da tabela Orcamentos_Produtos para adicionar a coluna Status_Codigo
ALTER TABLE Orcamentos_Produtos ADD COLUMN Status_Codigo INT;


-- Atualização dos valores da coluna Status_Codigo na tabela Orcamentos_Produtos
UPDATE Orcamentos_Produtos SET Status_Codigo = 
  CASE Orp_Status
    WHEN 'Pendente' THEN 1
	WHEN 'Cancelado' THEN 2
    WHEN 'Aprovado' THEN 3
    WHEN 'Rejeitado' THEN 4
   
  END;

-- Alteração da coluna Orp_Status na tabela Orcamentos_Produtos para Status_Codigo
ALTER TABLE Orcamentos_Produtos DROP COLUMN Orp_Status;
ALTER TABLE Orcamentos_Produtos CHANGE COLUMN Status_Codigo Orp_Status INT;

-- Criação da trigger para atualização do estoque
DELIMITER //
CREATE TRIGGER trigger_atualiza_estoque_produto
AFTER UPDATE ON Orcamentos_Produtos
FOR EACH ROW
BEGIN
  IF NEW.Orp_Status = 2 THEN
    UPDATE Produtos SET Prd_Qtd_estoque = Prd_Qtd_estoque + OLD.Orp_Qtd
    WHERE Prd_Codigo = OLD.Prd_Codigo;
  ELSE
    UPDATE Produtos SET Prd_Qtd_estoque = Prd_Qtd_estoque - OLD.Orp_Qtd + NEW.Orp_Qtd
    WHERE Prd_Codigo = NEW.Prd_Codigo;
  END IF;
END //
DELIMITER ;