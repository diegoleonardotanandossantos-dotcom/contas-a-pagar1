<%@ page import="java.sql.*" %>
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
PreparedStatement stmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, usuario, senha);

    // Receber dados enviados pelo formulário
    int idFornecedor = Integer.parseInt(request.getParameter("id_fornecedor"));
    String formaPagamento = request.getParameter("forma_pagamento");
    String contaBancaria = request.getParameter("conta_bancaria");
    String agencia = request.getParameter("agencia");
    int prazo = Integer.parseInt(request.getParameter("prazo"));
    double limiteValor = Double.parseDouble(request.getParameter("limite_valor"));

    // Criar descrição salva no banco
    String descricao =
        "Forma de Pagamento: " + formaPagamento + "; " +
        "Conta Bancária: " + contaBancaria + "; " +
        "Agência: " + agencia + "; " +
        "Prazo: " + prazo + " dias; " +
        "Limite: R$ " + limiteValor;

    // Atualizar fornecedor
    String sql = "UPDATE FORNECEDOR SET DECRICAO = ? WHERE IDFORNECEDOR = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, descricao);
    stmt.setInt(2, idFornecedor);
    stmt.executeUpdate();

    // Redirecionar de volta para a página com listagem
    response.sendRedirect("novo_pagamento_fornecedor.jsp?pagamentoSalvo=ok");

} catch(Exception e){
    e.printStackTrace();
    response.sendRedirect("novo_pagamento_fornecedor.jsp?erro=" + e.getMessage());
} finally {
    try { if(stmt != null) stmt.close(); } catch(Exception e){}
    try { if(conn != null) conn.close(); } catch(Exception e){}
}
%>
