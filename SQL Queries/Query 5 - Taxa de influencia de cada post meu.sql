
--
-- Query que retorna:  
-- * a média de influência de todos os meus posts
--

-- SELECT AVG(coalesce(rst.contador, 0)) AS contador FROM posts LEFT JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost FROM (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> 'alex'AND curtir.login <> posts.login_postador GROUP BY posts.login_postador, posts.id ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> 'alex'AND comentarios.login <> posts.login_postador GROUP BY posts.login_postador, posts.id ) AS tb_comentarios ON tb_curtir.idPost = tb_comentarios.idPost ) AS rst ON rst.idPost = posts.id WHERE posts.login_postador = 'alex'

-- SELECT AVG(coalesce(rst.contador, 0)) AS contador FROM posts LEFT JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost, coalesce(tb_comentarios.login, tb_curtir.login) AS login FROM (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> 'alex'AND curtir.login <> posts.login_postador AND posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'GROUP BY posts.login_postador, posts.id ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> 'alex'AND comentarios.login <> posts.login_postador AND posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'GROUP BY posts.login_postador, posts.id ) AS tb_comentarios ON tb_curtir.idPost = tb_comentarios.idPost ) AS rst ON rst.idPost = posts.id WHERE posts.login_postador = 'alex'AND posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'

-- SELECT posts.id, posts.login, posts.login_postador, coalesce(rst.contador, 0) AS contador FROM posts LEFT JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost, coalesce(tb_comentarios.login, tb_curtir.login) AS login FROM (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> 'alex'AND curtir.login <> posts.login_postador AND posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'GROUP BY posts.login_postador, posts.id ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> 'alex'AND comentarios.login <> posts.login_postador AND posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'GROUP BY posts.login_postador, posts.id ) AS tb_comentarios ON tb_curtir.idPost = tb_comentarios.idPost ) AS rst ON rst.idPost = posts.id WHERE posts.login_postador = 'alex'AND posts.time >= '1000-01-01 00:00:00'AND posts.time <= '3000-01-01 00:00:00'ORDER BY contador DESC

SELECT 
	AVG(coalesce(rst.contador, 0)) AS contador 
FROM 
	-- Retorna tabela posts
	posts 
LEFT JOIN -- LEFT JOIN entre as seguintes tabelas: "posts" e "TODOS os meus posts e suas respectivas taxas de influencia"
(
	-- Retorna tabela com TODOS os meus posts e suas respectivas taxas de influencia
	SELECT 
		coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, 
		coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost
	FROM 
	(
		-- Retorna tabela com número de curtições recebidos em cada post
		SELECT 
			COUNT(idPost) AS contador, 
			posts.login_postador AS login, 
			posts.id AS idPost 
		FROM 
			curtir 
		JOIN 
			posts 
		ON 
			curtir.idPost = posts.id 
		WHERE 
			curtir.login <> 'alex' 
			AND curtir.login <> posts.login_postador 
		GROUP BY 
			posts.login_postador, 
			posts.id
	) AS tb_curtir 
	FULL JOIN -- FULL JOIN entre as seguintes tabelas: "número de curtições recebidos em cada post" e "número de comentários recebidos em cada post"
	(
		-- Retorna tabela com número de comentários recebidos em cada post
		SELECT 
			COUNT(idPost) AS contador, 
			posts.login_postador AS login, 
			posts.id AS idPost 
		FROM 
			comentarios 
		JOIN 
			posts 
		ON 
			comentarios.idPost = posts.id 
		WHERE 
			comentarios.login <> 'alex' 
			AND comentarios.login <> posts.login_postador 
		GROUP BY 
			posts.login_postador, 
			posts.id
	) AS tb_comentarios 
	ON 
		tb_curtir.idPost = tb_comentarios.idPost
) AS rst
ON 
	rst.idPost = posts.id 
WHERE 
	posts.login_postador = 'alex'


--
-- Query que retorna:
-- * a média de influência dos meus posts no período
--

SELECT 
	AVG(coalesce(rst.contador, 0)) AS contador 
FROM 
	-- Retorna tabela posts
	posts 
LEFT JOIN -- LEFT JOIN entre as seguintes tabelas: "posts" e "meus posts num certo período e suas respectivas taxas de influencia"
(
	-- Retorna tabela com os meus posts num certo período e suas respectivas taxas de influencia
	SELECT 
		coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, 
		coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost, 
		coalesce(tb_comentarios.login, tb_curtir.login) AS login 
	FROM 
	(
		-- Retorna tabela com número de curtições recebidos em cada post de um período
		SELECT 
			COUNT(idPost) AS contador, 
			posts.login_postador AS login, 
			posts.id AS idPost  
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
			posts.login_postador, 
			posts.id
	) AS tb_curtir 
	FULL JOIN -- FULL JOIN entre as seguintes tabelas: "número de curtições recebidos em cada post de um período" e "número de comentários recebidos em cada post de um período"
	(
		-- Retorna tabela com número de comentários recebidos em cada post de um período
		SELECT 
			COUNT(idPost) AS contador, 
			posts.login_postador AS login, 
			posts.id AS idPost 
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
			posts.login_postador, 
			posts.id
	) AS tb_comentarios 
	ON 
		tb_curtir.idPost = tb_comentarios.idPost
) AS rst 
ON 
	rst.idPost = posts.id 
WHERE 
	posts.login_postador = 'alex' 
	AND posts.time >= '1000-01-01 00:00:00' 
	AND posts.time <= '3000-01-01 00:00:00'

-- 
-- Query que retorna:
-- * a taxa de influência de cada post meu no período, em ordem decrescente de influência, 
-- 

SELECT 
	posts.id, 
	posts.login, 
	posts.login_postador, 
	coalesce(rst.contador, 0) AS contador 
FROM 
	-- Retorna tabela posts
	posts 
LEFT JOIN -- LEFT JOIN entre as seguintes tabelas: "posts" e "meus posts num certo período e suas respectivas taxas de influencia"
(
	-- Retorna tabela com os meus posts num certo período e suas respectivas taxas de influencia
	SELECT 
		coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, 
		coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost, 
		coalesce(tb_comentarios.login, tb_curtir.login) AS login 
	FROM 
	(
		-- Retorna tabela com número de curtições recebidos em cada post de um período
		SELECT 
			COUNT(idPost) AS contador, 
			posts.login_postador AS login, 
			posts.id AS idPost  
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
			posts.login_postador, 
			posts.id
	) AS tb_curtir 
	FULL JOIN -- FULL JOIN entre as seguintes tabelas: "número de curtições recebidos em cada post de um período" e "número de comentários recebidos em cada post de um período"
	(
		-- Retorna tabela com número de comentários recebidos em cada post de um período
		SELECT 
			COUNT(idPost) AS contador, 
			posts.login_postador AS login, 
			posts.id AS idPost 
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
			posts.login_postador, 
			posts.id
	) AS tb_comentarios 
	ON 
		tb_curtir.idPost = tb_comentarios.idPost
) AS rst 
ON 
	rst.idPost = posts.id 
WHERE 
	posts.login_postador = 'alex' 
	AND posts.time >= '1000-01-01 00:00:00' 
	AND posts.time <= '3000-01-01 00:00:00' 
ORDER BY 
	contador DESC

