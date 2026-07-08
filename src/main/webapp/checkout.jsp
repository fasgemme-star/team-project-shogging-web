<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.cart.OrderDTO" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
<jsp:useBean id="orderService" class="client.order.OrderService" scope="page"/>
<%
    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirectTo=" + request.getContextPath() + "/cart.jsp");
        return;
    }

    // ---- CartService: 결제할 상품/금액 계산 ----
    List<OrderDTO> cartList = cartService.getCartList(clientNo);

    if (cartList == null || cartList.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
        return;
    }

    int subtotal = 0;
    for (OrderDTO item : cartList) {
        int unitPrice = item.getDiscount() > 0
                ? item.getPrice() * (100 - item.getDiscount()) / 100
                : item.getPrice();
        subtotal += unitPrice * item.getQuantity();
    }
    int deliveryFee = subtotal >= 30000 ? 0 : 3000;
    int total = subtotal + deliveryFee;

    // ---- OrderService: 배송지(수령인) 정보 조회 ----
    // 주의: OrderService의 getRecipeInfo() 외 나머지 메소드(calculateTotalPrice, processPayment 등)는
    // 아직 내용이 비어있는 상태라, 결제금액 계산은 이 페이지(JSP)에서 직접 하고 있습니다.
    client.order.OrderDTO recipient = orderService.getRecipeInfo(clientNo);

    request.setAttribute("cartList", cartList);
    request.setAttribute("subtotal", subtotal);
    request.setAttribute("deliveryFee", deliveryFee);
    request.setAttribute("total", total);
    request.setAttribute("recipient", recipient);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-max-width mx-auto py-16 px-margin-desktop" id="order-view">
  <h2 class="text-headline-lg font-headline-lg text-on-surface mb-10 text-center">주문/결제</h2>

  <form method="post" action="checkoutProcess.jsp" id="checkout-form">
  <div class="flex flex-col lg:flex-row gap-gutter-md">
    <div class="flex-1 space-y-8">

      <div class="bg-white p-8 rounded-xl border border-surface-variant">
        <h3 class="text-headline-sm font-headline-sm mb-6 pb-4 border-b border-surface-variant">배송 정보</h3>
        <c:choose>
          <c:when test="${not empty recipient and not empty recipient.recipient}">
            <div class="space-y-4">
              <div class="flex gap-8"><span class="text-on-surface-variant w-24">받는분</span><span class="font-bold">${recipient.recipient}</span></div>
              <div class="flex gap-8"><span class="text-on-surface-variant w-24">휴대폰</span><span>${recipient.recipientPhone}</span></div>
              <div class="flex gap-8"><span class="text-on-surface-variant w-24">배송지</span><span class="font-bold">${recipient.addr}</span></div>
            </div>
          </c:when>
          <c:otherwise>
            <p class="text-body-sm text-on-surface-variant">등록된 배송지 정보가 없습니다. 마이페이지에서 배송지를 먼저 등록해주세요.</p>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="bg-white p-8 rounded-xl border border-surface-variant">
        <h3 class="text-headline-sm font-headline-sm mb-6 pb-4 border-b border-surface-variant">결제 수단</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <label class="relative flex flex-col items-center justify-center p-4 border-2 border-primary rounded-xl cursor-pointer">
            <input checked class="hidden" name="payment" type="radio" value="naverpay"/>
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-full bg-[#03C75A] flex items-center justify-center text-white text-[10px] font-bold">N</span>
              <span class="font-bold">네이버페이</span>
            </div>
          </label>
          <label class="relative flex flex-col items-center justify-center p-4 border border-outline-variant rounded-xl cursor-pointer hover:border-primary">
            <input class="hidden" name="payment" type="radio" value="applepay"/>
            <div class="flex items-center gap-2"><span class="material-symbols-outlined text-[20px]">apple</span><span class="font-bold">애플페이</span></div>
          </label>
          <label class="relative flex flex-col items-center justify-center p-4 border border-outline-variant rounded-xl cursor-pointer hover:border-primary">
            <input class="hidden" name="payment" type="radio" value="card"/>
            <div class="flex items-center gap-2"><span class="material-symbols-outlined text-[20px]">credit_card</span><span class="font-bold">신용/체크카드</span></div>
          </label>
        </div>
        <p class="text-[12px] text-on-surface-variant mt-4">* 결제 연동(PG)은 아직 붙어있지 않아 실제 결제는 진행되지 않고, 주문만 완료 처리됩니다.</p>
      </div>
    </div>

    <div class="w-full lg:w-96">
      <div class="bg-surface-container p-8 rounded-xl sticky top-24">
        <h3 class="text-headline-sm font-headline-sm mb-6">최종 결제 금액</h3>
        <div class="space-y-4 mb-6">
          <div class="flex justify-between text-on-surface-variant">
            <span>총 상품 금액</span><span><fmt:formatNumber value="${subtotal}" type="number"/>원</span>
          </div>
          <div class="flex justify-between text-on-surface-variant">
            <span>배송비</span>
            <span class="text-primary">
              <c:choose>
                <c:when test="${deliveryFee == 0}">무료배송</c:when>
                <c:otherwise>+<fmt:formatNumber value="${deliveryFee}" type="number"/>원</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="border-t border-surface-variant pt-4 flex justify-between font-bold text-headline-sm">
            <span>결제금액</span><span class="text-primary"><fmt:formatNumber value="${total}" type="number"/>원</span>
          </div>
        </div>
        <button class="w-full bg-primary text-on-primary py-5 rounded-lg font-bold text-body-lg shadow-lg shadow-primary/20 hover:opacity-90 transition-opacity" type="submit">
          <fmt:formatNumber value="${total}" type="number"/>원 결제하기
        </button>
        <p class="text-[11px] text-on-surface-variant mt-4 text-center">주문 내용을 확인하였으며 결제에 동의합니다.</p>
      </div>
    </div>
  </div>
  </form>
</section>

<%@ include file="common/footer.jsp" %>
