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
<div class="grid grid-cols-1 md:grid-cols-4 gap-gutter-md">
<!-- Product Card 1 -->
<div class="group cursor-pointer" onclick="showView('detail-view')">
<div class="relative aspect-[3/4] rounded-xl overflow-hidden mb-4 bg-surface-container">
<img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" data-alt="Fresh organic lettuce" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDalHL2kArSw9FyhFR3-22R_wXQhC854QJyKsxTOesPYLkGSJixEgVGlOLrB0ix-DDelEgiydVJXLqy4W1_gnaDExqguKKoy10HO7H22BWhyTshB2ZszQUX_NojZUeu-NPYzRagglgAtex4ZlONKBhw2RC8WX6x-5dYN4zSFiJ6BDYtpny4UptOzfDJBB4RtAmg1UVkVgA4cCEwi5ug1GGznlQaJyI-5yTgCNN0qvKFlaCWHWIbkWZ3IeyBmjjW3aavC-1fCS1oU6k"/>
<button class="absolute bottom-4 right-4 bg-white/90 p-3 rounded-full shadow-md text-primary hover:bg-primary hover:text-white transition-all" onclick="event.stopPropagation(); addToCart('1', 1)">
<span class="material-symbols-outlined">add_shopping_cart</span>
</button>
<span class="absolute top-4 left-4 bg-primary text-on-primary px-3 py-1 rounded text-label-md">Best</span>
</div>
<p class="text-on-surface-variant text-body-sm mb-1">[프레시] 유기농 모듬 쌈채소</p>
<h3 class="font-bold text-on-surface text-body-lg mb-2">4,900원</h3>
<div class="flex items-center gap-1 text-primary">
<span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">star</span>
<span class="text-label-md font-bold">4.9 (2,103)</span>
</div>
</div>
<!-- Product Card 2 -->
<div class="group cursor-pointer" onclick="showView('detail-view')">
<div class="relative aspect-[3/4] rounded-xl overflow-hidden mb-4 bg-surface-container">
<img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" data-alt="Fresh organic carrots" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDSZusN5is3Nydu-CZqYb9SFW6pskAzhttR3suzgyLRPncRDNyHokhv3LxypME3EeX8_fkKPvL4LABPTRs7V2hdZOI55kEI7ysW2NuJaR5w-rf5i6R_SV-swt7tcmfS3UZbXUb_PSzn-ot7mYdOeDbHKg6uVY0iHrrgz6gMUT-XDJKMHuAtuLHzK954IECampDFQLJyaD8mdAtAXWGiMbYGFQmHiYgv6JcNhGuLbcyBl0i9jpeUXtsQzCigOQHCTZePag7rMnTqet8"/>
<button class="absolute bottom-4 right-4 bg-white/90 p-3 rounded-full shadow-md text-primary hover:bg-primary hover:text-white transition-all" onclick="event.stopPropagation(); addToCart('2', 1)">
<span class="material-symbols-outlined">add_shopping_cart</span>
</button>
</div>
<p class="text-on-surface-variant text-body-sm mb-1">[지리산] 흙당근 500g</p>
<h3 class="font-bold text-on-surface text-body-lg mb-2">3,200원</h3>
<div class="flex items-center gap-1 text-primary">
<span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">star</span>
<span class="text-label-md font-bold">4.8 (1,452)</span>
</div>
</div>
</div>
</section>
</section>
