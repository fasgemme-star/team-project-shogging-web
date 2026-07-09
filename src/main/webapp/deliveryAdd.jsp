<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.deliveryChg.DeliveryDTO" %>
<%@ page import="client.signup.ClientDTO" %>
<jsp:useBean id="deliveryChgService" class="client.deliveryChg.DeliveryChgService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    DeliveryDTO dDTO = new DeliveryDTO();
    dDTO.setRecipient(request.getParameter("recipient"));
    dDTO.setRecipientPhone(request.getParameter("recipientPhone"));
    dDTO.setDeliveryPost(request.getParameter("deliveryPost"));
    dDTO.setDeliveryAddr(request.getParameter("deliveryAddr"));
    dDTO.setFirstDestination("Y".equals(request.getParameter("firstDestination")));

    ClientDTO loginUser = new ClientDTO();
    loginUser.setClientNo(clientNo);

    boolean result = deliveryChgService.addDelivery(dDTO, loginUser);

    session.setAttribute("toastMsg", result ? "배송지를 추가했습니다." : "배송지 추가에 실패했습니다.");
    response.sendRedirect(request.getContextPath() + "/myPage.jsp?tab=delivery");
%>
