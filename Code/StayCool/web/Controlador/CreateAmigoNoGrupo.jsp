<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>
<%@page import="model.bean.Amigo"%>

<%
        Usuario user;
        Amigo amigos;
        String LoginDoAmigo = null;
        String NovoGrupo = null;

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
            NovoGrupo = request.getParameter("NovoGrupo");
            
            if(LoginDoAmigo != null || LoginDoAmigo.equals("")){
                System.out.println("");
                System.out.println("# Adicionando amigo num grupo...");
                System.out.println("Login do amigo: " + LoginDoAmigo);
                System.out.println("Grupo: " + NovoGrupo);

                amigos.inserirNoGrupo(user.getLogin(), LoginDoAmigo, NovoGrupo);

                response.sendRedirect("../Interface/Amigos.jsp?editar_grupo_amigo_sucesso=yes");
            }
            else{
                response.sendRedirect("../Interface/Amigos.jsp");
            }
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao adicionar amigo num grupo): " + e.getMessage());
            response.sendRedirect("../Interface/Amigos.jsp?editar_grupo_amigo_erro=yes");
        }
%>
