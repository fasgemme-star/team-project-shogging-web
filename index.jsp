<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%-- ============================================================
     index.jsp
     프레시마켓 메인 페이지. 공통 영역(head/header/sidebar/footer/script)과
     화면별 view 조각(views/*.jsp)을 include로 조립합니다.

     주의: 이 앱은 SPA 방식(JS의 showView() 함수로 보였다/숨겼다 처리)이라
     모든 view 섹션이 한 페이지(DOM) 안에 같이 존재해야 동작합니다.
     그래서 지금은 <%@ include %>(정적 include)로 파일만 나눠서 가독성/유지보수성을
     높인 상태이며, 실제 URL 분리(/login, /cart 등)가 필요해지면
     서블릿 라우팅 + 화면별 개별 요청으로 구조를 한 단계 더 바꾸면 됩니다.
============================================================ --%>
<%@ include file="common/head.jsp" %>
<%@ include file="common/header.jsp" %>
<%@ include file="common/sidebar.jsp" %>
<%@ include file="common/main_open.jsp" %>

<%@ include file="views/home.jsp" %>
<%@ include file="views/category.jsp" %>
<%@ include file="views/search.jsp" %>
<%@ include file="views/login.jsp" %>
<%@ include file="views/signup.jsp" %>
<%@ include file="views/cart.jsp" %>
<%@ include file="views/detail.jsp" %>
<%@ include file="views/success.jsp" %>

<%@ include file="common/footer.jsp" %>
<%@ include file="common/scripts.jsp" %>
