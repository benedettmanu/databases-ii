--Trigger de Auditoria de Empréstimos: Criar um trigger que registre em uma tabela de 
--auditoria cada vez que um empréstimo for realizado.

CREATE TABLE biblioteca.emprestimos_audit(
    operation         char(1)   NOT NULL,
    stamp             timestamp NOT NULL,
    userid            text      NOT NULL,
    book           text      NOT NULL
);

CREATE OR REPLACE FUNCTION biblioteca.process_emprestimos_audit() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO biblioteca.emprestimos_audit SELECT 'U', now(), current_user, NEW.id_livro;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO biblioteca.emprestimos_audit SELECT 'I', now(), current_user, NEW.id_livro;
        END IF;
        RETURN OLD;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER emprestimos_audit
AFTER INSERT OR UPDATE ON biblioteca.emprestimos
    FOR EACH ROW EXECUTE FUNCTION biblioteca.process_emprestimos_audit();
	
INSERT INTO biblioteca.emprestimos(id_livro,id_membro,data_emprestimo,data_devolucao) 
	VALUES  (1, 1, '2022-04-01', NULL);

--Antes de um empréstimo ser efetivado, verificar se o livro está disponível.
CREATE OR REPLACE FUNCTION Biblioteca.verifica_disponivel() RETURNS trigger AS $verifica_disponivel$
	DECLARE 
		disp boolean;
    BEGIN
		disp:=(SELECT l.disponivel FROM Biblioteca.livros l WHERE l.id_livro = NEW.id_livro);
		
        IF disp = false THEN
            RAISE EXCEPTION 'Livro não esta disponível';
        END IF;
        RETURN NEW;
    END;
$verifica_disponivel$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_disponivel BEFORE INSERT
ON Biblioteca.emprestimos
FOR EACH ROW EXECUTE FUNCTION Biblioteca.verifica_disponivel();
	 
INSERT INTO biblioteca.emprestimos(id_livro,id_membro,data_emprestimo,data_devolucao) 
	VALUES  (1, 1, '2022-04-01', NULL);

--Trigger de Atualização de Disponibilidade: Após um empréstimo ser efetivado, atualizar 
--a disponibilidade do livro para false.
CREATE OR REPLACE FUNCTION Biblioteca.muda_status() RETURNS trigger AS $muda_status$
    BEGIN
        UPDATE Biblioteca.livros SET disponivel = false WHERE id_livro = NEW.id_livro;
        RETURN OLD;
    END;
$muda_status$ LANGUAGE plpgsql;

CREATE TRIGGER muda_status AFTER INSERT
ON Biblioteca.emprestimos
FOR EACH ROW EXECUTE FUNCTION Biblioteca.muda_status();
	 
INSERT INTO biblioteca.emprestimos(id_livro,id_membro,data_emprestimo,data_devolucao) 
	VALUES  (2, 1, '2022-04-01', NULL);

--Trigger de Devolução de Livro: Quando um livro é devolvido, atualizar a disponibilidade 
--do livro para true.
CREATE OR REPLACE FUNCTION Biblioteca.muda_status_true() RETURNS trigger AS $muda_status_true$
    BEGIN
		IF NEW.data_devolucao IS NOT NULL THEN 
        	UPDATE Biblioteca.livros SET disponivel = true WHERE id_livro = NEW.id_livro;
		END IF;
        RETURN OLD;
    END;
$muda_status_true$ LANGUAGE plpgsql;

CREATE TRIGGER muda_status_true AFTER UPDATE
ON Biblioteca.emprestimos
FOR EACH ROW EXECUTE FUNCTION Biblioteca.muda_status_true();
	
UPDATE Biblioteca.emprestimos SET data_devolucao = '2024-03-22' WHERE id_livro = 1