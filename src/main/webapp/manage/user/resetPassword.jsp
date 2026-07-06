<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manage.client.ClientService" %>
<%
ClientService cs = new ClientService();

String clientId = request.getParameter("clientId");

if (clientId == null || clientId.trim().isEmpty()) {
	out.print("\"newPw\":\"");
	return;
}

String newPw = cs.changeClientPW(clientId);

response.setContentType("application/json;charset=UTF-8");

out.print("{");
out.print("\"newPw\":\"" + newPw + "\"");
out.print("}");
%>
