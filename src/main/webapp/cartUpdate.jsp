<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.cart.CartDTO" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");
    String clientNo = (String) session.getAttribute("clientNo");

    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirectTo=" + request.getContextPath() + "/cart.jsp");
        return;
    }

    String optionNo = request.getParameter("optionNo");

    int quantity = 1;
    try { quantity = Integer.parseInt(request.getParameter("quantity")); } catch (Exception e) { quantity = 1; }

    if (optionNo != null && !optionNo.trim().isEmpty()) {
        if (quantity < 1) {
            // 수량이 0 이하로 내려가면 담긴 상품을 삭제한다.
            CartDTO cartDTO = new CartDTO();
            cartDTO.setClientNo(clientNo);
            cartDTO.setPrdID(optionNo);
            cartService.deleteCart(cartDTO);
        } else {
            CartDTO cartDTO = new CartDTO();
            cartDTO.setClientNo(clientNo);
            cartDTO.setPrdID(optionNo);
            cartDTO.setQuantity(quantity);
            cartService.updateCart(cartDTO);
        }
    }

    response.sendRedirect(request.getContextPath() + "/cart.jsp");
%>
