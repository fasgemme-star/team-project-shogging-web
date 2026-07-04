<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manage.client.ClientService" %>
<%
ClientService cs = new ClientService();

String clientId = request.getParameter("clientId");
String newPw = cs.changeClientPW(clientId);

response.setContentType("application/json;charset=UTF-8");

out.print("{");
out.print("\"newPw\":\"" + newPw + "\"");
out.print("}");
%>