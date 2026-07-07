<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.signup.ClientDTO" %>
<jsp:useBean id="signupService" class="client.signup.SignupService" scope="page"/>
<%
    String mode = request.getParameter("mode");
    String dupCheckMsg = null;
    String errorMsg = null;
    String userIdValue = request.getParameter("userId");
    if (userIdValue == null) userIdValue = "";

    // ---- 아이디 중복확인 (SignupService.checkDupId) ----
    if ("checkId".equals(mode)) {
        ClientDTO checkDTO = new ClientDTO();
        checkDTO.setClientId(userIdValue);
        boolean dup = signupService.checkDupId(checkDTO);
        dupCheckMsg = dup ? "이미 사용 중인 아이디입니다." : "사용 가능한 아이디입니다.";
    }

    // ---- 회원가입 처리 (SignupService.addUser) ----
    if ("register".equals(mode) && "POST".equalsIgnoreCase(request.getMethod())) {
        String password = request.getParameter("password");
        String passwordConfirm = request.getParameter("passwordConfirm");
        String userName = request.getParameter("userName");
        String userEmail = request.getParameter("userEmail");
        String userPhone = request.getParameter("userPhone");
        String userBirth = request.getParameter("userBirth");
        boolean agreeTerms = request.getParameter("termsOfUse") != null;
        boolean agreePrivacy = request.getParameter("privacyPolicy") != null;

        if (userIdValue.trim().isEmpty() || password == null || password.isEmpty()
                || userName == null || userName.trim().isEmpty()) {
            errorMsg = "필수 항목을 모두 입력해주세요.";
        } else if (!password.equals(passwordConfirm)) {
            errorMsg = "비밀번호가 일치하지 않습니다.";
        } else if (!agreeTerms || !agreePrivacy) {
            errorMsg = "필수 약관에 동의해주세요.";
        } else {
            ClientDTO cDTO = new ClientDTO();
            cDTO.setClientId(userIdValue);
            cDTO.setClientHash(password); // SignupService.addUser 내부에서 해싱 처리됨
            cDTO.setClientName(userName);
            cDTO.setClientEmail(userEmail);
            cDTO.setClientTel(userPhone);
            cDTO.setClientBirth(userBirth);
            cDTO.setClientIp(request.getRemoteAddr());

            boolean success = signupService.addUser(cDTO);

            if (success) {
                session.setAttribute("toastMsg", "프레시마켓 회원이 되신 것을 환영합니다!");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            } else {
                errorMsg = "이미 사용 중인 아이디이거나 가입 처리 중 오류가 발생했습니다.";
            }
        }
    }

    request.setAttribute("dupCheckMsg", dupCheckMsg);
    request.setAttribute("errorMsg", errorMsg);
    request.setAttribute("userIdValue", userIdValue);
%>
<%@ include file="common/header.jsp" %>

<link href="${pageContext.request.contextPath}/common/signup-style.css" rel="stylesheet"/>

