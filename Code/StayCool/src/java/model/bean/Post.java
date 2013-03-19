/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package model.bean;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.InputStream;
import java.sql.Connection;
import java.util.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import javax.imageio.ImageIO;

/**
 *
 * @author cawecoyrodrigues
 */
public class Post {
    private int id;
    private int idPostOriginal;
    private String login;
    private String login_postador;
    private String conteudo;
    private String operation;
    private Timestamp time;
    private ArrayList lista_posts;
    private boolean pic_post;
    private int contador;
    private boolean reincidente;
    
    public Post(){
        lista_posts = new ArrayList();
    }
    
    public Post(int id, int idPostOriginal, String operation, String login, String login_postador, String conteudo, Timestamp time){
        this.id = id;
        this.idPostOriginal = idPostOriginal;
        this.operation = operation;
        this.login = login;
        this.login_postador = login_postador;
        this.conteudo = conteudo;
        this.time = time;
    }
    
    public Post(int id, String login, String login_postador, String conteudo, Timestamp time, boolean pic_post){
        this.id = id;
        this.login = login;
        this.login_postador = login_postador;
        this.conteudo = conteudo;
        this.time = time;
        this.pic_post = pic_post;
    }
    
    public Post(boolean reincidente, int id, String login, String login_postador, String conteudo, Timestamp time){
        this.reincidente = reincidente;
        this.id = id;
        this.login = login;
        this.login_postador = login_postador;
        this.conteudo = conteudo;
        this.time = time;
    }
    
    public Post(int id, String login, String login_postador, String conteudo, Timestamp time, boolean pic_post, int contador){
        this.id = id;
        this.login = login;
        this. login_postador = login_postador;
        this.conteudo = conteudo;
        this.time = time;
        this.pic_post = pic_post;
        this.contador = contador;
    }
    
    public Post(int id, String login, String login_postador, int contador){
        this.id = id;
        this.login = login;
        this. login_postador = login_postador;
        this.contador = contador;
    }
    
    public Post(int id, String login, String login_postador, int contador, Timestamp time){
        this.id = id;
        this.login = login;
        this. login_postador = login_postador;
        this.contador = contador;
        this.time = time;
    }
    
    public void inserirPost(String conteudo, String login, String login_postador, InputStream filecontent, long size) throws SQLException{
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            if(filecontent != null){
                String SQL = "INSERT INTO " + "posts(login, login_postador, conteudo, imagem)" + " VALUES (?,?,?,?)";
                
                pst = conn.prepareStatement(SQL);

                pst.setString(1, login);
                pst.setString(2, login_postador);
                pst.setString(3, conteudo);
                pst.setBinaryStream(4, filecontent, (int) size);

                pst.executeUpdate( );
                pst.clearParameters( );
            }
            else{
                String SQL = "INSERT INTO " + "posts(login, login_postador, conteudo)" + " VALUES (?,?,?)";
            
                pst = conn.prepareStatement(SQL);

                pst.setString(1, login);
                pst.setString(2, login_postador);
                pst.setString(3, conteudo);

                pst.executeUpdate( );
                pst.clearParameters( );
            }
            
            
            System.out.print("");
            System.out.println("Post realizado com sucesso");

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Post não foi realizado com sucesso...");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (pst != null) {
                        pst.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
    }
    
    public ArrayList getPosts(String login, String path) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        InputStream pic = null;
        boolean temPic = false;
        int id = -1;
        
        this.getLista_posts().clear();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT * FROM posts WHERE login = '" + login + "' ORDER BY time");
            
            while(resultSetQuery.next()){
                temPic = false;
                id = resultSetQuery.getInt("id");
                pic = resultSetQuery.getBinaryStream("imagem");
                
                if(pic != null){
                    if(pic.available() != 0){
                        temPic = true;
                        BufferedImage bImageFromConvert = ImageIO.read(pic);
                        ImageIO.write(bImageFromConvert, "png", new File(path + "Post" + id + ".png"));
                    }
                }
                
                this.getLista_posts().add(new Post(id, login, resultSetQuery.getString("login_postador"), resultSetQuery.getString("conteudo"), resultSetQuery.getTimestamp("time"), temPic));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de posts em 'ArrayList lista_posts' com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar posts.");
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
        
        Collections.reverse(getLista_posts());
        
        return this.getLista_posts();
    }
    
    public void getOnePost(String login, String path, int id) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        InputStream pic = null;
        boolean temPic = false;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT * FROM posts WHERE id = " + id);
            
