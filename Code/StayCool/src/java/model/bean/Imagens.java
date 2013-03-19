/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package model.bean;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.imageio.ImageIO;

public class Imagens {
    public String getImagem(String login, String path) throws SQLException {
        
        boolean imagemOk = this.getImagemFinal(login, path);
        
        if(imagemOk == false){ // Se a imagem náo existir no banco de dados, quer dizer que o usuario se cadastrou sem uma imagem, entao...
            this.deleteImagem(login);
            this.criarAvatarPadrao(login, path); // salvamos em seu BD uma imagem de avatar padrão
            this.getImagemFinal(login, path); // e carregamos essa imagem em "Files/${login}.jpg".
        }
        
        return login + ".jpg";
    }
    
    public Boolean getImagemFinal(String login, String path) throws SQLException {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSetQuery = null;
        Boolean imagemOk = false;
        
        try {
            
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            
            // linha abaixo, para quando haver albuns de fotos, haverá o atributo album
//            resultSetQuery = statement.executeQuery("SELECT imagem FROM imagens WHERE login = '" + login + "' AND album = 'profile'");
            
            resultSetQuery = statement.executeQuery("SELECT imagem FROM imagens WHERE login = '" + login + "'");
            
            resultSetQuery.next();

            InputStream img = resultSetQuery.getBinaryStream(1);
            //imgData = img.getBytes(1,(int)img.length());
            
            if(img != null) {
                if(img.available() != 0){
                    imagemOk = true;
                    
                    BufferedImage bImageFromConvert = ImageIO.read(img);
     
                    ImageIO.write(bImageFromConvert, "png", new File(
                                    path + login + ".png"));

                    System.out.println("");
                    System.out.println("Imagem carregada com sucesso! salva em: " + path + login + ".png");
                }
            }
            
            statement.close();

            } catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao carregar imagem. Talvez o usuario não tenha foto.");
                
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
        
        return imagemOk;
    }
    
    public void criarAvatarPadrao(String login, String path) throws SQLException {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try{
            File file = new File(path + "avatar.png");
            FileInputStream fis = new FileInputStream(file);
            
//            System.out.println("");
//            System.out.println(path + "avatar.png");
            
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");
            
            String SQL = "INSERT INTO " + "imagens(login, imagem)" + " VALUES (?,?)";
            
            pst = conn.prepareStatement(SQL);
            
            // linhas abaixo são para quando haver albuns de foto
//            pst.setString(1, "profile");
//            pst.setString(2, login);
//            pst.setBinaryStream(3, filecontent, (int)size));
            
            pst.setString(1, login);
            pst.setBinaryStream(2, fis, (int) file.length());
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Imagem de avatar padrão inserida com sucesso!");
            
            pst.close();
        }
        catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao inserir imagem de avatar padrão.");
                
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
    
    public void deleteImagem(String login) throws SQLException{
        Connection conn = null;
        Statement statement = null;

        try {
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");

            statement = conn.createStatement();
            statement.execute("DELETE FROM imagens WHERE login = '" + login + "'");
            
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
    
    public void insertImagem(String login, InputStream filecontent, long size) throws SQLException {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try{
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");
            
            String SQL = "INSERT INTO " + "imagens(login, imagem)" + " VALUES (?,?)";
            
            pst = conn.prepareStatement(SQL);
            
            // linhas abaixo são para quando haver albuns de foto
//            pst.setString(1, "profile");
//            pst.setString(2, login);
//            pst.setBinaryStream(3, filecontent, (int)size));
            
            pst.setString(1, login);
            pst.setBinaryStream(2, filecontent, (int) size);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Imagem inserida com sucesso!");
            
            pst.close();
        }
        catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao inserir imagem.");
                
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
    
    public void updateImagem(String login, InputStream filecontent, long size) throws SQLException {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try{
            Class.forName("org.postgresql.Driver").newInstance( );
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","postgres","marega");
            
            String SQL = "UPDATE " + "imagens SET login = ?, imagem = ?" + " WHERE login = '" + login + "'";
            
            pst = conn.prepareStatement(SQL);
            
            // linhas abaixo são para quando haver albuns de foto
//            pst.setString(1, "profile");
//            pst.setString(2, login);
//            pst.setBinaryStream(3, filecontent, (int)size));
            
            pst.setString(1, login);
            pst.setBinaryStream(2, filecontent, (int) size);
            
            pst.executeUpdate( );
            pst.clearParameters( );
            
            System.out.print("");
            System.out.println("Imagem atualizada com sucesso!");
            
            pst.close();
        }
        catch (Exception ex) {
                System.out.println("");
                System.out.println("Excessão ao atualizar imagem.");
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
}
