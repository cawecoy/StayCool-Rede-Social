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

public class Amigo {
    private ArrayList listaDeAmigos;
   
    private String meuLogin;
    private String nome;
    private String login;
    
    public Amigo(){
        this.listaDeAmigos = new ArrayList();
    }
    
    public Amigo(String meuLogin){
        this.listaDeAmigos = new ArrayList();
        this.meuLogin = meuLogin;
    }
    
    
    public Amigo(String nome, String login){
        this.nome = nome;
        this.login = login;
    }
    
    public void loadAmigos() throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        
        this.listaDeAmigos.clear();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT * FROM amigos JOIN usuarios ON amigos.seulogin = usuarios.login WHERE meulogin = '" + getMeuLogin() + "' ORDER BY nome");
            
            while(resultSetQuery.next()){
                this.listaDeAmigos.add(new Amigo(resultSetQuery.getString("nome"), resultSetQuery.getString("seulogin")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de amigos em 'ArrayList listaDeAmigos' com sucesso!");
            
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
    
    public ArrayList getAmigosSugeridosRandom(String login, int limite) throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        ArrayList l = new ArrayList();

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT resultado.login, resultado.nome FROM (SELECT * FROM usuarios WHERE login <> '" + login + "'ORDER BY RANDOM() ) AS resultado LEFT JOIN (SELECT seulogin FROM amigos WHERE meulogin = '" + login + "') AS amg ON resultado.login = amg.seulogin WHERE amg.seulogin is null LIMIT " + limite);
            
            while(resultSetQuery.next()){
                l.add(new Usuario(resultSetQuery.getString("nome"), resultSetQuery.getString("login"), ""));
            }
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar lista de sugestão de amigos.");
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
    
    public ArrayList getAmigosSugeridos(String login, int limite) throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        ArrayList l = new ArrayList();
        boolean temAmigosMutuos = false;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT resultado.login, resultado.nome FROM (SELECT * FROM amigos WHERE meulogin = '" + login + "') as amg3 RIGHT JOIN (SELECT amg1.seulogin as login, amg1.nome as nome, COUNT(amg1.seulogin) as contador FROM (SELECT amigos.meulogin, amigos.seulogin, usuarios.nome FROM amigos JOIN usuarios ON amigos.seulogin = usuarios.login WHERE amigos.seulogin <> '" + login + "') as amg1 JOIN (SELECT * FROM amigos WHERE amigos.meulogin = '" + login + "') as amg2 ON amg1.meulogin = amg2.seulogin GROUP BY amg1.seulogin, amg1.nome ) as resultado ON amg3.seulogin = resultado.login WHERE seulogin is null ORDER BY contador DESC LIMIT " + limite);
            
            while(resultSetQuery.next()){
                temAmigosMutuos = true;
                l.add(new Usuario(resultSetQuery.getString("nome"), resultSetQuery.getString("login"), ""));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de sugestão de amigos em 'ArrayList listaRandom' com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao carregar lista de sugestão de amigos.");
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
        
        if(temAmigosMutuos == false){
            l = getAmigosSugeridosRandom(login, limite);
        }
        
        return l;
    }
    
    public void insert(String NovoAmigoLogin) throws SQLException {
        // Insere meu novo amigo na minha lista de amigos
        insert1(NovoAmigoLogin);
        
        // Me insere na lista de amigos do meu novo amigo
        insert2(NovoAmigoLogin);
    }
    
    public void insert1(String NovoAmigoLogin) throws SQLException {
        Connection conn;
        conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            String SQL = "INSERT INTO amigos(meulogin, seulogin) VALUES (?,?)";
            
            pst = conn.prepareStatement(SQL);
            pst.setString(1, this.meuLogin);
            pst.setString(2, NovoAmigoLogin);
            
            pst.executeUpdate( );
            pst.clearParameters( );

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao adicionar amigo.");
                
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
    
    public void insert2(String NovoAmigoLogin) throws SQLException {
        
        Connection conn;
        conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            String SQL = "INSERT INTO amigos(meulogin, seulogin)" + " VALUES (?,?)";
            
            pst = conn.prepareStatement(SQL);
            pst.setString(1, NovoAmigoLogin);
            pst.setString(2, this.meuLogin);
            
            pst.executeUpdate( );
            pst.clearParameters( );

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao adicionar amigo.");
                
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
    
    public boolean jaSomosAmigos(String login){
        boolean exist = false;
        
        // Navega pela lista de amigos, se encontrar o usuário do login de entrada (parametro 'login'), então os usuários já são amigos (true), caso contrário eles ainda não são amigos (false)
        for(int i = 0; i < this.listaDeAmigos.size() ;i++){
            Amigo amigo = (Amigo) this.listaDeAmigos.get(i);
            String seulogin = amigo.getLogin();
            
            if(seulogin.equals(login)){
                exist = true;
                break;
            }
        }

        return exist;
    }
    
    // Retorn uma sublista de todos os amigos que são de um certo grupo (parametro 'grupo' e 'meulogin')
    public ArrayList getListaPorGrupo(String grupo, String meulogin) throws SQLException{
        ArrayList l = new ArrayList();
        
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            resultSetQuery = statement.executeQuery("SELECT usuarios.nome, usuarios.login FROM amigosgrupos JOIN usuarios ON amigosgrupos.seulogin = usuarios.login WHERE meulogin = '" + meulogin + "' AND grupo = '" + grupo + "' ORDER BY nome");
            
            while(resultSetQuery.next()){
                l.add(new Amigo(resultSetQuery.getString("nome"), resultSetQuery.getString("login")));
            }
            
            System.out.println("");
            System.out.println("Carregada lista de amigos do grupo " + grupo + " com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Lista de amigos do grupo " + grupo + " não foi carregada com sucesso...");
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
    
    public void exclui1(String LoginDoAmigo) throws SQLException {
        Connection conn = null;
        Statement statement = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            statement.execute("DELETE FROM amigos WHERE meulogin = '" + getMeuLogin() + "' AND seulogin = '" + LoginDoAmigo + "'");
            
            System.out.println("");
            System.out.println("Amigo foi excluído com sucesso!");
            
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
    
    public void exclui2(String LoginDoAmigo) throws SQLException {
        Connection conn = null;
        Statement statement = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            statement.execute("DELETE FROM amigos WHERE meulogin = '" + LoginDoAmigo + "' AND seulogin = '" + getMeuLogin() + "'");
            
            System.out.println("");
            System.out.println("Amigo foi excluído com sucesso!");
            
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
    
    public void excluir(String LoginDoAmigo) throws SQLException {
        // Exclui amigo da minha lista de amigos
        exclui1(LoginDoAmigo);
        
        // Me exclui da lista de amigos do meu novo ex-amigo
        exclui2(LoginDoAmigo);
    }
    
    public void inserirNoGrupo(String meulogin, String seulogin, String novo_grupo) throws SQLException{
        Connection conn;
        conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            String SQL = "INSERT INTO amigosgrupos (meulogin, seulogin, grupo) " + "VALUES(?,?,?)";
            
            pst = conn.prepareStatement(SQL);
            pst.setString(1, meulogin);
            pst.setString(2, seulogin);
            pst.setString(3, novo_grupo);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Amigo foi adicionado num grupo com sucesso!");

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao adicionar amigo num grupo.");
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
    
    public void excluirDoGrupo(String meulogin, String seulogin, String grupo) throws SQLException {
        Connection conn = null;
        Statement statement = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            statement.execute("DELETE FROM amigosgrupos WHERE meulogin = '" + meulogin + "' AND seulogin = '" + seulogin + "' AND grupo = '" + grupo + "'");
            
            System.out.println("");
            System.out.println("Amigo foi excluído de um grupo com sucesso!");
            
            statement.close();

            } catch (Exception ex) {
                System.out.print("");
                System.out.println("Excessão ao excluir amigo de um grupo.");
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

    public ArrayList getlistaDeAmigos() {
        return listaDeAmigos;
    }

    /**
     * @return the meuLogin
     */
    public String getMeuLogin() {
        return meuLogin;
    }

    /**
     * @param meuLogin the meuLogin to set
     */
    public void setMeuLogin(String meuLogin) {
        this.meuLogin = meuLogin;
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
}
