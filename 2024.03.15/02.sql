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