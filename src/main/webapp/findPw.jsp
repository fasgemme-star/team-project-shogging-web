<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="findPwService" class="client.findPw.FindPwService" scope="page"/>
<%
    request.setCharacterEncoding("UTF-8");
    String errorMsg = null;
    boolean verified = false;
    String verifiedId = null;
    boolean resetDone = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String step = request.getParameter("step");

        if ("verify".equals(step)) {
            String clientId = request.getParameter("clientId");
            String userEmail = request.getParameter("userEmail");

            // ---- FindPwService 메소드 연결: 본인 확인 ----
            boolean exists = findPwService.findPassword(clientId, userEmail);

            if (exists) {
                verified = true;
                verifiedId = clientId;
            } else {
                errorMsg = "일치하는 회원 정보를 찾을 수 없습니다.";
            }
        } else if ("reset".equals(step)) {
            String clientId = request.getParameter("clientId");
            String newPw = request.getParameter("newPw");
            String newPwConfirm = request.getParameter("newPwConfirm");

            if (newPw == null || !newPw.equals(newPwConfirm)) {
                errorMsg = "새 비밀번호가 일치하지 않습니다.";
                verified = true;
                verifiedId = clientId;
            } else {
                // ---- FindPwService 메소드 연결: 비밀번호 재설정 ----
                boolean ok = findPwService.resetPassword(clientId, newPw);
                if (ok) {
                    resetDone = true;
                    session.setAttribute("toastMsg", "비밀번호가 변경되었습니다. 새 비밀번호로 로그인해주세요.");
                } else {
                    errorMsg = "비밀번호 변경에 실패했습니다.";
                    verified = true;
                    verifiedId = clientId;
                }
            }
        }
    }
    request.setAttribute("errorMsg", errorMsg);
    request.setAttribute("verified", verified);
    request.setAttribute("verifiedId", verifiedId);
    request.setAttribute("resetDone", resetDone);
%>
<%@ include file="common/header.jsp" %>

<section class="max-w-md mx-auto py-24 px-6" id="find-pw-view">
  <div class="bg-surface rounded-2xl shadow-xl shadow-primary/5 p-8 border border-surface-variant">
    <h2 class="text-headline-md font-headline-md text-on-surface text-center mb-8">비밀번호 찾기</h2>

    <c:if test="${not empty errorMsg}">
      <div class="mb-4 p-3 rounded-lg bg-error-container text-on-error-container text-body-sm text-center">${errorMsg}</div>
    </c:if>

    <c:choose>
      <c:when test="${resetDone}">
        <p class="text-center text-primary font-bold mb-8">비밀번호가 정상적으로 변경되었습니다.</p>
        <a class="w-full block text-center bg-primary py-4 text-on-primary font-bold rounded-lg hover:opacity-90 transition-opacity" href="login.jsp">로그인하러 가기</a>
      </c:when>

      <c:when test="${verified}">
        <p class="text-center text-on-surface-variant text-body-sm mb-6">본인 확인이 완료되었습니다. 새 비밀번호를 입력해주세요.</p>
        <form method="post" action="findPw.jsp" class="space-y-4">
          <input type="hidden" name="step" value="reset"/>
          <input type="hidden" name="clientId" value="${verifiedId}"/>
          <div>
            <label class="block text-label-md font-bold text-on-surface-variant mb-1">새 비밀번호</label>
            <input class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                   name="newPw" type="password" required/>
          </div>
          <div>
            <label class="block text-label-md font-bold text-on-surface-variant mb-1">새 비밀번호 확인</label>
            <input class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                   name="newPwConfirm" type="password" required/>
          </div>
          <button class="w-full bg-primary py-4 text-on-primary font-bold rounded-lg hover:opacity-90 transition-opacity mt-4" type="submit">비밀번호 변경</button>
        </form>
      </c:when>

      <c:otherwise>
        <form method="post" action="findPw.jsp" class="space-y-4">
          <input type="hidden" name="step" value="verify"/>
          <div>
            <label class="block text-label-md font-bold text-on-surface-variant mb-1">아이디</label>
            <input class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                   name="clientId" type="text" required/>
          </div>
          <div>
            <label class="block text-label-md font-bold text-on-surface-variant mb-1">이메일</label>
            <input class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                   name="userEmail" type="email" required/>
          </div>
          <button class="w-full bg-primary py-4 text-on-primary font-bold rounded-lg hover:opacity-90 transition-opacity mt-4" type="submit">본인 확인</button>
        </form>
      </c:otherwise>
    </c:choose>

    <div class="flex justify-center gap-4 mt-8 text-body-sm text-on-surface-variant">
      <a class="hover:text-primary" href="login.jsp">로그인으로 돌아가기</a>
      <span class="text-surface-variant">|</span>
      <a class="hover:text-primary" href="findId.jsp">아이디 찾기</a>
    </div>
  </div>
</section>

<%@ include file="common/footer.jsp" %>
