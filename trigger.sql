CREATE TABLE setores
(
	id int auto_increment primary key,
    nome varchar(50) not null,
    total_salario decimal(18,2) default 0
);

insert into setores (nome)
	values ('Dev'), ('Suporte'),('Finan');

CREATE TABLE funcionarios
(
	id int auto_increment primary key,
    nome varchar(50) not null, 
    salario decimal(18,2) default 0,
    id_setor int,
    constraint funcionarios_setores_fk
		foreign key(id_setor) 
			references setores(id) 
				ON DELETE RESTRICT
                ON UPDATE CASCADE
);

DELIMITER //
  CREATE TRIGGER trigger_atualiza_total_salario
  AFTER INSERT ON funcionarios
  FOR EACH ROW
  BEGIN
     UPDATE setores SET total_salario = total_salario + NEW.salario
     WHERE id = NEW.id_setor;
  END //
DELIMITER ;

DELIMITER //
  CREATE TRIGGER trigger_atualiza_total_salario_quando_deleta
  AFTER DELETE ON funcionarios
  FOR EACH ROW
  BEGIN
     UPDATE setores SET total_salario = total_salario - OLD.salario
     WHERE id = OLD.id_setor;
  END //
DELIMITER ;

DELIMITER //
  CREATE TRIGGER trigger_atualiza_total_salario_quando_funcionario_recebe_aumento
  AFTER UPDATE ON funcionarios
  FOR EACH ROW
  BEGIN
     UPDATE setores SET total_salario = total_salario + NEW.salario
     WHERE id = NEW.id_setor;
  END //
DELIMITER ;

DELIMITER //
  CREATE TRIGGER trigger_atualiza_total_salario_quando_funcionario_recebe_aumento
  AFTER UPDATE ON funcionarios
  FOR EACH ROW
  BEGIN
     UPDATE setores SET total_salario = total_salario - OLD.salario + NEW.salario
     WHERE id = NEW.id_setor;
  END //
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;

UPDATE funcionarios SET salario = 2000
WHERE id = 4;

INSERT INTO funcionarios (nome, salario, id_setor) VALUES
("João", 4000, 1);

DELETE FROM funcionarios where id = 3;

SELECT * FROM funcionarios;
SELECT * FROM setores;
