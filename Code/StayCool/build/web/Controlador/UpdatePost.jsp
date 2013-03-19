<%@page import="model.bean.Post"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user;
        Post post = null;
        String login_profile = null;
        String conteudo = null;
        int id = -1;

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
            login_profile = request.getParameter("login_profile");
            id = Integer.valueOf(request.getParameter("id"));
            conteudo = request.getParameter("conteudo");
            
            System.out.println();
            System.out.println("Editando postando id = " + id + " | Novo conteudo: " + conteudo);
            
            post = new Post();
            post.editarPost(id, conteudo);
            
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "&post_editado_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao editar post): " + e.getMessage());
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "post_editado_erro=yes");
        }
%>