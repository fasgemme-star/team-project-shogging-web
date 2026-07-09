<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.cart.OrderDTO" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
<jsp:useBean id="orderService" class="client.order.OrderService" scope="page"/>
<%
    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
        return;
    }

    // ---- 장바구니 항목 재조회 + 결제 금액 재계산 (checkout.jsp와 동일한 방식, 위·변조 방지를 위해 서버에서 다시 계산) ----
    List<OrderDTO> cartList = cartService.getCartList(clientNo);

    if (cartList == null || cartList.isEmpty()) {
        session.setAttribute("toastMsg", "장바구니가 비어 있습니다.");
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

    // ---- OrderService: 실제 주문(ORDERS/ORDER_DETAILS) 생성 ----
    String orderId = orderService.placeOrder(clientNo, total, cartList);

    if (orderId == null) {
        session.setAttribute("toastMsg", "주문 처리 중 오류가 발생했습니다. 다시 시도해주세요.");
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
        return;
    }

    // ---- 주문이 정상 생성된 경우에만 장바구니 비우기 ----
    cartService.clearAllCart(clientNo);

    session.setAttribute("toastMsg", "주문이 완료되었습니다!");
    response.sendRedirect(request.getContextPath() + "/orderSuccess.jsp");
%>
