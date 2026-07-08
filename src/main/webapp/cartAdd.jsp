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
    // 같은 옵션이 장바구니에 이미 있으면(=이전에 담은 적 있으면) 새 행을 또 insert 하지 않고
    // 기존 수량에 더해서 update 한다. (그냥 매번 insert만 하면 같은 상품이 여러 줄로 쪼개져
    // 들어가서 "수량 조절/담은 개수"가 실제 화면과 안 맞아 보이는 문제가 생긴다.)
    CartDTO cartDTO = new CartDTO();
    cartDTO.setClientNo(clientNo);
    cartDTO.setPrdID(prdID);

    ProductDTO optionInfo = pdService.getProductInfo(prdID);
    String optionName = (optionInfo != null) ? optionInfo.getOptionName() : null;

    boolean alreadyInCart = false;
    if (optionName != null) {
        List<OrderDTO> existingCart = cartService.getCartList(clientNo);
        for (OrderDTO item : existingCart) {
            if (optionName.equals(item.getPrdName())) {
                quantity += item.getQuantity();
                alreadyInCart = true;
                break;
            }
        }
    }
    cartDTO.setQuantity(quantity);

    int result = alreadyInCart ? cartService.updateCart(cartDTO) : cartService.addCart(cartDTO);

    session.setAttribute("toastMsg", result > 0 ? "장바구니에 담았습니다." : "장바구니 담기에 실패했습니다.");
    response.sendRedirect(redirectTo);
%>
