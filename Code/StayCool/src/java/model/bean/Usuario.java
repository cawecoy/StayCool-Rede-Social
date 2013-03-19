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

public class Usuario {
    private String nome;
    private String login;
    private String senha;
    private String sobre;
    
    public Usuario(){
        
    }
    
    public Usuario(String login){
        this.login = login;
    }
    
    public Usuario(String nome, String login, String senha){
        this.nome = nome;
        this.login = login;
        this.senha = senha;
    }
    
    public Usuario(String nome, String login, String senha, String sobre){
        this.nome = nome;
        this.login = login;
        this.senha = senha;
        this.sobre = sobre;
    }
    
    public Usuario(String login, String senha){
        this.login = login;
        this.senha = senha;
    }
 
    public String getNome() {
        return nome;
    }
    public void setNome(String nome) {
        this.nome = nome;
    }
    public String getLogin() {
        return login;
    }
    public void setLogin(String login) {
        this.login = login;
    }
    public String getSenha() {
        return senha;
    }
    public void setSenha(String senha) {
        this.senha = senha;
    }
    
    /**
     * @return the sobre
     */
    public String getSobre() {
        return sobre;
    }

    /**
     * @param sobre the sobre to set
     */
    public void setSobre(String sobre) {
        this.sobre = sobre;
    }
    
    public void insert() throws SQLException {
        
        Connection conn;
        conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            String SQL = "INSERT INTO " + "usuarios(nome, login, senha, sobre)" + " VALUES (?,?,?,?)";
            
            pst = conn.prepareStatement(SQL);
            pst.setString(1, nome);
            pst.setString(2, login);
            pst.setString(3, senha);
            pst.setString(4, sobre);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Usuário cadastrado com sucesso");

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Usuario não foi criado com sucesso...");
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
    
    public void update(String nome, String login, String senha, String sobre) throws SQLException {
        
        Connection conn;
        conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            String SQL = "UPDATE usuarios SET " + "nome = ?, login = ?, senha = ?, sobre = ? " + "WHERE login = '" + this.login + "'";
            
            pst = conn.prepareStatement(SQL);
            pst.setString(1, nome);
            pst.setString(2, login);
            pst.setString(3, senha);
            pst.setString(4, sobre);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            this.nome = nome;
            this.login = login;
            this.senha = senha;
            this.sobre = sobre;
            
            System.out.print("");
            System.out.println("Profile atualizado com sucesso");

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Profile não foi atualizado com sucesso...");
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
    
    public int validaUsuario() throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        int n = -1;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT COUNT(*) AS total FROM usuarios WHERE login = '" + this.login + "' AND senha = '" + this.senha + "'");
            
            resultSetQuery.next();
            
            // separar essa parte em uma funcao com conexao propria com bd
            
            n = resultSetQuery.getInt("total");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Usuario não foi logado com sucesso...");
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
        
        return n;
    }
    
    public int getUsuario() throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        int n = -1;

        try {
            n = validaUsuario(); // retorna o numero de usuários com os dados de login encontrados no BD (deve ser 1 [existe], 0 [nao existe] ou -1 [erro])
            
            if(n > 0){
                // Usuário existe e é válido
                Class.forName("org.postgresql.Driver").newInstance( );
                conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

                statement = conn.createStatement();
                
                resultSetQuery = statement.executeQuery("SELECT * FROM usuarios WHERE login = '" + this.login + "' AND senha = '" + this.senha + "'");
            
                resultSetQuery.next();

                this.nome = resultSetQuery.getString("nome");
                this.login = resultSetQuery.getString("login");
                this.senha = resultSetQuery.getString("senha");
                this.sobre = resultSetQuery.getString("sobre");

                System.out.println("");
                System.out.println("Usuário logado com sucesso!");
                n = 0;
            }
            else{
                // Usuário não existe ou é inválido (senha ou login errado)
                n = -1;
                System.out.println("");
                System.out.println("Erro ao logar usuário. Usuário não existe ou é inválido (senha ou login errado)!");
            }
            
            statement.close();

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao logar usuario.");
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return n;
    }
    
    public int getUsuarioProfile() throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        int n = -1;

        try {
            
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();

            resultSetQuery = statement.executeQuery("SELECT * FROM usuarios WHERE login = '" + this.login + "'");

            resultSetQuery.next();

            this.nome = resultSetQuery.getString("nome");
            this.login = resultSetQuery.getString("login");
            this.senha = resultSetQuery.getString("senha");
            this.sobre = resultSetQuery.getString("sobre");

            System.out.println("");
            System.out.println("Dados do profile de um usuário carregados com sucesso!");
            n = 0;
            
            statement.close();

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao ler dados do profile de um usuario.");
                } finally {
                    if (statement != null) {
                        statement.close( );
                    }
                    if (conn != null) {
                        conn.close( );
                    }
        }
        
        return n;
    }
    
    public void excluir(String login) throws SQLException{
        Connection conn = null;
        Statement statement = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            statement.execute("DELETE FROM usuarios WHERE login = '" + login + "'");
            
            System.out.println("");
            System.out.println("Conta foi excluída com sucesso!");
            
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

}
