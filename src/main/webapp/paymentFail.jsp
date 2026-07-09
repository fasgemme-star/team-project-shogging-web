<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String code = request.getParameter("code");
    String message = request.getParameter("message");
    if (message == null) {
        message = "결제가 정상적으로 처리되지 않았습니다.";
    }
    request.setAttribute("errorCode", code);
    request.setAttribute("errorMessage", message);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-2xl mx-auto py-24 px-margin-desktop text-center">
  <span class="material-symbols-outlined text-error text-[64px]">cancel</span>
  <h2 class="text-headline-lg font-headline-lg mt-6 mb-4">결제에 실패했습니다</h2>
  <p class="text-on-surface-variant">${errorMessage}</p>
  <c:if test="${not empty errorCode}">
    <p class="text-[12px] text-on-surface-variant mt-2">오류 코드: ${errorCode}</p>
  </c:if>
  <a href="${pageContext.request.contextPath}/cart.jsp"
     class="inline-block mt-10 bg-primary text-on-primary px-8 py-4 rounded-lg font-bold">
    장바구니로 돌아가기
  </a>
</section>

<%@ include file="common/footer.jsp" %>
