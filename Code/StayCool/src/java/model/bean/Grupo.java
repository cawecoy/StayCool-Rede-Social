/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package model.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Grupo {
    private ArrayList listaDeGrupos;
    private String login;
    
    public Grupo(String login){
        this.listaDeGrupos = new ArrayList();
        this.login = login;
    }
    
    public void loadGrupos() throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        String grupo = null;
        
        this.listaDeGrupos.clear();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT grupo FROM grupos WHERE login = '" + this.login + "' ORDER BY grupo");
            
            while(resultSetQuery.next()){
                grupo = resultSetQuery.getString("grupo");
                this.listaDeGrupos.add(grupo);
            }
            
            System.out.println("");
            System.out.println("Carregada lista de grupos em 'ArrayList listaDeGrupos' com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessao ao carregar lista de grupos em 'ArrayList listaDeGrupos'.");
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
    
    public void insert(String titulo) throws SQLException {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try{
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");
            
            String SQL = "INSERT INTO " + "grupos(login, grupo)" + " VALUES (?,?)";
            
            pst = conn.prepareStatement(SQL);
            
            pst.setString(1, this.login);
            pst.setString(2, titulo);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Grupo inserido com sucesso!");
            
            pst.close();
        }
        catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao inserir grupo.");
                
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
    
    public void exclui(String titulo) throws SQLException {
        Connection conn = null;
        Statement statement = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            statement.execute("DELETE FROM grupos WHERE grupo = '" + titulo + "' AND login = '" + this.login + "'");
            
            System.out.println("");
            System.out.println("Grupo foi excluído com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao excluir grupo.");
                
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
    
    public void edit(String atual_nome, String novo_nome) throws SQLException{
        Connection conn;
        conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            String SQL = "UPDATE grupos SET " + "grupo = ? " + "WHERE login = '" + this.login + "' AND grupo = '" + atual_nome + "'";
            
            pst = conn.prepareStatement(SQL);
            pst.setString(1, novo_nome);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Grupo foi editado com sucesso!");

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao editar grupo.");
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
    
    public ArrayList getGrupos(){
        return this.listaDeGrupos;
    }
}
