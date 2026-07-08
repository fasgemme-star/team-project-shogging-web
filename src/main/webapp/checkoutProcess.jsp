<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.cart.CartDTO" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
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

    // ---- CartService 메소드 연결 ----
    // 주의: client.order.OrderService 의 processPayment/getOrder 등은 아직 내용이 비어있어서(구현체 없음)
    // 실제 결제 연동이나 주문(ORDERS) 테이블 등록은 여기서 할 수 없다.
    // 또한 CartService.clearCart()는 이름과 달리 clientNo+prdID 두 조건이 다 있어야 지워지는데,
    // CartService.getCartList()가 돌려주는 목록에는 prdID(option_id)가 채워지지 않아
    // 지금은 장바구니가 실제로는 비워지지 않을 수 있다. (CartDAO.selectCart() SQL에 option_id 컬럼 추가 필요)
    CartDTO cartDTO = new CartDTO();
    cartDTO.setClientNo(clientNo);
    cartService.clearCart(cartDTO);

    session.setAttribute("toastMsg", "주문이 완료되었습니다!");
    response.sendRedirect(request.getContextPath() + "/orderSuccess.jsp");
%>
