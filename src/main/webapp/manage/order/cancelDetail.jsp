<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manage.ordermanagement.*" %>
<%
String claimID = request.getParameter("claimID");

OrderManagementService oms = new OrderManagementService();
ClaimDTO cDTO = oms.getClaimDetail(claimID, 0);

StringBuilder json = new StringBuilder();

json.append("{");

json.append("\"claimID\":\"")
.append(cDTO.getClaimID())
.append("\",");

json.append("\"requestDate\":\"")
.append(cDTO.getRequestDate())
.append("\",");

json.append("\"clientName\":\"")
.append(cDTO.getClientName())
.append("\",");

json.append("\"clientTel\":\"")
.append(cDTO.getClientTel())
.append("\",");

json.append("\"claimStatus\":\"")
.append(cDTO.getClaimStatus())
.append("\",");

json.append("\"products\":[{");

json.append("\"order_detail_ID\":\"")
.append(cDTO.getOrder_detail_ID())
.append("\",");

json.append("\"prdName\":\"")
.append(cDTO.getPrdName())
.append("\",");

json.append("\"price\":")
.append(cDTO.getPrice())
.append(",");

json.append("\"quantity\":")
.append(cDTO.getQuantity());

json.append("}]");
json.append("}");

out.print(json.toString());
%>
