<%@page import="model.bean.Curtir"%>
<%@page import="model.bean.Comentario"%>
<%@page import="model.bean.Post"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.bean.Amigo"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.bean.Usuario"%>

<%
        Usuario user, profile;
        Amigo amigos;
        String login;
        
        user = (Usuario) session.getAttribute("user");
        
        login = request.getParameter("login");
        
        if(login == null){
            profile = user;
        }
        else if(login.equals("")){
            profile = user;
        }
        else{
            profile = new Usuario(login);
            profile.getUsuarioProfile();
        }
        
        amigos = new Amigo(profile.getLogin());
        
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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

<script type="text/javascript">
    function EditarPost(id, login_profile){
        var atual_conteudo = document.getElementById("Post" + id).innerHTML;
        
        var conteudo = prompt("Editando post", atual_conteudo);
        
        if (conteudo != null && conteudo != ""){
            window.location.href = "../Controlador/UpdatePost.jsp?id=" + id + "&conteudo=" + conteudo + "&login_profile=" + login_profile;
        }
    }
    
    function Comentar(id, login_profile){
        var comentario = prompt("Insira seu comentário:", "");
        
        if (comentario != null && comentario != ""){
            window.location.href = "../Controlador/CreateComentario.jsp?idPost=" + id + "&comentario=" + comentario + "&login_profile=" + login_profile;
        }
    }
</script>

