<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manage.client.ClientService" %>
<%
ClientService sc = new ClientService();

String newPw = request.getParameter("newPw");
sc.sendEmailNewPw(newPw);

%>