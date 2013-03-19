<%@ page import="model.bean.Usuario"%>
<%@ page import="model.bean.Busca"%>
<%@page import="model.bean.Amigo"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>StayCool</title>
<link href="../style.css" rel="stylesheet" type="text/css">
<!--[if IE]>
<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
<!--[if IE 6]>
<script src="../js/belatedPNG.js"></script>
<script>
        DD_belatedPNG.fix('*');
</script>
<![endif]-->
<script src="../js/jquery-1.4.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../js/loopedslider.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8">
        $(function(){
                $('#slider').loopedSlider({
                        autoStart: 6000,
                        restart: 5000
                });
        });
</script>
<%
        Usuario user;
        Amigo amigos;

        user = (Usuario) session.getAttribute("user");

        amigos = new Amigo(user.getLogin());
%>
</head>
<body>
<div id="bodywrap">
	<section id="pagetop">
		<p id="siteinfo">
			 
		</p>
		<nav id="sitenav">
			<ul>
				<li><a href="../Interface/Inicio.jsp"><%=user.getNome()%></a></li>
				<li><a href="../Interface/Grupos.jsp">Grupos</a></li>
                                <li><a href="../Interface/Amigos.jsp">Amigos</a></li>
				<li><a href="../Interface/Estatisticas.jsp">Estatísticas</a></li>
                                <li><a href="../Interface/Profile.jsp">Editar perfil</a></li>
				<li><a href="../Controlador/LogOut.jsp">Logout</a></li>
			</ul>
		</nav>
	</section>
	<header id="pageheader">
	<h1>
		Stay<span>Cool</span>
	</h1>
	<div id="search">
		<form action="../Interface/Busca.jsp" method="POST">
			<div class="searchfield">
				<input type="text" name="Query" id="s">
			</div>
			<div class="searchbtn">
				<input type="image" src="../images/searchbtn.png" alt="search">
			</div>
		</form>
	</div>
	</header>
	<div id="contents">
		<section id="main">
			<div id="leftcontainer">
				<h2 class="mainheading">
					Busca
				</h2>
				<article class="post">
                        <%
                            Busca lista = new Busca(user.getLogin());
                            ArrayList resultados;
                            String query = request.getParameter("Query");
                            
                            
                            lista.loadLista(query);
                            resultados = lista.getLista();
                            
                            amigos.loadAmigos();

                            Iterator it = resultados.iterator();

                            while(it.hasNext()){
                                Usuario u = (Usuario) it.next();
                                %>
                                    <footer>
                                	<span class="permalink">
                                            <a href="../Interface/Inicio.jsp?login=<%=u.getLogin()%>">
                                            <%=u.getNome()%>
                                            </a>
                                            <%

                                            // Verifica se esse usuário encontrado já é seu amigo, pois se não for aparecerá um botão para "adicionar como amigo", mas se já forem amigos aparecerá "vocês já são amigos | Grupo XYZ"
                                            if(amigos.jaSomosAmigos(u.getLogin()) == true){
                                                %>
                                                 | Vocês já são amigos
                                                <%
                                            }
                                            else
                                            {

                                            %>
                                                | <a href="../Controlador/CreateAmigo.jsp?LoginDoAmigo=<%=u.getLogin()%>&NomeDoAmigo=<%=u.getNome()%>">
                                                       + Amigo
                                                   </a>
                                            <%
                                            }
                                            %>
                                        </span>
                                </footer>
                            <%
                            }
                            %>
				</article>
				<div class="clear">
				</div>
			</div>
		</section>
		<section id="sidebar">
			<div id="sidebarwrap">
				<h2>Sugestão de amigos</h2>
                                    <%
                                    int limite = 5; //limite de amigos sugeridos a ser consultado e exibido
                                    resultados = amigos.getAmigosSugeridos(user.getLogin(), limite);

                                    it = resultados.iterator();

                                    while(it.hasNext()){
                                        Usuario u = (Usuario) it.next();
                                        %>
                                        <footer>
                                            <span class="permalink">
                                                <a href="../Interface/Inicio.jsp?login=<%=u.getLogin()%>">
                                                    <%=u.getNome()%>
                                                </a>

                                                <%

                                                // Verifica se esse usuário encontrado já é seu amigo, pois se não for aparecerá um botão para "adicionar como amigo", mas se já forem amigos aparecerá "vocês já são amigos | Grupo XYZ"
                                                if(amigos.jaSomosAmigos(u.getLogin()) == true){
                                                    %>
                                                     | Vocês já são amigos
                                                    <%
                                                }
                                                else
                                                {

                                                %>

                                                 | <a href="../Controlador/CreateAmigo.jsp?LoginDoAmigo=<%=u.getLogin()%>&NomeDoAmigo=<%=u.getNome()%>">
                                                       + Amigo
                                                   </a>
                                                <%
                                                }
                                          %>
                                          </span>
                                        </footer>
                                        <%
                                    }
                                %>
			</div>
		</section>
		<div class="clear">
		</div>
	</div>
</div>
<footer id="pagefooter">
	<div id="footerwrap">
		<div class="copyright">
			 2012 &copy; Trabalho de Banco de Dados | Ciência da Computação UEL | Professor Daniel Kaster
		</div>
		<div class="credit">
			Desenvolvido por Luiz Villela
		</div>
	</div>
</footer>
</body>
</html>
