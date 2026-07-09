<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manage.ordermanagement.*" %>
<%
String claimID = request.getParameter("claimID");

OrderManagementService oms = new OrderManagementService();

ClaimDTO cDTO = oms.getClaimDetail(claimID, 1);

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

json.append("\"reason\":\"")
.append(cDTO.getReason())
.append("\",");

json.append("\"reasonDetail\":\"")
.append(cDTO.getReasonDetail())
.append("\",");

json.append("\"img\":[");

if (cDTO.getImg() != null) {
for (int i = 0; i < cDTO.getImg().size(); i++) {
if (i > 0) {
json.append(",");
}
json.append("\"")
.append(cDTO.getImg().get(i))
.append("\"");
}
}

json.append("],");

json.append("\"products\":[{");

json.append("\"claimStatus\":\"")
.append(cDTO.getClaimStatus())
.append("\",");

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
