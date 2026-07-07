<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.cart.CartDTO" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
<%
    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ---- CartService 메소드 연결 ----
    // 주의: client.order.OrderService 의 processPayment/getOrder 등은 현재 내용이 비어있는 상태(구현체 없음)라
    // 실제 주문/결제 테이블 등록 로직은 아직 연결할 수 없다. 우선 장바구니만 비우고 완료 화면으로 이동한다.
    CartDTO cartDTO = new CartDTO();
    cartDTO.setClientNo(clientNo);
    cartService.clearCart(cartDTO);

    response.sendRedirect(request.getContextPath() + "/orderSuccess.jsp");
%>
