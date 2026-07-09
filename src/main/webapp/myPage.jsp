<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="client.orderCheck.OrderDTO" %>
<%@ page import="client.orderCheck.RangeDTO" %>
<%@ page import="client.deliveryChg.DeliveryDTO" %>
<%@ page import="client.inquiry.InquiryDTO" %>
<%@ page import="client.signup.ClientDTO" %>
<jsp:useBean id="orderCheckService" class="client.orderCheck.OrderCheckService" scope="page"/>
<jsp:useBean id="deliveryChgService" class="client.deliveryChg.DeliveryChgService" scope="page"/>
<%-- <jsp:useBean id="mpInquiryService" class="client.inquiry.InquiryService" scope="page"/> --%>
<jsp:useBean id="pdInquiryService" class="client.prdInquiry.PrdInquiryService" scope="page"/>
<jsp:useBean id="changeClientInfoService" class="client.changeClientInfo.ChangeClientInfoService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");

    // ---- 로그인 확인 ----
    String clientNo = (String) session.getAttribute("clientNo");
    String clientId = (String) session.getAttribute("clientId");

    if (clientNo == null) {
        session.setAttribute("toastMsg", "로그인이 필요한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirectTo="
                + java.net.URLEncoder.encode(request.getContextPath() + "/myPage.jsp", "UTF-8"));
        return;
    }

    // ---- 탭 선택 ----
    String tab = request.getParameter("tab");
    if (tab == null || tab.trim().isEmpty()) tab = "orders";

    // ---- 주문 내역 (OrderCheckService) ----
    RangeDTO orderRange = new RangeDTO();
    orderRange.setStartNum(1);
    orderRange.setEndNum(50);
    List<OrderDTO> orderList = orderCheckService.searchOrderChk(orderRange, clientNo);

    // ---- 배송지 목록 (DeliveryChgService) ----
    List<DeliveryDTO> deliveryList = deliveryChgService.getDeliveryList(clientNo);

    // ---- 1:1 문의 내역 (InquiryService) ----
    /* List<InquiryDTO> inquiryList = mpInquiryService.getInquiryList(clientNo); */
    java.util.List<InquiryDTO> prdInquiryList = (clientNo == null)
            ? new java.util.ArrayList<InquiryDTO>()
            : pdInquiryService.getInquiryList(clientNo);
    
    String inquiryId = request.getParameter("inquiryId");
    InquiryDTO prdInquiryDetail = (inquiryId == null)? null : pdInquiryService.getInquiryDetail(inquiryId);
    
    
    // ---- 회원 정보 (ChangeClientInfoService) ----
    ClientDTO myInfo = changeClientInfoService.getUserInfo(clientId);

    request.setAttribute("tab", tab);
    request.setAttribute("orderList", orderList);
    request.setAttribute("deliveryList", deliveryList);
  /*   request.setAttribute("inquiryList", inquiryList); */
    request.setAttribute("myInfo", myInfo);
    request.setAttribute("prdInquiryList", prdInquiryList);
    request.setAttribute("prdInquiryDetail", prdInquiryDetail);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-max-width mx-auto py-12 px-margin-desktop">
