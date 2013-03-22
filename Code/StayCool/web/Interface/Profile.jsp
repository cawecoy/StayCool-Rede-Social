<%@page import="model.bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<%
        Usuario user;

        user = (Usuario) session.getAttribute("user");

%>
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
            
            function excluirConta(login){
                var r = confirm("Deseja realmente excluir sua conta?");
                    if (r == true){
                        window.location.href = "../Controlador/DeleteUsuario.jsp?login=" + login
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
                                    <li><a href="../Interface/Grupos.jsp">Grupos</a></li>
                                    <li><a href="../Interface/Amigos.jsp">Amigos</a></li>
                                    <li><a href="../Interface/Estatisticas.jsp">Estatísticas</a></li>
                                    <li class="current"><a href="../Interface/Profile.jsp">Editar perfil</a></li>
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
                                    <h2>Editar meu profile</h2>

                                    <article class="post">

                                            <form action="../Controlador/UpdateUsuario.jsp" method="POST" enctype="multipart/form-data">
                                                    <p class="textfield">
                                                        <input name="nome" value="<%=user.getNome()%>" size="22" tabindex="1" type="text">
                                                          <label for="nome">
                                                             <small>Nome</small>
                                                          </label>
                                                    </p>
                                                    <p class="textfield">
                                                       <input name="login" value="<%=user.getLogin()%>" size="22" tabindex="2" type="text">
                                                          <label for="login">
                                                              <small>Login</small>
                                                          </label>
                                                    </p>
                                                    <p class="textfield">
                                                       <input name="sobre" value="<%=user.getSobre()%>" size="22" tabindex="3" type="text">
                                                          <label for="sobre">
                                                             <small>Sobre mim</small>
                                                          </label>
                                                    </p>
                                                    <p class="textfield">
                                                       <input type="file" name="File" size="22" tabindex="3">
                                                          <label for="File">
                                                             <small>Foto</small>
                                                          </label>
                                                    </p>
                                                    <p class="textfield">
                                                       <input name="senha" value="" size="22" tabindex="3" type="password">
                                                          <label for="senha">
                                                             <small>Senha</small>
                                                          </label>
                                                    </p>
                                                    <p>
                                                       <input name="submit" id="submit" tabindex="5" type="image" src="../images/submit.png">
                                                    </p>
                                                    <p>
                                                        <a href="javascript: excluirConta('<%=user.getLogin()%>');">Excluir minha conta</a>
                                                    </p>
                                                    <div class="clear"></div>
                                            </form>

                                            <!--Important--><div class="clear"></div>
                                    </article>
                            </div>
                    </section>
                    <div class="clear"></div>
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