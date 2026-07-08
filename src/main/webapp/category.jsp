<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.productDetail.ProductDTO" %>
<%@ page import="client.usermain.RangeDTO" %>
<jsp:useBean id="umService" class="client.usermain.UserMainService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    // ---- 파라미터 처리 ----
    // category 값(베스트/신상품/알뜰쇼핑/잎채소 등)이 한글이라 GET 쿼리스트링으로 넘어올 때
    // 서버 설정에 따라 깨질 수 있으므로 원본 쿼리스트링을 UTF-8로 직접 재디코딩한다.
    String category = request.getParameter("category");
    String rawQuery = request.getQueryString();
    if (rawQuery != null) {
        for (String pair : rawQuery.split("&")) {
            int eq = pair.indexOf('=');
            if (eq > 0 && "category".equals(pair.substring(0, eq))) {
                category = java.net.URLDecoder.decode(pair.substring(eq + 1), "UTF-8");
                break;
            }
        }
    }
    if (category == null || category.trim().isEmpty()) category = "베스트";

    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try { currentPage = Integer.parseInt(pageParam); } catch (NumberFormatException e) { currentPage = 1; }
        if (currentPage < 1) currentPage = 1;
    }

    // ---- 세부 탭(sub-tab) 처리 ----
    // 베스트/알뜰쇼핑/일반 카테고리별로 보여줄 세부 탭 목록과, 그 중 사용자가 선택한 탭(sort)
    String sort = request.getParameter("sort");
    if (sort == null || sort.trim().isEmpty()) sort = "default";

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

    // ---- 세부 탭 목록 정의 (key, 화면표시명) ----
    // key/label 쌍의 배열: {탭key, 탭라벨}
    String[][] subTabs;
    if ("베스트".equals(category)) {
        subTabs = new String[][] { {"default", "베스트랭킹"}, {"trending", "인기급상승"} };
    } else if ("알뜰쇼핑".equals(category)) {
        subTabs = new String[][] { {"default", "알뜰쇼핑"}, {"halfsale", "반값세일"} };
    } else {
        subTabs = new String[][] { {"default", "전체보기"}, {"recommend", "추천순"}, {"newest", "신상품순"}, {"lowprice", "낮은가격순"} };
    }
    // 존재하지 않는 sort 값이 넘어오면 기본값으로
    boolean validSort = false;
    for (String[] t : subTabs) { if (t[0].equals(sort)) { validSort = true; break; } }
    if (!validSort) sort = "default";

    // ---- 선택된 탭에 따른 정렬/필터 적용 ----
    productList = new java.util.ArrayList<ProductDTO>(productList);
    if ("halfsale".equals(sort)) {
        java.util.List<ProductDTO> filtered = new java.util.ArrayList<ProductDTO>();
        for (ProductDTO p : productList) { if (p.getDiscount() >= 50) filtered.add(p); }
        productList = filtered;
        totalCount = productList.size();
    } else if ("trending".equals(sort) || "newest".equals(sort)) {
        java.util.Collections.sort(productList, new java.util.Comparator<ProductDTO>() {
            public int compare(ProductDTO a, ProductDTO b) {
                java.sql.Date da = a.getProductInputDate(), db = b.getProductInputDate();
                if (da == null || db == null) return 0;
                return db.compareTo(da); // 최신순(내림차순)
            }
        });
    } else if ("lowprice".equals(sort)) {
        java.util.Collections.sort(productList, new java.util.Comparator<ProductDTO>() {
            public int compare(ProductDTO a, ProductDTO b) {
                int priceA = a.getPrice() * (100 - a.getDiscount()) / 100;
                int priceB = b.getPrice() * (100 - b.getDiscount()) / 100;
                return priceA - priceB; // 낮은가격순(오름차순)
            }
        });
    }

    request.setAttribute("category", category);
    request.setAttribute("sort", sort);
    request.setAttribute("subTabs", subTabs);
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

  <%-- 세부 탭 --%>
  <div class="flex gap-gutter-md border-b border-surface-variant w-full justify-center mb-10">
    <c:forEach var="tab" items="${subTabs}">
      <a class="px-6 py-4 text-body-md transition-all border-b-2 ${tab[0] == sort ? 'sub-tab-active' : 'border-transparent text-on-surface-variant hover:text-primary'}"
         href="category.jsp?category=${category}&amp;sort=${tab[0]}">${tab[1]}</a>
    </c:forEach>
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
      <a class="px-3 py-2 rounded-lg border border-surface-variant hover:bg-surface-container" href="category.jsp?category=${category}&amp;page=${currentPage - 1}&amp;sort=${sort}">이전</a>
    </c:if>
    <c:forEach var="pg" begin="1" end="${totalPage}">
      <a class="px-4 py-2 rounded-lg ${pg == currentPage ? 'bg-primary text-on-primary font-bold' : 'border border-surface-variant hover:bg-surface-container'}"
         href="category.jsp?category=${category}&amp;page=${pg}&amp;sort=${sort}">${pg}</a>
    </c:forEach>
    <c:if test="${currentPage < totalPage}">
      <a class="px-3 py-2 rounded-lg border border-surface-variant hover:bg-surface-container" href="category.jsp?category=${category}&amp;page=${currentPage + 1}&amp;sort=${sort}">다음</a>
    </c:if>
  </div>
  </c:if>

</section>

<%@ include file="common/footer.jsp" %>
