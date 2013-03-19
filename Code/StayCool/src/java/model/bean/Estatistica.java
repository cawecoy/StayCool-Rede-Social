/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package model.bean;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import javax.imageio.ImageIO;

/**
 *
 * @author cawecoyrodrigues
 */
public class Estatistica {
    private String nome = null;
    private String login = null;
    private String grupo = null;
    private int contador;
    
    private float media;
    
    private int npost;
    private int ncurtir;
    private int ncomentario;
    private int nmeupostcurtir;
    private int nmeupostcomentario;
    private String time;
    
    
    public Estatistica(){
    }
    
    public Estatistica(float media){
        this.media = media;
    }
    
    public Estatistica(String nome, String login, int npost, int ncurtir, int ncomentario, int nmeupostcurtir, int nmeupostcomentario, String time){
        this.nome = nome;
        this.login = login;
        this.npost = npost;
        this.ncurtir = ncurtir;
        this.ncomentario = ncomentario;
        this.nmeupostcurtir = nmeupostcurtir;
        this.nmeupostcomentario = nmeupostcomentario;
        this.time = time;
    }
    
    public Estatistica(String nome, String login, int contador){
        this.nome = nome;
        this.login = login;
        this.contador = contador;
    }
    
    public Estatistica(String nome, String login, String grupo, int contador){
        this.nome = nome;
        this.login = login;
        this.grupo = grupo;
        this.contador = contador;
    }
    
    //Opção: 1
    private ArrayList amigosPublicadores(Timestamp data_inicio, Timestamp data_fim, String meulogin) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        ArrayList l = new ArrayList();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT final.nome AS nome, final.login AS login, final.contador AS contador, coalesce(amigosgps.grupo, 'Amigos sem grupo') AS grupo FROM (SELECT * FROM amigosgrupos WHERE meulogin = '" + meulogin + "') AS amigosgps RIGHT JOIN (SELECT usuarios.nome AS nome, rst.login AS login, rst.contador AS contador FROM usuarios JOIN (SELECT resultado.login_postador AS login, resultado.contador AS contador FROM (SELECT seulogin FROM amigos WHERE meulogin = '" + meulogin + "') AS amgs RIGHT JOIN (SELECT login_postador, COUNT(login_postador) AS contador FROM posts WHERE login_postador <> '" + meulogin + "'AND time >= '" + data_inicio + "'AND time <= '" + data_fim + "'GROUP BY login_postador ) AS resultado ON amgs.seulogin = resultado.login_postador WHERE amgs.seulogin is not null GROUP BY resultado.login_postador, resultado.contador ) AS rst ON rst.login = usuarios.login ) AS final ON amigosgps.seulogin = final.login ORDER BY amigosgps.grupo, final.contador DESC");
            
            while(resultSetQuery.next()){
                l.add(new Estatistica (resultSetQuery.getString("nome"), resultSetQuery.getString("login"), resultSetQuery.getString("grupo"), resultSetQuery.getInt("contador")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de amigos mais publicadores com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar lista de amigos mais publicadores.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return l;
    }
    
    //Opção: 2
    private ArrayList amigosInfluentes(Timestamp data_inicio, Timestamp data_fim, String meulogin) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        ArrayList l = new ArrayList();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT usuarios.nome, rst.login, rst.contador FROM usuarios JOIN (SELECT pts.login AS login, pts.contador AS contador FROM amigos JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_curtir.login, tb_comentarios.login) AS login FROM (SELECT COUNT(idPost) AS contador, login_postador AS login FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> '" + meulogin + "'AND curtir.login <> posts.login_postador AND posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'GROUP BY login_postador ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, login_postador AS login FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> '" + meulogin + "'AND comentarios.login <> posts.login_postador AND posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'GROUP BY login_postador ) AS tb_comentarios ON tb_curtir.login = tb_comentarios.login ) AS pts ON pts.login = amigos.seulogin WHERE amigos.meulogin = '" + meulogin + "'AND amigos.seulogin IS NOT NULL ORDER BY pts.contador DESC LIMIT 10 ) AS rst ON rst.login = usuarios.login");
            
