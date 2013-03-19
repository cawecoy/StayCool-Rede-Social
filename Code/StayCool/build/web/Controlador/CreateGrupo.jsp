<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="model.bean.Grupo"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user;
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
        
        grupos = new Grupo(user.getLogin());
        
        try{
            String titulo = request.getParameter("titulo");
            
            System.out.println("");
            System.out.println("# Adicionando novo grupo...");
            System.out.println("T�tulo: " + titulo);
            
            grupos.insert(titulo);
            
            response.sendRedirect("../Interface/Grupos.jsp?adicionar_grupo_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exce��o (erro ao adicionar novo grupo): " + e.getMessage());
            response.sendRedirect("../Interface/Grupos.jsp?adicionar_grupo_erro=yes");
        }
%>
