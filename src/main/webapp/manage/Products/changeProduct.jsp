<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manage.searchproduct.SearchProductService" %>
<%@ page import="manage.searchproduct.ProductDTO" %>

<%
request.setCharacterEncoding("UTF-8");

String prdID = request.getParameter("prdID");
String prdName = request.getParameter("prdName");
String quantityStr = request.getParameter("stock");

try {
int quantity = 0;
if (quantityStr != null && !quantityStr.trim().isEmpty()) {
    quantity = Integer.parseInt(quantityStr);
}

ProductDTO dto = new ProductDTO();
dto.setPrdID(prdID);
dto.setPrdName(prdName);
dto.setQuantity(quantity);

SearchProductService sps = new SearchProductService();

sps.changeProduct(dto);
%>

<script>
    alert("수정 성공");
    location.href = "vieweditProducts.jsp";
</script>

<%
} catch (Exception e) {
e.printStackTrace();
%>
<script>
    alert("수정 중 오류가 발생했습니다.");
    history.back();
</script>
<%
}
%>
