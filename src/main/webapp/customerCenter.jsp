<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.File" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="dbcon.DbConnection" %>
<%@ page import="dbcon.Path" %>
<%@ page import="client.inquiry.InquiryDTO" %>
<jsp:useBean id="ccInquiryService" class="client.inquiry.InquiryService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    // ---- 로그인 확인 ----
    String clientNo = (String) session.getAttribute("clientNo");
    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirectTo="
                + java.net.URLEncoder.encode(request.getContextPath() + "/customerCenter.jsp", "UTF-8"));
        return;
    }

    // ---- 문의 등록 (POST) ----
/*     if ("POST".equalsIgnoreCase(request.getMethod())) {
        InquiryDTO writeDTO = new InquiryDTO();
        writeDTO.setInquiryTitle(request.getParameter("inquiryTitle"));
        writeDTO.setInquiryContent(request.getParameter("inquiryContent"));
        writeDTO.setInquirySecret("Y".equals(request.getParameter("inquirySecret")) ? "Y" : "N");
        writeDTO.setInquiryCode(request.getParameter("inquiryCode"));
        writeDTO.setClientNo(clientNo);

        boolean result = ccInquiryService.registerInquiry(writeDTO);

        session.setAttribute("toastMsg", result ? "문의가 등록되었습니다." : "문의 등록에 실패했습니다.");
        response.sendRedirect(request.getContextPath() + "/customerCenter.jsp");
        return;
    } */

    // ---- 문의 유형 목록 (INQUIRY_TYPE 테이블에서 일반 1:1 문의에 해당하는 코드만 조회) ----
    List<String[]> inquiryTypeList = new ArrayList<String[]>();
    DbConnection ccDbcon = DbConnection.getInstance();

    Connection ccCon = null;
    PreparedStatement ccPstmt = null;
    ResultSet ccRs = null;

    try {
        ccCon = ccDbcon.getConn(new File(Path.DATABASE_PROPERTIES));

        String typeSql = " SELECT INQUIRY_CODE, INQUIRY_NAME "
                        + " FROM INQUIRY_TYPE "
                        + " WHERE INQUIRY_CODE IN ('TYP000001','TYP000002') "
                        + " ORDER BY INQUIRY_CODE ";

        ccPstmt = ccCon.prepareStatement(typeSql);
        ccRs = ccPstmt.executeQuery();

        while (ccRs.next()) {
            inquiryTypeList.add(new String[] { ccRs.getString("INQUIRY_CODE"), ccRs.getString("INQUIRY_NAME") });
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            ccDbcon.dbClose(ccRs, ccPstmt, ccCon);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    request.setAttribute("inquiryTypeList", inquiryTypeList);

    // ---- 1:1 문의 내역 ----
    List<InquiryDTO> inquiryList = ccInquiryService.getInquiryList(clientNo);
    request.setAttribute("inquiryList", inquiryList);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-2xl mx-auto py-24 px-margin-desktop">
  <h2 class="text-headline-lg font-headline-lg mb-8 flex items-center">
    <span class="material-symbols-outlined mr-2 text-primary">support_agent</span>고객센터
  </h2>

  <%-- ===================== 1:1 문의 작성 ===================== --%>
  <div class="bg-surface-container-lowest border border-surface-variant rounded-xl p-6 mb-10">
    <h3 class="font-headline-sm text-headline-sm mb-6 flex items-center">
      <span class="material-symbols-outlined mr-2 text-primary">edit_note</span>1:1 문의
    </h3>
    <form method="post" action="${pageContext.request.contextPath}/customerCenter.jsp" class="space-y-4">
      <div>
        <label class="text-body-sm text-on-surface-variant block mb-1">문의 유형</label>
        <select class="w-full border border-outline-variant rounded-lg px-4 py-2" name="inquiryCode" required>
          <c:forEach var="t" items="${inquiryTypeList}">
            <option value="${t[0]}">${t[1]}</option>
          </c:forEach>
        </select>
      </div>
      <div>
        <label class="text-body-sm text-on-surface-variant block mb-1">제목</label>
        <input class="w-full border border-outline-variant rounded-lg px-4 py-2" type="text" name="inquiryTitle" placeholder="문의 제목을 입력해주세요" required/>
      </div>
      <div>
        <label class="text-body-sm text-on-surface-variant block mb-1">내용</label>
        <textarea class="w-full border border-outline-variant rounded-lg px-4 py-2 h-32" name="inquiryContent" placeholder="문의 내용을 입력해주세요" required></textarea>
      </div>
      <label class="flex items-center gap-2 text-body-sm text-on-surface-variant">
        <input type="checkbox" name="inquirySecret" value="Y"/> 비밀글로 등록
      </label>
      <button class="bg-primary text-on-primary py-3 px-8 rounded-lg font-bold" type="submit">문의 등록</button>
    </form>
  </div>

  <%-- ===================== 1:1 문의 내역 ===================== --%>
  <div class="bg-surface-container-lowest border border-surface-variant rounded-xl overflow-hidden">
    <div class="p-6 border-b border-surface-variant">
      <h3 class="font-headline-sm text-headline-sm flex items-center">
        <span class="material-symbols-outlined mr-2 text-primary">chat_bubble</span>1:1 문의내역
      </h3>
    </div>
    <c:choose>
      <c:when test="${empty inquiryList}">
        <div class="p-16 text-center text-on-surface-variant">
          <span class="material-symbols-outlined text-6xl text-outline-variant mb-4 block">quiz</span>
          문의 내역이 없습니다.
        </div>
      </c:when>
      <c:otherwise>
        <div class="divide-y divide-surface-variant">
          <c:forEach var="iq" items="${inquiryList}">
            <div class="p-6 flex items-center justify-between gap-4">
              <div>
                <p class="font-bold">${iq.inquiryTitle}</p>
                <p class="text-on-surface-variant text-body-sm mt-1"><fmt:formatDate value="${iq.inquiryDate}" pattern="yyyy.MM.dd"/></p>
              </div>
              <div class="flex items-center gap-4">
                <span class="px-3 py-1 rounded-full text-body-sm ${iq.answerStatus == '답변완료' ? 'bg-secondary-container text-on-secondary-container' : 'bg-surface-container-high text-on-surface-variant'}">${iq.answerStatus}</span>
                <form method="post" action="${pageContext.request.contextPath}/inquiryDelete.jsp" onsubmit="return confirm('이 문의 내역을 삭제할까요?');">
                  <input type="hidden" name="inquiryId" value="${iq.inquiryId}"/>
                  <input type="hidden" name="redirectTo" value="${pageContext.request.contextPath}/customerCenter.jsp"/>
                  <button type="submit" class="text-error text-body-sm hover:underline">삭제</button>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<%@ include file="common/footer.jsp" %>
