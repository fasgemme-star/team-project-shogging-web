<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- SIGNUP VIEW -->
<section class="hidden-view max-w-xl mx-auto py-16 px-6" id="signup-view">
<h2 class="text-headline-md font-headline-md text-on-surface text-center mb-10">회원가입</h2>
<div class="space-y-6">
<div class="grid grid-cols-4 items-center gap-4">
<label class="text-body-md font-bold text-on-surface" for="signup-id">아이디<span class="text-error">*</span></label>
<div class="col-span-2">
<input autocomplete="username" class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary outline-none" id="signup-id" name="signupId" placeholder="아이디를 입력해주세요" type="text"/>
<!-- 중복확인 결과 메시지: JS에서 텍스트/색상 채움 -->
<p class="text-body-sm mt-1 hidden" id="signup-id-check-msg"></p>
</div>
<button class="border border-primary text-primary py-3 rounded-lg font-bold hover:bg-surface-container" onclick="checkDuplicateId()">중복확인</button>
</div>
<div class="grid grid-cols-4 items-center gap-4">
<label class="text-body-md font-bold text-on-surface" for="signup-pw">비밀번호<span class="text-error">*</span></label>
<div class="col-span-3">
<input autocomplete="new-password" class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:ring-2 focus:ring-primary outline-none" id="signup-pw" name="signupPw" placeholder="비밀번호를 입력해주세요" type="password"/>
</div>
</div>
<div class="pt-10 border-t border-surface-variant flex justify-center">
<button class="w-64 bg-primary text-on-primary py-4 font-bold rounded-lg shadow-lg shadow-primary/20" onclick="submitSignup()">가입하기</button>
</div>
</div>
</section>