            while(resultSetQuery.next()){
                l.add(new Estatistica (resultSetQuery.getString("nome"), resultSetQuery.getString("login"), resultSetQuery.getInt("contador")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de amigos mais influentes com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar lista de amigos mais influentes.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return l;
    }
    
    //Opção: 3
    private ArrayList usuariosInfluentes(Timestamp data_inicio, Timestamp data_fim, String meulogin) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        ArrayList l = new ArrayList();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT usuarios.nome, rst.login, rst.contador FROM usuarios JOIN (SELECT pts.login AS login, pts.contador AS contador FROM (SELECT seulogin AS login FROM amigos WHERE meulogin = '" + meulogin + "') AS amg RIGHT JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_curtir.login, tb_comentarios.login) AS login FROM (SELECT COUNT(idPost) AS contador, login_postador AS login FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> '" + meulogin + "'AND curtir.login <> posts.login_postador AND curtir.time >= '" + data_inicio + "'AND curtir.time <= '" + data_fim + "'GROUP BY login_postador ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, login_postador AS login FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> '" + meulogin + "'AND comentarios.login <> posts.login_postador AND comentarios.time >= '" + data_inicio + "'AND comentarios.time <= '" + data_fim + "'GROUP BY login_postador ) AS tb_comentarios ON tb_curtir.login = tb_comentarios.login ) AS pts ON pts.login = amg.login WHERE amg.login IS NULL AND pts.login <> '" + meulogin + "'GROUP BY pts.login, pts.contador ORDER BY contador DESC LIMIT 10 ) AS rst ON rst.login = usuarios.login");
            
            while(resultSetQuery.next()){
                l.add(new Estatistica (resultSetQuery.getString("nome"), resultSetQuery.getString("login"), resultSetQuery.getInt("contador")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de amigos mais influentes com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar lista de amigos mais influentes.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return l;
    }
    
    //Opção: 4
    private ArrayList postsInfluentesAmigos(Timestamp data_inicio, Timestamp data_fim, String meulogin, String path) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        ArrayList l = new ArrayList();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");
            
            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT posts.id, posts.login, posts.login_postador, posts.time, rst.contador FROM posts JOIN (SELECT pts2.contador, pts2.idPost FROM amigos JOIN (SELECT pts.contador, pts.idPost, pts.login, pts.login_postador FROM amigos JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_curtir.idPost, tb_comentarios.idPost) AS idPost, coalesce(tb_curtir.login, tb_comentarios.login) AS login, coalesce(tb_curtir.login_postador, tb_comentarios.login_postador) AS login_postador FROM (SELECT COUNT(idPost) AS contador, posts.id AS idPost, posts.login AS login, posts.login_postador AS login_postador FROM curtir RIGHT JOIN posts ON curtir.idPost = posts.id GROUP BY posts.id, posts.login, posts.login_postador ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, posts.id AS idPost, posts.login AS login, posts.login_postador AS login_postador FROM comentarios RIGHT JOIN posts ON comentarios.idPost = posts.id GROUP BY posts.id, posts.login, posts.login_postador ) AS tb_comentarios ON tb_curtir.idPost = tb_comentarios.idPost ) AS pts ON pts.login_postador = amigos.seulogin WHERE ( amigos.meulogin = '" + meulogin + "' AND amigos.seulogin IS NOT NULL ) OR ( pts.login = '" + meulogin + "' AND pts.login_postador <> '" + meulogin + "' ) GROUP BY pts.idPost, pts.contador, pts.login, pts.login_postador ) AS pts2 ON pts2.login = amigos.seulogin WHERE ( amigos.meulogin = '" + meulogin + "' AND amigos.seulogin IS NOT NULL ) OR ( pts2.login = '" + meulogin + "' AND pts2.login_postador <> '" + meulogin + "' ) GROUP BY pts2.idPost, pts2.contador ) AS rst ON rst.idPost = posts.id WHERE posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'ORDER BY posts.time::date DESC, rst.contador DESC");
            