</head>
<body>
<div id="bodywrap">
	<section id="pagetop">
		<p id="siteinfo">
			 
		</p>
		<nav id="sitenav">
			<ul>
				<li class="current"><a href="../Interface/Inicio.jsp"><%=user.getNome()%></a></li>
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
			<section id="featured">
			<h2 class="ftheading"></h2>
			<div class="ftwrap">
                            <center>
                                <jsp:include page="../Controlador/ReadImagem.jsp">
                                    <jsp:param name="login" value="<%=profile.getLogin()%>" />
                                </jsp:include>
				<br/>
                                <h3><%=profile.getNome()%></h3>
                                <p>
                                        "<%=profile.getSobre()%>"
                                        <%
                                        Amigo ua = new Amigo(user.getLogin());

                                        if(!profile.getLogin().equals(user.getLogin())){
                                            ua.loadAmigos();

                                            // Verifica se esse usuário encontrado já é seu amigo, pois se não for aparecerá um botão para "adicionar como amigo", mas se já forem amigos aparecerá "vocês já são amigos | Grupo XYZ"
                                            if(ua.jaSomosAmigos(profile.getLogin()) == false){
                                                %>

                                                <form action="../Controlador/CreateAmigo.jsp" method="POST">
                                                    <input type="hidden" name="LoginDoAmigo" value="<%=profile.getLogin()%>"/>
                                                    <input type="hidden" name="NomeDoAmigo" value="<%=profile.getNome()%>"/>
                                                    <br/>
                                                    <input type="submit" value="+ Amigo" name="AdicionarAmigo" class="input" />
                                                </form>
                                                
                                                <%
                                            }
                                            %>
                                            <br/>
                                            <%
                                        }
                                        %>
                                </p>
                            </center>
			</div>
			</section>
			<div id="leftcontainer">	
                    <%
                    if(ua.jaSomosAmigos(profile.getLogin()) || profile.getLogin().equals(user.getLogin())){
                    %>
                    
                <h2 class="mainheading">
                        Deixe um recado
                </h2>
                <form action="../Controlador/CreatePost.jsp" method="POST" enctype="multipart/form-data">
                    <input type="search" name="post" value="" />
                    <input type="hidden" name="login_profile" value="<%=profile.getLogin()%>" />
                    <input type="file" name="File"/>
                    <input type="submit" value="Postar" name="Postar"/>
                </form>
                <h2 class="mainheading">
					Últimos recados
				</h2>
                <%
                            Post lista = new Post();
                            Comentario lista_com = new Comentario();
                            Curtir lista_cur = new Curtir();
                            
                            ArrayList posts;
                            ArrayList comments;
                            ArrayList likes;

                            String path = request.getSession().getServletContext().getRealPath("/") + "Files/";
                            posts = lista.getPosts(profile.getLogin(), path);

                            Iterator itPosts = posts.iterator();
                            Iterator itComments;
                            Iterator itLikes;

                            while(itPosts.hasNext()){
                                Post p = (Post) itPosts.next();
                                
                                likes = lista_cur.getCurtirs(p.getId());
                                itLikes = likes.iterator();
                                %>
                                <article class="post" id="p<%=p.getId()%>">
                                	<header>
                                                <h3><a href="../Interface/Inicio.jsp?login=<%=p.getLogin_postador()%>"><%=p.getNome_postador()%></a> deixou um recado</h3>
                                		<p class="postinfo">
                                			<%=p.getTime().toString()%>
                                		</p>
                                	</header>
                                <%

                                if(p.isPic_post() == true){
                                    %>
                                    <div class="ftimg">
                                        <jsp:include page="../Controlador/ReadPostPic.jsp">
                                            <jsp:param name="id" value="<%=p.getId()%>" />
                                        </jsp:include>
                                    </div>
                                    <%
                                }
                                %>

                                <p id="Post<%=p.getId()%>">
                                	<%=p.getConteudo()%>
                                </p>

                                <footer>
								
                                <%
                                if(!lista_cur.jaCurtiuIsto(user.getLogin())){
                                    %>
                                    <span class="permalink"><a href="../Controlador/CreateCurtir.jsp?idPost=<%=p.getId()%>&login_profile=<%=profile.getLogin()%>">Curtir</a></span>
                                    <%
                                }
                                %>
                                <span class="permalink"><a href="javascript: Comentar(<%=p.getId()%>,'<%=profile.getLogin()%>')">Comentar</a> </span>
                                <%
                                if(p.getLogin_postador().equals(user.getLogin())){
                                    %>
                                    <span class="permalink"><a href="javascript: EditarPost(<%=p.getId()%>,'<%=profile.getLogin()%>')">Editar</a> </span>
                                    <%
                                }

                                if(p.getLogin_postador().equals(user.getLogin()) || p.getLogin().equals(user.getLogin())){
                                    %>
                                    <span class="permalink"><a href="../Controlador/DeletePost.jsp?id=<%=p.getId()%>&login_profile=<%=profile.getLogin()%>">Deletar</a></span>
                                    <%
                                }

                                String nome_pessoas = "";
                                
                                while(itLikes.hasNext()){
                                    Curtir l = (Curtir) itLikes.next();
                                    nome_pessoas += l.getNome() + "\\n";
                                }
                                
                                int n_pessoas = likes.size();
                                
                                if(n_pessoas == 1){
                                    %>
                                    <span class="permalink"><a href="javascript: alert('<%=nome_pessoas%>')">Uma pessoa curtiu isto</a></span>
                                    <%
                                }
                                else if(n_pessoas > 1){
                                    %>
                                    <span class="permalink"><a href="javascript: alert('<%=nome_pessoas%>')"><%=n_pessoas%> pessoas curtiram isto</a></span>
                                    <%
                                }

                                %>
                                </footer>
                                <%
                                
                                comments = lista_com.getComentarios(p.getId());
                                itComments = comments.iterator();
                                
                                while(itComments.hasNext()){
                                    Comentario c = (Comentario) itComments.next();
                                    
                                    %>
                                    
                                    <footer>
                                    	<a href="../Interface/Inicio.jsp?login=<%=c.getLogin()%>"><%=c.getNome()%></a>: <%=c.getComentario()%>
                                    </footer>
                                    <%
                                    
                                }
                            %>
                        	</article>
                            <%
                            }
                        }
                    %>
				<div class="clear">
				</div>
			</div>
		</section>
		<section id="sidebar">
			<div id="sidebarwrap">
				<h2>Amigos</h2>
				<ul>
                                    <%
                                    ArrayList lista_amigos = null;

                                    Iterator itAmigos = null;

                                    amigos.loadAmigos(); //carrega listaAmigs e Grupo do BD

                                    lista_amigos = amigos.getlistaDeAmigos();
                                    itAmigos = lista_amigos.iterator();

                                    while(itAmigos.hasNext()){
                                        Amigo a = (Amigo) itAmigos.next();
                                        %>
                                        <li>
                                            <a href="../Interface/Inicio.jsp?login=<%=a.getLogin()%>">
                                                <%=a.getNome()%>
                                            </a>
                                        </li>
                                        <%
                                    }

                                    %>
				</ul>
			</div>
		</section>
		<div class="clear">
		</div>
	</div>
</div>
<footer id="pagefooter">
	<div id="footerwrap">
		<div class="copyright">
			 2012 &copy;
		</div>
		<div class="credit">
			Desenvolvido por Cawe Coy Rodrigues Marega
		</div>
	</div>
</footer>
</body>
</html>
