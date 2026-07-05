<%@page import="manage.inquiry.InquiryService"%>
<%@page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String inquiryID = request.getParameter("inquiryID");
int result = 0;

if (inquiryID != null && !inquiryID.trim().isEmpty()) {
    InquiryService inquiryService = new InquiryService();
    result = inquiryService.deleteInquiry(inquiryID);
}

out.print("{\"result\":" + result + "}");
%>
