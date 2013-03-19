-- 
-- Função que cria uma linha na tabela posts_log para uma certa operação realizada na tabela posts
-- 

CREATE OR REPLACE FUNCTION process_posts_log() RETURNS TRIGGER AS $posts_log$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO posts_log SELECT 'D', now(), user, OLD.*;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO posts_log SELECT 'U', now(), user, NEW.*;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO posts_log SELECT 'I', now(), user, NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$posts_log$ LANGUAGE plpgsql;

-- 
-- Trigger que associa efetivamente a função acima com a tabela posts,
-- garantindo que a cada operação nesta tabela a função acima será chamada em tempo real (como um gatilho = trigger)
-- 

CREATE TRIGGER posts_log
AFTER INSERT OR UPDATE OR DELETE ON posts
    FOR EACH ROW EXECUTE PROCEDURE process_posts_log();

-- 
-- Query para exibir a tabela completa de log de histórico atualizações de posts (meus e de meus amigos)
-- 

SELECT 
	posts_log.id,
	posts_log.operation, 
	posts_log.idPostAtual,
	posts_log.time,
	posts_log.login,
	posts_log.login_postador,
	posts_log.conteudo
FROM 
	-- Retorna tabela de histórico de atualizações de posts
	posts_log 
JOIN -- JOIN entre as seguintes tabelas: "histórico de atualizações de posts" e "meu login e login dos meus amigos"
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
	posts_log.login_postador = amg.lgn
ORDER BY
	posts_log.time DESC