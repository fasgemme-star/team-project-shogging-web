<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.productDetail.ProductDTO" %>
<jsp:useBean id="pdService" class="client.productDetail.ProductDetailService" scope="page"/>
<%
    String prdID = request.getParameter("prdID");

    int quantity = 1;
    String qtyParam = request.getParameter("quantity");
    if (qtyParam != null) {
        try { quantity = Integer.parseInt(qtyParam); } catch (NumberFormatException e) { quantity = 1; }
        if (quantity < 1) quantity = 1;
    }

    // ---- ProductDetailService 메소드 연결 ----
    ProductDTO product = (prdID == null) ? null : pdService.getProductInfo(prdID);

    request.setAttribute("product", product);
    request.setAttribute("prdID", prdID);
    request.setAttribute("quantity", quantity);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-max-width mx-auto py-16 px-margin-desktop" id="detail-view">

  <c:choose>
  <c:when test="${empty product}">
    <div class="py-24 text-center text-on-surface-variant">
      <span class="material-symbols-outlined text-6xl text-outline-variant mb-4 block">inventory_2</span>
      상품을 찾을 수 없습니다.
    </div>
  </c:when>
  <c:otherwise>

  <div class="flex flex-col md:flex-row gap-gutter-md">
    <div class="flex-1">
      <img class="w-full aspect-square object-cover rounded-2xl bg-surface-container"
           src="${product.url}" alt="${product.prdName}"
           onerror="this.src='${pageContext.request.contextPath}/images/imgbanner1.png'"/>
    </div>
    <div class="flex-1 py-4">
      <span class="text-on-surface-variant text-body-sm mb-2 block">샛별배송</span>
      <h2 class="text-headline-lg font-headline-lg text-on-surface mb-2">${product.prdName}</h2>
      <p class="text-body-md text-on-surface-variant mb-6">${product.shortInfo}</p>

      <c:set var="unitPrice" value="${product.discount > 0 ? (product.price * (100 - product.discount) / 100) : product.price}"/>

      <div class="text-headline-xl font-bold text-on-surface mb-8">
        <fmt:formatNumber value="${unitPrice}" type="number"/>원
        <c:if test="${product.discount > 0}">
          <span class="text-body-md text-on-surface-variant line-through ml-2"><fmt:formatNumber value="${product.price}" type="number"/>원</span>
          <span class="text-body-md text-primary ml-1">${product.discount}%</span>
        </c:if>
      </div>

      <%-- 수량 선택 + 담기: quantity 파라미터로 현재 페이지를 다시 불러오는 GET 링크 방식 (서블릿 없이 JSP만으로 처리) --%>
      <div class="mb-8 p-4 bg-surface-container-low rounded-xl border border-surface-variant">
        <div class="flex justify-between items-center">
          <span class="font-bold">수량</span>
          <div class="flex items-center border border-outline-variant bg-white rounded-lg">
            <a class="p-2 hover:bg-surface-container transition-colors inline-block ${quantity <= 1 ? 'opacity-30 pointer-events-none' : ''}"
               href="productDetail.jsp?prdID=${prdID}&amp;quantity=${quantity - 1}">
              <span class="material-symbols-outlined text-[20px]">remove</span>
            </a>
            <span class="px-6 font-bold">${quantity}</span>
            <a class="p-2 hover:bg-surface-container transition-colors inline-block" href="productDetail.jsp?prdID=${prdID}&amp;quantity=${quantity + 1}">
              <span class="material-symbols-outlined text-[20px]">add</span>
            </a>
          </div>
        </div>
        <div class="border-t border-surface-variant mt-4 pt-4 flex justify-between items-center">
          <span class="font-bold text-on-surface-variant">총 상품 금액</span>
          <span class="text-headline-md font-bold text-primary"><fmt:formatNumber value="${unitPrice * quantity}" type="number"/>원</span>
        </div>
      </div>

      <form method="post" action="cartAdd.jsp">
        <input type="hidden" name="prdID" value="${prdID}"/>
        <input type="hidden" name="quantity" value="${quantity}"/>
        <input type="hidden" name="redirectTo" value="cart.jsp"/>
        <div class="flex gap-4">
          <button class="flex-1 bg-primary text-on-primary py-4 rounded-lg font-bold text-body-lg" type="submit">장바구니 담기</button>
        </div>
      </form>
    </div>
  </div>

  </c:otherwise>
  </c:choose>

</section>

<%@ include file="common/footer.jsp" %>
