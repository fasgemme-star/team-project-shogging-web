<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="manage.addproduct.ProductDTO" %>
<%@ page import="manage.addproduct.ImageDTO" %>
<%@ page import="manage.addproduct.AddProductService" %>
<%
request.setCharacterEncoding("UTF-8");

String priceParam = request.getParameter("price");
String minPurchaseParam = request.getParameter("minPurchase");
String maxPurchaseParam = request.getParameter("maxPurchase");
String discountParam = request.getParameter("discount");
String weightParam = request.getParameter("weight");
String quantityParam = request.getParameter("quantity");

int price = (priceParam == null || priceParam.trim().isEmpty()) ? 0 : Integer.parseInt(priceParam);
int minPurchase = (minPurchaseParam == null || minPurchaseParam.trim().isEmpty()) ? 1 : Integer.parseInt(minPurchaseParam);
int maxPurchase = (maxPurchaseParam == null || maxPurchaseParam.trim().isEmpty()) ? 999999999 : Integer.parseInt(maxPurchaseParam);
int discount = (discountParam == null || discountParam.trim().isEmpty()) ? 0 : Integer.parseInt(discountParam);
int weight = (weightParam == null || weightParam.trim().isEmpty()) ? 0 : Integer.parseInt(weightParam);
int quantity = (quantityParam == null || quantityParam.trim().isEmpty()) ? 0 : Integer.parseInt(quantityParam);

ProductDTO pDTO = new ProductDTO();

pDTO.setCategory(request.getParameter("category"));
pDTO.setPrdName(request.getParameter("prdName"));
pDTO.setPrdDescription(request.getParameter("prdDescription"));

pDTO.setPrice(price);
pDTO.setMinPurchae(minPurchase);
pDTO.setMaxPurchase(maxPurchase);
pDTO.setDiscount(discount);

pDTO.setManufacturer(request.getParameter("manufacturer"));
pDTO.setOrigin(request.getParameter("origin"));
pDTO.setUnderAgePurchase(request.getParameter("underAgePurchase"));
pDTO.setWeight(weight);
pDTO.setExpirationDate(request.getParameter("expirationDate"));
pDTO.setStorageType(request.getParameter("storageType"));
pDTO.setSalesUnit(request.getParameter("salesUnit"));
pDTO.setAdditionalInfo(request.getParameter("additionalInfo"));
pDTO.setQuantity(quantity);

List<ImageDTO> imgList = new ArrayList<ImageDTO>();

String thumbImg = request.getParameter("thumbImg");
String mainImg = request.getParameter("mainImg");
String descImg = request.getParameter("descImg");
String detailImg = request.getParameter("detailImg");

if (thumbImg != null && !thumbImg.trim().isEmpty()) {
imgList.add(new ImageDTO("THUMBNAIL", thumbImg));
}

if (mainImg != null && !mainImg.trim().isEmpty()) {
imgList.add(new ImageDTO("MAIN", mainImg));
}

if (descImg != null && !descImg.trim().isEmpty()) {
imgList.add(new ImageDTO("DESCRIPTION", descImg));
}

if (detailImg != null && !detailImg.trim().isEmpty()) {
imgList.add(new ImageDTO("DETAIL", detailImg));
}

AddProductService service = new AddProductService();

int result = service.addProduct(pDTO, imgList);

if (result > 0) {
response.sendRedirect("addProduct.jsp");
return;
}
%>

<script>
    alert("상품 등록에 실패했습니다.");
    history.back();
</script>
