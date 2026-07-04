<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String adminId = (String)session.getAttribute("adminId");
if(adminId == null){
    response.sendRedirect("../login/login.jsp");
    return;
}
%>