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
                alert("Desculpe, mas sua sess�o expirou. Por favor, fa�a login novamente.");
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
            System.out.println("# Exce��o (erro ao adicionar novo amigo): " + e.getMessage());
            response.sendRedirect("../Interface/Amigos.jsp?excluir_amigo_erro=yes");
        }
%>