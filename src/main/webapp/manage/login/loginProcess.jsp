<%@ page language="java" contentType="text/html; charset=UTF-8"
			pageEncoding="UTF-8"%>
<%@ page import="manage.admin.AdminService"%>
<%
request.setCharacterEncoding("UTF-8");

String id = request.getParameter("id");
String password = request.getParameter("password");

AdminService as = new AdminService();
int result = as.login(id, password);

if (result == 1) {
	session.setAttribute("adminId", id);
	response.sendRedirect("../dashboard/dashboard.jsp");
} else {
	response.sendRedirect("login.jsp?flag=N");
}
%>
