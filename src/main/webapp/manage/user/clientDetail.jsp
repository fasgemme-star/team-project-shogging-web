<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manage.client.ClientService" %>
<%@ page import="manage.client.ClientDTO" %>
<%
ClientService sc = new ClientService();

String clientId = request.getParameter("clientId");
ClientDTO cDTO = sc.getClientDEtail(clientId);

response.setContentType("application/json;charset=UTF-8");

out.print("{");
out.print("\"name\":\""+cDTO.getClientName()+"\",");
out.print("\"email\":\""+cDTO.getEmail()+"\",");
out.print("\"phone\":\""+cDTO.getPhone()+"\",");
out.print("\"joinDate\":\""+cDTO.getJoinDate()+"\",");
out.print("\"totalPayment\":\""+cDTO.getTotalPayment()+"\"");
out.print("}");
%>