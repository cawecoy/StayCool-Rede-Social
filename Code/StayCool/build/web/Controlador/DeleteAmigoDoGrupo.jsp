<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>
<%@page import="model.bean.Amigo"%>

<%
        Usuario user;
        Amigo amigos;
        String LoginDoAmigo = null;
        String Grupo = null;

        user = (Usuario) session.getAttribute("user");

        if(user == null){
            %>
            
            <script type="text/javascript">
                alert("Desculpe, mas sua sessão expirou. Por favor, faça login novamente.");
            </script>
            
            <%
            
            response.sendRedirect("../index.jsp");
        }
        
        amigos = new Amigo(user.getLogin());
        
        try{
            LoginDoAmigo = request.getParameter("LoginDoAmigo");
            Grupo = request.getParameter("Grupo");
            
            System.out.println("");
            System.out.println("# Removendo amigo de um grupo...");
            System.out.println("Login do amigo: " + LoginDoAmigo);
            System.out.println("Grupo: " + Grupo);
            
            amigos.excluirDoGrupo(user.getLogin(), LoginDoAmigo, Grupo);
            
            response.sendRedirect("../Interface/Grupos.jsp?excluir_amigo_grupo_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao mover amigo para um grupo): " + e.getMessage());
            response.sendRedirect("../Interface/Grupos.jsp?excluir_amigo_grupo_erro=yes");
        }
%>
