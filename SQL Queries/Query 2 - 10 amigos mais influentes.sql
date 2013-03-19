--
-- Query que retorna os 10 amigos mais influentes
-- Ordenado pela taxa de influencia do amigo = somatório ( número de curtições + número de comentários * 5 )
--

-- SELECT usuarios.nome, rst.login, rst.contador FROM usuarios JOIN (SELECT pts.login AS login, pts.contador AS contador FROM amigos JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_curtir.login, tb_comentarios.login) AS login FROM (SELECT COUNT(idPost) AS contador, login_postador AS login FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> 'alex'AND curtir.login <> posts.login_postador AND posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'GROUP BY login_postador ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, login_postador AS login FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> 'alex'AND comentarios.login <> posts.login_postador AND posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'GROUP BY login_postador ) AS tb_comentarios ON tb_curtir.login = tb_comentarios.login ) AS pts ON pts.login = amigos.seulogin WHERE amigos.meulogin = 'alex'AND amigos.seulogin IS NOT NULL ORDER BY pts.contador DESC LIMIT 10 ) AS rst ON rst.login = usuarios.login

SELECT 
	usuarios.nome, 
	rst.login, 
	rst.contador 
FROM 
	-- Retorna tabela de todos os usuarios (apenas para pegar o atributo "nome" dos mais amigos influentes)
	usuarios
JOIN -- JOIN entre as seguintes tabelas: "usuarios" e "os 10 amigos mais influentes"
(
	-- Retorna tabela com os 10 amigos mais influentes
	-- (porém, a tabela retornada aqui não tem o atributo "nome")
	SELECT 
		pts.login AS login, 
		pts.contador AS contador 
	FROM 
		-- Retorna a tabela amigos
		-- (apenas para fazer JOIN com a tabela de taxa de influencia de TODOS os usuários exceto eu, e filtrar apenas os amigos)
		amigos
	JOIN -- JOIN entre as seguintes tabelas: "amigos" e "taxa de influencia de TODOS os usuários exceto eu"
	(
		-- Retorna tabela com taxa de influencia de TODOS os usuários
		SELECT 
			coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, 
			coalesce(tb_curtir.login, tb_comentarios.login) AS login 
		FROM 
		(
			-- Retorna todos os usuários e número de curtições recebidos
			SELECT 
				COUNT(idPost) AS contador, 
				login_postador AS login 
			FROM 
				curtir 
			JOIN 
				posts 
			ON 
				curtir.idPost = posts.id 
			WHERE 
				curtir.login <> 'alex' 
				AND curtir.login <> posts.login_postador 
				AND posts.time >= '1000-01-01 00:00:00' 
				AND posts.time <= '3000-01-01 00:00:00' 
			GROUP BY 
				login_postador
		) AS tb_curtir 
		FULL JOIN -- FULL JOIN entre as seguintes tabelas: "todos os usuários e número de curtições recebidos" e "todos os usuários e número de comentarios recebidos"
		(
			-- Retorna todos os usuários e número de comentários recebidos
			SELECT 
				COUNT(idPost) AS contador, 
				login_postador AS login 
			FROM 
				comentarios 
			JOIN 
				posts 
			ON 
				comentarios.idPost = posts.id 
			WHERE 
				comentarios.login <> 'alex' 
				AND comentarios.login <> posts.login_postador 
				AND posts.time >= '1000-01-01 00:00:00' 
				AND posts.time <= '3000-01-01 00:00:00' 
			GROUP BY 
				login_postador
		) AS tb_comentarios 
		ON 
			tb_curtir.login = tb_comentarios.login
	) AS pts  
	ON 
		pts.login = amigos.seulogin 
	WHERE 
		amigos.meulogin = 'alex' 
		AND amigos.seulogin IS NOT NULL
	ORDER BY 
		pts.contador DESC 
	LIMIT 
		10
) AS rst 
ON 
	rst.login = usuarios.login 

