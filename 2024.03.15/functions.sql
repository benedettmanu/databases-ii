-- 1 Crie uma função que insira um novo registro na tabela Endereco e 
--   retorne o código do endereço inserido.
CREATE OR REPLACE FUNCTION insere_endereco(
logradouro text,
numero integer,
complemento text,
cep text,
cidade text,
uf text)
	RETURNS integer AS $$
	BEGIN
		INSERT INTO clinica_vet.endereco(logradouro,numero,complemento,cep,cidade,uf) 
		VALUES 	(logradouro, numero, complemento, cep, cidade, uf);
		RETURN max(cod) from clinica_vet.endereco;
	END
	$$ LANGUAGE plpgsql;
	
	
select insere_endereco('Rua Estanislau Voltolini', 31, '401', '88270-000', 'Nova Trento', 'SC');

-- 2 Crie um procedimento que atualize o email de um responsável com base no seu código. 
 CREATE OR REPLACE FUNCTION atualiza_email(cod_responsavel INTEGER, novo_email TEXT)
	RETURNS setof clinica_vet.responsavel AS $$
	BEGIN
		UPDATE clinica_vet.responsavel
		SET email = novo_email
		WHERE cod = cod_responsavel;
		RETURN query 
		SELECT * FROM clinica_vet.responsavel
		WHERE
		cod = cod_responsavel;
	END
	$$ LANGUAGE plpgsql;
	
SELECT atualiza_email(1,'laurasanches@outlook.com')

-- 4 Faça um procedimento para excluir um responsável. 
--	 Excluir seus pets e endereços.
CREATE OR REPLACE FUNCTION excluir_responsavel(cod_responsavel INTEGER)
	RETURNS TEXT AS $$
	BEGIN
		DELETE FROM clinica_vet.pet
		WHERE cod_resp = cod_responsavel;
		DELETE FROM clinica_vet.responsavel
		WHERE cod = cod_responsavel;
		DELETE FROM clinica_vet.endereco
		WHERE cod = (SELECT cod_end FROM clinica_vet.responsavel WHERE cod = cod_responsavel);
		RETURN 'responsavel excluído';
	END
	$$ LANGUAGE plpgsql;
	
SELECT excluir_responsavel(1)

-- 5 Faça uma função que liste todas as consultas agendadas para uma data específica.
--   Deve retornar uma tabela com os campos data da consulta, nome do responsavel, 
--   nome do pet, telefone do responsavel e nome do veterinario 

drop function clinica_vet.consulta_por_data;
CREATE OR REPLACE FUNCTION clinica_vet.consulta_por_data(dt text)
RETURNS TABLE(
	data_consulta date,
	nome_responsavel text,
	nome_pet text,
	telefone_responsavel text,
	nome_veterinario VARCHAR
) AS $$
BEGIN
	RETURN QUERY SELECT c.dt as data_consulta, r.nome as nome_responsavel, p.nome as nome_pet, r.fone as telefone_responsavel, v.nome as nome_veterinario 
	FROM clinica_vet.consulta c 
	INNER JOIN clinica_vet.veterinario v ON v.cod = c.cod_vet
	INNER JOIN clinica_vet.pet p ON p.cod = c.cod_pet
	INNER JOIN clinica_vet.responsavel r ON r.cod = p.cod_resp  
	WHERE c.dt = dt::date;
END
$$ LANGUAGE plpgsql;
	
SELECT * from consulta_por_data('2023-10-05');

-- 6 Crie uma função que receba os dados do veterinario por parâmetro, armazene na tabela “veterinario” e retorne todos os dados da tabela.
CREATE OR REPLACE FUNCTION clinica_vet.dados_vet(
nome text,
crmv numeric,
especialidade text,
fone text,
email text,
cod_end INTEGER)
	RETURNS setof clinica_vet.veterinario AS $$
	BEGIN
		INSERT INTO clinica_vet.veterinario(nome,crmv,especialidade,fone,email,cod_end) 
		VALUES 	(nome,crmv,especialidade,fone,email,cod_end) ;
		RETURN query 
		SELECT * FROM clinica_vet.veterinario
		WHERE cod = (SELECT max(cod) FROM clinica_vet.veterinario);
	END
	$$ LANGUAGE plpgsql;
	
SELECT clinica_vet.dados_vet('Laura', 12569, 'pediatra', '991541447', 'laurasanches@outlook.com', '1');