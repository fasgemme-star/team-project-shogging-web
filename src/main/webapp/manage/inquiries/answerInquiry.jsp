<%@page import="manage.inquiry.InquiryService"%>
<%@page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String inquiryID = request.getParameter("inquiryID");
String answer = request.getParameter("answer");

int result = 0;

if (inquiryID != null && !inquiryID.trim().isEmpty()
        && answer != null && !answer.trim().isEmpty()) {

    InquiryService inquiryService = new InquiryService();
    result = inquiryService.answerInquiry(inquiryID, answer);
}

out.print("{\"result\":" + result + "}");
%>