<div class="flex flex-col md:flex-row gap-gutter-md">

  <%-- ===================== 사이드 네비 (탭) ===================== --%>
  <aside class="w-full md:w-64 flex-shrink-0">
    <div class="bg-surface-container-lowest rounded-xl p-6 border border-surface-variant">
      <div class="flex items-center gap-4 mb-6">
        <div class="w-12 h-12 rounded-full bg-primary-fixed flex items-center justify-center flex-shrink-0">
          <span class="material-symbols-outlined text-on-primary-fixed text-3xl">face</span>
        </div>
        <p class="font-bold text-headline-sm text-headline-sm">${sessionScope.clientName}님</p>
      </div>
      <nav class="space-y-1">
        <a class="flex items-center justify-between p-3 rounded-lg transition-all ${tab == 'orders' ? 'bg-secondary-container text-on-secondary-container font-bold' : 'text-on-surface-variant hover:bg-surface-container'}"
           href="myPage.jsp?tab=orders">
          <span class="flex items-center"><span class="material-symbols-outlined mr-3">shopping_bag</span>주문 내역</span>
          <span class="material-symbols-outlined">chevron_right</span>
        </a>
        <a class="flex items-center justify-between p-3 rounded-lg transition-all ${tab == 'delivery' ? 'bg-secondary-container text-on-secondary-container font-bold' : 'text-on-surface-variant hover:bg-surface-container'}"
           href="myPage.jsp?tab=delivery">
          <span class="flex items-center"><span class="material-symbols-outlined mr-3">location_on</span>배송지 관리</span>
          <span class="material-symbols-outlined">chevron_right</span>
        </a>
        <a class="flex items-center justify-between p-3 rounded-lg transition-all ${tab == 'inquiry' ? 'bg-secondary-container text-on-secondary-container font-bold' : 'text-on-surface-variant hover:bg-surface-container'}"
           href="myPage.jsp?tab=inquiry">
          <span class="flex items-center"><span class="material-symbols-outlined mr-3">chat_bubble</span>문의내역</span>
          <span class="material-symbols-outlined">chevron_right</span>
        </a>
        <a class="flex items-center justify-between p-3 rounded-lg transition-all ${tab == 'info' ? 'bg-secondary-container text-on-secondary-container font-bold' : 'text-on-surface-variant hover:bg-surface-container'}"
           href="myPage.jsp?tab=info">
          <span class="flex items-center"><span class="material-symbols-outlined mr-3">settings</span>개인정보 수정</span>
          <span class="material-symbols-outlined">chevron_right</span>
        </a>
      </nav>
    </div>
  </aside>

  <%-- ===================== 메인 콘텐츠 ===================== --%>
  <section class="flex-grow">

    <%-- ---------- 주문 내역 ---------- --%>
    <c:if test="${tab == 'orders'}">
      <div class="bg-surface-container-lowest border border-surface-variant rounded-xl overflow-hidden">
        <div class="p-6 border-b border-surface-variant">
          <h2 class="font-headline-sm text-headline-sm flex items-center">
            <span class="material-symbols-outlined mr-2 text-primary">receipt_long</span>주문 내역
          </h2>
        </div>
        <c:choose>
          <c:when test="${empty orderList}">
            <div class="p-16 text-center text-on-surface-variant">
              <span class="material-symbols-outlined text-6xl text-outline-variant mb-4 block">receipt_long</span>
              주문 내역이 없습니다.
            </div>
          </c:when>
          <c:otherwise>
            <div class="divide-y divide-surface-variant">
              <c:forEach var="o" items="${orderList}">
                <c:set var="unitPrice" value="${o.discount > 0 ? (o.price * (100 - o.discount) / 100) : o.price}"/>
                <div class="p-6 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                  <div>
                    <span class="px-3 py-1 rounded-full text-body-sm ${o.deliveryStatus == '배송완료' ? 'bg-secondary-container text-on-secondary-container' : 'bg-primary-container text-white'}">${o.deliveryStatus}</span>
                    <p class="font-bold mt-2">${o.prdName}</p>
                    <p class="text-on-surface-variant text-body-sm">주문번호: ${o.orderID}</p>
                  </div>
                  <div class="flex items-center gap-4">
                    <p class="font-bold text-headline-sm text-primary"><fmt:formatNumber value="${unitPrice}" type="number"/>원</p>
                    <form method="post" action="orderDelete.jsp" onsubmit="return confirm('이 주문 내역을 삭제할까요?');">
                      <input type="hidden" name="orderId" value="${o.orderID}"/>
                      <button type="submit" class="text-error text-body-sm hover:underline">삭제</button>
                    </form>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </c:if>

    <%-- ---------- 배송지 관리 ---------- --%>
    <c:if test="${tab == 'delivery'}">
      <div class="bg-surface-container-lowest border border-surface-variant rounded-xl overflow-hidden mb-6">
        <div class="p-6 border-b border-surface-variant">
          <h2 class="font-headline-sm text-headline-sm flex items-center">
            <span class="material-symbols-outlined mr-2 text-primary">location_on</span>배송지 관리
          </h2>
        </div>
        <c:choose>
          <c:when test="${empty deliveryList}">
            <div class="p-16 text-center text-on-surface-variant">
              <span class="material-symbols-outlined text-6xl text-outline-variant mb-4 block">location_off</span>
              등록된 배송지가 없습니다.
            </div>
          </c:when>
          <c:otherwise>
            <div class="divide-y divide-surface-variant">
              <c:forEach var="d" items="${deliveryList}">
                <div class="p-6 flex items-start justify-between gap-4">
                  <div>
                    <c:if test="${d.firstDestination}">
                      <span class="px-2 py-0.5 rounded-full bg-secondary-container text-on-secondary-container text-body-sm mr-2">기본 배송지</span>
                    </c:if>
                    <p class="font-bold mt-2">${d.recipient} <span class="text-on-surface-variant font-normal">(${d.recipientPhone})</span></p>
                    <p class="text-on-surface-variant text-body-sm mt-1">[${d.deliveryPost}] ${d.deliveryAddr}</p>
                  </div>
                  <form method="post" action="deliveryDelete.jsp" onsubmit="return confirm('이 배송지를 삭제할까요?');">
                    <input type="hidden" name="deliveryId" value="${d.deliveryID}"/>
                    <button type="submit" class="text-error text-body-sm hover:underline">삭제</button>
                  </form>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="bg-surface-container-lowest border border-surface-variant rounded-xl p-6">
        <h3 class="font-bold mb-4">새 배송지 추가</h3>
        <form method="post" action="deliveryAdd.jsp" class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <input class="border border-outline-variant rounded-lg px-4 py-2" type="text" name="recipient" placeholder="받는 사람" required/>
          <input class="border border-outline-variant rounded-lg px-4 py-2" type="text" name="recipientPhone" placeholder="연락처" required/>
          <input class="border border-outline-variant rounded-lg px-4 py-2" type="text" name="deliveryPost" placeholder="우편번호" required/>
          <input class="border border-outline-variant rounded-lg px-4 py-2" type="text" name="deliveryAddr" placeholder="주소" required/>
          <label class="flex items-center gap-2 md:col-span-2 text-body-sm text-on-surface-variant">
            <input type="checkbox" name="firstDestination" value="Y"/> 기본 배송지로 설정
          </label>
          <button class="md:col-span-2 bg-primary text-on-primary py-3 rounded-lg font-bold" type="submit">배송지 추가</button>
        </form>
      </div>
    </c:if>

    <%-- ---------- 문의내역 ---------- --%>
