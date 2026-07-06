<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- PRODUCT DETAIL VIEW -->
<section class="hidden-view max-w-max-width mx-auto py-16 px-margin-desktop" id="detail-view">
<div class="flex flex-col md:flex-row gap-gutter-md">
<div class="flex-1">
<img class="w-full aspect-square object-cover rounded-2xl bg-surface-container" data-alt="Product Image" id="detail-image" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAq_eyy1ETvUS4wTwkvlK8sSBsTiAaatv4x5biRc33Et-9FO7ooZ6L9FU6LRtIGEIFk0VRw3jE8fZQ08KyXCp5rnYt9BmdijMumuGriJEknC2j7N4qNLzXPvTnDt6GkNsGiRCYodDwjE1jUUehy3p_k1Va7rHeIDYEX_90W7CPZtsCSM4FNM1fXygeCwo7xNvH0NRBJPGhLy5oPZj3FP7pyTjzOTzlWF00W4ac1whV3oh37axJSxeUQkAPm1GMoXppQfutJy7Et0Kg"/>
</div>
<div class="flex-1 py-4">
<span class="text-on-surface-variant text-body-sm mb-2 block">샛별배송</span>
<h2 class="text-headline-lg font-headline-lg text-on-surface mb-2" id="detail-name">[프레시] 유기농 모듬 쌈채소</h2>
<p class="text-body-md text-on-surface-variant mb-6">산지 직송으로 만나는 가장 신선한 자연의 맛</p>
<div class="text-headline-xl font-bold text-on-surface mb-8" id="detail-price">4,900원</div>
<!-- Quantity Selector -->
<div class="mb-8 p-4 bg-surface-container-low rounded-xl border border-surface-variant">
<div class="flex justify-between items-center">
<span class="font-bold">수량</span>
<div class="flex items-center border border-outline-variant bg-white rounded-lg">
<button class="p-2 hover:bg-surface-container transition-colors disabled:opacity-30" id="detail-minus-btn" onclick="updateDetailQuantity(-1)">
<span class="material-symbols-outlined text-[20px]">remove</span>
</button>
<span class="px-6 font-bold" id="detail-quantity">1</span>
<button class="p-2 hover:bg-surface-container transition-colors" onclick="updateDetailQuantity(1)">
<span class="material-symbols-outlined text-[20px]">add</span>
</button>
</div>
</div>
<div class="border-t border-surface-variant mt-4 pt-4 flex justify-between items-center">
<span class="font-bold text-on-surface-variant">총 상품 금액</span>
<span class="text-headline-md font-bold text-primary" id="detail-total-price">4,900원</span>
</div>
</div>
<div class="flex gap-4">
<button class="flex-1 bg-primary text-on-primary py-4 rounded-lg font-bold text-body-lg" id="detail-add-cart-btn" onclick="addToCartFromDetail()">장바구니 담기</button>
<button class="w-16 border border-outline-variant rounded-lg flex items-center justify-center hover:bg-surface-container transition-colors" onclick="toggleFavorite(this)">
<span class="material-symbols-outlined text-primary">favorite</span>
</button>
</div>
</div>
</div>
</section>
