<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.File" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="dbcon.DbConnection" %>
<%@ page import="dbcon.Path" %>
<%
    // ---- 사이드바 카테고리 목록 DB 연동 ----
    // 새 자바 클래스 없이, header.jsp 안에서 직접 CATEGORY 테이블을 조회해 카테고리명 리스트만 뽑는다.
    // ※ 컬럼명(CATEGORY_NAME)이 실제 테이블과 다르면 아래 SQL과 rs.getString(...) 부분만 맞춰서 수정하면 됨.
    List<String> sideCategoryList = new ArrayList<String>();
    DbConnection headerDbcon = DbConnection.getInstance();

    Connection headerCon = null;
    PreparedStatement headerPstmt = null;
    ResultSet headerRs = null;

    try {
        headerCon = headerDbcon.getConn(new File(Path.DATABASE_PROPERTIES));

        String sideCategorySql = " SELECT CATEGORY_NAME "
                                + " FROM CATEGORY "
                                + " ORDER BY CATEGORY_ID ";

        headerPstmt = headerCon.prepareStatement(sideCategorySql);
        headerRs = headerPstmt.executeQuery();

        while (headerRs.next()) {
            sideCategoryList.add(headerRs.getString("CATEGORY_NAME"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            headerDbcon.dbClose(headerRs, headerPstmt, headerCon);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    request.setAttribute("sideCategoryList", sideCategoryList);

    // 카테고리별로 순서대로 돌려쓸 아이콘 (CATEGORY 테이블에 아이콘 컬럼이 없으므로 고정 배열을 순환)
    String[] sideCategoryIcons = { "eco", "psychology_alt", "egg_alt", "local_florist", "nutrition", "spa" };
    request.setAttribute("sideCategoryIcons", sideCategoryIcons);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>프레시마켓</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&amp;family=Work+Sans:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="${pageContext.request.contextPath}/common/style.css" rel="stylesheet"/>
<script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
                  "secondary": "#1b6d24", "surface-variant": "#e5e2e1", "surface": "#fcf9f8",
                  "secondary-fixed-dim": "#88d982", "background": "#fcf9f8", "tertiary-fixed-dim": "#c6c6c7",
                  "surface-bright": "#fcf9f8", "on-primary": "#ffffff", "on-primary-fixed-variant": "#2e4f00",
                  "surface-container": "#f0eded", "inverse-on-surface": "#f3f0ef", "on-secondary-container": "#217128",
                  "tertiary-fixed": "#e2e2e2", "on-tertiary-container": "#434546", "inverse-primary": "#9ed75b",
                  "secondary-fixed": "#a3f69c", "inverse-surface": "#303030", "on-surface-variant": "#424939",
                  "surface-tint": "#3e6a00", "on-tertiary-fixed": "#1a1c1c", "on-error": "#ffffff",
                  "tertiary": "#5d5f5f", "on-primary-fixed": "#0f2000", "primary": "#8BC34A",
                  "on-secondary": "#ffffff", "on-tertiary": "#ffffff", "error": "#ba1a1a",
                  "on-error-container": "#93000a", "error-container": "#ffdad6", "surface-dim": "#dcd9d9",
                  "on-background": "#1b1c1c", "primary-fixed": "#b9f474", "on-secondary-fixed": "#002204",
                  "surface-container-low": "#f6f3f2", "secondary-container": "#a0f399", "surface-container-lowest": "#ffffff",
                  "surface-container-highest": "#e5e2e1", "primary-fixed-dim": "#9ed75b", "surface-container-high": "#eae7e7",
                  "tertiary-container": "#b2b3b3", "on-secondary-fixed-variant": "#005312", "on-tertiary-fixed-variant": "#454747",
                  "on-primary-container": "#2d4e00", "outline-variant": "#c2c9b4", "primary-container": "#8bc34a",
                  "on-surface": "#1b1c1c", "outline": "#737a67"
          },
          "borderRadius": { "DEFAULT": "0.5rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
          "spacing": { "gutter-md": "24px", "gutter-xs": "8px", "max-width": "1200px", "margin-mobile": "16px", "base": "4px", "gutter-sm": "16px", "margin-desktop": "48px", "section-gap": "80px" },
          "fontFamily": { "headline-lg": ["Plus Jakarta Sans"], "headline-md": ["Plus Jakarta Sans"], "headline-sm": ["Plus Jakarta Sans"], "body-lg": ["Work Sans"], "body-md": ["Work Sans"], "body-sm": ["Work Sans"] }
        }
      }
    }
</script>
</head>
<body class="bg-background text-on-surface font-body-md overflow-x-hidden">

<div id="toast">메시지가 표시됩니다.</div>

<%-- ===================== TopNavBar ===================== --%>
<header class="fixed top-0 left-0 right-0 z-50 bg-surface border-b border-surface-variant transition-all duration-300">
<div class="flex justify-between items-center w-full px-margin-desktop h-20 max-w-max-width mx-auto">

  <a class="cursor-pointer flex items-center gap-2" href="${pageContext.request.contextPath}/home.jsp">
    <span class="text-headline-md font-headline-md font-bold text-primary">프레시마켓</span>
  </a>

  <nav class="hidden md:flex items-center gap-gutter-md h-full">
    <button class="text-on-surface-variant hover:text-primary transition-colors font-bold flex items-center gap-1 h-full px-1" onclick="toggleSidebar()">
      <span class="material-symbols-outlined">menu</span> 카테고리
    </button>
    <a class="text-on-surface-variant hover:text-primary transition-colors h-full flex items-center px-1 nav-item" href="${pageContext.request.contextPath}/category.jsp?category=신상품">신상품</a>
    <a class="text-on-surface-variant hover:text-primary transition-colors h-full flex items-center px-1 nav-item" href="${pageContext.request.contextPath}/category.jsp?category=베스트">베스트</a>
    <a class="text-on-surface-variant hover:text-primary transition-colors h-full flex items-center px-1 nav-item" href="${pageContext.request.contextPath}/category.jsp?category=알뜰쇼핑">알뜰쇼핑</a>
  </nav>

  <div class="flex items-center gap-gutter-sm">
    <form class="relative block mr-4" action="${pageContext.request.contextPath}/search.jsp" method="get">
      <input class="bg-surface-container-low border border-outline-variant rounded-full py-2 px-6 w-36 md:w-64 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-body-sm"
             id="search-input" name="keyword" placeholder="검색어를 입력해주세요" type="text"/>
      <button type="submit" class="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 text-on-surface-variant bg-transparent border-0">search</button>
    </form>

    <a class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" href="${pageContext.request.contextPath}/cart.jsp">shopping_cart</a>

    <c:choose>
      <c:when test="${not empty sessionScope.clientNo}">
        <span class="text-body-sm text-on-surface-variant hidden md:inline">${sessionScope.clientName}님</span>
        <a class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" href="${pageContext.request.contextPath}/myPage.jsp" title="마이페이지">person</a>
        <a class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" href="${pageContext.request.contextPath}/customerCenter.jsp" title="고객센터">support_agent</a>
        <a class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" href="${pageContext.request.contextPath}/logout.jsp" title="로그아웃">logout</a>
      </c:when>
      <c:otherwise>
        <a class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" href="${pageContext.request.contextPath}/login.jsp">person</a>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</header>

<%-- ===================== SideNavBar (Category) ===================== --%>
<aside class="fixed left-0 top-0 h-full w-64 bg-surface-container-lowest border-r border-surface-variant z-[60] -translate-x-full transition-transform duration-300" id="side-nav">
  <div class="flex flex-col gap-base p-gutter-sm mt-20">
    <div class="mb-6 px-2">
      <h2 class="text-headline-sm font-headline-sm text-primary">품목별 카테고리</h2>
      <p class="text-body-sm text-on-surface-variant">신선한 채소를 만나보세요</p>
    </div>
    <div class="flex flex-col gap-1">
      <c:choose>
        <c:when test="${empty sideCategoryList}">
          <p class="text-body-sm text-on-surface-variant px-2 py-4">등록된 카테고리가 없습니다.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="cat" items="${sideCategoryList}" varStatus="status">
            <a class="category-btn flex items-center gap-3 p-3 text-on-surface-variant hover:bg-surface-container rounded-lg transition-transform hover:translate-x-1"
               href="${pageContext.request.contextPath}/category.jsp?category=${cat}">
              <span class="material-symbols-outlined">${sideCategoryIcons[status.index % fn:length(sideCategoryIcons)]}</span> ${cat}
            </a>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
  <button class="absolute top-4 right-4 material-symbols-outlined" onclick="toggleSidebar()">close</button>
</aside>
<div class="fixed inset-0 bg-black/20 z-[55] hidden" id="side-overlay" onclick="toggleSidebar()"></div>

<main class="pt-20 min-h-screen">
