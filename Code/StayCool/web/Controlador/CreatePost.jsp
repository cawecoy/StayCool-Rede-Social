<%@page import="java.io.InputStream"%>
<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.tomcat.util.http.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="model.bean.Post"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user;
        Post post = null;
        String login_profile = null;
        String login_postador = null;
        String conteudo = null;
        InputStream filecontent = null;
        long size = 0;

        user = (Usuario) session.getAttribute("user");

        if(user == null){
            %>
            
            <script type="text/javascript">
                alert("Desculpe, mas sua sessão expirou. Por favor, faça login novamente.");
            </script>
            
            <%
            
            response.sendRedirect("../index.jsp");
        }
        
        try{
            login_postador = user.getLogin();
            
            List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
        
            for (FileItem item : items) {
                String fieldname = item.getFieldName();
                if (fieldname.equals("login_profile")) {
                    login_profile = item.getString();
                }
                else if (fieldname.equals("post")) {
                    conteudo = item.getString();
                }
                else if(fieldname.equals("File")){
                    filecontent = item.getInputStream();
                    size = item.getSize();
                }
            }
            
            System.out.println();
            System.out.println("Postando: " + conteudo);
            System.out.println("De: " + login_postador);
            System.out.println("Para: " + login_profile);
            
            post = new Post();
            post.inserirPost(conteudo, login_profile, login_postador, filecontent, size);
            
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "&post_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao postar): " + e.getMessage());
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "post_erro=yes");
        }
%>