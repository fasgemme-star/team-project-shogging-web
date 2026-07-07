<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.productDetail.ProductDTO" %>
<%@ page import="client.usermain.RangeDTO" %>
<jsp:useBean id="umService" class="client.usermain.UserMainService" scope="page"/>
<%
    // ---- 파라미터 처리 ----
    String category = request.getParameter("category");
    if (category == null || category.trim().isEmpty()) category = "베스트";

    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try { currentPage = Integer.parseInt(pageParam); } catch (NumberFormatException e) { currentPage = 1; }
        if (currentPage < 1) currentPage = 1;
    }

    // ---- UserMainService 메소드 연결 ----
    // "베스트"/"알뜰쇼핑"/"신상품"은 CATEGORY 테이블의 실제 카테고리명이 아니라
    // 홈 화면과 동일한 베스트/세일 목록을 그대로 보여준다 (페이징 없음).
    List<ProductDTO> productList;
    int totalCount;
    int totalPage;

    if ("베스트".equals(category) || "신상품".equals(category)) {
        productList = umService.searchBest();
        totalCount = productList.size();
        totalPage = 1;
    } else if ("알뜰쇼핑".equals(category)) {
        productList = umService.searchSale();
        totalCount = productList.size();
        totalPage = 1;
    } else {
        // 잎채소/뿌리채소 등 실제 카테고리는 페이징 조회
        RangeDTO range = new RangeDTO();
        range.setKeyword(category);
        range.setCurrentPage(currentPage);

        productList = umService.getCategory(range);            // 카테고리별 상품 목록(페이징 반영)
        totalCount  = umService.totalCount(range);              // 카테고리별 전체 상품 수
        int pageScale = umService.pageScale();                  // 페이지당 개수
        totalPage = umService.totalPage(totalCount, pageScale); // 전체 페이지 수
    }

    request.setAttribute("category", category);
    request.setAttribute("productList", productList);
    request.setAttribute("totalCount", totalCount);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPage", totalPage);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-max-width mx-auto py-16 px-margin-desktop" id="category-view">

  <div class="flex flex-col items-center mb-10">
    <h2 class="text-headline-xl font-headline-xl text-on-surface mb-2">${category}</h2>
    <p class="text-body-md text-on-surface-variant">총 ${totalCount}개의 상품</p>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter-md">
    <c:choose>
      <c:when test="${empty productList}">
        <div class="col-span-full py-20 text-center text-on-surface-variant">
          <span class="material-symbols-outlined text-6xl text-outline-variant mb-4 block">inventory_2</span>
          해당 카테고리에 상품이 없습니다.
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach var="p" items="${productList}">
          <%@ include file="common/productCard.jspf" %>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- 페이징 --%>
  <c:if test="${totalPage > 1}">
  <div class="flex justify-center items-center gap-2 mt-16">
    <c:if test="${currentPage > 1}">
      <a class="px-3 py-2 rounded-lg border border-surface-variant hover:bg-surface-container" href="category.jsp?category=${category}&amp;page=${currentPage - 1}">이전</a>
    </c:if>
    <c:forEach var="pg" begin="1" end="${totalPage}">
      <a class="px-4 py-2 rounded-lg ${pg == currentPage ? 'bg-primary text-on-primary font-bold' : 'border border-surface-variant hover:bg-surface-container'}"
         href="category.jsp?category=${category}&amp;page=${pg}">${pg}</a>
    </c:forEach>
    <c:if test="${currentPage < totalPage}">
      <a class="px-3 py-2 rounded-lg border border-surface-variant hover:bg-surface-container" href="category.jsp?category=${category}&amp;page=${currentPage + 1}">다음</a>
    </c:if>
  </div>
  </c:if>

</section>

<%@ include file="common/footer.jsp" %>
