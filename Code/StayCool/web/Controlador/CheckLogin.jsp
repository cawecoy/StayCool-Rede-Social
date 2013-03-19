<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>
<%
    Usuario user = null;
    int loginOk;

    try{
        String login = request.getParameter("login");
        String senha = request.getParameter("senha");
        
        user = new Usuario(login, senha);

        System.out.println("");
        System.out.println(":: Login de Cliente ::");
        System.out.println("Login: " + user.getLogin());
        System.out.println("Senha: " + user.getSenha());
        
        loginOk = user.getUsuario();
        
        if(loginOk == 0){
            session.setAttribute("user", user);
            response.sendRedirect("../Interface/Inicio.jsp");
        }
        else{
            System.out.println("Erro no login.");
            response.sendRedirect("../index.jsp?erroLogin=yes");
        }
    }

    catch(Exception e){
        System.out.println("Exceção: " + e.getMessage());
        response.sendRedirect("../index.jsp?erroLogin=yes");
    }
%>
