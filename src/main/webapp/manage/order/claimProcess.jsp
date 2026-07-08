<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manage.ordermanagement.*" %>
<%
String claimID = request.getParameter("claimID");
String result = request.getParameter("result");

OrderManagementService oms = new OrderManagementService();
boolean success = oms.processClaimStatus(claimID, result);

out.print("{\"success\":" + success + "}");
%>
