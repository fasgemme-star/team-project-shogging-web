<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.signup.ClientDTO" %>
<jsp:useBean id="findIdService" class="client.findId.FindIdService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");
    String resultMsg = null;
    boolean found = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String userName = request.getParameter("userName");
        String userEmail = request.getParameter("userEmail");

        // ---- FindIdService 메소드 연결 ----
        ClientDTO cDTO = findIdService.findId(userName, userEmail);

        if (cDTO != null && cDTO.getClientId() != null) {
            found = true;
            resultMsg = "회원님의 아이디는 [" + cDTO.getClientId() + "] 입니다.";
        } else {
            resultMsg = "일치하는 회원 정보를 찾을 수 없습니다.";
        }
    }
    request.setAttribute("resultMsg", resultMsg);
    request.setAttribute("found", found);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-md mx-auto py-24 px-6" id="find-id-view">
  <div class="bg-surface rounded-2xl shadow-xl shadow-primary/5 p-8 border border-surface-variant">
    <h2 class="text-headline-md font-headline-md text-on-surface text-center mb-8">아이디 찾기</h2>

    <c:if test="${not empty resultMsg}">
      <div class="mb-6 p-4 rounded-lg text-body-sm text-center ${found ? 'bg-primary/10 text-primary font-bold' : 'bg-error-container text-on-error-container'}">
        ${resultMsg}
      </div>
    </c:if>

    <c:if test="${!found}">
    <form method="post" action="findId.jsp" class="space-y-4">
      <div>
        <label class="block text-label-md font-bold text-on-surface-variant mb-1">이름</label>
        <input class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
               name="userName" placeholder="이름을 입력해주세요" type="text" required/>
      </div>
      <div>
        <label class="block text-label-md font-bold text-on-surface-variant mb-1">이메일</label>
        <input class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
               name="userEmail" placeholder="가입 시 등록한 이메일" type="email" required/>
      </div>
      <button class="w-full bg-primary py-4 text-on-primary font-bold rounded-lg hover:opacity-90 transition-opacity mt-4" type="submit">아이디 찾기</button>
    </form>
    </c:if>

    <c:if test="${found}">
      <a class="w-full block text-center bg-primary py-4 text-on-primary font-bold rounded-lg hover:opacity-90 transition-opacity" href="login.jsp">로그인하러 가기</a>
    </c:if>

    <div class="flex justify-center gap-4 mt-8 text-body-sm text-on-surface-variant">
      <a class="hover:text-primary" href="login.jsp">로그인으로 돌아가기</a>
      <span class="text-surface-variant">|</span>
      <a class="hover:text-primary" href="findPw.jsp">비밀번호 찾기</a>
    </div>
  </div>
</section>

<%@ include file="common/footer.jsp" %>
