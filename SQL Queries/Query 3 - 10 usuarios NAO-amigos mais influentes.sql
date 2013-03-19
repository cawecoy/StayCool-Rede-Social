--
-- Query que retorna os 10 usuários (não-amigos) mais influentes
-- Ordenado pela taxa de influencia do amigo = somatório ( número de curtições + número de comentários * 5 )
--

-- SELECT usuarios.nome, rst.login, rst.contador FROM usuarios JOIN (SELECT pts.login AS login, pts.contador AS contador FROM (SELECT seulogin AS login FROM amigos WHERE meulogin = 'alex') AS amg RIGHT JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_curtir.login, tb_comentarios.login) AS login FROM (SELECT COUNT(idPost) AS contador, login_postador AS login FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> 'alex'AND curtir.login <> posts.login_postador AND curtir.time >= '1000-01-01 00:00:00'AND curtir.time <= '3000-01-01 00:00:00'GROUP BY login_postador ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, login_postador AS login FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> 'alex'AND comentarios.login <> posts.login_postador AND comentarios.time >= '1000-01-01 00:00:00'AND comentarios.time <= '3000-01-01 00:00:00'GROUP BY login_postador ) AS tb_comentarios ON tb_curtir.login = tb_comentarios.login ) AS pts ON pts.login = amg.login WHERE amg.login IS NULL AND pts.login <> 'alex'GROUP BY pts.login, pts.contador ORDER BY contador DESC LIMIT 10 ) AS rst ON rst.login = usuarios.login

SELECT 
	usuarios.nome, 
	rst.login, 
	rst.contador 
FROM 
	-- Retorna tabela de todos os usuarios (apenas para pegar o atributo "nome" dos usuarios não-amigos mais influentes)
	usuarios
JOIN -- JOIN entre as seguintes tabelas: "usuarios" e "os 10 usuários não-amigos mais influentes"
(
	-- Retorna tabela com os 10 usuários não-amigos mais influentes
	-- (porém, a tabela retornada aqui não tem o atributo "nome")
	SELECT 
		pts.login AS login, 
		pts.contador AS contador 
	FROM 
	(
		-- Retorna a tabela meus amigos
		-- (apenas para fazer RIGHT JOIN com a tabela de taxa de influencia de TODOS os usuários exceto eu, e filtrar apenas os não-amigos)
		SELECT 
			seulogin AS login 
		FROM 
			amigos 
		WHERE 
			meulogin = 'alex'
	) AS amg 
	RIGHT JOIN -- RIGHT JOIN entre as seguintes tabelas: "meus amigos" e "taxa de influencia de TODOS os usuários exceto eu"
	(
		-- Retorna tabela com taxa de influencia de TODOS os usuários exceto eu
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
				AND curtir.time >= '1000-01-01 00:00:00' 
				AND curtir.time <= '3000-01-01 00:00:00' 
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
				AND comentarios.time >= '1000-01-01 00:00:00' 
				AND comentarios.time <= '3000-01-01 00:00:00' 
			GROUP BY 
				login_postador
		) AS tb_comentarios 
		ON 
			tb_curtir.login = tb_comentarios.login
	) AS pts 
	ON 
		pts.login = amg.login 
	WHERE 
		amg.login IS NULL 
		AND pts.login <> 'alex' 
	GROUP BY 
		pts.login, 
		pts.contador
	ORDER BY 
		contador DESC 
	LIMIT 
		10
) AS rst  
ON 
	rst.login = usuarios.login 
