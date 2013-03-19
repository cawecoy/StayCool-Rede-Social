
--
-- Query que retorna o comportamento de um amigo
--

-- SELECT rst.nome, MAX(rst.npost) AS npost, MAX(rst.ncomentario) AS ncomentario, MAX(rst.ncurtir) AS ncurtir, MAX(rst.nmeupostcomentario) AS nmeupostcomentario, MAX(rst.nmeupostcurtir) AS nmeupostcurtir, rst.time FROM (SELECT usr.nome AS nome, coalesce(p.contador, 0) AS npost, coalesce(c.contador, 0) AS ncomentario, coalesce(l.contador, 0) AS ncurtir, coalesce(mc.contador, 0) AS nmeupostcomentario, coalesce(ml.contador, 0) AS nmeupostcurtir, coalesce(p.time, coalesce(c.time, coalesce(l.time, coalesce(mc.time, ml.time)))) AS time FROM (SELECT COUNT(*) AS contador, posts.time::date AS time FROM posts WHERE login_postador = 'cida'GROUP BY posts.time::date ) AS p FULL JOIN (SELECT COUNT(*) AS contador, comentarios.time::date AS time FROM comentarios WHERE login = 'cida'GROUP BY comentarios.time::date ) AS c ON p.time = c.time FULL JOIN (SELECT COUNT(*) AS contador, curtir.time::date AS time FROM curtir WHERE login = 'cida'GROUP BY curtir.time::date ) AS l ON p.time = l.time FULL JOIN (SELECT COUNT(*) AS contador, comentarios.time::date AS time FROM posts FULL JOIN comentarios ON posts.id = comentarios.idPost WHERE posts.login_postador = 'alex'AND comentarios.login = 'cida'GROUP BY comentarios.time::date ) AS mc ON p.time = mc.time FULL JOIN (SELECT COUNT(*) AS contador, curtir.time::date AS time FROM posts FULL JOIN curtir ON posts.id = curtir.idPost WHERE posts.login_postador = 'alex'AND curtir.login = 'cida'GROUP BY curtir.time::date ) AS ml ON p.time = ml.time, (SELECT nome FROM usuarios WHERE login = 'cida')AS usr ) AS rst WHERE rst.time >= '1000-01-01 00:00:00'AND rst.time <=  '3000-01-01 00:00:00'GROUP BY rst.time, rst.nome ORDER BY rst.time

SELECT 
	rst.nome, 
	MAX(rst.npost) AS npost, 
	MAX(rst.ncomentario) AS ncomentario, 
	MAX(rst.ncurtir) AS ncurtir, 
	MAX(rst.nmeupostcomentario) AS nmeupostcomentario, 
	MAX(rst.nmeupostcurtir) AS nmeupostcurtir, 
	rst.time 
FROM 
(
	-- Retorna comportamento de um amigo
	SELECT 
		usr.nome AS nome, 
		coalesce(p.contador, 0) AS npost, 
		coalesce(c.contador, 0) AS ncomentario, 
		coalesce(l.contador, 0) AS ncurtir, 
		coalesce(mc.contador, 0) AS nmeupostcomentario, 
		coalesce(ml.contador, 0) AS nmeupostcurtir, 
		coalesce(p.time, coalesce(c.time, coalesce(l.time, coalesce(mc.time, ml.time)))) AS time 
	FROM 
	(
		-- Retorna número de publicações (posts) de um amigo
		SELECT 
			COUNT(*) AS contador, 
			posts.time::date AS time -- Neste SELECT, posts.time é selecionado no formato "date", que exibe apenas datas sem as horas (ao contrário de "timestamp")
		FROM 
			posts 
		WHERE 
			login_postador = 'cida' 
		GROUP BY 
			posts.time::date
	) AS p 
	FULL JOIN -- FULL JOIN entre as seguintes tabelas: "número de publicações (posts) de um amigo" e "número de comentários de um amigo"
	(
		-- Retorna número de comentários de um amigo
		SELECT 
			COUNT(*) AS contador, 
			comentarios.time::date AS time 
		FROM 
			comentarios 
		WHERE 
			login = 'cida' 
		GROUP BY 
			comentarios.time::date
	) AS c 
	ON 
		p.time = c.time 
	FULL JOIN -- FULL JOIN entre as seguintes tabelas: "número de publicações (posts) de um amigo" e "Retorna número de curtições de um amigo", aninhado com "número de comentários de um amigo"
	(
		-- Retorna número de curtições de um amigo
		SELECT 
			COUNT(*) AS contador, 
			curtir.time::date AS time 
		FROM 
			curtir 
		WHERE 
			login = 'cida' 
		GROUP BY 
			curtir.time::date
	) AS l 
	ON 
		p.time = l.time 
	FULL JOIN -- FULL JOIN entre as seguintes tabelas: "número de publicações (posts) de um amigo" e "Retorna número de comentários de um amigo em meus posts", aninhado com "número de comentários de um amigo" e "Retorna número de curtições de um amigo"
	(
		-- Retorna número de comentários de um amigo em meus posts
		SELECT 
			COUNT(*) AS contador, 
			comentarios.time::date AS time 
		FROM 
			posts 
		FULL JOIN 
			comentarios 
		ON 
			posts.id = comentarios.idPost 
		WHERE 
			posts.login_postador = 'alex' 
			AND comentarios.login = 'cida' 
		GROUP BY 
			comentarios.time::date
	) AS mc 
	ON 
		p.time = mc.time 
	FULL JOIN -- FULL JOIN entre as seguintes tabelas: "número de publicações (posts) de um amigo" e "número de curtições de um amigo em meus posts", aninhado com "número de comentários de um amigo", "Retorna número de curtições de um amigo" e "Retorna número de comentários de um amigo em meus posts"
	(
		-- Retorna número de curtições de um amigo em meus posts
		SELECT 
			COUNT(*) AS contador, 
			curtir.time::date AS time 
		FROM 
			posts 
		FULL JOIN 
			curtir 
		ON 
			posts.id = curtir.idPost 
		WHERE 
			posts.login_postador = 'alex' 
			AND curtir.login = 'cida' 
		GROUP BY 
			curtir.time::date
	) AS ml 
	ON 
		p.time = ml.time,
	-- Retorna nome do amigo analizado 
	(SELECT 
		nome 
	FROM 
		usuarios 
	WHERE 
		login = 'cida' 
	)AS usr
) AS rst 
WHERE 
	rst.time >= '1000-01-01 00:00:00' 
	AND rst.time <=  '3000-01-01 00:00:00' 
GROUP BY 
	rst.time, 
	rst.nome 
ORDER BY 
	rst.time
