<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.productDetail.ProductDTO" %>
<%@ page import="client.inquiry.InquiryDTO" %>
<jsp:useBean id="pdService" class="client.productDetail.ProductDetailService" scope="page"/>
<jsp:useBean id="pdInquiryService" class="client.prdInquiry.PrdInquiryService" scope="page"/> 
<%
    // 주의: ProductDetailDAO.selectProductInfo()는 실제로 OPTION_ID(옵션번호) 기준으로 조회한다.
    // (PRODUCT_ID를 넘기면 매칭되는 행이 없어 상세페이지가 비어 보인다.)
    String optionNo = request.getParameter("optionNo");

    int quantity = 1;
    String qtyParam = request.getParameter("quantity");
    if (qtyParam != null) {
        try { quantity = Integer.parseInt(qtyParam); } catch (NumberFormatException e) { quantity = 1; }
        if (quantity < 1) quantity = 1;
    }

    // ---- ProductDetailService 메소드 연결 ----
    ProductDTO product = (optionNo == null) ? null : pdService.getProductInfo(optionNo);

    // ---- 상품 문의 목록 (PrdInquiryService) ----
    String clientNo = (String) session.getAttribute("clientNo");


	java.util.List<InquiryDTO> getPrdDetailInquiryList = (optionNo == null )
	? new java.util.ArrayList<InquiryDTO>()
	: pdInquiryService.getPrdDetailInquiryList(optionNo);

    

    
    request.setAttribute("product", product);
    request.setAttribute("optionNo", optionNo);
    request.setAttribute("quantity", quantity);
  	request.setAttribute("getPrdDetailInquiryList", getPrdDetailInquiryList);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-max-width mx-auto py-16 px-margin-desktop" id="detail-view">

  <c:choose>
  <c:when test="${empty product}">
    <div class="py-24 text-center text-on-surface-variant">
      <span class="material-symbols-outlined text-6xl text-outline-variant mb-4 block">inventory_2</span>
      상품을 찾을 수 없습니다.
    </div>
  </c:when>
  <c:otherwise>

  <div class="flex flex-col md:flex-row gap-gutter-md">
    <div class="flex-1">
      <img class="w-full aspect-square object-cover rounded-2xl bg-surface-container"
           src="${pageContext.request.contextPath}/${product.prdID}_t.png" alt="${product.prdName}"
           onerror="this.src='${pageContext.request.contextPath}/images/imgbanner1.png'"/>
    </div>
    <div class="flex-1 py-4">
      <span class="text-on-surface-variant text-body-sm mb-2 block">샛별배송</span>
      <h2 class="text-headline-lg font-headline-lg text-on-surface mb-2">${product.prdName}<br>${product.optionName}</h2>
      <p class="text-body-md text-on-surface-variant mb-6">${product.shortInfo}</p>

      <c:set var="unitPrice" value="${product.discount > 0 ? (product.price * (100 - product.discount) / 100) : product.price}"/>

      <div class="text-headline-xl font-bold text-on-surface mb-8">
        <fmt:formatNumber value="${unitPrice}" type="number"/>원
        <c:if test="${product.discount > 0}">
          <span class="text-body-md text-on-surface-variant line-through ml-2"><fmt:formatNumber value="${product.price}" type="number"/>원</span>
          <span class="text-body-md text-primary ml-1">${product.discount}%</span>
        </c:if>
      </div>

      <%-- 수량 선택 + 담기: quantity 파라미터로 현재 페이지를 다시 불러오는 GET 링크 방식 (서블릿 없이 JSP만으로 처리) --%>
      <div class="mb-8 p-4 bg-surface-container-low rounded-xl border border-surface-variant">
        <div class="flex justify-between items-center">
          <span class="font-bold">수량</span>
          <div class="flex items-center border border-outline-variant bg-white rounded-lg">
            <a class="p-2 hover:bg-surface-container transition-colors inline-block ${quantity <= 1 ? 'opacity-30 pointer-events-none' : ''}"
               href="productDetail.jsp?optionNo=${optionNo}&amp;quantity=${quantity - 1}">
              <span class="material-symbols-outlined text-[20px]">remove</span>
            </a>
            <span class="px-6 font-bold">${quantity}</span>
            <a class="p-2 hover:bg-surface-container transition-colors inline-block" href="productDetail.jsp?optionNo=${optionNo}&amp;quantity=${quantity + 1}">
              <span class="material-symbols-outlined text-[20px]">add</span>
            </a>
          </div>
        </div>
        <div class="border-t border-surface-variant mt-4 pt-4 flex justify-between items-center">
          <span class="font-bold text-on-surface-variant">총 상품 금액</span>
          <span class="text-headline-md font-bold text-primary"><fmt:formatNumber value="${unitPrice * quantity}" type="number"/>원</span>
        </div>
      </div>

      <div class="flex gap-4">
        <form method="post" action="cartAdd.jsp" class="flex-1">
          <input type="hidden" name="optionNo" value="${optionNo}"/>
          <input type="hidden" name="quantity" value="${quantity}"/>
          <input type="hidden" name="redirectTo" value="cart.jsp"/>
          <button class="w-full bg-surface-container-high text-on-surface py-4 rounded-lg font-bold text-body-lg border border-outline-variant" type="submit">장바구니 담기</button>
        </form>
        <%-- 바로구매: 장바구니에 담은 뒤 order.jsp로 바로 이동. 이 상품이 담겨 있으므로
             order.jsp에서 만드는 결제 주문명(orderName)이 이 상품명 기준으로 채워진다. --%>
        <form method="post" action="cartAdd.jsp" class="flex-1">
          <input type="hidden" name="optionNo" value="${optionNo}"/>
          <input type="hidden" name="quantity" value="${quantity}"/>
          <input type="hidden" name="redirectTo" value="order.jsp"/>
          <button class="w-full bg-primary text-on-primary py-4 rounded-lg font-bold text-body-lg" type="submit">바로구매</button>
        </form>
      </div>
    </div>
  </div>
