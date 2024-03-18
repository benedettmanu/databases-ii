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