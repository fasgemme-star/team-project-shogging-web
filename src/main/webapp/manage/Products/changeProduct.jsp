<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="manage.searchproduct.SearchProductService" %>
<%@ page import="manage.searchproduct.ProductDTO" %>
<%
request.setCharacterEncoding("UTF-8");

String prdID = request.getParameter("prdID");
String prdName = request.getParameter("prdName");
String stockStr = request.getParameter("stock");

int stock = 0;
if(stockStr != null && !stockStr.equals("")){
    stock = Integer.parseInt(stockStr);
}

ProductDTO dto = new ProductDTO();
dto.setPrdID(prdID);
dto.setPrdName(prdName);
dto.setStock(stock);

SearchProductService sps = new SearchProductService();
int result = sps.changeProduct(dto);

if(result > 0){
%>
<script>
alert("수정 성공");
location.href="vieweditProducts.jsp";
</script>
<%
} else {
%>
<script>
alert("수정 실패");
history.back();
</script>
<%
}
%>