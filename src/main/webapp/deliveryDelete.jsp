<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="deliveryChgService" class="client.deliveryChg.DeliveryChgService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String deliveryId = request.getParameter("deliveryId");

    boolean result = (deliveryId != null && !deliveryId.trim().isEmpty())
            && deliveryChgService.deleteDelivery(clientNo, deliveryId);

    session.setAttribute("toastMsg", result ? "배송지를 삭제했습니다." : "배송지 삭제에 실패했습니다.");
    response.sendRedirect(request.getContextPath() + "/myPage.jsp?tab=delivery");
%>
