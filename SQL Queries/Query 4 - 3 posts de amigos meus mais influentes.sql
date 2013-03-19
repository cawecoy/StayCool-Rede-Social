
--
-- Query que retorna os 3 posts de amigos meus mais influentes
--

-- SELECT posts.id, posts.login, posts.login_postador, posts.time, rst.contador FROM posts JOIN (SELECT pts2.contador, pts2.idPost FROM amigos JOIN (SELECT pts.contador, pts.idPost, pts.login, pts.login_postador FROM amigos JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_curtir.idPost, tb_comentarios.idPost) AS idPost, coalesce(tb_curtir.login, tb_comentarios.login) AS login, coalesce(tb_curtir.login_postador, tb_comentarios.login_postador) AS login_postador FROM (SELECT COUNT(idPost) AS contador, posts.id AS idPost, posts.login AS login, posts.login_postador AS login_postador FROM curtir RIGHT JOIN posts ON curtir.idPost = posts.id GROUP BY posts.id, posts.login, posts.login_postador ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, posts.id AS idPost, posts.login AS login, posts.login_postador AS login_postador FROM comentarios RIGHT JOIN posts ON comentarios.idPost = posts.id GROUP BY posts.id, posts.login, posts.login_postador ) AS tb_comentarios ON tb_curtir.idPost = tb_comentarios.idPost ) AS pts ON pts.login_postador = amigos.seulogin WHERE ( amigos.meulogin = 'alex' AND amigos.seulogin IS NOT NULL ) OR ( pts.login = 'alex' AND pts.login_postador <> 'alex' ) GROUP BY pts.idPost, pts.contador, pts.login, pts.login_postador ) AS pts2 ON pts2.login = amigos.seulogin WHERE ( amigos.meulogin = 'alex' AND amigos.seulogin IS NOT NULL ) OR ( pts2.login = 'alex' AND pts2.login_postador <> 'alex' ) GROUP BY pts2.idPost, pts2.contador ) AS rst ON rst.idPost = posts.id WHERE posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'ORDER BY posts.time::date DESC, rst.contador DESC

SELECT 
	posts.id,
	posts.login, 
	posts.login_postador,
	posts.time,
	rst.contador 
FROM
	-- Retorna a tabela posts 
	posts
JOIN -- JOIN entre as seguintes tabelas: "posts" e "posts mais influentes de amigos"
(
	-- Retorna tabela de posts mais influentes de amigos
	-- (porém, a tabela retornada aqui só tem o atributo "id" dos posts 
	-- e a taxa de influência do respectivo post)
	SELECT 
		pts2.contador, 
		pts2.idPost 
	FROM 
		-- Retorn tabela amigos
		amigos
	JOIN -- JOIN entre as seguintes tabelas: "amigos" e "posts mais influentes de TODOS exceto eu"
	(
		-- Retorna tabela de posts mais influentes de TODOS os usuários exceto eu
		SELECT 
			pts.contador, 
			pts.idPost, 
			pts.login, 
			pts.login_postador 
		FROM 
			-- Retorna tabela amigos
			amigos
		JOIN -- JOIN entre as seguintes tabelas: "amigos" e "posts mais influentes de TODOS incluindo eu"
		(
			-- Retorna tabela de posts mais influentes de TODOS os usuários incluindo eu
			SELECT 
				coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, 
				coalesce(tb_curtir.idPost, tb_comentarios.idPost) AS idPost, 
				coalesce(tb_curtir.login, tb_comentarios.login) AS login, 
				coalesce(tb_curtir.login_postador, tb_comentarios.login_postador) AS login_postador  
			FROM 
			(
				-- Retorna número de curtições em TODOS os posts
				SELECT 
					COUNT(idPost) AS contador, 
					posts.id AS idPost, 
					posts.login AS login, 
					posts.login_postador AS login_postador 
				FROM 
					curtir 
				RIGHT JOIN 
					posts 
				ON 
					curtir.idPost = posts.id 
				GROUP BY 
					posts.id, 
					posts.login, 
					posts.login_postador
			) AS tb_curtir 
			FULL JOIN -- JOIN entre as seguintes tabelas: "número de curtições em TODOS os posts" e "número de comentários em TODOS os posts"
			(
				-- Retorna número de comentários em TODOS os posts
				SELECT 
					COUNT(idPost) AS contador, 
					posts.id AS idPost, 
					posts.login AS login, 
					posts.login_postador AS login_postador 
				FROM 
					comentarios 
				RIGHT JOIN 
					posts 
				ON 
					comentarios.idPost = posts.id 
				GROUP BY 
					posts.id, 
					posts.login, 
					posts.login_postador
			) AS tb_comentarios 
			ON 
				tb_curtir.idPost = tb_comentarios.idPost
		) AS pts 
		ON 
			pts.login_postador = amigos.seulogin 
		WHERE 
			( amigos.meulogin = 'alex' AND amigos.seulogin IS NOT NULL ) 
			OR 
			( pts.login = 'alex' AND pts.login_postador <> 'alex' )
		GROUP BY 
			pts.idPost, 
			pts.contador, 
			pts.login, 
			pts.login_postador 
	) AS pts2 
	ON 
		pts2.login = amigos.seulogin 
	WHERE 
		( amigos.meulogin = 'alex' AND amigos.seulogin IS NOT NULL ) 
		OR 
		( pts2.login = 'alex' AND pts2.login_postador <> 'alex' ) 
	GROUP BY 
		pts2.idPost, 
		pts2.contador
) AS rst  
ON 
	rst.idPost = posts.id 
WHERE
	posts.time >= '1000-01-01 00:00:00' 
	AND posts.time <= '3000-01-01 00:00:00' 
ORDER BY 
	posts.time::date DESC, rst.contador DESC
