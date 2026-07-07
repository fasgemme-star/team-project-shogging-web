<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.cart.OrderDTO" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
<%
    String clientNo = (String) session.getAttribute("clientNo");

    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirectTo=" + request.getContextPath() + "/cart.jsp");
        return;
    }

    // ---- CartService 메소드 연결 ----
    List<OrderDTO> cartList = cartService.getCartList(clientNo);

    int subtotal = 0;
    for (OrderDTO item : cartList) {
        int unitPrice = item.getDiscount() > 0
                ? item.getPrice() * (100 - item.getDiscount()) / 100
                : item.getPrice();
        subtotal += unitPrice * item.getQuantity();
    }
    int deliveryFee = subtotal > 0 ? (subtotal >= 30000 ? 0 : 3000) : 0;
    int total = subtotal + deliveryFee;

    request.setAttribute("cartList", cartList);
    request.setAttribute("subtotal", subtotal);
    request.setAttribute("deliveryFee", deliveryFee);
    request.setAttribute("total", total);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-max-width mx-auto py-16 px-margin-desktop" id="cart-view">
  <h2 class="text-headline-lg font-headline-lg text-on-surface mb-10">장바구니</h2>

  <div class="flex flex-col lg:flex-row gap-gutter-md">
    <div class="flex-1 space-y-4">
      <c:choose>
        <c:when test="${empty cartList}">
          <div class="py-20 text-center text-on-surface-variant">장바구니가 비어 있습니다.</div>
        </c:when>
        <c:otherwise>
          <c:forEach var="item" items="${cartList}">
            <c:set var="itemUnitPrice" value="${item.discount > 0 ? (item.price * (100 - item.discount) / 100) : item.price}"/>
            <div class="flex items-center gap-4 p-6 bg-white rounded-xl border border-surface-variant">
              <div class="flex-1">
                <h4 class="font-bold text-on-surface">${item.prdName}</h4>
                <p class="text-body-sm text-on-surface-variant mb-2"><fmt:formatNumber value="${itemUnitPrice}" type="number"/>원 x ${item.quantity}개</p>
              </div>
              <div class="text-right">
                <p class="font-bold text-on-surface text-lg"><fmt:formatNumber value="${itemUnitPrice * item.quantity}" type="number"/>원</p>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="w-full lg:w-96">
      <div class="bg-surface-container p-8 rounded-xl sticky top-24">
        <h3 class="text-headline-sm font-headline-sm mb-6">결제 예정 금액</h3>
        <div class="space-y-4 mb-6">
          <div class="flex justify-between text-on-surface-variant">
            <span>상품금액</span>
            <span><fmt:formatNumber value="${subtotal}" type="number"/>원</span>
          </div>
          <div class="flex justify-between text-on-surface-variant">
            <span>배송비</span>
            <span class="text-primary">
              <c:choose>
                <c:when test="${subtotal == 0}">0원</c:when>
                <c:when test="${deliveryFee == 0}">무료배송</c:when>
                <c:otherwise>+<fmt:formatNumber value="${deliveryFee}" type="number"/>원</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="border-t border-surface-variant pt-4 flex justify-between font-bold text-headline-sm">
            <span>결제금액</span>
            <span class="text-primary"><fmt:formatNumber value="${total}" type="number"/>원</span>
          </div>
        </div>
        <form method="post" action="checkout.jsp">
          <button class="w-full bg-primary text-on-primary py-4 rounded-lg font-bold text-body-lg shadow-lg shadow-primary/20" type="submit"
                  ${empty cartList ? 'disabled' : ''}>주문하기</button>
        </form>
      </div>
    </div>
  </div>
</section>

<%@ include file="common/footer.jsp" %>
