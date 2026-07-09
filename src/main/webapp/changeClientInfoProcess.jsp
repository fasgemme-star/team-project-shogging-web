<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.signup.ClientDTO" %>
<jsp:useBean id="changeClientInfoService" class="client.changeClientInfo.ChangeClientInfoService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    String clientId = (String) session.getAttribute("clientId");
    if (clientId == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    ClientDTO cDTO = new ClientDTO();
    cDTO.setClientId(clientId);
    cDTO.setClientName(request.getParameter("clientName"));
    cDTO.setClientEmail(request.getParameter("clientEmail"));
    cDTO.setClientTel(request.getParameter("clientTel"));

    int result = changeClientInfoService.modifyUserInfo(cDTO);

    if (result > 0) {
        // 세션에 표시되는 이름도 최신화 (헤더의 "OOO님" 표시 반영)
        session.setAttribute("clientName", cDTO.getClientName());
        session.setAttribute("toastMsg", "회원 정보를 수정했습니다.");
    } else {
        session.setAttribute("toastMsg", "회원 정보 수정에 실패했습니다.");
    }
    response.sendRedirect(request.getContextPath() + "/myPage.jsp?tab=info");
%>
