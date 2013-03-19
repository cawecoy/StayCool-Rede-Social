<%@page import="model.bean.Amigo"%>
<%@page import="model.bean.Grupo"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user;
        Amigo amigos;
        Grupo grupos;

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
        grupos = new Grupo(user.getLogin());
        
        try{
            String titulo = request.getParameter("titulo");
            
            System.out.println("");
            System.out.println("# Excluindo grupo...");
            System.out.println("T�tulo: " + titulo);
            
            grupos.exclui(titulo);
            
            response.sendRedirect("../Interface/Grupos.jsp?excluir_grupo_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exce��o (erro ao excluir grupo): " + e.getMessage());
            response.sendRedirect("../Interface/Grupos.jsp?excluir_grupo_erro=yes");
        }
%>