<c:if test="${tab == 'inquiry'}">
  <c:choose>
    
    <c:when test="${not empty prdInquiryDetail}">
      <div class="bg-surface-container-lowest border border-surface-variant rounded-xl p-6">
        <div class="p-6 border-b border-surface-variant flex justify-between items-center bg-surface-container-low mb-6 rounded-lg">
          <h2 class="font-headline-sm text-headline-sm flex items-center">
            <span class="material-symbols-outlined mr-2 text-primary">quiz</span>문의 상세 보기
          </h2>
          <a href="myPage.jsp?tab=inquiry" class="bg-surface-container text-on-surface px-4 py-2 rounded-lg font-bold text-body-sm hover:bg-surface-container-high flex items-center">
            <span class="material-symbols-outlined text-body-sm mr-1">arrow_back</span>목록으로
          </a>
        </div>

        <div class="space-y-4">
          <div>
            <span class="px-3 py-1 rounded-full text-body-sm ${prdInquiryDetail.answerStatus == '답변완료' ? 'bg-secondary-container text-on-secondary-container' : 'bg-surface-container-high text-on-surface-variant'}">
              ${prdInquiryDetail.answerStatus}
            </span>
            <h3 class="text-xl font-bold mt-2">${prdInquiryDetail.inquiryTitle}</h3>
            <p class="text-on-surface-variant text-body-sm mt-1">
              작성일: <fmt:formatDate value="${prdInquiryDetail.inquiryDate}" pattern="yyyy.MM.dd HH:mm"/>
            </p>
          </div>
          
          <div class="border-t border-surface-variant pt-4">
            <p class="text-body-sm text-on-surface-variant mb-1 font-bold">문의 내용</p>
            <div class="bg-surface-container rounded-lg p-4 text-on-surface min-h-[120px] whitespace-pre-wrap">${prdInquiryDetail.inquiryContent}</div>
          </div>
          
          <c:if test="${not empty prdInquiryDetail.answer}">
            <div class="border-t border-surface-variant pt-4 bg-secondary-container/10 p-4 rounded-lg">
              <p class="text-body-sm text-secondary font-bold mb-1 flex items-center">
                <span class="material-symbols-outlined text-sm mr-1">reply</span>운영자 답변
              </p>
              <div class="text-on-surface whitespace-pre-wrap">${prdInquiryDetail.answer}</div>
              <p class="text-on-surface-variant text-body-xs mt-2 text-right">
                답변일: <fmt:formatDate value="${prdInquiryDetail.answerDate}" pattern="yyyy.MM.dd HH:mm"/>
              </p>
            </div>
          </c:if>
        </div>
      </div>
    </c:when>

    <c:otherwise>
      <div class="bg-surface-container-lowest border border-surface-variant rounded-xl overflow-hidden">
        <div class="p-6 border-b border-surface-variant">
          <h2 class="font-headline-sm text-headline-sm flex items-center">
            <span class="material-symbols-outlined mr-2 text-primary">chat_bubble</span>문의내역
          </h2>
        </div>
        <c:choose>
          <c:when test="${empty prdInquiryList}">
            <div class="p-16 text-center text-on-surface-variant">
              <span class="material-symbols-outlined text-6xl text-outline-variant mb-4 block">quiz</span>
              문의 내역이 없습니다.
            </div>
          </c:when>
          <c:otherwise>
            <div class="divide-y divide-surface-variant">
              <c:forEach var="prdiq" items="${prdInquiryList}">
                <div class="p-6 flex items-center justify-between gap-4">
                  <div>
                    <p class="font-bold">
                      <a href="myPage.jsp?tab=inquiry&inquiryId=${prdiq.inquiryId}" class="text-primary hover:underline">
                        ${prdiq.inquiryTitle}
                      </a>
                    </p>
                    <p class="text-on-surface-variant text-body-sm mt-1"><fmt:formatDate value="${prdiq.inquiryDate}" pattern="yyyy.MM.dd"/></p>
                  </div>
                  <div class="flex items-center gap-4">
                    <span class="px-3 py-1 rounded-full text-body-sm ${prdiq.answerStatus == '답변완료' ? 'bg-secondary-container text-on-secondary-container' : 'bg-surface-container-high text-on-surface-variant'}">${prdiq.answerStatus}</span>
                    <form method="post" action="inquiryDelete.jsp" onsubmit="return confirm('이 문의 내역을 삭제할까요?');">
                      <input type="hidden" name="inquiryId" value="${prdiq.inquiryId}"/>
                      <button type="submit" class="text-error text-body-sm hover:underline">삭제</button>
                    </form>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </c:otherwise>

  </c:choose>
