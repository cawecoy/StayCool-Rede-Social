-- 
-- Query que retorna posts que contenham certa palavra ofensiva dentro de um certo período de tempo especificado
-- Além disso, a consulta deve apresentar o nome do usuário postador e se ele é reincidente.
-- 

CREATE OR REPLACE FUNCTION verifica_conteudos_ofensivos(palavra text, data_inicio timestamp, data_fim timestamp, login_consultador text) 
RETURNS TABLE(
    reincidente boolean,
    id int,
    tempo timestamp,
    login varchar(255),
    login_postador varchar(255),
    conteudo varchar(255),
    nome varchar(255)
)
AS $conteudos_ofensivos$
    BEGIN
    	-- Uma tabela temporária
        CREATE TEMP TABLE TempTable(
            reincidente boolean,
            id int,
            tempo timestamp,
            login varchar(255),
            login_postador varchar(255),
            conteudo varchar(255),
            nome varchar(255)
        );

        -- Insere resultado da consulta abaixo na tabela temporária
        INSERT INTO
            TempTable
        -- A consulta abaixo retorna os posts meus e de meus amigos 
        -- que contenham uma certa palavra ofensivsa e em um certo período de tempo, 
        -- além de indicar se o postador do post é reincidente na tabela conteudos_ofensivos
        SELECT
          CASE -- Caso o postador já tenha registro na tabela conteudos_ofensivos, então ele é reincidente (= true)
            WHEN 
              cont_ofens.login_postador = posts_amigos_e_meus.login_postador 
            THEN 
              true 
            ELSE 
              false 
            END AS reincidente, 
          posts_amigos_e_meus.id AS id, 
          posts_amigos_e_meus.time AS time, 
          posts_amigos_e_meus.login AS login, 
          posts_amigos_e_meus.login_postador AS login_postador, 
          posts_amigos_e_meus.conteudo AS conteudo,
          usuarios.nome AS nome
        FROM 
          -- Retorna tabela de usuários
          usuarios
        RIGHT JOIN -- RIGHT JOIN entre as seguintes tabelas: "usuarios" e "posts meus e de meus amigos"
        (
        	-- Retorna tabela de posts meus e de meu amigos
            SELECT 
              posts.id AS id, 
              posts.time AS time, 
              posts.login AS login, 
              posts.login_postador AS login_postador, 
              posts.conteudo AS conteudo
            FROM 
              -- Retorna tabela de posts
              posts 
            JOIN -- JOIN entre as seguintes tabelas: "posts" e "login dos meus amigos e meu próprio login"
            (
              -- Retorna login dos meus amigos e meu próprio login
              SELECT 
                amigos.seulogin AS lgn 
              FROM 
                amigos 
              WHERE 
                amigos.meulogin = login_consultador 
              UNION -- UNE (acrescenta) meu próprio login a uma tabela contendo os logins dos meus amigos
              SELECT 
                login_consultador AS lgn
            ) AS amg 
            ON 
              posts.login_postador = amg.lgn
        ) AS posts_amigos_e_meus
        ON
          usuarios.login = posts_amigos_e_meus.login_postador
        LEFT JOIN -- LEFT JOIN entre as seguintes tabelas: "posts meus e de meus amigos", "logins de postadores de conteúdos intrusos registrados anteriormente" e "usuarios"
        (
          -- Retorna tabela contendo login dos postadores que já postaram posts 
          -- que foram registrados como posts contendo certo conteúdo ofensivo no passado
          SELECT 
            conteudos_ofensivos.login_postador 
          FROM 
            conteudos_ofensivos 
          GROUP BY 
            conteudos_ofensivos.login_postador
        ) AS cont_ofens 
        ON 
          cont_ofens.login_postador = posts_amigos_e_meus.login_postador 
        WHERE 
          posts_amigos_e_meus.conteudo LIKE palavra
          AND posts_amigos_e_meus.time >= data_inicio
          AND posts_amigos_e_meus.time <= data_fim;

        -- Insere na tabela conteudos_ofensivos o resultado da consulta, que esta na tabela temporária (acima)
        INSERT INTO conteudos_ofensivos SELECT * FROM TempTable;

        -- Retorna resultado, que está na tabela temporária
        RETURN QUERY SELECT * FROM TempTable;
    END;
$conteudos_ofensivos$ LANGUAGE plpgsql;

-- 
-- A seguinte query registra na tabela 'conteudos_ofensivos' todos os posts de amigos e meus
-- realizados num certo perído e que contém a palavra ofensiva 'bife'.
-- Além disso ela retorna o resultado (os posts realizados num certo período e que contém 'bife').
-- 

SELECT * FROM verifica_conteudos_ofensivos('%bife%', '1000-01-01 00:00:00', '3000-01-01 00:00:00', 'alex');

-- 
-- Query para exibir a tabela completa de conteudos_ofensivos que foram consultados e registrados no passado
-- Observação: são exibidas apenas os conteúdos ofensivos que estavam em posts meus e de meus atuais amigos
-- 

SELECT 
	conteudos_ofensivos.reincidente, 
	conteudos_ofensivos.id, 
	conteudos_ofensivos.time, 
	conteudos_ofensivos.login, 
	conteudos_ofensivos.login_postador, 
	conteudos_ofensivos.conteudo, 
	conteudos_ofensivos.nome 
FROM 
	-- Retorna tabela de conteúdos ofensivos
	conteudos_ofensivos 
JOIN -- JOIN entre as seguintes tabelas: "conteúdos ofensivos" e "meu login e login dos meus amigos"
(
	-- Retorna tabela contendo meu login e login dos meus amigos
	SELECT 
		amigos.seulogin AS lgn 
	FROM 
		amigos 
	WHERE 
		amigos.meulogin = 'alex' 
	UNION 
	SELECT 
		'alex' AS lgn 
) AS amg 
ON 
	conteudos_ofensivos.login_postador = amg.lgn
ORDER BY
	conteudos_ofensivos.time DESC