<%
ProductDTO product2 = (optionNo == null) ? null : pdService.getProductDetail(optionNo);
request.setAttribute("product2", product2); 
%>
  <%-- ===================== 상품 탭 (상품설명 / 상세정보 / 문의하기) ===================== --%>
  <section class="mt-20 border-t border-surface-variant">
    <div class="flex justify-center items-center border-b border-surface-variant gap-12 md:gap-20">
      <button class="tab-btn py-4 text-body-sm tracking-wider sub-tab-active" onclick="switchDetailTab(event, 'tab-info')">상품설명</button>
      <button class="tab-btn py-4 text-body-sm tracking-wider text-on-surface-variant hover:text-primary transition-colors" onclick="switchDetailTab(event, 'tab-spec')">상세정보</button>
      <button class="tab-btn py-4 text-body-sm tracking-wider text-on-surface-variant hover:text-primary transition-colors" onclick="switchDetailTab(event, 'tab-qna')">문의하기 (${fn:length(getPrdDetailInquiryList)})</button>
    </div>

    <div class="py-12">

      <%-- 상품설명 --%>
      <div class="tab-content-detail" id="tab-info">
        <div class="max-w-3xl mx-auto text-center">
          <h3 class="text-headline-md font-headline-md text-on-surface mb-6">${product.prdName}, 이렇게 좋아요</h3><br>
          <h3 class="text-headline-md font-headline-md text-on-surface mb-6">${product2.description}</h3><br>
          <h3 class="text-headline-md font-headline-md text-on-surface mb-6">${product2.info}</h3><br>
			<%-- <p class="text-body-md text-on-surface-variant leading-relaxed mb-12">${product2.description}</p><br> --%>
			
          <img class="w-full aspect-square object-cover rounded-2xl bg-surface-container"
           src="${pageContext.request.contextPath}/${product.prdID}_c.png" alt="${product.prdName}"
           onerror="this.src='${pageContext.request.contextPath}/images/imgbanner1.png'"/><br>
           
          <img class="w-full aspect-square object-cover rounded-2xl bg-surface-container"
           src="${pageContext.request.contextPath}/${product.prdID}_c2.png" alt="${product.prdName}"
           onerror="this.src='${pageContext.request.contextPath}/images/imgbanner1.png'"/><br>
           
          <div class="grid grid-cols-1 md:grid-cols-2 gap-8 text-left">
            <div class="bg-surface-container rounded-xl p-8 border border-outline-variant">
              <span class="material-symbols-outlined text-primary text-4xl mb-4">eco</span>
              <h4 class="text-headline-sm font-headline-sm mb-2">엄선된 산지 직송</h4>
              <p class="text-on-surface-variant text-body-sm">믿을 수 있는 산지에서 정성껏 재배한 상품만 선별해 소개합니다.</p>
            </div>
            <div class="bg-surface-container rounded-xl p-8 border border-outline-variant">
              <span class="material-symbols-outlined text-primary text-4xl mb-4">local_shipping</span>
              <h4 class="text-headline-sm font-headline-sm mb-2">신선 배송</h4>
              <p class="text-on-surface-variant text-body-sm">주문 즉시 콜드체인으로 포장해 신선함을 그대로 전달해 드립니다.</p>
            </div>
          </div>
        </div>
      </div>

      <%-- 상세정보 --%>
      <div class="tab-content-detail hidden" id="tab-spec">
        <div class="max-w-3xl mx-auto">
          <table class="w-full text-body-sm">
            <tbody>
              <tr class="border-b border-surface-variant">
                <th class="text-left py-4 w-40 text-on-surface-variant font-medium">원산지</th>
                <td class="py-4">${empty product.origin ? '정보 없음' : product.origin}</td>
              </tr>
              <tr class="border-b border-surface-variant">
                <th class="text-left py-4 text-on-surface-variant font-medium">제조사</th>
                <td class="py-4">${empty product.manufacturer ? '정보 없음' : product.manufacturer}</td>
              </tr>
              <tr class="border-b border-surface-variant">
                <th class="text-left py-4 text-on-surface-variant font-medium">단위</th>
                <td class="py-4">${empty product.unit ? '정보 없음' : product.unit}</td>
              </tr>
              <tr class="border-b border-surface-variant">
                <th class="text-left py-4 text-on-surface-variant font-medium">구매 수량</th>
                <td class="py-4">최소 ${product.minPurchase}개 · 최대 ${product.maxPurchase}개</td>
              </tr>
              <tr class="border-b border-surface-variant">
                <th class="text-left py-4 text-on-surface-variant font-medium">청소년 구매</th>
                <td class="py-4">${product.underagePurchase == 'N' ? '구매 가능' : '구매 제한'}</td>
              </tr>
              <tr>
                <th class="text-left py-4 text-on-surface-variant font-medium align-top">유의사항</th>
                <td class="py-4">${empty product.notification ? '정보 없음' : product.notification}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <%-- 문의하기 --%>
      <div class="tab-content-detail hidden" id="tab-qna">
        <div class="max-w-3xl mx-auto">
          <c:choose>
            <c:when test="${empty getPrdDetailInquiryList}">
              <div class="flex flex-col items-center justify-center py-16 text-center">
                <span class="material-symbols-outlined text-outline-variant text-6xl mb-4">quiz</span>
                <h3 class="text-headline-sm font-headline-sm text-on-surface mb-2">등록된 문의가 없습니다.</h3>
                <p class="text-on-surface-variant text-body-md">이 상품에 대해 궁금한 점을 남겨주세요.</p>
              </div>
            </c:when>
            <c:otherwise>
              <div class="divide-y divide-surface-variant border-y border-surface-variant mb-10">
                <c:forEach var="prdiq" items="${getPrdDetailInquiryList}">
                  <div class="inquiry-item">
                    
                   <div class="py-4 flex items-center justify-between gap-4 cursor-pointer hover:bg-surface-container/30 transition-colors" 
     onclick="this.closest('.inquiry-item').querySelector('.inquiry-detail').classList.toggle('hidden')">
                      <div>
                        <p class="font-bold text-primary hover:underline flex items-center gap-1">
                          <span class="material-symbols-outlined text-body-md transition-transform duration-200">expand_more</span>
                          ${prdiq.inquiryTitle}
                        </p>
                        <p class="text-on-surface-variant text-body-sm mt-1">
                          <fmt:formatDate value="${prdiq.inquiryDate}" pattern="yyyy.MM.dd"/>
                        </p>
                      </div>
                      <span class="px-3 py-1 rounded-full text-body-sm ${prdiq.answerStatus == '답변완료' ? 'bg-secondary-container text-on-secondary-container' : 'bg-surface-container-high text-on-surface-variant'}">
                        ${prdiq.answerStatus}
                      </span>
                    </div>

                    <div class="inquiry-detail hidden bg-surface-container-low px-6 py-4 border-t border-surface-variant/30 space-y-3">
                      <div>
                        <p class="text-body-xs font-bold text-primary mb-1">[문의 내용]</p>
                        <div class="text-body-md text-on-surface whitespace-pre-wrap">${prdiq.inquiryContent}</div>
                      </div>
                      
                      <c:if test="${not empty prdiq.answer}">
                        <div class="bg-white border border-surface-variant rounded-lg p-4 mt-2">
                          <p class="text-body-xs font-bold text-secondary mb-1 flex items-center">
                            <span class="material-symbols-outlined text-body-sm mr-1">reply</span>[운영자 답변]
                          </p>
                          <div class="text-body-md text-on-surface whitespace-pre-wrap">${prdiq.answer}</div>
                        </div>
                      </c:if>
                    </div>

                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>

          <c:choose>
            <c:when test="${not empty sessionScope.clientNo}">
              <form method="post" action="prdInquiryAdd.jsp" class="bg-surface-container-low rounded-xl p-6 border border-surface-variant space-y-4">
                <input type="hidden" name="prdID" value="${product.prdID}"/>
                <input type="hidden" name="optionNo" value="${optionNo}"/>
                <input type="hidden" name="redirectTo" value="productDetail.jsp?optionNo=${optionNo}"/>
                <input class="w-full border border-outline-variant rounded-lg px-4 py-2" type="text" name="inquiryTitle" placeholder="문의 제목" required/>
                <textarea class="w-full border border-outline-variant rounded-lg px-4 py-2" name="inquiryContent" rows="4" placeholder="문의 내용을 입력해주세요" required></textarea>
                <label class="flex items-center gap-2 text-body-sm text-on-surface-variant">
                  <input type="checkbox" name="inquirySecret" value="Y"/> 비밀글로 등록
                </label>
                <button class="bg-primary text-on-primary py-3 px-8 rounded-lg font-bold" type="submit">문의 등록</button>
              </form>
            </c:when>
            <c:otherwise>
              <div class="text-center py-6 text-on-surface-variant">
                문의를 남기려면 <a class="text-primary font-bold line" href="login.jsp?redirectTo=productDetail.jsp?optionNo=${optionNo}">로그인</a>이 필요합니다.
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

    </div>
  </section>

  </c:otherwise>
  </c:choose>

</section>

<script>
  function switchDetailTab(event, tabId) {
    document.querySelectorAll('.tab-content-detail').forEach(function(el) { el.classList.add('hidden'); });
    document.querySelectorAll('.tab-btn').forEach(function(btn) {
      btn.classList.remove('sub-tab-active');
      btn.classList.add('text-on-surface-variant');
    });
    document.getElementById(tabId).classList.remove('hidden');
    event.currentTarget.classList.add('sub-tab-active');
    event.currentTarget.classList.remove('text-on-surface-variant');
  }
</script>

<%@ include file="common/footer.jsp" %>
