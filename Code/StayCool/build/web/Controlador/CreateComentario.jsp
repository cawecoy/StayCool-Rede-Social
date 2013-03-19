<%@page import="model.bean.Comentario"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user;
        Comentario c = null;
        String login_profile = null;
        String comentario = null;
        int idPost = -1;

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
            idPost = Integer.valueOf(request.getParameter("idPost"));
            comentario = request.getParameter("comentario");
            
            System.out.println("");
            System.out.println("Comentando em post id = " + idPost + " | Conteudo do comentario: " + comentario);
            
            c = new Comentario();
            c.inserirComentario(idPost, comentario, user.getLogin());
            
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "&comentario_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao comentar em post): " + e.getMessage());
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "comentario_erro=yes");
        }
%>