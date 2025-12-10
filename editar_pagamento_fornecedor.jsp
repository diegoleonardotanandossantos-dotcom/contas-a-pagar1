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
ResultSet rs = null;

int id = Integer.parseInt(request.getParameter("id"));
String represent = "";
String descricao = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, usuario, senha);

    String sql = "SELECT REPRESENT, DECRICAO FROM FORNECEDOR WHERE IDFORNECEDOR = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setInt(1, id);
    rs = stmt.executeQuery();

    if (rs.next()) {
        represent = rs.getString("REPRESENT");
        descricao = rs.getString("DECRICAO");
    }

} catch (Exception e) {
    out.print("Erro: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Editar Pagamento</title></head>
<body style="font-family:Arial; padding:20px;">

<h2>Editar Pagamento do Fornecedor</h2>

<form action="update_pagamento_fornecedor.jsp" method="post">

    <input type="hidden" name="id" value="<%= id %>">

    <label>Fornecedor:</label>
    <input type="text" value="<%= represent %>" readonly
           style="width:400px;padding:8px;margin-bottom:12px;">

    <label>Descrição:</label><br>
    <textarea name="descricao" style="width:400px;height:120px;padding:8px;"><%= descricao %></textarea>

    <br><br>
    <button type="submit" style="padding:10px 18px;background:green;color:white;">Salvar</button>
    <a href="novo_pagamento_fornecedor.jsp?pagamentoSalvo=ok"
       style="padding:10px 18px;background:#555;color:white;text-decoration:none;margin-left:10px;">
       Cancelar
    </a>

</form>

</body>
</html>
