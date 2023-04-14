drop procedure getDatetime;

DELIMITER $$
CREATE PROCEDURE getDatetime()
BEGIN

	select concat('A data atual é : ', current_timestamp) as retorno;
    
END $$
DELIMITER ;

call getDatetime();


drop procedure getPersonByName;

DELIMITER $$
CREATE PROCEDURE getPersonByName(name varchar(50))
BEGIN
	
	select * from PESSOAS
		where nome like concat('%',name,'%');
    
END $$
DELIMITER ;

call getPersonByName('la');



drop procedure crudPerson;

DELIMITER $$
CREATE PROCEDURE crudPerson(p_id int, p_name varchar(50), p_oper char(1))
BEGIN
	declare v_nome varchar(50);
	if(p_oper = 'I') then
		insert into PESSOAS(NOME) values(p_name);
	elseif(p_oper = 'U') then
		update PESSOAS set NOME = p_name where ID = p_id;
    elseif(p_oper = 'D') then
		set v_nome = (select NOME from PESSOAS where ID = p_id);
		delete from PESSOAS where ID = p_id;
        
        select concat('A pessoa ', v_nome,' foi excluída com sucesso') as mensagem;
	else
		select 'informe I para inserir, U para atualizar ou D para deletar:' as error;
    end if;
    
END $$
DELIMITER ;

select * from PESSOAS;

call crudPerson(8, 'Francisco teste', 'D');



drop procedure tabuada;




DELIMITER $$
CREATE PROCEDURE tabuada(num int)
BEGIN
	declare i int default 1;
    
	drop table if exists tmp_tabuada;
    create temporary table tmp_tabuada(
		multiplicador int,
		resultado int
    );
    
    while i <= 10 do
        insert into tmp_tabuada(multiplicador, resultado) values (i, i*num);
        set i = i + 1;
    end while;
    
    SELECT CONCAT(num,' x ', multiplicador, ' = ', resultado) AS tabuada FROM tmp_tabuada;
    
END $$
DELIMITER ;

call tabuada(5);



