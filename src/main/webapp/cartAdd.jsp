<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.cart.CartDTO" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
<%
    String clientNo = (String) session.getAttribute("clientNo");
    String prdID = request.getParameter("prdID");
    String redirectTo = request.getParameter("redirectTo");
    if (redirectTo == null || redirectTo.trim().isEmpty()) {
        redirectTo = request.getContextPath() + "/home.jsp";
    }

    int quantity = 1;
    try { quantity = Integer.parseInt(request.getParameter("quantity")); } catch (Exception e) { quantity = 1; }
    if (quantity < 1) quantity = 1;

    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirectTo=" + java.net.URLEncoder.encode(redirectTo, "UTF-8"));
        return;
    }

    if (prdID == null || prdID.trim().isEmpty()) {
        session.setAttribute("toastMsg", "상품 정보가 올바르지 않습니다.");
        response.sendRedirect(redirectTo);
        return;
    }

    // ---- CartService 메소드 연결 ----
    CartDTO cartDTO = new CartDTO();
    cartDTO.setClientNo(clientNo);
    cartDTO.setPrdID(prdID);
    cartDTO.setQuantity(quantity);

    int result = cartService.addCart(cartDTO);

    session.setAttribute("toastMsg", result > 0 ? "장바구니에 담았습니다." : "장바구니 담기에 실패했습니다.");
    response.sendRedirect(redirectTo);
%>
