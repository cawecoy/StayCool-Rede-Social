<%
    String id = request.getParameter("id");
    
//    InputStream is = photo.getImagem(login);
    String path = request.getSession().getServletContext().getRealPath("/") + "Files/";
%>
<a href="../Files/Post<%=id%>.png" target="_blank"><img class="postPic" src="../Files/Post<%=id%>.png" style="width: 200px; height: 200px; border:1px solid whitesmoke;"/></a>
