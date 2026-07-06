<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- LOGIN VIEW -->
<section class="hidden-view max-w-md mx-auto py-24 px-6" id="login-view">
<div class="bg-surface rounded-2xl shadow-xl shadow-primary/5 p-8 border border-surface-variant">
<h2 class="text-headline-md font-headline-md text-on-surface text-center mb-8">로그인</h2>
<!-- 에러 메시지 영역: 백엔드 로그인 실패 시 JS에서 텍스트 채우고 hidden 제거 -->
<div class="hidden mb-4 px-4 py-3 rounded-lg bg-error-container text-on-error-container text-body-sm" id="login-error-msg"></div>
<div class="space-y-4">
<div>
<label class="block text-label-md font-bold text-on-surface-variant mb-1" for="login-id">아이디</label>
<input autocomplete="username" class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none" id="login-id" name="loginId" placeholder="아이디를 입력해주세요" type="text"/>
</div>
<div>
<label class="block text-label-md font-bold text-on-surface-variant mb-1" for="login-pw">비밀번호</label>
<input autocomplete="current-password" class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary focus:border-transparent outline-none" id="login-pw" name="loginPw" placeholder="비밀번호를 입력해주세요" type="password"/>
</div>
<button class="w-full bg-primary py-4 text-on-primary font-bold rounded-lg hover:opacity-90 transition-opacity mt-4" onclick="handleLogin()">로그인</button>
<button class="w-full border border-primary text-primary py-4 font-bold rounded-lg hover:bg-surface-container transition-colors" onclick="showView('signup-view')">회원가입</button>
</div>
<div class="flex justify-center gap-4 mt-8 text-body-sm text-on-surface-variant">
<a class="hover:text-primary" href="javascript:void(0)" onclick="showToast('준비 중입니다.')">아이디 찾기</a>
<span class="text-surface-variant">|</span>
<a class="hover:text-primary" href="javascript:void(0)" onclick="showToast('준비 중입니다.')">비밀번호 찾기</a>
</div>
</div>
</section>
