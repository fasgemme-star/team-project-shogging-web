<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="manage.category.CategoryService"%>
<%
request.setCharacterEncoding("UTF-8");

String categoryId = request.getParameter("categoryId");

CategoryService cs = new CategoryService();
int result = cs.removeCategory(categoryId);
out.print(result);
/* out.print("카테고리가 삭제 되었습니다."); */
%>
