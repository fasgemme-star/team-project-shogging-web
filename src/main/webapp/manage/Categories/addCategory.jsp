<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="manage.category.CategoryService"%>
<%
request.setCharacterEncoding("UTF-8");

String categoryName = request.getParameter("categoryName");

CategoryService cs = new CategoryService();
cs.addCategory(categoryName);

out.print("카테고리를 추가하였습니다.");
%>