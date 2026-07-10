<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="mpInquiryService" class="client.inquiry.InquiryService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String inquiryId = request.getParameter("inquiryId");
	
    boolean deleteInquiry=(inquiryId==null && clientNo==null)? null : mpInquiryService.deleteInquiry(inquiryId,clientNo);
    
    /* boolean result = (inquiryId != null && !inquiryId.trim().isEmpty())
            && mpInquiryService.deleteInquiry(inquiryId, clientNo); */

    session.setAttribute("toastMsg", deleteInquiry ? "문의 내역을 삭제했습니다." : "문의 내역 삭제에 실패했습니다.");
    response.sendRedirect(request.getContextPath() + "/myPage.jsp?tab=inquiry");
%>
