<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.productDetail.ProductDTO" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="psService" class="client.productSearch.ProductSearchService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    // ---- 검색어(keyword) 한글 깨짐 방지 ----
    // Tomcat 기본 설정(server.xml URIEncoding 미설정)에서는 GET 방식 쿼리스트링을
    // ISO-8859-1로 디코딩해버려서 request.getParameter()로 받은 한글 검색어가 깨지고,
    // 그 결과 DB 검색 조건이 일치하지 않아 "검색 결과 없음"으로 나온다.
    // 원본 쿼리스트링을 직접 읽어 UTF-8로 재디코딩하면 서버 설정과 무관하게 항상 정상 동작한다.
    String keyword = request.getParameter("keyword");
    String rawQuery = request.getQueryString();
    if (rawQuery != null) {
        for (String pair : rawQuery.split("&")) {
            int eq = pair.indexOf('=');
            if (eq > 0 && "keyword".equals(pair.substring(0, eq))) {
                keyword = java.net.URLDecoder.decode(pair.substring(eq + 1), "UTF-8");
                break;
            }
        }
    }
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
