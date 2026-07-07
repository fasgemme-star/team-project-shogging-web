<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.productDetail.ProductDTO" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="psService" class="client.productSearch.ProductSearchService" scope="page"/>
<%
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";
    keyword = keyword.trim();

    // ---- ProductSearchService 메소드 연결 ----
    List<ProductDTO> resultList = keyword.isEmpty()
            ? java.util.Collections.<ProductDTO>emptyList()
            : psService.searchProduct(keyword);                 // 상품명 검색

    request.setAttribute("keyword", keyword);
    request.setAttribute("resultList", resultList);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-max-width mx-auto py-16 px-margin-desktop" id="search-view">
  <h2 class="text-headline-lg font-headline-lg text-on-surface mb-2">'<c:out value="${keyword}"/>' 검색 결과</h2>
  <p class="text-body-md text-on-surface-variant mb-10">총 ${fn:length(resultList)}개의 상품이 검색되었습니다.</p>

  <c:choose>
    <c:when test="${empty resultList}">
      <div class="flex flex-col items-center justify-center py-20">
        <span class="material-symbols-outlined text-6xl text-outline-variant mb-4">search_off</span>
        <p class="text-on-surface-variant">검색 결과가 없습니다. 다른 검색어를 입력해 보세요.</p>
      </div>
    </c:when>
    <c:otherwise>
      <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter-md">
        <c:forEach var="p" items="${resultList}">
          <%@ include file="common/productCard.jspf" %>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</section>

<%@ include file="common/footer.jsp" %>
