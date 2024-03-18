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