<section class="max-w-[640px] mx-auto px-margin-mobile py-section-gap" id="signup-view">
  <div class="text-center mb-10">
    <h2 class="font-headline-md text-headline-md text-on-surface">회원가입</h2>
    <p class="text-label-md text-on-surface-variant mt-2 text-right"><span class="text-[#ee6a7b]">*</span> 필수입력사항</p>
  </div>

  <c:if test="${not empty errorMsg}">
    <div class="mb-6 p-3 rounded-lg bg-error-container text-on-error-container text-body-sm text-center">${errorMsg}</div>
  </c:if>

  <%-- 아이디 중복확인용 별도 폼 (GET, 비밀번호 등은 포함하지 않음) --%>
  <form class="form-row border-t-2 border-primary" method="get" action="signup.jsp">
    <label class="font-label-md text-on-surface label-required" for="userId">아이디</label>
    <input class="input-base" id="userId" name="userId" placeholder="아이디를 입력해주세요" required type="text" value="${userIdValue}"/>
    <input type="hidden" name="mode" value="checkId"/>
    <button class="btn-outline" type="submit">중복확인</button>
  </form>
  <c:if test="${not empty dupCheckMsg}">
    <p class="text-body-sm ${dupCheckMsg.startsWith('사용') ? 'text-primary' : 'text-[#ee6a7b]'} mt-1 mb-2">${dupCheckMsg}</p>
  </c:if>

  <%-- 실제 회원가입 폼 (POST) --%>
  <form class="flex flex-col" id="signupForm" method="post" action="signup.jsp">
    <input type="hidden" name="mode" value="register"/>
    <input type="hidden" name="userId" value="${userIdValue}"/>

    <div class="form-row">
      <label class="font-label-md text-on-surface">아이디</label>
      <div class="col-span-2 flex items-center text-on-surface-variant"><c:out value="${userIdValue}"/> (위에서 입력/확인)</div>
    </div>

    <div class="form-row">
      <label class="font-label-md text-on-surface label-required" for="password">비밀번호</label>
      <div class="col-span-2">
        <input class="input-base" id="password" name="password" placeholder="비밀번호를 입력해주세요" required type="password"/>
      </div>
    </div>

    <div class="form-row">
      <label class="font-label-md text-on-surface label-required" for="passwordConfirm">비밀번호확인</label>
      <div class="col-span-2">
        <input class="input-base" id="passwordConfirm" name="passwordConfirm" placeholder="비밀번호를 한번 더 입력해주세요" required type="password"/>
      </div>
    </div>

    <div class="form-row">
      <label class="font-label-md text-on-surface label-required" for="userName">이름</label>
      <div class="col-span-2">
        <input class="input-base" id="userName" name="userName" placeholder="이름을 입력해주세요" required type="text"/>
      </div>
    </div>

    <div class="form-row">
      <label class="font-label-md text-on-surface label-required" for="userEmail">이메일</label>
      <input class="input-base" id="userEmail" name="userEmail" placeholder="예: freshmarket@market.com" required type="email"/>
    </div>

    <div class="form-row">
      <label class="font-label-md text-on-surface label-required" for="userPhone">휴대폰</label>
      <input class="input-base" id="userPhone" name="userPhone" placeholder="숫자만 입력해주세요" required type="tel"/>
    </div>

    <div class="form-row border-none">
      <label class="font-label-md text-on-surface" for="userBirth">생년월일</label>
      <div class="col-span-2">
        <input class="input-base" id="userBirth" name="userBirth" placeholder="예: 19900101" type="text"/>
      </div>
    </div>

    <div class="mt-8 pt-8 border-t border-outline-variant">
      <div class="flex items-center gap-3 mb-4">
        <input class="w-6 h-6 rounded-full custom-checkbox border-outline-variant" id="allAgree" type="checkbox"/>
        <label class="font-headline-md text-headline-md cursor-pointer" for="allAgree">전체 동의합니다</label>
      </div>
      <div class="pl-9 space-y-3">
        <div class="flex justify-between items-center">
          <div class="flex items-center gap-2">
            <input class="w-5 h-5 rounded-full custom-checkbox border-outline-variant" id="termsOfUse" name="termsOfUse" required type="checkbox"/>
            <label class="text-body-md cursor-pointer" for="termsOfUse">이용약관 동의 (필수)</label>
          </div>
        </div>
        <div class="flex justify-between items-center">
          <div class="flex items-center gap-2">
            <input class="w-5 h-5 rounded-full custom-checkbox border-outline-variant" id="privacyPolicy" name="privacyPolicy" required type="checkbox"/>
            <label class="text-body-md cursor-pointer" for="privacyPolicy">개인정보 수집·이용 동의 (필수)</label>
          </div>
        </div>
      </div>
    </div>

    <button class="btn-primary" type="submit">가입하기</button>
  </form>
</section>

<script>
    const allAgreeCheckbox = document.getElementById('allAgree');
    const subCheckboxes = [document.getElementById('termsOfUse'), document.getElementById('privacyPolicy')];
    allAgreeCheckbox.addEventListener('change', function() {
        subCheckboxes.forEach(cb => cb.checked = this.checked);
    });
    subCheckboxes.forEach(cb => {
        cb.addEventListener('change', function() {
            allAgreeCheckbox.checked = subCheckboxes.every(sub => sub.checked);
        });
    });
</script>

<%@ include file="common/footer.jsp" %>
