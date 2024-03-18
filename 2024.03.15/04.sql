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