</c:if>

    <%-- ---------- 개인정보 수정 ---------- --%>
    <c:if test="${tab == 'info'}">
      <div class="bg-surface-container-lowest border border-surface-variant rounded-xl p-6">
        <h2 class="font-headline-sm text-headline-sm flex items-center mb-6">
          <span class="material-symbols-outlined mr-2 text-primary">settings</span>개인정보 수정
        </h2>
        <c:if test="${empty myInfo}">
          <p class="text-on-surface-variant">회원 정보를 불러오지 못했습니다.</p>
        </c:if>
        <c:if test="${not empty myInfo}">
          <form method="post" action="changeClientInfoProcess.jsp" class="space-y-4 max-w-lg">
            <div>
              <label class="text-body-sm text-on-surface-variant block mb-1">아이디</label>
              <input class="w-full border border-outline-variant rounded-lg px-4 py-2 bg-surface-container" type="text" value="${myInfo.clientId}" disabled/>
            </div>
            <div>
              <label class="text-body-sm text-on-surface-variant block mb-1">이름</label>
              <input class="w-full border border-outline-variant rounded-lg px-4 py-2" type="text" name="clientName" value="${myInfo.clientName}" required/>
            </div>
            <div>
              <label class="text-body-sm text-on-surface-variant block mb-1">이메일</label>
              <input class="w-full border border-outline-variant rounded-lg px-4 py-2" type="email" name="clientEmail" value="${myInfo.clientEmail}" required/>
            </div>
            <div>
              <label class="text-body-sm text-on-surface-variant block mb-1">연락처</label>
              <input class="w-full border border-outline-variant rounded-lg px-4 py-2" type="text" name="clientTel" value="${myInfo.clientTel}" required/>
            </div>
            <button class="bg-primary text-on-primary py-3 px-8 rounded-lg font-bold" type="submit">정보 수정</button>
          </form>
        </c:if>
      </div>
    </c:if>

  </section>
</div>
</section>

<%@ include file="common/footer.jsp" %>
