<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
request.setCharacterEncoding("UTF-8");

String host = "160.20.22.99";
String port = "3360";
String banco = "fasiclin";
String usuario = "aluno8";
String senha = "RxpPyKa7Zu8=";
String url = "jdbc:mysql://" + host + ":" + port + "/" + banco +
        "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

Connection conn = null;
PreparedStatement stmtFor = null;
PreparedStatement stmtList = null;
ResultSet rsFor = null;
ResultSet rsList = null;

String pagamentoSalvo = request.getParameter("pagamentoSalvo");
String mensagem = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, usuario, senha);

    // Fornecedores para o select
    String sqlFor = "SELECT IDFORNECEDOR, REPRESENT FROM FORNECEDOR ORDER BY REPRESENT";
    stmtFor = conn.prepareStatement(sqlFor);
    rsFor = stmtFor.executeQuery();

    // Carregar lista completa APENAS SE pagamento foi salvo
    if ("ok".equals(pagamentoSalvo)) {
        String sqlList = "SELECT IDFORNECEDOR, REPRESENT, DECRICAO FROM FORNECEDOR ORDER BY REPRESENT";
        stmtList = conn.prepareStatement(sqlList);
        rsList = stmtList.executeQuery();
    }

} catch(Exception e){
    mensagem = "Erro ao carregar fornecedores: " + e.getMessage();
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title>Configuração de Pagamento</title>
<style>
body{margin:0;font-family:Arial;background:#f4f6f9}
.form-box{background:white;padding:25px;width:700px;margin:40px auto;border-radius:10px;box-shadow:0 3px 7px rgba(0,0,0,.2)}
input,select,textarea{width:100%;padding:10px;border:1px solid #ccc;border-radius:8px;margin-bottom:13px}
button{background:#27ae60;border:none;padding:12px 22px;color:white;border-radius:8px;cursor:pointer}
.table-box{background:white;padding:25px;width:900px;margin:20px auto;border-radius:10px;box-shadow:0 3px 7px rgba(0,0,0,.2)}
table{width:100%;border-collapse:collapse;margin-top:15px}
th,td{padding:10px;border:1px solid #ccc;text-align:left}
th{background:#e8e8e8}
.btn-pdf{background:#34495e;color:white;padding:10px 18px;border:none;border-radius:8px;cursor:pointer;margin-bottom:10px}
.btn-edit{background:#2980b9;color:white;padding:6px 12px;border:none;border-radius:6px;cursor:pointer}
</style>
</head>
<body>

<div class="form-box">
    <h2>Configuração de Pagamento</h2>

    <% if(mensagem != null){ %>
        <div style="background:#f8d7da;padding:10px;color:#721c24;border-radius:6px;margin-bottom:18px;">
            <%= mensagem %>
        </div>
    <% } %>

    <form action="salvar_pagamento_fornecedor.jsp" method="post">

        <label><b>Fornecedor:</b></label>
        <select name="id_fornecedor" required>
            <option value="">Selecione...</option>
            <% while(rsFor != null && rsFor.next()){ %>
                <option value="<%= rsFor.getInt("IDFORNECEDOR") %>">
                    <%= rsFor.getString("REPRESENT") %>
                </option>
            <% } %>
        </select>

        <label><b>Forma de Pagamento:</b></label>
        <select name="forma_pagamento" required>
            <option value="PIX">PIX</option>
            <option value="DINHEIRO">Dinheiro</option>
            <option value="CARTAO">Cartão</option>
        </select>

        <label><b>Conta Bancária:</b></label>
        <input type="text" name="conta_bancaria" placeholder="Número da conta" required>

        <label><b>Agência:</b></label>
        <input type="text" name="agencia" placeholder="Agência bancária" required>

        <label><b>Prazo de Pagamento (dias):</b></label>
        <input type="number" name="prazo" min="0" required>

        <label><b>Limite de Valor:</b></label>
        <input type="number" step="0.01" name="limite_valor" min="0" required>

        <button type="submit">Salvar Pagamento</button>
    </form>
</div>


<!-- =============================== -->
<!-- LISTAGEM — APARECE APÓS SALVAR -->
<!-- =============================== -->

<% if ("ok".equals(pagamentoSalvo)) { %>

<div class="table-box">
    <h2>Ordens de Pagamento</h2>

    <button class="btn-pdf">Exportar PDF</button>

   <table>
    <tr>
        <th>ID</th>
        <th>Representante</th>
        <th>Descrição</th>
        <th style="text-align:center;">Ações</th>
    </tr>

    <% 
    try {
        while(rsList != null && rsList.next()){
    %>
        <tr>
            <td><%= rsList.getInt("IDFORNECEDOR") %></td>
            <td><%= rsList.getString("REPRESENT") %></td>
            <td><%= rsList.getString("DECRICAO") %></td>

            <!-- COLUNA DE AÇÕES ORGANIZADA -->
            <td style="text-align:center; white-space: nowrap;">

                <a href="editar_pagamento_fornecedor.jsp?id=<%= rsList.getInt("IDFORNECEDOR") %>" 
                   style="background:#2980b9;color:white;padding:6px 14px;border-radius:6px;text-decoration:none;margin-right:8px;display:inline-block;">
                   Editar
                </a>

                <a href="excluir_fornecedor.jsp?id=<%= rsList.getInt("IDFORNECEDOR") %>" 
                   style="background:#c0392b;color:white;padding:6px 14px;border-radius:6px;text-decoration:none;display:inline-block;"
                   onclick="return confirm('Tem certeza que deseja excluir este fornecedor?');">
                   Excluir
                </a>

            </td>
        </tr>
    <% 
        }
    } catch(Exception ex){
        out.print("Erro ao listar: " + ex.getMessage());
    }
    %>
</table>


</div>

<% } %>


<%
try { if(rsFor != null) rsFor.close(); } catch(Exception e){}
try { if(rsList != null) rsList.close(); } catch(Exception e){}
try { if(stmtFor != null) stmtFor.close(); } catch(Exception e){}
try { if(stmtList != null) stmtList.close(); } catch(Exception e){}
try { if(conn != null) conn.close(); } catch(Exception e){}
%>

</body>
</html>
