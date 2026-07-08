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

    if (optionNo != null && !optionNo.trim().isEmpty()) {
        CartDTO cartDTO = new CartDTO();
        cartDTO.setClientNo(clientNo);
        cartDTO.setPrdID(optionNo);
        cartService.deleteCart(cartDTO);
        session.setAttribute("toastMsg", "장바구니에서 삭제했습니다.");
    }

    response.sendRedirect(request.getContextPath() + "/cart.jsp");
%>