            resultSetQuery.next();
            temPic = false;
            pic = resultSetQuery.getBinaryStream("imagem");

            if(pic != null){
                if(pic.available() != 0){
                    temPic = true;
                    BufferedImage bImageFromConvert = ImageIO.read(pic);
                    ImageIO.write(bImageFromConvert, "png", new File(path + "Post" + id + ".png"));
                }
            }
            
            this.setId(id);
            this.setLogin(login);
            this.setLogin_postador(resultSetQuery.getString("login_postador"));
            this.setConteudo(resultSetQuery.getString("conteudo"));
            this.setTime(resultSetQuery.getTimestamp("time"));
            this.setPic_post(temPic);
            
            System.out.println("");
            System.out.println("Carregado post id = " + id + " com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar post id = " + id);
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
    }
    
    public void editarPost(int id, String conteudo) throws SQLException{
        Connection conn;
        conn = null;
        PreparedStatement pst = null;
        Date data = new Date();
        Timestamp currentTime = new Timestamp(data.getTime());

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            String SQL = "UPDATE posts SET " + "conteudo = ?, time = ? " + "WHERE id = " + id;
            
            pst = conn.prepareStatement(SQL);
            pst.setString(1, conteudo);
            pst.setTimestamp(2, currentTime);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Post foi editado com sucesso!");

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao editar post.");
                System.out.print("");
                System.out.println(ex.getMessage());
                } finally {
                    if (pst != null) {
                        pst.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
    }
    
    public void deletePost(int id) throws SQLException{
        Connection conn = null;
        Statement statement = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            statement.execute("DELETE FROM posts WHERE id = " + id);
            
            System.out.println("");
            System.out.println("Post foi excluído com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao excluir post.");
                
                System.out.println("");
                System.out.println(ex.getMessage());
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
    }
    
    public String getNome_postador() throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        String nome = "";

        try {
            // Usuário existe e é válido
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();

            resultSetQuery = statement.executeQuery("SELECT nome FROM usuarios WHERE login = '" + this.login_postador + "'");

            resultSetQuery.next();

            nome = resultSetQuery.getString("nome");

            System.out.println("");
            System.out.println("Nome do usuário obtido com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao obter nome do usuario.");
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return nome;
    }
    
    public String getNome_profile() throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        String nome = "";

        try {
            // Usuário existe e é válido
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();

            resultSetQuery = statement.executeQuery("SELECT nome FROM usuarios WHERE login = '" + this.login + "'");

            resultSetQuery.next();

            nome = resultSetQuery.getString("nome");

            System.out.println("");
            System.out.println("Nome do usuário obtido com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao obter nome do usuario.");
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return nome;
    }

    /**
     * @return the id
     */
    public int getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.id = id;
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
     * @return the login_postador
     */
    public String getLogin_postador() {
        return login_postador;
    }

    /**
     * @param login_postador the login_postador to set
     */
    public void setLogin_postador(String login_postador) {
        this.login_postador = login_postador;
    }

    /**
     * @return the conteudo
     */
    public String getConteudo() {
        return conteudo;
    }

    /**
     * @param conteudo the conteudo to set
     */
    public void setConteudo(String conteudo) {
        this.conteudo = conteudo;
    }

    /**
     * @return the time
     */
    public Timestamp getTime() {
        return time;
    }

    /**
     * @param time the time to set
     */
    public void setTime(Timestamp time) {
        this.time = time;
    }

    /**
     * @return the pic_post
     */
    public boolean isPic_post() {
        return pic_post;
    }

    /**
     * @param pic_post the pic_post to set
     */
    public void setPic_post(boolean pic_post) {
        this.pic_post = pic_post;
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
     * @return the reincidente
     */
    public boolean isReincidente() {
        return reincidente;
    }

    /**
     * @param reincidente the reincidente to set
     */
    public void setReincidente(boolean reincidente) {
        this.reincidente = reincidente;
    }

    /**
     * @return the lista_posts
     */
    public ArrayList getLista_posts() {
        return lista_posts;
    }

    /**
     * @param lista_posts the lista_posts to set
     */
    public void setLista_posts(ArrayList lista_posts) {
        this.lista_posts = lista_posts;
    }

    /**
     * @return the operation
     */
    public String getOperation() {
        return operation;
    }

    /**
     * @param operation the operation to set
     */
    public void setOperation(String operation) {
        this.operation = operation;
    }
}