            while(resultSetQuery.next()){;
                l.add(new Post(resultSetQuery.getInt("id"), resultSetQuery.getString("login"), resultSetQuery.getString("login_postador"), resultSetQuery.getInt("contador"), resultSetQuery.getTimestamp("time")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de posts mais influentes com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar lista de posts mais influentes.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return l;
    }
    
    //Opção: 5 - média de influencia de todos os meus posts
    private ArrayList mediaInfluenciaMeusPosts(String meulogin, ArrayList l) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT AVG(coalesce(rst.contador, 0)) AS contador FROM posts LEFT JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost FROM (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> '" + meulogin + "'AND curtir.login <> posts.login_postador GROUP BY posts.login_postador, posts.id ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> '" + meulogin + "'AND comentarios.login <> posts.login_postador GROUP BY posts.login_postador, posts.id ) AS tb_comentarios ON tb_curtir.idPost = tb_comentarios.idPost ) AS rst ON rst.idPost = posts.id WHERE posts.login_postador = '" + meulogin + "'");
            
            resultSetQuery.next();
            
            l.add(resultSetQuery.getFloat("contador"));
            
            System.out.println("");
            System.out.println("Carregada média de influencias de todos os meus posts com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar média de influencias de todos os meus posts.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return l;
    }
    
    //Opção: 5 - média de influencia dos meus posts no período
    private ArrayList mediaInfluenciaMeusPostsPeriodo(String meulogin, Timestamp data_inicio, Timestamp data_fim, ArrayList l) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT AVG(coalesce(rst.contador, 0)) AS contador FROM posts LEFT JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost, coalesce(tb_comentarios.login, tb_curtir.login) AS login FROM (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> '" + meulogin + "'AND curtir.login <> posts.login_postador AND posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'GROUP BY posts.login_postador, posts.id ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> '" + meulogin + "'AND comentarios.login <> posts.login_postador AND posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'GROUP BY posts.login_postador, posts.id ) AS tb_comentarios ON tb_curtir.idPost = tb_comentarios.idPost ) AS rst ON rst.idPost = posts.id WHERE posts.login_postador = '" + meulogin + "'AND posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'");
            
            resultSetQuery.next();
            
            l.add(resultSetQuery.getFloat("contador"));
            
            System.out.println("");
            System.out.println("Carregada média de influencias dos meus posts num período com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar média de influencias dos meus posts num período.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return l;
    }
    
    //Opção: 5 - taxa de influencia dos meus posts no período
    private ArrayList taxaInfluenciaMeusPosts(Timestamp data_inicio, Timestamp data_fim, String meulogin, String path, ArrayList l) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT posts.id, posts.login, posts.login_postador, coalesce(rst.contador, 0) AS contador FROM posts LEFT JOIN (SELECT coalesce(tb_curtir.contador, 0) + ( coalesce(tb_comentarios.contador, 0) * 5 ) AS contador, coalesce(tb_comentarios.idPost, tb_curtir.idPost) AS idPost, coalesce(tb_comentarios.login, tb_curtir.login) AS login FROM (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM curtir JOIN posts ON curtir.idPost = posts.id WHERE curtir.login <> '" + meulogin + "'AND curtir.login <> posts.login_postador AND posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'GROUP BY posts.login_postador, posts.id ) AS tb_curtir FULL JOIN (SELECT COUNT(idPost) AS contador, posts.login_postador AS login, posts.id AS idPost FROM comentarios JOIN posts ON comentarios.idPost = posts.id WHERE comentarios.login <> '" + meulogin + "'AND comentarios.login <> posts.login_postador AND posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'GROUP BY posts.login_postador, posts.id ) AS tb_comentarios ON tb_curtir.idPost = tb_comentarios.idPost ) AS rst ON rst.idPost = posts.id WHERE posts.login_postador = '" + meulogin + "'AND posts.time >= '" + data_inicio + "'AND posts.time <= '" + data_fim + "'ORDER BY contador DESC");
            
