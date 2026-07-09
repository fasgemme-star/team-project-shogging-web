<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.UUID" %>
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
    client.order.OrderDTO recipient = orderService.getRecipeInfo(clientNo);

    // ---- 결제 주문번호 발급 ----
    // Toss에 보내는 orderId는 매 요청마다 유일해야 합니다(6~64자, 영문/숫자/-/_).
    String orderId = "ORD" + System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 8);
    String orderName = cartList.get(0).getPrdName()
            + (cartList.size() > 1 ? " 외 " + (cartList.size() - 1) + "건" : "");

    // 결제 승인 시 금액 위변조를 막기 위해, 서버 세션에 "이 orderId는 이 금액이 맞다"를 저장해둡니다.
    // paymentSuccess.jsp에서 이 값과 Toss가 돌려준 amount를 대조합니다.
    session.setAttribute("pendingOrderId", orderId);
    session.setAttribute("pendingOrderAmount", total);
    session.setAttribute("pendingOrderName", orderName);

    request.setAttribute("cartList", cartList);
    request.setAttribute("subtotal", subtotal);
    request.setAttribute("deliveryFee", deliveryFee);
    request.setAttribute("total", total);
    request.setAttribute("recipient", recipient);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-max-width mx-auto py-16 px-margin-desktop" id="order-view">
  <h2 class="text-headline-lg font-headline-lg text-on-surface mb-10 text-center">주문/결제</h2>

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
        <!-- 토스페이먼츠 결제위젯이 이 영역에 카드/네이버페이/카카오페이/토스페이 등을 자동으로 렌더링합니다 -->
        <div id="payment-method"></div>
        <div id="agreement" class="mt-6"></div>
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
        <button class="w-full bg-primary text-on-primary py-5 rounded-lg font-bold text-body-lg shadow-lg shadow-primary/20 hover:opacity-90 transition-opacity" type="button" id="payment-button">
          <fmt:formatNumber value="${total}" type="number"/>원 결제하기
        </button>
        <p class="text-[11px] text-on-surface-variant mt-4 text-center">주문 내용을 확인하였으며 결제에 동의합니다.</p>
      </div>
    </div>
  </div>
</section>

<!-- 토스페이먼츠 결제위젯 SDK v2 -->
<script src="https://js.tosspayments.com/v2/standard"></script>
<script>
  (function () {
    // TODO: 정식 운영 전환 시 실제 발급받은 클라이언트 키(live_gck_...)로 교체하세요.
    var clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";

    // 로그인 사용자를 식별하는 고유 키. 이메일 등 개인정보 원문 대신 접두어를 붙여 사용합니다.
    var customerKey = "cust_${clientNo}";

    var amount = ${total};
    var orderId = "${orderId}";
    var orderName = "${orderName}";

    var tossPayments = TossPayments(clientKey);
    var widgets = tossPayments.widgets({ customerKey: customerKey });

    async function initWidgets() {
      await widgets.setAmount({ currency: "KRW", value: amount });

      await Promise.all([
        widgets.renderPaymentMethods({
          selector: "#payment-method",
          variantKey: "DEFAULT"
        }),
        widgets.renderAgreement({
          selector: "#agreement",
          variantKey: "AGREEMENT"
        })
      ]);
    }

    initWidgets();

    document.querySelector("#payment-button").addEventListener("click", async function () {
      try {
        await widgets.requestPayment({
          orderId: orderId,
          orderName: orderName,
          successUrl: window.location.origin + "${pageContext.request.contextPath}/paymentSuccess.jsp",
          failUrl: window.location.origin + "${pageContext.request.contextPath}/paymentFail.jsp",
          customerEmail: undefined,
          customerName: "${recipient.recipient}"
        });
      } catch (err) {
        // 사용자가 결제창을 닫는 등 requestPayment 자체에서 발생하는 에러
        console.error(err);
        alert("결제 요청 중 문제가 발생했습니다: " + (err.message || err));
      }
    });
  })();
</script>

<%@ include file="common/footer.jsp" %>
