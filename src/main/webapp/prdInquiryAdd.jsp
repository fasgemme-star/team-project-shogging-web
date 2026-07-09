<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.inquiry.InquiryDTO" %>
<jsp:useBean id="pdInquiryService" class="client.prdInquiry.PrdInquiryService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    String clientNo = (String) session.getAttribute("clientNo");
    String redirectTo = request.getParameter("redirectTo");
    if (redirectTo == null || redirectTo.trim().isEmpty()) {
        redirectTo = request.getContextPath() + "/home.jsp";
    }

    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirectTo=" + java.net.URLEncoder.encode(redirectTo, "UTF-8"));
        return;
    }

    InquiryDTO iDTO = new InquiryDTO();
    iDTO.setInquiryTitle(request.getParameter("inquiryTitle"));
    iDTO.setInquiryContent(request.getParameter("inquiryContent"));
    iDTO.setInquirySecret("Y".equals(request.getParameter("inquirySecret")) ? "Y" : "N");
    iDTO.setProductId(request.getParameter("prdID"));
    iDTO.setClientNo(clientNo);

    boolean result = pdInquiryService.registerInquiry(iDTO);

    session.setAttribute("toastMsg", result ? "문의가 등록되었습니다." : "문의 등록에 실패했습니다.");
    response.sendRedirect(redirectTo);
%>
