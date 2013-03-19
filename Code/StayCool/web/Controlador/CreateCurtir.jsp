<%@page import="model.bean.Curtir"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user;
        Curtir c = null;
        String login_profile = null;
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
            
            System.out.println("");
            System.out.println("Curtindo post id = " + idPost);
            
            c = new Curtir();
            c.inserirCurtir(idPost, user.getLogin(), user.getNome());
            
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "&curtir_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao curtir post): " + e.getMessage());
            response.sendRedirect("../Interface/Inicio.jsp?login=" + login_profile + "curtir_erro=yes");
        }
%>