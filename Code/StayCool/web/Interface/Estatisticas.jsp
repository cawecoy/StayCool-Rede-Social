<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="model.bean.Post"%>
<%@page import="model.bean.Estatistica"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.bean.Usuario"%>
<%@page import="model.bean.Amigo"%>

<%
        Usuario user;
        user = (Usuario) session.getAttribute("user");
        
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
    function mostraAmigos(){
        document.getElementById("amigo").style.visibility = "visible"
    }
    
    function escondeAmigos(){
        document.getElementById("amigo").style.visibility = "hidden"
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
				<li><a href="../Interface/Inicio.jsp"><%=user.getNome()%></a></li>
				<li><a href="../Interface/Grupos.jsp">Grupos</a></li>
                                <li><a href="../Interface/Amigos.jsp">Amigos</a></li>
				<li class="current"><a href="../Interface/Estatisticas.jsp">Estatísticas</a></li>
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
                        <section id="normalheader" class="header2">

                        </section>
                        <h2>Estatísticas</h2>

                        <article class="post">

                                <form action="../Controlador/ReadEstatisticas.jsp" method="POST">
                                        <p>
                                            <input tabindex="1" type="number" name="dedia" id="dedia" min="1" max="31" size="2" tabindex="2"> 
                                            / <input  type="number" name="demes" id="demes" min="1" max="12" size="2" tabindex="2"> 
                                            / <input type="number" name="deano" id="deano" min="0000" max="9999" size="4" tabindex="3">
                                          <br/>
                                          <label for="desde">
                                             <small>Desde</small>
                                          </label>
                                        </p>
                                        <p>
                                           <input type="number" name="atedia" id="atedia" min="1" max="31" size="2" tabindex="3">
                                           / <input type="number" name="atemes" id="atemes" min="1" max="12" size="2" tabindex="3">
                                           / <input type="number" name="ateano" id="ateano" min="0000" max="9999" size="4" tabindex="3">
                                           <br/>
                                              <label for="login">
                                                  <small>Até</small>
                                              </label>
                                        </p>
                                        <p>
                                       		<input type="radio" name="opcao" value="1" onclick="escondeAmigos();" checked> Os meus três amigos mais publicadores por grupo<br/>
                                                <input type="radio" name="opcao" value="2" onclick="escondeAmigos();"> Os meus dez amigos mais influentes<br/>
                                                <input type="radio" name="opcao" value="3" onclick="escondeAmigos();"> Os dez usuários mais influentes<br/>
                                                <input type="radio" name="opcao" value="4" onclick="escondeAmigos();"> Os três recados de amigos mais influentes por dia<br/>
                                                <input type="radio" name="opcao" value="5" onclick="escondeAmigos();"> Dados sobre meus recados<br/>
                                                <input type="radio" name="opcao" value="6" onclick="mostraAmigos();"> O comportamento de um certo amigo por dia<br/>
                                              <label for="opcao">
                                                 <small>Opção</small>
                                              </label>
                                        </p>
                                        <div id="amigo" style="visibility: hidden;">
                                            <p class="textfield">
                                                <select name="amigo">
                                                    <%
                                                    Amigo amigos = new Amigo(user.getLogin());
                                                    ArrayList lista_amigos = null;

                                                    Iterator itAmigos = null;

                                                    amigos.loadAmigos(); //carrega listaAmigs e Grupo do BD

                                                    lista_amigos = amigos.getlistaDeAmigos();
                                                    itAmigos = lista_amigos.iterator();

                                                    while(itAmigos.hasNext()){
                                                        Amigo a = (Amigo) itAmigos.next();
                                                        %>
                                                        <option value="<%=a.getLogin()%>"><%=a.getNome()%></option>
                                                        <%
                                                    }

                                                    %>
                                                </select><br/>
                                                <label for="amigo">
                                                   <small>Amigo</small>
                                                </label>
                                             </p>
                                        </div>
                                        <p>
                                           <input name="submit" id="submit" tabindex="5" type="image" src="../images/submit.png">
                                        </p>
                                    </form>

                                    <%
                        
			                        if(request.getParameter("estatistica_sucesso") != null){
			                            int opcao = Integer.valueOf(request.getParameter("opcao"));
			                            ArrayList lista_stats = (ArrayList) session.getAttribute("estatistica");
			                            Iterator itResults = null;
			                            
			                            if(opcao == 1){
			                            
			                            %>

                                                    <article class="post">
                                                        <header>
                                                                <h3>Os meus três amigos mais publicadores por grupo</h3>
                                                        </header>
                                                        <p>
			                                
			                                <table class="stats">
			                                    
			                                    <%
			                                    
			                                    itResults = lista_stats.iterator();
			                                    
			                                    String grp = "";
			                                    
			                                    int contador = 0;

			                                    while(itResults.hasNext()){
			                                        Estatistica e = (Estatistica) itResults.next();
			                                        
			                                        if(!e.getGrupo().equals(grp)){
			                                            %>
			                                                
			                                                <tr>
			                                                    <td>&nbsp;</td>
			                                                    <td></td>
			                                                </tr>
			                                                
			                                                <tr>
			                                                    <td><b>Grupo:</b></td>
			                                                    <td><b><%=e.getGrupo()%></b></td>
			                                                </tr>
			                                                
			                                                <tr>
			                                                    <td>Nome</td>
			                                                    <td>Posts</td>
			                                                </tr>
			                                                
			                                            <%
			                                            
			                                            grp = e.getGrupo();
			                                            contador = 0;
			                                        }
			                                        
			                                        if(contador != 3){

			                                            %>

			                                                <tr>
			                                                    <td><a href="../Interface/Inicio.jsp?login=<%=e.getLogin()%>"><%=e.getNome()%></a></td>
			                                                    <td><%=e.getContador()%></td>
			                                                </tr>

			                                            <%

			                                            contador++;
			                                    
			                                        }
			                                    }
			                                    
			                                    %>
			                                    
			                                </table>
                                                    </p>
                                                    </article>
			                                
			                            <%
			                            
			                            }
			                            else if(opcao == 2){
			                            
			                            %>

                                                    <article class="post">
                                                        <header>
                                                                <h3>Os meus dez amigos mais influentes</h3>
                                                        </header>
                                                        <p>
			                                
			                                <table>
			                                    <tr>
			                                        <td>Nome</td>
			                                        <td>Taxa de influência</td>
			                                    </tr>
			                                    
			                                    <%
			                                    
			                                    itResults = lista_stats.iterator();

			                                    while(itResults.hasNext()){
			                                        Estatistica e = (Estatistica) itResults.next();
			                                    
			                                    %>
			                                    
			                                        <tr>
			                                            <td><a href="../Interface/Inicio.jsp?login=<%=e.getLogin()%>"><%=e.getNome()%></a></td>
			                                            <td><%=e.getContador()%></td>
			                                        </tr>
			                                    
			                                    <%
			                                    
			                                    }
			                                    
			                                    %>
			                                    
			                                </table>
			                                </p>
                                                    </article>
			                            <%
			                            
			                            }
			                            else if(opcao == 3){
			                            
			                            %>

			                            <article class="post">
                                                        <header>
                                                                <h3>Os dez usuários mais influentes</h3>
                                                        </header>
                                                        <p>
			                                
			                                <table>
			                                    <tr>
			                                        <td>Nome</td>
			                                        <td>Taxa de influência</td>
			                                    </tr>
			                                    
			                                    <%
			                                    
			                                    itResults = lista_stats.iterator();

			                                    while(itResults.hasNext()){
			                                        Estatistica e = (Estatistica) itResults.next();
			                                    
			                                    %>
			                                    
			                                        <tr>
			                                            <td><a href="../Interface/Inicio.jsp?login=<%=e.getLogin()%>"><%=e.getNome()%></a></td>
			                                            <td><%=e.getContador()%></td>
			                                        </tr>
			                                    
			                                    <%
			                                    
			                                    }
			                                    
			                                    %>
			                                    
			                                </table>
                                                    </p>
                                                    </article>
			                            <%
			                            
			                            }
			                            else if(opcao == 4){
			                                
			                                %>
                                                    <article class="post">
							<header>
								<h3>Os três recadis de amigos mais influentes por dia</h3>
							</header>
							<p>
			                                <h1>Três posts de amigos mais influentes</h1>
			                                
			                                <table>
			                                    
			                                    <%
			                                    
			                                    Date data = new Date(0);
			                                    
			                                    itResults = lista_stats.iterator();
			                                    
			                                    int contador = 0;

			                                    while(itResults.hasNext()){
			                                        Post p = (Post) itResults.next();
			                                        
			                                        Usuario u = new Usuario(p.getLogin());
			                                        u.getUsuarioProfile();
			                                        
			                                        Timestamp t = p.getTime();
			                                        Date d = new Date(t.getTime());
			                                        
			                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			                                        
			                                        String time = sdf.format(d);
			                                        String time2 = sdf.format(data);
			                                        
			                                        if(!time.equals(time2)){
			                                            
			                                        %>

			                                            <tr>
			                                                <td>&nbsp;</td>
			                                                <td></td>
			                                                <td></td>
			                                                <td></td>
			                                            </tr>
			                                            <tr>
			                                                <td>Data:</td>
			                                                <td><%=time%></td>
			                                                <td></td>
			                                                <td></td>
			                                            </tr>
			                                            <tr>
			                                                <td>De</td>
			                                                <td>Para</td>
			                                                <td>ID</td>
			                                                <td>Influência</td>
			                                            </tr>

			                                        <%
			                                        
			                                        data = d;
			                                        
			                                        contador = 0;
			                                    
			                                    }
			                                    
			                                    if(contador != 3){
			                                    
			                                        %>

			                                            <tr>
			                                                <td><a href="../Interface/Inicio.jsp?login=<%=p.getLogin_postador()%>"><%=p.getNome_postador()%></a></td>
			                                                <td><a href="../Interface/Inicio.jsp?login=<%=p.getLogin()%>"><%=p.getNome_profile()%></a></td>
			                                                <td><a href="../Interface/Inicio.jsp?login=<%=p.getLogin()%>#p<%=p.getId()%>" target="_blank"><%=p.getId()%></a></td>
			                                                <td><%=p.getContador()%></td>
			                                            </tr>

			                                        <%
			                                        
			                                        contador++;
			                                        
			                                    }
			                                    
			                                }
			                                    
			                               %>
			                                    
			                                </table>
                                                       </p>
						</article>
			                                    
			                            <%
			                                
			                            }
			                            else if(opcao == 5){
			                                
			                                itResults = lista_stats.iterator();
			                                
			                                Estatistica e;
			                                float media;
			                                
			                                if(itResults.hasNext()){
			                                    media =  (Float) itResults.next();
			                                    
			                                    %>
			                                    
                                                            <article class="post">
                                                                <header>
                                                                        <h3>Média de influência de todos os meus posts</h3>
                                                                </header>
                                                                <p>
                                                                    <%=media%>
                                                                </p>
                                                            </article>
			                                    <%
			                                }
			                                
			                                if(itResults.hasNext()){
			                                    media =  (Float) itResults.next();
			                                    
			                                    %>
			                                    
                                                            <article class="post">
                                                                    <header>
                                                                            <h3>Média de influência dos meus posts no período de entrada</h3>
                                                                    </header>
                                                                    <p>
                                                                        <%=media%>
                                                                    </p>
                                                            </article>
			                                    
			                                    <%
			                                }
			                                
			                                %>
			                                <article class="post">
                                                                <header>
                                                                        <h3>Taxa de influência de cada post meu no período</h3>
                                                                </header>
                                                                <p>
			                                
                                                                    <table>
                                                                        <tr>
                                                                            <td>De</td>
                                                                            <td>Para</td>
                                                                            <td>ID</td>
                                                                            <td>Influência</td>
                                                                        </tr>

                                                                        <%

                                                                        while(itResults.hasNext()){
                                                                            Post p = (Post) itResults.next();

                                                                            Usuario u = new Usuario(p.getLogin());
                                                                            u.getUsuarioProfile();

                                                                        %>

                                                                            <tr>
                                                                                <td><a href="../Interface/Inicio.jsp?login=<%=p.getLogin_postador()%>"><%=p.getNome_postador()%></a></td>
                                                                                <td><a href="../Interface/Inicio.jsp?login=<%=u.getLogin()%>"><%=u.getNome()%></a></td>
                                                                                <td><a href="../Interface/Inicio.jsp?login=<%=p.getLogin()%>#p<%=p.getId()%>" target="_blank"><%=p.getId()%></a></td>
                                                                                <td><%=p.getContador()%></td>
                                                                            </tr>

                                                                        <%

                                                                        }

                                                                        %>

                                                                    </table>
                                                                </p>
                                                        </article>
			                            <%
			                            
			                            }
			                            else if(opcao == 6){
			                                
			                                %>
			                                
                                                    <article class="post">
                                                        <header>
                                                                <h3>O comportamento de um certo amigo por dia</h3>
                                                        </header>
                                                        <p>
			                                
			                                <%
			                                
			                                itResults = lista_stats.iterator();
			                                
			                                if(itResults.hasNext()){
			                                
			                                    Estatistica e = (Estatistica) itResults.next();
			                                    
			                                %>
			                                
			                                    Amigo: <a href="../Interface/Inicio.jsp?login=<%=e.getLogin()%>"><%=e.getNome()%></a>

			                                    <table>
			                                        <tr>
			                                            <td>Data</td>
			                                            <td>Posts</td>
			                                            <td>Curtições</td>
			                                            <td>Comentarios</td>
			                                            <td>Curtições em meus posts</td>
			                                            <td>Comentarios em meus posts</td>
			                                        </tr>
			                                        <tr>
			                                            <td><%=e.getTime()%></td>
			                                            <td><%=e.getNpost()%></td>
			                                            <td><%=e.getNcurtir()%></td>
			                                            <td><%=e.getNcomentario()%></td>
			                                            <td><%=e.getNmeupostcurtir()%></td>
			                                            <td><%=e.getNmeupostcomentario()%></td>
			                                        </tr>
			                                    
			                                <%
			                                
			                                }
			                                
			                                while(itResults.hasNext()){
			                                    Estatistica e = (Estatistica) itResults.next();

			                                %>

			                                    <tr>
			                                        <td><%=e.getTime()%></td>
			                                        <td><%=e.getNpost()%></td>
			                                        <td><%=e.getNcurtir()%></td>
			                                        <td><%=e.getNcomentario()%></td>
			                                        <td><%=e.getNmeupostcurtir()%></td>
			                                        <td><%=e.getNmeupostcomentario()%></td>
			                                    </tr>

			                                <%

			                                }

			                                %>
			                                    
			                                </table>
                                                        </p>
                                                    </article>
			                                <%
			                                
			                            }
			                        }
			                        
			                        %>
									
									<div class="clear"></div>
                                

                                <!--Important--><div class="clear"></div>
                        </article>
                </div>
        </section>
        <div class="clear"></div>
	</div>
</div>
<footer id="pagefooter">
	<div id="footerwrap">
		<div class="copyright">
			 2012 &copy; cawecoy
		</div>
		<div class="credit">
			Desenvolvido por Cawe Coy Rodrigues Marega
		</div>
	</div>
</footer>
</body>
</html>
