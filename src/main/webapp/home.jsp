<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.productDetail.ProductDTO" %>
<jsp:useBean id="umService" class="client.usermain.UserMainService" scope="page"/>
<%
    // ---- UserMainService 메소드 연결 ----
    List<ProductDTO> bestList = umService.searchBest();   // 베스트 상품 목록
    List<ProductDTO> saleList = umService.searchSale();   // 세일 상품 목록
    String[] banners = umService.getBannerImages();       // 배너 이미지 경로

    request.setAttribute("bestList", bestList);
    request.setAttribute("saleList", saleList);
    request.setAttribute("banners", banners);
%>
<%@ include file="common/header.jsp" %>

<!-- HOME VIEW -->
<section id="home-view">

  <!-- Hero Banner -->
  <div class="relative w-full h-[500px] overflow-hidden bg-surface-container">
    <div class="absolute inset-0 bg-cover bg-center"
         style="background-image: url('${pageContext.request.contextPath}/${banners[0]}')"></div>
    <div class="absolute inset-0 bg-gradient-to-r from-black/50 to-transparent"></div>
    <div class="relative max-w-max-width mx-auto h-full flex flex-col justify-center px-margin-desktop text-white">
      <span class="bg-primary text-on-primary px-4 py-1 rounded-full text-label-md w-fit mb-4">TODAY'S HARVEST</span>
      <h1 class="font-headline-xl text-headline-xl mb-4 leading-tight">오늘 수확한<br/>프리미엄 유기농 채소</h1>
      <p class="text-body-lg mb-8 max-w-md">새벽 샛별배송으로 가장 신선한 식탁을 준비하세요. 농장에서 바로 온 프리미엄 퀄리티.</p>
      <a class="bg-primary-container text-on-primary-container px-8 py-4 rounded-lg font-bold text-body-md hover:opacity-90 transition-opacity w-fit shadow-lg shadow-primary/20"
         href="${pageContext.request.contextPath}/category.jsp?category=베스트">지금 쇼핑하기</a>
    </div>
  </div>

  <!-- Best Sellers -->
  <section class="max-w-max-width mx-auto px-margin-desktop py-16">
    <div class="flex justify-between items-end mb-10">
      <div>
        <h2 class="text-headline-lg font-headline-lg text-on-surface">인기 상품 리스트</h2>
        <p class="text-body-md text-on-surface-variant">프레시마켓 고객들이 가장 많이 찾는 제품들</p>
      </div>
      <a class="text-primary font-bold hover:underline flex items-center gap-1" href="${pageContext.request.contextPath}/category.jsp?category=베스트">
        전체보기 <span class="material-symbols-outlined text-sm">arrow_forward</span>
      </a>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter-md">
      <c:choose>
        <c:when test="${empty bestList}">
          <div class="col-span-full py-16 text-center text-on-surface-variant">등록된 베스트 상품이 없습니다.</div>
        </c:when>
        <c:otherwise>
          <c:forEach var="p" items="${bestList}">
            <%@ include file="common/productCard.jspf" %>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </section>

  <!-- Sale Products -->
  <section class="max-w-max-width mx-auto px-margin-desktop py-16">
    <div class="flex justify-between items-end mb-10">
      <div>
        <h2 class="text-headline-lg font-headline-lg text-on-surface">알뜰 세일 상품</h2>
        <p class="text-body-md text-on-surface-variant">할인율 높은 순으로 모아봤어요</p>
      </div>
      <a class="text-primary font-bold hover:underline flex items-center gap-1" href="${pageContext.request.contextPath}/category.jsp?category=알뜰쇼핑">
        전체보기 <span class="material-symbols-outlined text-sm">arrow_forward</span>
      </a>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter-md">
      <c:choose>
        <c:when test="${empty saleList}">
          <div class="col-span-full py-16 text-center text-on-surface-variant">등록된 세일 상품이 없습니다.</div>
        </c:when>
        <c:otherwise>
          <c:forEach var="p" items="${saleList}">
            <%@ include file="common/productCard.jspf" %>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </section>

</section>

<%@ include file="common/footer.jsp" %>
