
<%@page import="model.bean.Amigo"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.bean.Grupo"%>
<%@page import="model.bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">

<%
        Usuario user;
        Amigo amigos;
        Grupo grupos;

        user = (Usuario) session.getAttribute("user");
        
        amigos = new Amigo(user.getLogin());
        grupos = new Grupo(user.getLogin());
        
%>

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
        
        <script type="text/javascript">
            function EditarGrupo(atual_nome){
                var novo_nome = prompt("Editando nome do grupo", atual_nome);

                if (novo_nome != null && novo_nome != ""){
                    window.location.href = "../Controlador/UpdateGrupo.jsp?atual_nome=" + atual_nome + "&novo_nome=" + novo_nome;
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
                                    <li><a href="../Interface/Inicio.jsp"><%=user.getNome()%></a></li>
                                    <li class="current"><a href="../Interface/Grupos.jsp">Grupos</a></li>
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
                                            Cadastrar novo grupo
                                    </h2>
                                    <form action="../Controlador/CreateGrupo.jsp" method="POST">
                                        <input type="search" name="titulo" value="" class="input" />
                                        <input type="submit" value="Cadastrar novo grupo" name="CadastrarGrupo" class="input" />
                                    </form>
                                    <h2 class="mainheading">
                                        Meus grupos
                                    </h2>

                                    <%
                                        ArrayList lista_grupos = null;
                                        ArrayList lista_amigos = null;
                                        ArrayList lista_edita_grupos = null;

                                        Iterator itGrupos = null;
                                        Iterator itEditaGrupos = null;
                                        Iterator itAmigos = null;

                                        amigos.loadAmigos(); //carrega listaAmigs e Grupo do BD
                                        grupos.loadGrupos();

                                        lista_grupos = grupos.getGrupos();
                                        itGrupos = lista_grupos.iterator();

                                        while(itGrupos.hasNext()){
                                            String nome_grupo = (String) itGrupos.next();
                                            %>
                                            <article class="post">
                                                <header>
                                                        <h3><%=nome_grupo%></h3>
                                                        <p class="postinfo">
                                                                <a href="javascript: EditarGrupo('<%=nome_grupo%>')">Editar grupo</a> | <a href="../Controlador/DeleteGrupo.jsp?titulo=<%=nome_grupo%>">Excluir grupo</a>
                                                        </p>
                                                </header>
                                        <%

                                            lista_amigos = amigos.getListaPorGrupo(nome_grupo, user.getLogin());
                                            itAmigos = lista_amigos.iterator();

                                            if(lista_amigos.isEmpty()){
                                                %>

                                                Grupo vazio

                                                <%
                                            }

                                            while(itAmigos.hasNext()){
                                                Amigo a = (Amigo) itAmigos.next();
                                                %>
                                                <footer>
                                                    <span class="permalink">
                                                        <a href="../Interface/Inicio.jsp?login=<%=a.getLogin()%>">
                                                            <%=a.getNome()%>
                                                        </a> | 
                                                        <a href="../Controlador/DeleteAmigoDoGrupo.jsp?LoginDoAmigo=<%=a.getLogin()%>&Grupo=<%=nome_grupo%>" color="#FF0000">
                                                            <img src="../x.png"/>
                                                        </a>
                                                    </span>
                                                </footer>
                                                <%
                                            }
                                            %>

                                        </article> 

                                        <%
                                        }

                                    %>
                                    <div class="clear">
                                    </div>
                            </div>
                    </section>
                    <section id="sidebar">
                            <div id="sidebarwrap">
                            </div>
                    </section>
                    <div class="clear">
                    </div>
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