            while(resultSetQuery.next()){
                l.add(new Post(resultSetQuery.getInt("id"), resultSetQuery.getString("login"), resultSetQuery.getString("login_postador"), resultSetQuery.getInt("contador")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de posts meus e suas influencias com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar lista de posts meus e suas influencias.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return l;
    }
    
    //Opção: 5
    private ArrayList influenciaMeusPosts(Timestamp data_inicio, Timestamp data_fim, String meulogin, String path) throws SQLException{
        
        ArrayList l = new ArrayList();
        
        l = mediaInfluenciaMeusPosts(meulogin, l); //insere valor na primeira posicao da lista ArrayList l
        l = mediaInfluenciaMeusPostsPeriodo(meulogin, data_inicio, data_fim, l); //insere valor na segunda posicao da lista ArrayList l
        l = taxaInfluenciaMeusPosts(data_inicio, data_fim, meulogin, path, l); //insere valores da terceira posição da lista pra frente ArrayList l
        
        return l;
    }
    
    
    //Opção: 6
    private ArrayList comportamentoAmigo(Timestamp data_inicio, Timestamp data_fim, String meulogin, String login_amigo) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        ArrayList l = new ArrayList();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT rst.nome, MAX(rst.npost) AS npost, MAX(rst.ncomentario) AS ncomentario, MAX(rst.ncurtir) AS ncurtir, MAX(rst.nmeupostcomentario) AS nmeupostcomentario, MAX(rst.nmeupostcurtir) AS nmeupostcurtir, rst.time FROM (SELECT usr.nome AS nome, coalesce(p.contador, 0) AS npost, coalesce(c.contador, 0) AS ncomentario, coalesce(l.contador, 0) AS ncurtir, coalesce(mc.contador, 0) AS nmeupostcomentario, coalesce(ml.contador, 0) AS nmeupostcurtir, coalesce(p.time, coalesce(c.time, coalesce(l.time, coalesce(mc.time, ml.time)))) AS time FROM (SELECT COUNT(*) AS contador, posts.time::date AS time FROM posts WHERE login_postador = '" + login_amigo + "'GROUP BY posts.time::date ) AS p FULL JOIN (SELECT COUNT(*) AS contador, comentarios.time::date AS time FROM comentarios WHERE login = '" + login_amigo + "'GROUP BY comentarios.time::date ) AS c ON p.time = c.time FULL JOIN (SELECT COUNT(*) AS contador, curtir.time::date AS time FROM curtir WHERE login = '" + login_amigo + "'GROUP BY curtir.time::date ) AS l ON p.time = l.time FULL JOIN (SELECT COUNT(*) AS contador, comentarios.time::date AS time FROM posts FULL JOIN comentarios ON posts.id = comentarios.idPost WHERE posts.login_postador = '" + meulogin + "'AND comentarios.login = '" + login_amigo + "'GROUP BY comentarios.time::date ) AS mc ON p.time = mc.time FULL JOIN (SELECT COUNT(*) AS contador, curtir.time::date AS time FROM posts FULL JOIN curtir ON posts.id = curtir.idPost WHERE posts.login_postador = '" + meulogin + "'AND curtir.login = '" + login_amigo + "'GROUP BY curtir.time::date ) AS ml ON p.time = ml.time, (SELECT nome FROM usuarios WHERE login = '" + login_amigo + "')AS usr ) AS rst WHERE rst.time >= '" + data_inicio + "'AND rst.time <=  '" + data_fim + "'GROUP BY rst.time, rst.nome ORDER BY rst.time");
            
            while(resultSetQuery.next()){
                l.add(new Estatistica (resultSetQuery.getString("nome"), login_amigo, resultSetQuery.getInt("npost"), resultSetQuery.getInt("ncurtir"), resultSetQuery.getInt("ncomentario"), resultSetQuery.getInt("nmeupostcurtir"), resultSetQuery.getInt("nmeupostcomentario"), resultSetQuery.getString("time")));
            }
            
            System.out.println("");
            System.out.println("Carregado comportamento do amigo com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar comportamento do amigo.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return l;
    }
    
    public ArrayList obterEstatisticas(Timestamp data_inicio, Timestamp data_fim, int opcao, String meulogin, String login_amigo, String path) throws SQLException{
        switch(opcao){
            case 1:
                return amigosPublicadores(data_inicio, data_fim, meulogin);
                
            case 2:
                return amigosInfluentes(data_inicio, data_fim, meulogin);
                
            case 3:
                return usuariosInfluentes(data_inicio, data_fim, meulogin);
                
            case 4:
                return postsInfluentesAmigos(data_inicio, data_fim, meulogin, path);
                
            case 5:
                return influenciaMeusPosts(data_inicio, data_fim, meulogin, path);
                
            case 6:
                return comportamentoAmigo(data_inicio, data_fim, meulogin, login_amigo);
        }
        
        return null;
    }

    /**
     * @return the nome
     */
    public String getNome() {
        return nome;
    }

    /**
     * @param nome the nome to set
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * @return the login
     */
    public String getLogin() {
        return login;
    }

    /**
     * @param login the login to set
     */
    public void setLogin(String login) {
        this.login = login;
    }

    /**
     * @return the contador
     */
    public int getContador() {
        return contador;
    }

    /**
     * @param contador the contador to set
     */
    public void setContador(int contador) {
        this.contador = contador;
    }

    /**
     * @return the npost
     */
    public int getNpost() {
        return npost;
    }

    /**
     * @param npost the npost to set
     */
    public void setNpost(int npost) {
        this.npost = npost;
    }

    /**
     * @return the ncurtir
     */
    public int getNcurtir() {
        return ncurtir;
    }

    /**
     * @param ncurtir the ncurtir to set
     */
    public void setNcurtir(int ncurtir) {
        this.ncurtir = ncurtir;
    }

    /**
     * @return the ncomentario
     */
    public int getNcomentario() {
        return ncomentario;
    }

    /**
     * @param ncomentario the ncomentario to set
     */
    public void setNcomentario(int ncomentario) {
        this.ncomentario = ncomentario;
    }

    /**
     * @return the nmeupostcurtir
     */
    public int getNmeupostcurtir() {
        return nmeupostcurtir;
    }

    /**
     * @param nmeupostcurtir the nmeupostcurtir to set
     */
    public void setNmeupostcurtir(int nmeupostcurtir) {
        this.nmeupostcurtir = nmeupostcurtir;
    }

    /**
     * @return the nmeupostcomentario
     */
    public int getNmeupostcomentario() {
        return nmeupostcomentario;
    }

    /**
     * @param nmeupostcomentario the nmeupostcomentario to set
     */
    public void setNmeupostcomentario(int nmeupostcomentario) {
        this.nmeupostcomentario = nmeupostcomentario;
    }

    /**
     * @return the grupo
     */
    public String getGrupo() {
        return grupo;
    }

    /**
     * @param grupo the grupo to set
     */
    public void setGrupo(String grupo) {
        this.grupo = grupo;
    }

    /**
     * @return the media
     */
    public float getMedia() {
        return media;
    }

    /**
     * @param media the media to set
     */
    public void setMedia(float media) {
        this.media = media;
    }

    /**
     * @return the time
     */
    public String getTime() {
        return time;
    }

    /**
     * @param time the time to set
     */
    public void setTime(String time) {
        this.time = time;
    }
}
