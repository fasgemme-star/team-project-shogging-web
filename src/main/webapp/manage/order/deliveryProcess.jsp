<%@ page contentType="text/plain; charset=UTF-8"%>
<%@ page import="manage.ordermanagement.*"%>
<%
String[] orderIDs = request.getParameterValues("orderIDs");
OrderManagementService oms = new OrderManagementService();

int successCount = 0;

if(orderIDs != null){
    for(String orderID : orderIDs){
        boolean result = oms.processDelivery(orderID);
        if(result) successCount++;
    }
}

out.print(successCount);
%>
