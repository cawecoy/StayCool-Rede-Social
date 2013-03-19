<%@page import="model.bean.Imagens"%>
<%
    Imagens photo = new Imagens();
    String login = request.getParameter("login");
    
//    InputStream is = photo.getImagem(login);
    String path = request.getSession().getServletContext().getRealPath("/") + "Files/";
    String is = photo.getImagem(login,path);
%>
<!--<a href="../Files/<%=login%>.png"><img class="profilePic" src="../Files/<%=login%>.png" style="width: 50px; height: 50px; border:1px solid black;"/></a>-->
<a href="../Files/<%=login%>.png" target="_blank"><img class="profilePic" src="../Files/<%=login%>.png" style="width: 120px; height: 100px; border:1px solid whitesmoke;"/></a>
