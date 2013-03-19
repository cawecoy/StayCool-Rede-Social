<%@page import="model.bean.Post"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user;
        Post post = null;
        String login_profile = null;
        int id = -1;

        user = (Usuario) session.getAttribute("user");

        if(user == null){
            %>
            
            <script type="text/javascript">
                alert("Desculpe, mas sua sess�o expirou. Por favor, fa�a login novamente.");
            </script>
            
            <%
            
            response.sendRedirect("../index.jsp");
        }
        
        try{
            id = Integer.valueOf(request.getParameter("id"));
            login_profile = request.getParameter("login_profile");
            
            System.out.println();
            System.out.println("Deletando postando id = " + id);
            
            post = new Post();
            post.deletePost(id);
            
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "&post_deletado_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exce��o (erro ao postar): " + e.getMessage());
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "&post_deletado_erro=yes");
        }
%>