<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>
<%@page import="model.bean.Amigo"%>

<%
        Usuario user;
        Amigo amigos;

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
            String LoginDoAmigo = request.getParameter("LoginDoAmigo");
            amigos.excluir(LoginDoAmigo);
            
            response.sendRedirect("../Interface/Amigos.jsp?excluir_amigo_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao adicionar novo amigo): " + e.getMessage());
            response.sendRedirect("../Interface/Amigos.jsp?excluir_amigo_erro=yes");
        }
%>