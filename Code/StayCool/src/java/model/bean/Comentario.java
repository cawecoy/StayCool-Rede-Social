/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package model.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;

/**
 *
 * @author cawecoyrodrigues
 */
public class Comentario {
    private int id;
    private Timestamp time;
    private String login;
    private String nome;
    private String comentario;
    
    public Comentario(){
        
    }
    
    public Comentario(int id, Timestamp time, String login, String nome, String comentario){
        this.id = id;
        this.time = time;
        this.login = login;
        this.nome = nome;
        this.comentario = comentario;
    }
    
    public void inserirComentario(int idPost, String comentario, String login) throws SQLException{
        Connection conn = null;
        PreparedStatement pst = null;
        
        try{
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");
            
            String SQL = "INSERT INTO " + "comentarios(login, idPost, comentario)" + " VALUES (?,?,?)";
            
            pst = conn.prepareStatement(SQL);
            
            pst.setString(1, login);
            pst.setInt(2, idPost);
            pst.setString(3, comentario);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Comentario realizado com sucesso!");
            
            pst.close();
        }
        catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao realizar comentario.");
                
                System.out.println("");
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
    
    public ArrayList getComentarios(int idPost) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        ArrayList lista_comentarios = new ArrayList();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT comentarios.id, comentarios.time, comentarios.login, comentarios.comentario, usuarios.nome FROM comentarios JOIN usuarios ON comentarios.login = usuarios.login WHERE idPost = '" + idPost + "' ORDER BY time");
            
            while(resultSetQuery.next()){
                lista_comentarios.add(new Comentario(resultSetQuery.getInt("id"), resultSetQuery.getTimestamp("time"), resultSetQuery.getString("login"), resultSetQuery.getString("nome"), resultSetQuery.getString("comentario")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de comentarios com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar comentarios.");
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
        
        return lista_comentarios;
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
     * @return the comentario
     */
    public String getComentario() {
        return comentario;
    }

    /**
     * @param comentario the comentario to set
     */
    public void setComentario(String comentario) {
        this.comentario = comentario;
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
}
