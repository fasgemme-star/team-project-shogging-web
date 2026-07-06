<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- HOME VIEW -->
<section class="active-view" id="home-view">
<!-- Hero Banner -->
<div class="relative w-full h-[500px] overflow-hidden bg-surface-container">
<div class="absolute inset-0 bg-cover bg-center" data-alt="A lush and vibrant close-up photograph of assorted premium organic vegetables" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuBVKkTgilaUswNHvksY6TGPsXcR_uZnB-Mt0ZgdRNLsZIHkSkHfcZIvgYbuBM5c_ypCKOGDLsbhd1y0HOlscanFre3H02AhAkxV0muJDYSUfY0d2zRQmRRNNSf3U4RMKW1Z7xZPE_smBiGwhD3jf0NORku9el6I-j_lBVOjewa9sGtA_iCz7wG1guE0frb0YYeIFEcZ1n49jiOxZdGxO-Cpz_NED9b4x43LnGuC-pymxBG6aHHfdaQn-HNwBiE75nmE2zHz8rbSWg4')"></div>
<div class="absolute inset-0 bg-gradient-to-r from-black/50 to-transparent"></div>
<div class="relative max-w-max-width mx-auto h-full flex flex-col justify-center px-margin-desktop text-white">
<span class="bg-primary text-on-primary px-4 py-1 rounded-full text-label-md w-fit mb-4">TODAY'S HARVEST</span>
<h1 class="font-headline-xl text-headline-xl mb-4 leading-tight">오늘 수확한<br/>프리미엄 유기농 채소</h1>
<p class="text-body-lg mb-8 max-w-md">새벽 샛별배송으로 가장 신선한 식탁을 준비하세요. 농장에서 바로 온 프리미엄 퀄리티.</p>
<button class="bg-primary-container text-on-primary-container px-8 py-4 rounded-lg font-bold text-body-md hover:opacity-90 transition-opacity w-fit shadow-lg shadow-primary/20" onclick="showView('detail-view')">지금 쇼핑하기</button>
</div>
</div>
<!-- Best Sellers Bento Grid -->
<section class="max-w-max-width mx-auto px-margin-desktop py-16">
<div class="flex justify-between items-end mb-10">
<div>
<h2 class="text-headline-lg font-headline-lg text-on-surface">인기 상품 리스트</h2>
<p class="text-body-md text-on-surface-variant">프레시마켓 고객들이 가장 많이 찾는 제품들</p>
</div>
<button class="text-primary font-bold hover:underline flex items-center gap-1" onclick="showView('category-view', '베스트')">전체보기 <span class="material-symbols-outlined text-sm">arrow_forward</span></button>
</div>
<!-- 서버(HomeServlet: /api/home)에서 받아온 베스트 상품이 renderHome()에 의해 여기 채워짐 -->
<div class="grid grid-cols-1 md:grid-cols-4 gap-gutter-md" id="home-best-grid">
<div class="col-span-full py-20 text-center text-on-surface-variant">상품 정보를 불러오고 있습니다...</div>
</div>
</section>
</section>
