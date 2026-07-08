<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.cart.CartDTO" %>
<%@ page import="client.cart.OrderDTO" %>
<%@ page import="client.productDetail.ProductDTO" %>
<jsp:useBean id="cartService" class="client.cart.CartService" scope="page"/>
<jsp:useBean id="pdService" class="client.productDetail.ProductDetailService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");
    String clientNo = (String) session.getAttribute("clientNo");
    // 상품카드/상세페이지 모두 "옵션 번호(optionNo)" 기준으로 담는다.
    // (구버전 prdID 파라미터로 오는 요청이 있을 경우를 대비해 fallback 유지)
    String prdID = request.getParameter("optionNo");
    if (prdID == null || prdID.trim().isEmpty()) {
        prdID = request.getParameter("prdID");
    }
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
    // 주의(JSP-only 수정): 기존엔 "이미 담겨있는지"를 옵션 '이름' 문자열로 비교해서,
    // 서로 다른 상품인데 옵션명이 같으면(예: "1kg") 잘못 매칭되어 엉뚱한 option_id로
    // UPDATE를 시도 -> 수정된 행이 0개 -> "담기 실패"로 표시되는 버그가 있었음.
    // 이름 대신 실제 option_id로 정확히 조회해서 이미 담긴 수량을 확인하도록 수정.
    CartDTO cartDTO = new CartDTO();
    cartDTO.setClientNo(clientNo);
    cartDTO.setPrdID(prdID);

    boolean alreadyInCart = false;
    {
        java.sql.Connection con = null;
        java.sql.PreparedStatement pstmt = null;
        java.sql.ResultSet rs = null;
        try {
            dbcon.DbConnection dbconn = dbcon.DbConnection.getInstance();
            con = dbconn.getConn(new java.io.File(dbcon.Path.DATABASE_PROPERTIES));
            pstmt = con.prepareStatement(
                "select quantity from shopping_cart where client_no = ? and option_id = ?");
            pstmt.setString(1, clientNo);
            pstmt.setString(2, prdID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                quantity += rs.getInt("quantity");
                alreadyInCart = true;
            }
        } finally {
            dbcon.DbConnection.getInstance().dbClose(rs, pstmt, con);
        }
    }
    cartDTO.setQuantity(quantity);

    int result = alreadyInCart ? cartService.updateCart(cartDTO) : cartService.addCart(cartDTO);

    session.setAttribute("toastMsg", result > 0 ? "장바구니에 담았습니다." : "장바구니 담기에 실패했습니다.");
    response.sendRedirect(redirectTo);
%>
