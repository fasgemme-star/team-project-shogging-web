<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- PRODUCT DETAIL VIEW -->
<section class="hidden-view max-w-max-width mx-auto py-16 px-margin-desktop" id="detail-view">

<div class="flex flex-col md:flex-row gap-gutter-md">

    <div class="flex-1">
        <img class="w-full aspect-square object-cover rounded-2xl bg-surface-container"
             id="detail-image"
             src="https://lh3.googleusercontent.com/aida-public/AB6AXuAq_eyy1ETvUS4wTwkvlK8sSBsTiAaatv4x5biRc33Et-9FO7ooZ6L9FU6LRtIGEIFk0VRw3jE8fZQ08KyXCp5rnYt9BmdijMumuGriJEknC2j7N4qNLzXPvTnDt6GkNsGiRCYodDwjE1jUUehy3p_k1Va7rHeIDYEX_90W7CPZtsCSM4FNM1fXygeCwo7xNvH0NRBJPGhLy5oPZj3FP7pyTjzOTzlWF00W4ac1whV3oh37axJSxeUQkAPm1GMoXppQfutJy7Et0Kg"/>
    </div>

    <div class="flex-1 py-4">

        <span class="text-on-surface-variant text-body-sm mb-2 block">샛별배송</span>

        <h2 class="text-headline-lg font-headline-lg text-on-surface mb-2" id="detail-name">
            [프레시] 유기농 모듬 쌈채소
        </h2>

        <p class="text-body-md text-on-surface-variant mb-6">
            산지 직송으로 만나는 가장 신선한 자연의 맛
        </p>

        <div class="text-headline-xl font-bold text-on-surface mb-8" id="detail-price">
            4,900원
        </div>

        <div class="mb-8 p-4 bg-surface-container-low rounded-xl border border-surface-variant">

            <div class="flex justify-between items-center">
                <span class="font-bold">수량</span>

                <div class="flex items-center border border-outline-variant bg-white rounded-lg">

                    <button class="p-2" id="detail-minus-btn"
                            onclick="updateDetailQuantity(-1)">
                        <span class="material-symbols-outlined">remove</span>
                    </button>

                    <span class="px-6 font-bold" id="detail-quantity">1</span>

                    <button class="p-2"
                            onclick="updateDetailQuantity(1)">
                        <span class="material-symbols-outlined">add</span>
                    </button>

                </div>
            </div>

            <div class="border-t border-surface-variant mt-4 pt-4 flex justify-between">

                <span class="font-bold text-on-surface-variant">
                    총 상품 금액
                </span>

                <span class="text-headline-md font-bold text-primary"
                      id="detail-total-price">
                    4,900원
                </span>

            </div>

        </div>

        <div class="flex gap-4">

            <button class="flex-1 bg-primary text-on-primary py-4 rounded-lg font-bold"
                    id="detail-add-cart-btn"
                    onclick="addToCartFromDetail()">
                장바구니 담기
            </button>

            <button class="w-16 border border-outline-variant rounded-lg"
                    onclick="toggleFavorite(this)">
                <span class="material-symbols-outlined text-primary">favorite</span>
            </button>

        </div>

    </div>

</div>

<div class="border-t border-surface-variant mt-16">

    <div class="flex border-b border-surface-variant">

        <button id="tab-desc"
                class="flex-1 py-4 text-center font-bold border-b-2 border-primary text-primary"
                onclick="switchDetailTab('desc')">
            상품설명
        </button>

        <button id="tab-info"
                class="flex-1 py-4 text-center font-bold text-on-surface-variant"
                onclick="switchDetailTab('info')">
            상세정보
        </button>

        <button id="tab-qna"
                class="flex-1 py-4 text-center font-bold text-on-surface-variant"
                onclick="switchDetailTab('qna')">
            상품문의
        </button>

    </div>

    <div class="py-16 px-margin-desktop">

        <div id="content-desc">
            <h3 class="text-2xl font-bold mb-6">자연의 싱그러움을 그대로 담았습니다.</h3>
            <p class="mb-8">
                프레시마켓의 유기농 채소는 농장에서 매일 수확하여
                신선한 상태 그대로 배송됩니다.
            </p>

            <img class="w-full rounded-2xl"
                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuBVKkTgilaUswNHvksY6TGPsXcR_uZnB-Mt0ZgdRNLsZIHkSkHfcZIvgYbuBM5c_ypCKOGDLsbhd1y0HOlscanFre3H02AhAkxV0muJDYSUfY0d2zRQmRRNNSf3U4RMKW1Z7xZPE_smBiGwhD3jf0NORku9el6I-j_lBVOjewa9sGtA_iCz7wG1guE0frb0YYeIFEcZ1n49jiOxZdGxO-Cpz_NED9b4x43LnGuC-pymxBG6aHHfdaQn-HNwBiE75nmE2zHz8rbSWg4">
        </div>

        <div id="content-info" class="hidden">
            <table class="w-full">
                <tr><th class="text-left py-3">포장단위</th><td>1팩</td></tr>
                <tr><th class="text-left py-3">중량</th><td>200g</td></tr>
                <tr><th class="text-left py-3">원산지</th><td>국산</td></tr>
                <tr><th class="text-left py-3">생산자</th><td>프레시마켓 협력농가</td></tr>
            </table>
        </div>

        <div id="content-qna" class="hidden">
            <div class="flex justify-between mb-6">
                <h3 class="font-bold text-xl">상품문의</h3>
                <button class="bg-primary text-on-primary px-5 py-2 rounded-lg">
                    문의하기
                </button>
            </div>

            <div class="border rounded-xl py-16 text-center">
                등록된 문의가 없습니다.
            </div>
        </div>

    </div>

</div>

</section>
