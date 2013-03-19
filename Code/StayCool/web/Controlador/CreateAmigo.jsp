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
            String NovoAmigoLogin = request.getParameter("LoginDoAmigo");
            String NovoAmigoNome = request.getParameter("NomeDoAmigo");
            
            System.out.println("");
            System.out.println("# Adicionando novo amigo...");
            System.out.println("Nome: " + NovoAmigoNome);
            System.out.println("Login: " + NovoAmigoLogin);
            
            amigos.insert(NovoAmigoLogin);
            
            response.sendRedirect("../Interface/Inicio.jsp?adicionar_amigo_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao adicionar novo amigo): " + e.getMessage());
            response.sendRedirect("../Interface/Inicio.jsp?adicionar_amigo_erro=yes");
        }
%>
