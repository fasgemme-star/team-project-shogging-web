<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.signup.ClientDTO" %>
<jsp:useBean id="loginService" class="client.login.LoginService" scope="page"/>
<%
    String errorMsg = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String clientId = request.getParameter("clientId");
        String password = request.getParameter("password");

        if (clientId == null || clientId.trim().isEmpty() || password == null || password.isEmpty()) {
            errorMsg = "아이디와 비밀번호를 입력해주세요.";
        } else {
            // ---- LoginService 메소드 연결 ----
            ClientDTO cDTO = loginService.login(clientId, password);

            if (cDTO != null && cDTO.getClientNo() != null) {
                // 로그인 성공 -> 세션에 저장
                session.setAttribute("clientNo", cDTO.getClientNo());
                session.setAttribute("clientId", cDTO.getClientId());
                session.setAttribute("clientName", cDTO.getClientName());
                session.setAttribute("toastMsg", cDTO.getClientName() + "님 환영합니다!");

                String redirectTo = request.getParameter("redirectTo");
                if (redirectTo == null || redirectTo.trim().isEmpty()) {
                    redirectTo = request.getContextPath() + "/home.jsp";
                }
                response.sendRedirect(redirectTo);
                return;
            } else {
                errorMsg = "아이디 또는 비밀번호가 일치하지 않습니다.";
            }
        }
    }
    request.setAttribute("errorMsg", errorMsg);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-md mx-auto py-24 px-6" id="login-view">
  <div class="bg-surface rounded-2xl shadow-xl shadow-primary/5 p-8 border border-surface-variant">
    <h2 class="text-headline-md font-headline-md text-on-surface text-center mb-8">로그인</h2>

    <c:if test="${not empty errorMsg}">
      <div class="mb-4 p-3 rounded-lg bg-error-container text-on-error-container text-body-sm text-center">${errorMsg}</div>
    </c:if>

    <form method="post" action="login.jsp" class="space-y-4">
      <input type="hidden" name="redirectTo" value="${param.redirectTo}"/>
      <div>
        <label class="block text-label-md font-bold text-on-surface-variant mb-1">아이디</label>
        <input class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
               name="clientId" placeholder="아이디를 입력해주세요" type="text" required/>
      </div>
      <div>
        <label class="block text-label-md font-bold text-on-surface-variant mb-1">비밀번호</label>
        <input class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
               name="password" placeholder="비밀번호를 입력해주세요" type="password" required/>
      </div>
      <button class="w-full bg-primary py-4 text-on-primary font-bold rounded-lg hover:opacity-90 transition-opacity mt-4" type="submit">로그인</button>
      <a class="block w-full text-center border border-primary text-primary py-4 font-bold rounded-lg hover:bg-surface-container transition-colors" href="signup.jsp">회원가입</a>
    </form>

    <div class="flex justify-center gap-4 mt-8 text-body-sm text-on-surface-variant">
      <a class="hover:text-primary" href="javascript:void(0)" onclick="showToast('준비 중입니다.')">아이디 찾기</a>
      <span class="text-surface-variant">|</span>
      <a class="hover:text-primary" href="javascript:void(0)" onclick="showToast('준비 중입니다.')">비밀번호 찾기</a>
    </div>
  </div>
</section>

<%@ include file="common/footer.jsp" %>
