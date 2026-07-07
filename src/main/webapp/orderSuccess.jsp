<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/header.jsp" %>

<section class="py-32 px-6 text-center" id="success-view">
  <div class="max-w-md mx-auto">
    <span class="material-symbols-outlined text-primary text-[80px] mb-6 block" style="font-variation-settings: 'wght' 200;">check_circle</span>
    <h2 class="text-headline-lg font-headline-lg text-on-surface mb-4">주문이 완료되었습니다!</h2>
    <p class="text-body-md text-on-surface-variant mb-10">내일 아침 7시 전까지 신선하게 배송해 드릴게요.</p>
    <div class="flex flex-col gap-4">
      <a class="w-full bg-primary text-on-primary py-4 rounded-lg font-bold inline-block" href="${pageContext.request.contextPath}/home.jsp">계속 쇼핑하기</a>
    </div>
  </div>
</section>

<%@ include file="common/footer.jsp" %>
