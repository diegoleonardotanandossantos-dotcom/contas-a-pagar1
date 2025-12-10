<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String host = "160.20.22.99";
String port = "3360";
String banco = "fasiclin";
String usuario = "aluno8";
String senha = "RxpPyKa7Zu8=";
String url = "jdbc:mysql://" + host + ":" + port + "/" + banco +
    "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

Connection conn = null;
PreparedStatement stmt = null;

try {
    int id = Integer.parseInt(request.getParameter("id"));
    String descricao = request.getParameter("descricao");

    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, usuario, senha);

    String sql = "UPDATE FORNECEDOR SET DECRICAO = ? WHERE IDFORNECEDOR = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, descricao);
    stmt.setInt(2, id);
    stmt.executeUpdate();

    response.sendRedirect("novo_pagamento_fornecedor.jsp?pagamentoSalvo=ok&editado=1");

} catch(Exception e){
    out.print("Erro ao atualizar: " + e.getMessage());
} finally {
    try { if(stmt != null) stmt.close(); } catch(Exception e){}
    try { if(conn != null) conn.close(); } catch(Exception e){}
}
%>
