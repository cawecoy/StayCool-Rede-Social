-- Query que retorna os 3 amigos mais publicadores (incluindo seus grupos). 
-- Quando o usuario está em mais de um grupo, é retornado mais de uma tupla para este usuário 
-- (mais especificamente, uma tupla para cada grupo que ele estiver).
-- Ordenação da tabela a ser retornada (critérios):
	-- 1o. Nome do grupo
	-- 2o. Número de posts (quando o nome do grupo for igual para 2 ou mais tuplas)

-- SELECT final.nome AS nome, final.login AS login, final.contador AS contador, coalesce(amigosgps.grupo, 'Amigos sem grupo') AS grupo FROM (SELECT * FROM amigosgrupos WHERE meulogin = 'alex') AS amigosgps RIGHT JOIN (SELECT usuarios.nome AS nome, rst.login AS login, rst.contador AS contador FROM usuarios JOIN (SELECT resultado.login_postador AS login, resultado.contador AS contador FROM (SELECT seulogin FROM amigos WHERE meulogin = 'alex') AS amgs RIGHT JOIN (SELECT login_postador, COUNT(login_postador) AS contador FROM posts WHERE login_postador <> 'alex'AND time >= '0001-01-01 00:00:00'AND time <= '9000-01-01 00:00:00'GROUP BY login_postador ) AS resultado ON amgs.seulogin = resultado.login_postador WHERE amgs.seulogin is not null GROUP BY resultado.login_postador, resultado.contador ) AS rst ON rst.login = usuarios.login ) AS final ON amigosgps.seulogin = final.login ORDER BY amigosgps.grupo, final.contador DESC

SELECT 
	final.nome AS nome, 
	final.login AS login, 
	final.contador AS contador, 
	coalesce(amigosgps.grupo, 'Amigos sem grupo') AS grupo 
FROM 
(
	-- Retorna tabela de grupos dos meus amigos
	SELECT 
		* 
	FROM 
		amigosgrupos 
	WHERE 
		meulogin = 'alex'
) AS amigosgps 
RIGHT JOIN -- RIGHT JOIN entre as seguintes tabelas: "grupos dos meus amigos" e "os amigos mais publicadores"
(
	-- Retorna os amigos mais publicadores do usuário
	SELECT 
		usuarios.nome AS nome, 
		rst.login AS login, 
		rst.contador AS contador 
	FROM 
		-- Retorna tabela de todos os usuarios (apenas para pegar o atributo "nome" dos mais publicadores)
		usuarios
	JOIN -- JOIN entre as seguintes tabelas: "todos os usuários" e "número de publicações de todos amigos"
	(
		-- Retorna tabela número de publicações dos amigos
		-- (porém, a tabela retornada aqui não tem o atributo "nome")
		SELECT 
			resultado.login_postador AS login, 
			resultado.contador AS contador 
		FROM 
		(
			-- Retorna os amigos do usuário
			SELECT 
				seulogin 
			FROM 
				amigos 
			WHERE 
				meulogin = 'alex'
		) AS amgs 
		RIGHT JOIN -- RIGHT JOIN entre as seguintes tabelas: "os amigos do usuário" e "todos os usuário exceto eu (amigos e não-amigos) e o número de publicações realizadas por cada um"
		(
			-- Retorna todos os usuário exceto eu (amigos e não-amigos) e o número de publicações realizadas por cada um
			SELECT 
				login_postador, 
				COUNT(login_postador) AS contador 
			FROM 
				posts 
			WHERE 
				login_postador <> 'alex' 
				AND time >= '0001-01-01 00:00:00' 
				AND time <= '9000-01-01 00:00:00' 
			GROUP BY 
				login_postador
		) AS resultado 
		ON 
			amgs.seulogin = resultado.login_postador 
		WHERE 
			amgs.seulogin is not null 
		GROUP BY 
			resultado.login_postador, 
			resultado.contador 
	) AS rst  
	ON 
		rst.login = usuarios.login 
) AS final 
ON 
	amigosgps.seulogin = final.login 
ORDER BY 
	amigosgps.grupo, final.contador DESC