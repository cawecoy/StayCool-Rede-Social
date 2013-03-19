<%@page import="model.bean.Grupo"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.tomcat.util.http.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="model.bean.Imagens"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>
<%
    Usuario user;
    Grupo grupos;

    try{
        String login = null;
        String nome = null;
        String senha = null;
        String sobre = null;
        InputStream filecontent = null;
        long size = 0;
        
        List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        
        for (FileItem item : items) {
            String fieldname = item.getFieldName();
            if (fieldname.equals("nome")) {
                nome = item.getString();
            }
            else if (fieldname.equals("login")) {
                login = item.getString();
            }
            else if (fieldname.equals("senha")) {
                senha = item.getString();
            }
            else if (fieldname.equals("sobre")) {
                sobre = item.getString();
            }
            else if(fieldname.equals("File")){
                filecontent = item.getInputStream();
                size = item.getSize();
            }
        }
        
        user = new Usuario(nome, login, senha, sobre);
        user.insert();
        
        System.out.println("");
        System.out.println(":: Cadastro de Cliente ::");
        System.out.println("Nome: " + user.getNome());
        System.out.println("Login: " + user.getLogin());
        System.out.println("Senha: " + user.getSenha());
        System.out.println("Sobre: " + user.getSobre());
        
        if(size > 0){
            new Imagens().insertImagem(login, filecontent, size);
            System.out.println("");
            System.out.println(":: Cadastro da primeira imagem do novo cliente ::");
        }
               
        response.sendRedirect("../index.jsp?inserted=yes");
    }

    catch(Exception e){
        System.out.println("Exceção: " + e.getMessage());
        response.sendRedirect("../index.jsp?erro=yes");
    }
%>
