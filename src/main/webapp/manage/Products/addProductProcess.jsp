<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="manage.addproduct.ProductDTO" %>
<%@ page import="manage.addproduct.ImageDTO" %>
<%@ page import="manage.addproduct.AddProductService" %>
<%
request.setCharacterEncoding("UTF-8");

String priceParam = request.getParameter("price");//가격
String minPurchaseParam = request.getParameter("minPurchase");//최소구매수량
String maxPurchaseParam = request.getParameter("maxPurchase");//최대구매수량
String discountParam = request.getParameter("discount");//할인율
String quantityParam = request.getParameter("quantity");//판매수량

int price = (priceParam == null || priceParam.trim().isEmpty()) ? 0 : Integer.parseInt(priceParam);
int minPurchase = (minPurchaseParam == null || minPurchaseParam.trim().isEmpty()) ? 1 : Integer.parseInt(minPurchaseParam);
int maxPurchase = (maxPurchaseParam == null || maxPurchaseParam.trim().isEmpty()) ? 999999999 : Integer.parseInt(maxPurchaseParam);
int discount = (discountParam == null || discountParam.trim().isEmpty()) ? 0 : Integer.parseInt(discountParam);
int quantity = (quantityParam == null || quantityParam.trim().isEmpty()) ? 0 : Integer.parseInt(quantityParam);

ProductDTO pDTO = new ProductDTO();

pDTO.setCategory(request.getParameter("category"));//카테고리
pDTO.setPrdName(request.getParameter("prdName"));//상품명
pDTO.setPrdType(request.getParameter("prdType"));//상품타입
pDTO.setShortInfo(request.getParameter("shortInfo"));//짧은소개
pDTO.setPrdDescription(request.getParameter("prdDescription"));//상품설명 -> description

pDTO.setPrice(price);
pDTO.setMinPurchae(minPurchase);
pDTO.setMaxPurchase(maxPurchase);
pDTO.setDiscount(discount);

pDTO.setManufacturer(request.getParameter("manufacturer"));//제조사
pDTO.setOrigin(request.getParameter("origin"));//원산지
pDTO.setUnderAgePurchase(request.getParameter("underAgePurchase"));//미성년자구매
pDTO.setWeight(request.getParameter("weight"));//용량
pDTO.setExpirationDate(request.getParameter("expirationDate"));//유통기한
pDTO.setStorageType(request.getParameter("storageType"));//보관방법
pDTO.setSalesUnit(request.getParameter("salesUnit"));//판매단위
pDTO.setNotice(request.getParameter("notice"));//주의사항
pDTO.setAdditionalInfo(request.getParameter("additionalInfo"));//추가정보
pDTO.setQuantity(quantity);

List<ImageDTO> imgList = new ArrayList<ImageDTO>();

String thumbImg = request.getParameter("thumbImg");
String mainImg = request.getParameter("mainImg");
String descImg = request.getParameter("descImg");
String detailImg = request.getParameter("detailImg");

if (thumbImg != null && !thumbImg.trim().equals("")) {
	ImageDTO thumbDTO = new ImageDTO();
	thumbDTO.setImageType("THUMB");
	thumbDTO.setUrl(thumbImg);
	imgList.add(thumbDTO);
}

if (mainImg != null && !mainImg.trim().equals("")) {
	ImageDTO mainDTO = new ImageDTO();
	mainDTO.setImageType("MAIN");
	mainDTO.setUrl(mainImg);
	imgList.add(mainDTO);
}

if (descImg != null && !descImg.trim().equals("")) {
	ImageDTO descDTO = new ImageDTO();
	descDTO.setImageType("DESC");
	descDTO.setUrl(descImg);
	imgList.add(descDTO);
}

if (detailImg != null && !detailImg.trim().equals("")) {
	ImageDTO detailDTO = new ImageDTO();
	detailDTO.setImageType("DETAIL");
	detailDTO.setUrl(detailImg);
	imgList.add(detailDTO);
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
