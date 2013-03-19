<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="model.bean.Grupo"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user;
        Grupo grupos;
        String atual_nome = null;
        String novo_nome = null;

        user = (Usuario) session.getAttribute("user");

        if(user == null){
            %>
            
            <script type="text/javascript">
                alert("Desculpe, mas sua sessão expirou. Por favor, faça login novamente.");
            </script>
            
            <%
            
            response.sendRedirect("../index.jsp");
        }
        
        grupos = new Grupo(user.getLogin());
        
        try{
            atual_nome = request.getParameter("atual_nome");
            novo_nome = request.getParameter("novo_nome");
            
            System.out.println("");
            System.out.println("# Editando nome do grupo...");
            System.out.println("Atual nome: " + atual_nome);
            System.out.println("Novo nome: " + novo_nome);
            
            grupos.edit(atual_nome, novo_nome);
            
            response.sendRedirect("../Interface/Grupos.jsp?editar_grupo_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao editar grupo): " + e.getMessage());
            response.sendRedirect("../Interface/Grupos.jsp?editar_grupo_erro=yes");
        }
%>
