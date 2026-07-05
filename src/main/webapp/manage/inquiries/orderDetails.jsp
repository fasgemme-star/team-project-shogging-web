<%@page import="manage.inquiry.OrderDTO"%>
<%@page import="manage.inquiry.InquiryService"%>
<%@page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String orderDetailsId = request.getParameter("orderDetailsId");
InquiryService inquiryService = new InquiryService();
OrderDTO order = inquiryService.getOrderDetail(orderDetailsId);

String orderId = order.getOrderID() == null ? "" : order.getOrderID();
String prdName = order.getPrdName() == null ? "" : order.getPrdName();
String orderDate = order.getOrderDate() == null ? "" : order.getOrderDate();
String deliveryStatus = order.getDeliveryStatus() == null ? "" : order.getDeliveryStatus();

orderId = orderId.replace("\\", "\\\\").replace("\"", "\\\"");
prdName = prdName.replace("\\", "\\\\").replace("\"", "\\\"");
orderDate = orderDate.replace("\\", "\\\\").replace("\"", "\\\"");
deliveryStatus = deliveryStatus.replace("\\", "\\\\").replace("\"", "\\\"");

out.print("{");
out.print("\"orderId\":\"" + orderId + "\",");
out.print("\"prdName\":\"" + prdName + "\",");
out.print("\"quantity\":" + order.getQuantity() + ",");
out.print("\"totalAmount\":" + order.getTotalAmount() + ",");
out.print("\"orderDate\":\"" + orderDate + "\",");
out.print("\"deliveryStatus\":\"" + deliveryStatus + "\"");
out.print("}");
%>
