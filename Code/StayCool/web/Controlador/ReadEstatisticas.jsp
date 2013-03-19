<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="model.bean.Estatistica"%>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="model.bean.Usuario"%>
<%@page import="model.bean.Amigo"%>

<%
        Usuario user;
        Estatistica estatistica = new Estatistica ();
        
        Timestamp data_inicio = null;
        Timestamp data_fim = null;
        
        int opcao;
        String login_amigo = null;

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
            if(request.getParameter("deano").equals("") || request.getParameter("deano") == null){
                long thePast = System.currentTimeMillis() - (86400 * 7 * 1000);
                Date lastWeek = new Date(thePast);
                Date today = new Date();
                
                data_inicio = new Timestamp(lastWeek.getTime());
                data_fim = new Timestamp(today.getTime());
            }
            else{
                data_inicio = Timestamp.valueOf(request.getParameter("deano") + "-" + request.getParameter("demes") + "-" + request.getParameter("dedia") + " 00:00:00");
                data_fim = Timestamp.valueOf(request.getParameter("ateano") + "-" + request.getParameter("atemes") + "-" + request.getParameter("atedia") + " 23:59:59");
            }
            
            opcao = Integer.valueOf(request.getParameter("opcao"));
            
            login_amigo = request.getParameter("amigo");
            
            System.out.println("");
            System.out.println("# Gerando estatísticas...");
            System.out.println("De: " + data_inicio.toString());
            System.out.println("Até: " + data_fim.toString());
            System.out.println("Opção: " + opcao);
            System.out.println("Amigo: " + login_amigo);
            
            String path = request.getSession().getServletContext().getRealPath("/") + "Files/";
            
            ArrayList resultado = estatistica.obterEstatisticas(data_inicio, data_fim, opcao, user.getLogin(), login_amigo, path);
            
            session.setAttribute("estatistica", resultado);
            
            response.sendRedirect("../Interface/Estatisticas.jsp?estatistica_sucesso=yes&opcao=" + opcao);
        }
        catch(Exception e){
            System.out.println("# Exceção (erro ao obter estatísticas): " + e.getMessage());
            response.sendRedirect("../Interface/Estatisticas.jsp?estatistica_erro=yes");
        }
%>
