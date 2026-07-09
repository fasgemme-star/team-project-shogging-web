<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="orderCheckService" class="client.orderCheck.OrderCheckService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String orderId = request.getParameter("orderId");

    boolean result = (orderId != null && !orderId.trim().isEmpty())
            && orderCheckService.deleteOrder(orderId, clientNo);

    session.setAttribute("toastMsg", result ? "주문 내역을 삭제했습니다." : "주문 내역 삭제에 실패했습니다.");
    response.sendRedirect(request.getContextPath() + "/myPage.jsp?tab=orders");
%>
