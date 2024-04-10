CREATE SCHEMA Biblioteca;

CREATE TABLE biblioteca.livros(
    id_livro serial PRIMARY KEY,
    titulo text NOT NULL,
    autor text NOT NULL,
    ano_publicacao integer,
    disponivel boolean default true
);

CREATE TABLE biblioteca.membros(
    id_membro serial PRIMARY KEY,
    nome text NOT NULL,
    email text UNIQUE NOT NULL,
    data_cadastro date NOT NULL
);

CREATE TABLE biblioteca.emprestimos(
    id_emprestimo serial PRIMARY KEY,
    id_livro integer,
	id_membro integer,
    data_emprestimo date NOT NULL,
    data_devolucao date,
	FOREIGN KEY (id_livro) REFERENCES biblioteca.livros(id_livro),
	FOREIGN KEY (id_membro) REFERENCES biblioteca.membros(id_membro)
);

INSERT INTO biblioteca.livros(titulo,autor,ano_publicacao) 
	VALUES  ('Dom Quixote', 'Miguel de Cervantes', 1605),
			('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943),
			('Hamlet', 'William Shakespeare', 1603),
			('Cem Anos de Solidão', 'Gabriel Garcia Márquez', 1967),
			('Orgulho e Preconceito', 'Jane Austen', 1813),
			('1984', 'George Orwell', 1949),
			('O Senhor dos Anéis', 'J.R.R. Tolkien', 1954),
			('A Divina Comédia', 'Dante Alighieri', 1320);

INSERT INTO biblioteca.membros(nome,email,data_cadastro) 
	VALUES  ('Ana Silva', 'ana.silva@example.com', '2022-01-10'),
			('Bruno Gomes', 'bruno.gomes@example.com', '2022-02-15'),
			('Carlos Eduardo', 'carlos.eduardo@example.com', '2022-03-20'),
			('Daniela Rocha', 'daniela.rocha@example.com', '2022-05-05'),
			('Eduardo Lima', 'eduardo.lima@example.com', '2022-06-10'),
			('Fernanda Martins', 'fernanda.martins@example.com', '2022-07-15'),
			('Gustavo Henrique', 'gustavo.henrique@example.com', '2022-08-20'),
			('Helena Souza', 'helena.souza@example.com', '2022-09-25');
			
INSERT INTO biblioteca.emprestimos(id_livro,id_membro,data_emprestimo,data_devolucao) 
	VALUES  (1, 1, '2022-04-01', NULL),
			(2, 2, '2022-04-03', '2022-04-10'),
			(3, 3, '2022-04-05', NULL),
			(4, 4, '2022-10-01', NULL),
			(5, 5, '2022-10-03', '2022-10-17'),
			(2, 3, '2022-10-06', NULL),
			(1, 2, '2022-10-08', '2022-10-15'),
			(3, 1, '2022-10-10', NULL),
			(3, 2, '2022-11-01', NULL),
			(2, 3, '2022-11-03', NULL),
			(1, 4, '2022-11-05', NULL),
			(5, 1, '2022-11-07', '2022-11-21'),
			(4, 5, '2022-11-09', '2022-11-23'),
			(2, 1, '2022-11-12', NULL),
			(3, 4, '2022-11-14', '2022-11-28'),
			(1, 3, '2022-11-16', NULL),
			(5, 2, '2022-11-18', '2022-11-25'),
			(4, 1, '2022-11-20', '2022-12-04');