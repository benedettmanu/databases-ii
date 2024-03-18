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