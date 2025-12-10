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
String mensagem = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, usuario, senha);

    String sql = "SELECT * FROM FORNECEDOR ORDER BY IDFORNECEDOR";
    stmt = conn.prepareStatement(sql);
    rs = stmt.executeQuery();

} catch(Exception e){
    mensagem = "Erro ao listar fornecedores: " + e.getMessage();
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title>Lista de Fornecedores</title>
<style>
body{font-family:Arial;margin:20px;background:#f4f6f9}
table{border-collapse:collapse;width:100%;background:white;box-shadow:0 2px 8px rgba(0,0,0,0.15)}
th,td{border:1px solid #ddd;padding:10px;text-align:left}
th{background:#2c3e50;color:white}
tr:nth-child(even){background:#f2f2f2}
h1{color:#2c3e50}
</style>
</head>
<body>

<h1>Fornecedores Cadastrados</h1>

<% if(mensagem != null){ %>
    <div style="color:red;"><%= mensagem %></div>
<% } else { %>

<table>
    <tr>
        <th>IDFORNECEDOR</th>
        <th>ID_PESSOA</th>
        <th>REPRESENTANTE</th>
        <th>CONTREPRE</th>
        <th>DESCRIÇÃO</th>
    </tr>
    <% while(rs != null && rs.next()){ %>
        <tr>
            <td><%= rs.getInt("IDFORNECEDOR") %></td>
            <td><%= rs.getInt("ID_PESSOA") %></td>
            <td><%= rs.getString("REPRESENT") %></td>
            <td><%= rs.getString("CONTREPRE") %></td>
            <td><pre style="margin:0"><%= rs.getString("DECRICAO") %></pre></td>
        </tr>
    <% } %>
</table>

<% } %>

</body>
</html>

<%
try { if(rs != null) rs.close(); } catch(Exception e){}
try { if(stmt != null) stmt.close(); } catch(Exception e){}
try { if(conn != null) conn.close(); } catch(Exception e){}
%>

