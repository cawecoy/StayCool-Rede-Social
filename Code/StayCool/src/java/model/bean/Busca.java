/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package model.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Busca {
    private ArrayList lista;
    private String nome;
    private String meulogin;
    private String senha;
    
    public Busca(String meulogin){
        this.lista = new ArrayList();
        this.meulogin = meulogin;
    }
    
    public void loadLista(String query) throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT * FROM usuarios WHERE LOWER( nome ) LIKE '%" + query.toLowerCase() + "%' AND login <> '" + this.meulogin + "' ORDER BY nome");
            
            while(resultSetQuery.next()){
                lista.add(new Usuario(resultSetQuery.getString("nome"), resultSetQuery.getString("login"), resultSetQuery.getString("senha")));
            }
            
            System.out.println("");
            System.out.println("Resultado de uma busca carregada em 'ArrayList lista' com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        } 
    }

    public ArrayList getLista() {
        return lista;
    }
}
