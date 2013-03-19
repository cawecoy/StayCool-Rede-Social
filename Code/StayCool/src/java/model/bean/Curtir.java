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
import java.util.ArrayList;

/**
 *
 * @author cawecoyrodrigues
 */
public class Curtir {
    private int id;
    private String login;
    private String nome;
    ArrayList lista_curtir;
    
    public Curtir(){
        this.lista_curtir = new ArrayList();
    }
    
    public Curtir(int id, String login, String nome){
        this.id = id;
        this.login = login;
        this.nome = nome;
    }
    
    public void inserirCurtir(int idPost, String login, String nome) throws SQLException{
        Connection conn = null;
        PreparedStatement pst = null;
        
        try{
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");
            
            String SQL = "INSERT INTO " + "curtir(login, idPost)" + " VALUES (?,?)";
            
            pst = conn.prepareStatement(SQL);
            
            pst.setString(1, login);
            pst.setInt(2, idPost);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Curtir realizado com sucesso!");
            
            pst.close();
        }
        catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao curtir.");
                
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
    
    public ArrayList getCurtirs(int idPost) throws SQLException{
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        
        this.lista_curtir.clear();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT curtir.id, curtir.login, usuarios.nome FROM curtir JOIN usuarios ON curtir.login = usuarios.login WHERE idPost = '" + idPost + "'");
            
            while(resultSetQuery.next()){
                this.lista_curtir.add(new Curtir(resultSetQuery.getInt("id"),  resultSetQuery.getString("login"), resultSetQuery.getString("nome")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de curtir com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar lista de curtir.");
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
        
        return this.lista_curtir;
    }
    
    public boolean jaCurtiuIsto(String login){
        for(int i = 0; i < this.lista_curtir.size(); i++){
            Curtir c = (Curtir) this.lista_curtir.get(i);
            if(c.getLogin().equals(login)){
                return true;
            }
        }
        return false;
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
