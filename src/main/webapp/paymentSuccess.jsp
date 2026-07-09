<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.payment.TossPaymentService" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
<jsp:useBean id="orderService" class="client.order.OrderService" scope="page"/>
<%
    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String paymentKey = request.getParameter("paymentKey");
    String orderId = request.getParameter("orderId");
    String amountParam = request.getParameter("amount");

    // 1) 필수 파라미터 체크
    if (paymentKey == null || orderId == null || amountParam == null) {
        response.sendRedirect(request.getContextPath() + "/paymentFail.jsp?code=INVALID_REQUEST&message=" +
                java.net.URLEncoder.encode("잘못된 접근입니다.", "UTF-8"));
        return;
    }

    int amount;
    try {
        amount = Integer.parseInt(amountParam);
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/paymentFail.jsp?code=INVALID_AMOUNT&message=" +
                java.net.URLEncoder.encode("결제 금액이 올바르지 않습니다.", "UTF-8"));
        return;
    }

    // 2) 위변조 방지: order.jsp에서 세션에 저장해 둔 값과 대조
    String pendingOrderId = (String) session.getAttribute("pendingOrderId");
    Integer pendingAmount = (Integer) session.getAttribute("pendingOrderAmount");

    if (pendingOrderId == null || pendingAmount == null
            || !pendingOrderId.equals(orderId) || pendingAmount != amount) {
        response.sendRedirect(request.getContextPath() + "/paymentFail.jsp?code=AMOUNT_MISMATCH&message=" +
                java.net.URLEncoder.encode("주문 정보가 일치하지 않습니다. 다시 시도해주세요.", "UTF-8"));
        return;
    }

    // 3) 서버 -> 토스 승인 API 호출
    TossPaymentService tossPaymentService = new TossPaymentService();
    TossPaymentService.ConfirmResult result;
    try {
        result = tossPaymentService.confirmPayment(paymentKey, orderId, amount);
    } catch (Exception e) {
        response.sendRedirect(request.getContextPath() + "/paymentFail.jsp?code=CONFIRM_API_ERROR&message=" +
                java.net.URLEncoder.encode("결제 승인 처리 중 오류가 발생했습니다.", "UTF-8"));
        return;
    }

    if (!result.success) {
        response.sendRedirect(request.getContextPath() + "/paymentFail.jsp?code=" + result.getErrorCode()
                + "&message=" + java.net.URLEncoder.encode(result.getErrorMessage(), "UTF-8"));
        return;
    }

    // 4) 승인 성공 -> 주문 확정 처리
    // 장바구니를 비우기 전에 먼저 내용을 읽어둔다 (비우고 나면 조회할 수 없으므로).
    java.util.List<client.cart.OrderDTO> cartList = cartService.getCartList(clientNo);

    // ORDERS/ORDER_DETAILS 테이블에 실제 주문을 저장한다. (내부 주문번호는 O000001 형식으로 채번됨)
    String internalOrderId = orderService.placeOrder(clientNo, amount, cartList);

    if (internalOrderId == null) {
        // 결제는 이미 승인됐지만(돈은 빠져나감) 주문 저장에는 실패한 상황.
        // 실패 페이지로 보내면 "결제 자체가 안 된 것"처럼 보여 혼란을 줄 수 있어 별도로 안내한다.
        request.setAttribute("orderSaveFailed", true);
    } else {
        cartService.clearAllCart(clientNo);
    }

    session.removeAttribute("pendingOrderId");
    session.removeAttribute("pendingOrderAmount");
    session.removeAttribute("pendingOrderName");

    request.setAttribute("orderId", orderId);
    request.setAttribute("internalOrderId", internalOrderId);
    request.setAttribute("amount", amount);
    request.setAttribute("method", result.getMethod());
    request.setAttribute("approvedAt", result.getApprovedAt());
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-2xl mx-auto py-24 px-margin-desktop text-center">
  <span class="material-symbols-outlined text-primary text-[64px]">check_circle</span>
  <h2 class="text-headline-lg font-headline-lg mt-6 mb-4">결제가 완료되었습니다</h2>

  <c:if test="${orderSaveFailed}">
    <div class="bg-error-container text-on-error-container rounded-xl p-4 mb-6 text-body-sm">
      결제는 정상적으로 처리되었지만, 주문 내역 저장 중 문제가 발생했어요. 고객센터로 문의해주세요.
    </div>
  </c:if>

  <div class="bg-surface-container rounded-xl p-8 text-left space-y-3 mt-8">
    <c:if test="${not empty internalOrderId}">
      <div class="flex justify-between"><span class="text-on-surface-variant">주문번호</span><span class="font-bold">${internalOrderId}</span></div>
    </c:if>
    <div class="flex justify-between"><span class="text-on-surface-variant">결제수단</span><span class="font-bold">${method}</span></div>
    <div class="flex justify-between"><span class="text-on-surface-variant">결제금액</span><span class="font-bold"><fmt:formatNumber value="${amount}" type="number"/>원</span></div>
    <div class="flex justify-between"><span class="text-on-surface-variant">승인시각</span><span class="font-bold">${approvedAt}</span></div>
  </div>
  <a href="${pageContext.request.contextPath}/myPage.jsp"
     class="inline-block mt-10 bg-primary text-on-primary px-8 py-4 rounded-lg font-bold">
    주문 내역 보기
  </a>
</section>

<%@ include file="common/footer.jsp" %>
