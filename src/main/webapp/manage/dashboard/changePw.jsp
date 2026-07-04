<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manage.admin.AdminService" %>
<%@ page import="manage.admin.AdminDTO" %>
<%
request.setCharacterEncoding("UTF-8");

String adminId = (String) session.getAttribute("adminId");
String pw = request.getParameter("pw");
String newPw = request.getParameter("newPw");

AdminService as = new AdminService();

boolean result = false;

/* 현재 비밀번호 확인 */
if (as.login(adminId, pw) == 1) {
	AdminDTO aDTO = new AdminDTO();
	aDTO.setAdminID(adminId);
	aDTO.setAdminPW(pw);
	
	/* DB 비밀번호 변경 실행 */
	as.changePW(aDTO, newPw);
	result = true;
}

request.setAttribute("result", result);

RequestDispatcher rd = request.getRequestDispatcher("settings.jsp");
rd.forward(request, response);
%>
