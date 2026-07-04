<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="manage.category.CategoryService"%>
<%
request.setCharacterEncoding("UTF-8");

String categoryId = request.getParameter("categoryId");
String categoryName = request.getParameter("categoryName");

CategoryService cs = new CategoryService();
int result = cs.modifyCategory(categoryId, categoryName);

out.print("카테고리 수정이 완료되었습니다.");
%>
