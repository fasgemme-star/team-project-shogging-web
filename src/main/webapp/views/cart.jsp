<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- CART VIEW -->
<section class="hidden-view max-w-max-width mx-auto py-16 px-margin-desktop" id="cart-view">
<h2 class="text-headline-lg font-headline-lg text-on-surface mb-10">장바구니</h2>
<div class="flex flex-col lg:flex-row gap-gutter-md">
<!-- Cart Items -->
<div class="flex-1 space-y-4" id="cart-items-container">
<!-- Dynamic Cart Content -->
</div>
<!-- Payment Summary -->
<div class="w-full lg:w-96">
<div class="bg-surface-container p-8 rounded-xl sticky top-24">
<h3 class="text-headline-sm font-headline-sm mb-6">결제 예정 금액</h3>
<div class="space-y-4 mb-6">
<div class="flex justify-between text-on-surface-variant">
<span>상품금액</span>
<span id="cart-subtotal">0원</span>
</div>
<div class="flex justify-between text-on-surface-variant">
<span>배송비</span>
<span class="text-primary" id="cart-delivery-fee">+0원</span>
</div>
<div class="border-t border-surface-variant pt-4 flex justify-between font-bold text-headline-sm">
<span>결제금액</span>
<span class="text-primary" id="cart-total">0원</span>
</div>
</div>
<button class="w-full bg-primary text-on-primary py-4 rounded-lg font-bold text-body-lg shadow-lg shadow-primary/20" onclick="checkout()">주문하기</button>
</div>
</div>
</div>
</section>
