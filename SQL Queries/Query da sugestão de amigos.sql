
--
-- Query que retorna 5 usuários sugeridos (não-amigos) ordenado pelo número de amigos em comum comigo
--

-- SELECT resultado.login, resultado.nome FROM (SELECT * FROM amigos WHERE meulogin = 'alex') as amg3 RIGHT JOIN (SELECT amg1.seulogin as login, amg1.nome as nome, COUNT(amg1.seulogin) as contador FROM (SELECT amigos.meulogin, amigos.seulogin, usuarios.nome FROM amigos JOIN usuarios ON amigos.seulogin = usuarios.login WHERE amigos.seulogin <> 'alex') as amg1 JOIN (SELECT * FROM amigos WHERE amigos.meulogin = 'alex') as amg2 ON amg1.meulogin = amg2.seulogin GROUP BY amg1.seulogin, amg1.nome ) as resultado ON amg3.seulogin = resultado.login WHERE seulogin is null ORDER BY contador DESC LIMIT 5

-- SELECT resultado.login, resultado.nome FROM (SELECT * FROM usuarios WHERE login <> 'alex'ORDER BY RANDOM() ) AS resultado LEFT JOIN (SELECT seulogin FROM amigos WHERE meulogin = 'alex') AS amg ON resultado.login = amg.seulogin WHERE amg.seulogin is null LIMIT 5

SELECT 
	resultado.login, 
	resultado.nome 
FROM 
(
	-- Retorna tabela contendo meus amigos amigos
	SELECT 
		* 
	FROM 
		amigos 
	WHERE 
		meulogin = 'alex'
) as amg3 
RIGHT JOIN -- RIGHT JOIN entre as seguintes tabelas: "meus amigos" e "TODOS os usuários e o número de amigos em comum comigo"
(
	-- Retorna tabela com TODOS os usuários e o número de amigos em comum comigo
	SELECT 
		amg1.seulogin as login, 
		amg1.nome as nome, 
		COUNT(amg1.seulogin) as contador 
	FROM 
	(
		-- Retorna TODOS os amigos de TODOS usuários (exceto eu)
		SELECT 
			amigos.meulogin, 
			amigos.seulogin, 
			usuarios.nome 
		FROM 
			amigos 
		JOIN 
			usuarios 
		ON 
			amigos.seulogin = usuarios.login 
		WHERE 
			amigos.seulogin <> 'alex'
	) as amg1 
	JOIN -- JOIN entre as seguintes tabelas: "TODOS os amigos de TODOS usuários (exceto eu)" e "todos os meus amigos"
	(
		-- Retorna todos os meus amigos
		SELECT 
			* 
		FROM 
			amigos 
		WHERE 
			amigos.meulogin = 'alex'
	) as amg2 
	ON 
		amg1.meulogin = amg2.seulogin 
	GROUP BY 
		amg1.seulogin, amg1.nome
) as resultado 
ON 
	amg3.seulogin = resultado.login 
-- O "amg3 RIGHT JOIN resultado" vai retornar uma tabela onde sempre que o atributo "seulogin" for nulo, 
-- significa que não é meu amigo (este WHERE serve para filtrar apenas não-amigos)
WHERE 
	seulogin is null 
ORDER BY 
	contador DESC 
LIMIT 5


--
--	Query que retorna 5 usuários sugeridos (não-amigos) de forma randomizada
--

SELECT 
	resultado.login, 
	resultado.nome 
FROM 
(
	-- Retorna TODOS os usuários (exceto eu) ordenados randomicamente
	SELECT 
		* 
	FROM 
		usuarios 
	WHERE 
		login <> 'alex' 
	ORDER BY 
		RANDOM()
) AS resultado 
LEFT JOIN -- LEFT JOIN entre as tabelas: "TODOS os usuários (exceto eu) ordenados randomicamente" e "meus amigos"
(
	-- Retorna os meus amigos
	SELECT 
		seulogin 
	FROM 
		amigos 
	WHERE 
		meulogin = 'alex'
) AS amg 
ON 
	resultado.login = amg.seulogin 
WHERE 
	amg.seulogin is null 
LIMIT 
	5