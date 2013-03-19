<%@page import="model.bean.Amigo"%>
<%@page import="model.bean.Grupo"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>

<%
        Usuario user = new Usuario();
        
        String login = null;

        try{
            login = request.getParameter("login");
            
            System.out.println("");
            System.out.println("# Excluindo conta...");
            System.out.println("Login: " + login);
            
            user.excluir(login);
            
            response.sendRedirect("../index.jsp?excluir_conta_sucesso=yes");
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao excluir conta): " + e.getMessage());
            response.sendRedirect("../Interface/Inicio.jsp?excluir_conta_erro=yes");
        }
%>
