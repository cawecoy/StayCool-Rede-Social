
CREATE TABLE usuarios
(
  nome varchar(255),
  login varchar(255),
  senha varchar(255),
  sobre varchar(255),
  PRIMARY KEY (login)
);

CREATE TABLE grupos
(
  login varchar(255),
  grupo varchar(255),
  PRIMARY KEY(login, grupo),
  FOREIGN KEY (login) REFERENCES usuarios(login)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE amigos
(
  meulogin varchar(255),
  seulogin varchar(255),
  PRIMARY KEY (meulogin, seulogin),
  CONSTRAINT fk_usuario FOREIGN KEY (meulogin) 
      REFERENCES usuarios (login)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  CONSTRAINT fk_amigo FOREIGN KEY (seulogin) 
      REFERENCES usuarios (login)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE amigosgrupos
(
  meulogin varchar(255),
  seulogin varchar(255),
  grupo varchar(255),
  PRIMARY KEY(meulogin, seulogin, grupo),
  FOREIGN KEY (meulogin, seulogin) REFERENCES amigos(meulogin, seulogin)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (meulogin, grupo) REFERENCES grupos(login, grupo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE imagens
(
  login varchar(255),
  imagem bytea,
  PRIMARY KEY (login),
  FOREIGN KEY (login) REFERENCES usuarios(login)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE posts
(
  id SERIAL PRIMARY KEY,
  time timestamp DEFAULT NOW(),
  login varchar(255),
  login_postador varchar(255),
  conteudo varchar(255),
  imagem bytea DEFAULT NULL,
  FOREIGN KEY (login) REFERENCES usuarios(login)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (login_postador) REFERENCES usuarios(login)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE comentarios
(
  id SERIAL PRIMARY KEY,
  time timestamp DEFAULT NOW(),
  login varchar(255),
  idPost int,
  comentario varchar(255),
  FOREIGN KEY (login) REFERENCES usuarios(login)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (idPost) REFERENCES posts(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE curtir
(
  id SERIAL,
  idPost int,
  time timestamp DEFAULT NOW(),
  login varchar(255),
  PRIMARY KEY (id, login),
  FOREIGN KEY (login) REFERENCES usuarios(login)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (idPost) REFERENCES posts(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE log_ofensivo
(
  reincidente boolean,
  idPost int,
  time timestamp,
  login varchar(255),
  login_postador varchar(255),
  conteudo varchar(255),
  nome varchar(255),
  id SERIAL,
  PRIMARY KEY (id),
  FOREIGN KEY (idPost) REFERENCES posts(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE log_posts
(
  operation char(1),
  stamp timestamp,
  userid text,
  idPostAtual int,
  time timestamp,
  login varchar(255),
  login_postador varchar(255),
  conteudo varchar(255),
  imagem bytea,
  id SERIAL, 
  PRIMARY KEY (id)
);

CREATE OR REPLACE FUNCTION log_posts_trigger() RETURNS TRIGGER AS $log_posts$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO log_posts SELECT 'D', now(), user, OLD.*;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO log_posts SELECT 'U', now(), user, NEW.*;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO log_posts SELECT 'I', now(), user, NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$log_posts$ LANGUAGE plpgsql;

CREATE TRIGGER log_posts
AFTER INSERT OR UPDATE OR DELETE ON posts
    FOR EACH ROW EXECUTE PROCEDURE log_posts_trigger();

CREATE OR REPLACE FUNCTION gera_log_ofensivo(palavra varchar(255), data_inicio timestamp, data_fim timestamp) 
RETURNS void AS $$
    BEGIN
      INSERT INTO log_ofensivo
        SELECT 
          CASE 
            WHEN 
              cont_ofens.login_postador = posts.login_postador 
            THEN true 
            ELSE false 
            END AS reincidente, 
          posts.id AS id, 
          posts.time AS time, 
          posts.login AS login, 
          posts.login_postador AS login_postador, 
          posts.conteudo AS conteudo,
          usuarios.nome AS nome 
        FROM 
          usuarios RIGHT JOIN posts 
        ON usuarios.login = posts.login_postador
        LEFT JOIN 
        (
          SELECT log_ofensivo.login_postador 
          FROM log_ofensivo
          GROUP BY log_ofensivo.login_postador
        ) AS cont_ofens 
        ON 
          cont_ofens.login_postador = posts.login_postador 
        WHERE 
          posts.conteudo LIKE palavra
          AND posts.time >= data_inicio
          AND posts.time <= data_fim;
    END;
$$ LANGUAGE plpgsql;

INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Dante Aleghieri', 'dante', 'dante', 'a vida é uma comédia');
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Renno Descartes', 'renno', 'renno', 'Cogito, Ergo Sumo');
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Fred Nieztche', 'fred', 'fred', 'Quando você olha o abismo, ele tambem olha você');
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Fiodor Dostoievsky', 'fiodor', 'fiodor', 'Crime e Castigo');
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('George Martin', 'george', 'george', 'Eu vou matar seu personagem favorito');
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Legolas Greenleaf', 'legolas', 'legolas', 'Im pretty :D');
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Frodo Beggins', 'frodo', 'frodo', 'É só um anel, cara.');
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Sauron', 'sauron', 'sauron', 'I SEE YOU o.o');
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Luiz Villela', 'luiz', 'luiz', 'eu quero passar em BD!' );
INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('Hodor', 'hodor', 'hodor', 'Hodor? Hodor!!');

INSERT INTO usuarios(nome, login, senha, sobre) VALUES ('J. R. R. Tolkien', 'tolkien', 'tolkien', 'Eu escrevo paragrafos muito,muito longos :)');

INSERT INTO grupos(login, grupo) VALUES ('frodo', 'SDA');
INSERT INTO grupos(login, grupo) VALUES ('hodor', 'Game of Thrones');
INSERT INTO grupos(login, grupo) VALUES ('george', 'Kill list');
INSERT INTO grupos(login, grupo) VALUES ('sauron', 'Cade o anel?');
INSERT INTO grupos(login, grupo) VALUES ('fred', 'Pessimistas');
INSERT INTO grupos(login, grupo) VALUES ('legolas', 'Cabelos');
INSERT INTO grupos(login, grupo) VALUES ('renno', 'Pensadores');
INSERT INTO grupos(login, grupo) VALUES ('dante', 'Peças');
INSERT INTO grupos(login, grupo) VALUES ('fiodor', 'Crimes');

INSERT INTO amigos(meulogin, seulogin) VALUES ('frodo', 'dante');
INSERT INTO amigos(meulogin, seulogin) VALUES ('dante', 'frodo');

INSERT INTO amigos(meulogin, seulogin) VALUES ('renno', 'fred');
INSERT INTO amigos(meulogin, seulogin) VALUES ('fred', 'renno');

INSERT INTO amigos(meulogin, seulogin) VALUES ('luiz', 'frodo');
INSERT INTO amigos(meulogin, seulogin) VALUES ('frodo', 'luiz');

INSERT INTO amigos(meulogin, seulogin) VALUES ('frodo', 'sauron');
INSERT INTO amigos(meulogin, seulogin) VALUES ('sauron', 'frodo');

INSERT INTO amigos(meulogin, seulogin) VALUES ('hodor', 'tolkien');
INSERT INTO amigos(meulogin, seulogin) VALUES ('tolkien', 'hodor');

INSERT INTO amigos(meulogin, seulogin) VALUES ('legolas', 'frodo');
INSERT INTO amigos(meulogin, seulogin) VALUES ('frodo', 'legolas');

INSERT INTO amigos(meulogin, seulogin) VALUES ('dante', 'luiz');
INSERT INTO amigos(meulogin, seulogin) VALUES ('luiz', 'dante');

INSERT INTO amigos(meulogin, seulogin) VALUES ('luiz', 'sauron');
INSERT INTO amigos(meulogin, seulogin) VALUES ('sauron', 'luiz');

INSERT INTO amigos(meulogin, seulogin) VALUES ('legolas', 'fred');
INSERT INTO amigos(meulogin, seulogin) VALUES ('fred', 'legolas');

INSERT INTO amigos(meulogin, seulogin) VALUES ('frodo', 'tolkien');
INSERT INTO amigos(meulogin, seulogin) VALUES ('tolkien', 'frodo');

INSERT INTO amigos(meulogin, seulogin) VALUES ('tolkien', 'sauron');
INSERT INTO amigos(meulogin, seulogin) VALUES ('sauron', 'tolkien');

INSERT INTO amigos(meulogin, seulogin) VALUES ('hodor', 'sauron');
INSERT INTO amigos(meulogin, seulogin) VALUES ('sauron', 'hodor');

INSERT INTO amigos(meulogin, seulogin) VALUES ('george', 'sauron');
INSERT INTO amigos(meulogin, seulogin) VALUES ('sauron', 'george');

INSERT INTO amigos(meulogin, seulogin) VALUES ('george', 'tolkien');
INSERT INTO amigos(meulogin, seulogin) VALUES ('tolkien', 'george');

INSERT INTO amigos(meulogin, seulogin) VALUES ('george', 'legolas');
INSERT INTO amigos(meulogin, seulogin) VALUES ('legolas', 'george');

INSERT INTO amigos(meulogin, seulogin) VALUES ('george', 'hodor');
INSERT INTO amigos(meulogin, seulogin) VALUES ('hodor', 'george');

INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('frodo', 'legolas', 'SDA');
INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('frodo', 'luiz', 'SDA');

INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('frodo', 'tolkien', 'SDA');
INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('sauron', 'luiz', 'Cade o anel?');

INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('sauron', 'frodo', 'Cade o anel?');
INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('sauron', 'tolkien', 'Cade o anel?');

INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('sauron', 'hodor', 'Cade o anel?');

INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('george', 'hodor', 'Kill list');
INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('george', 'tolkien', 'Kill list');

INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('george', 'legolas', 'Kill list');
INSERT INTO amigosgrupos(meulogin, seulogin, grupo) VALUES ('george', 'sauron', 'Kill list');


INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-08 12:14:00', 'frodo', 'tolkien', 'eu escrevi voce'); 
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-12 12:14:00', 'tolkien', 'frodo', 'papai!');
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-10 12:14:00', 'frodo', 'sauron', 'devolve o anel, cara.');
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-11 12:14:00', 'hodor', 'george', 'hodor hodor hodor!');
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-09 12:14:00', 'sauron', 'luiz', 'i see YOU! HA!');

INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-12 12:14:00', 'tolkien', 'hodor', 'HODOR!');
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-08 12:14:00', 'luiz', 'sauron', 'I see you!');
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-09 12:14:00', 'hodor', 'george', 'lol');
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-10 12:14:00', 'george', 'luiz', 'serio, pq vc matou meu personagem favorito, cara?De novo?');
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-11 12:14:00', 'luiz', 'george', 'para de reclamar, rapaz'); 

INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-09 12:14:00', 'tolkien', 'luiz', 'Hey'); 
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-12 12:14:00', 'luiz', 'tolkien', 'forever alone'); 
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-08 12:14:00', 'dante', 'dante', 'aff'); 
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-09 12:14:00', 'fred', 'fred', '....'); 
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-10 12:14:00', 'luiz', 'luiz', 'cara que rede social mais legal a sua, voce devia tirar dez'); 

INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-11 12:14:00', 'frodo', 'sauron', 'serio, meu anel.'); 
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-12 12:14:00', 'frodo', 'sauron', 'babaca -_-'); 
INSERT INTO posts(time, login, login_postador, conteudo) VALUES ('2012-10-10 12:14:00', 'sauron', 'frodo', 'Nein!'); 

-- SELECT gera_log_ofensivo('%fdp%', '1000-01-01 00:00:00', '3000-01-01 00:00:00');
-- SELECT * FROM log_ofensivo;
-- SELECT * FROM log_posts;