<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- SEARCH VIEW -->
<section class="hidden-view max-w-max-width mx-auto py-16 px-margin-desktop" id="search-view">
<h2 class="text-headline-lg font-headline-lg text-on-surface mb-2">'<span id="search-keyword"></span>' 검색 결과</h2>
<p class="text-body-md text-on-surface-variant mb-10" id="search-result-count">총 0개의 상품이 검색되었습니다.</p>
<!-- ProductSearchServlet(/api/search) 결과가 handleSearch()에 의해 여기 채워짐 -->
<div class="grid grid-cols-1 md:grid-cols-4 gap-gutter-md" id="search-results-grid"></div>
</section>
