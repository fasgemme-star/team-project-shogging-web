<%@ page contentType="application/json; charset=UTF-8"%>
<%@ page import="manage.ordermanagement.*"%>
<%@ page import="java.util.*"%>

<%
String claimID = request.getParameter("claimID");

OrderManagementService oms = new OrderManagementService();

ClaimDTO dto = oms.getClaimDetail(claimID, 0);

StringBuilder json = new StringBuilder();

json.append("{");

json.append("\"claimID\":\"").append(dto.getClaimID()).append("\",");
json.append("\"requestDate\":\"").append(dto.getRequestDate()).append("\",");
json.append("\"clientName\":\"").append(dto.getClientName()).append("\",");
json.append("\"tel\":\"").append(dto.getClientTel()).append("\",");
json.append("\"status\":\"").append(dto.getClaimType()).append("\",");
json.append("\"reasonDetail\":\"").append(dto.getReasonDetail()).append("\",");

json.append("\"product\":{");
json.append("\"optionID\":\"").append(dto.getOptionID()).append("\",");
json.append("\"prdName\":\"").append(dto.getPrdName()).append("\"");
json.append("},");

json.append("\"images\":[");

if(dto.getImg() != null){
    for(int i=0;i<dto.getImg().size();i++){
        json.append("\"").append(dto.getImg().get(i)).append("\"");
        if(i < dto.getImg().size()-1) json.append(",");
    }
}

json.append("]");
json.append("}");

out.print(json.toString());
%>
