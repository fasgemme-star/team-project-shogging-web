<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    // State Management
    let currentDetailProduct = null;
    let detailQuantity = 1;
    let cart = [];

    // Constants for mock products
    const MOCK_PRODUCTS = [
        { id: '1', name: '[프레시] 유기농 모듬 쌈채소', price: 4900, rating: '4.9', reviews: '2,103', tag: 'Best', img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDalHL2kArSw9FyhFR3-22R_wXQhC854QJyKsxTOesPYLkGSJixEgVGlOLrB0ix-DDelEgiydVJXLqy4W1_gnaDExqguKKoy10HO7H22BWhyTshB2ZszQUX_NojZUeu-NPYzRagglgAtex4ZlONKBhw2RC8WX6x-5dYN4zSFiJ6BDYtpny4UptOzfDJBB4RtAmg1UVkVgA4cCEwi5ug1GGznlQaJyI-5yTgCNN0qvKFlaCWHWIbkWZ3IeyBmjjW3aavC-1fCS1oU6k' },
        { id: '2', name: '[지리산] 흙당근 500g', price: 3200, rating: '4.8', reviews: '1,452', tag: 'Sale', img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDSZusN5is3Nydu-CZqYb9SFW6pskAzhttR3suzgyLRPncRDNyHokhv3LxypME3EeX8_fkKPvL4LABPTRs7V2hdZOI55kEI7ysW2NuJaR5w-rf5i6R_SV-swt7tcmfS3UZbXUb_PSzn-ot7mYdOeDbHKg6uVY0iHrrgz6gMUT-XDJKMHuAtuLHzK954IECampDFQLJyaD8mdAtAXWGiMbYGFQmHiYgv6JcNhGuLbcyBl0i9jpeUXtsQzCigOQHCTZePag7rMnTqet8' },
        { id: '3', name: '[친환경] 아삭이 고추 200g', price: 2980, rating: '4.7', reviews: '890', tag: '', img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAq_eyy1ETvUS4wTwkvlK8sSBsTiAaatv4x5biRc33Et-9FO7ooZ6L9FU6LRtIGEIFk0VRw3jE8fZQ08KyXCp5rnYt9BmdijMumuGriJEknC2j7N4qNLzXPvTnDt6GkNsGiRCYodDwjE1jUUehy3p_k1Va7rHeIDYEX_90W7CPZtsCSM4FNM1fXygeCwo7xNvH0NRBJPGhLy5oPZj3FP7pyTjzOTzlWF00W4ac1whV3oh37axJSxeUQkAPm1GMoXppQfutJy7Et0Kg' },
        { id: '4', name: '[무농약] 브로콜리 1송이', price: 3500, rating: '4.9', reviews: '3,201', tag: 'Hot', img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD7cXtn_UVW44GOA8m5gH1ISXTZmlZoSEhwUd0TUYuyFrtI5q7qwkgC9zWxCeoK9fSK--WFTWj4OgeiBAssrSWXvAPJKv0xbNwiaPMGJDxiC2cK00mclvK2FZUpPAKxBg-8cRMe1LuL3MZ5bQn0pHMjaZ0flh1vl3n1YGz0Swr-UAuz3AtzF-IVTNQ47C_5qMb_Zkd33Coyt9MrQnUJFNfdjsLjN9ixuWzsPxCcYvdXIxanfpnvsFi1pckRJmpP8rV8lzZXyad3HjQ' }
    ];

    // Helper: Currency Format
    function formatKRW(number) {
        return new Intl.NumberFormat('ko-KR').format(number) + '원';
    }

    // Detail View Logic
    function openDetail(productId) {
        const product = MOCK_PRODUCTS.find(p => p.id === productId);
        if (!product) return;
        currentDetailProduct = product;
        detailQuantity = 1;
        
        document.getElementById('detail-name').innerText = product.name;
        document.getElementById('detail-price').innerText = formatKRW(product.price);
        document.getElementById('detail-image').src = product.img;
        
        updateDetailDisplay();
        showView('detail-view');
    }

    function updateDetailQuantity(delta) {
        detailQuantity = Math.max(1, detailQuantity + delta);
        updateDetailDisplay();
    }

    function updateDetailDisplay() {
        if (!currentDetailProduct) return;
        document.getElementById('detail-quantity').innerText = detailQuantity;
        document.getElementById('detail-total-price').innerText = formatKRW(currentDetailProduct.price * detailQuantity);
        document.getElementById('detail-minus-btn').disabled = detailQuantity <= 1;
    }

    function addToCartFromDetail() {
        if (!currentDetailProduct) return;
        addToCart(currentDetailProduct.id, detailQuantity);
        showToast('장바구니에 담겼습니다.');
    }

    // Cart Logic
    function addToCart(productId, quantity) {
        const product = MOCK_PRODUCTS.find(p => p.id === productId);
        const existing = cart.find(item => item.id === productId);
        
        if (existing) {
            existing.quantity += quantity;
        } else {
            cart.push({ ...product, quantity });
        }
        
        renderCart();
        showToast('장바구니에 상품을 담았습니다.');
    }

    function updateCartQuantity(productId, delta) {
        const item = cart.find(i => i.id === productId);
        if (item) {
            item.quantity = Math.max(1, item.quantity + delta);
            renderCart();
        }
    }

    function removeFromCart(productId) {
        cart = cart.filter(item => item.id !== productId);
        renderCart();
    }

    function renderCart() {
        const container = document.getElementById('cart-items-container');
        if (cart.length === 0) {
            container.innerHTML = '<div class="py-20 text-center text-on-surface-variant">장바구니가 비어 있습니다.</div>';
            updateCartSummary(0);
            return;
        }

        container.innerHTML = cart.map(item => `
            <div class="flex items-center gap-4 p-6 bg-white rounded-xl border border-surface-variant">
                <input checked class="w-6 h-6 text-primary rounded border-outline focus:ring-primary" data-product-id="${item.id}" name="selectedItems" type="checkbox" value="${item.id}"/>
                <img class="w-24 h-24 object-cover rounded-lg" src="${item.img}"/>
                <div class="flex-1">
                    <h4 class="font-bold text-on-surface">${item.name}</h4>
                    <p class="text-body-sm text-on-surface-variant mb-2">${formatKRW(item.price)}</p>
                    <div class="flex items-center border border-outline-variant bg-white rounded-lg w-fit">
                        <button class="p-1 hover:bg-surface-container transition-colors disabled:opacity-30" onclick="updateCartQuantity('${item.id}', -1)" ${item.quantity <= 1 ? 'disabled' : ''}>
                            <span class="material-symbols-outlined text-[18px]">remove</span>
                        </button>
                        <span class="px-4 font-bold text-sm">${item.quantity}</span>
                        <button class="p-1 hover:bg-surface-container transition-colors" onclick="updateCartQuantity('${item.id}', 1)">
                            <span class="material-symbols-outlined text-[18px]">add</span>
                        </button>
                    </div>
                </div>
                <div class="text-right">
                    <p class="font-bold text-on-surface text-lg">${formatKRW(item.price * item.quantity)}</p>
                    <button class="text-on-surface-variant hover:text-error material-symbols-outlined mt-2" onclick="removeFromCart('${item.id}')">delete</button>
                </div>
            </div>
        `).join('');

        const subtotal = cart.reduce((acc, item) => acc + (item.price * item.quantity), 0);
        updateCartSummary(subtotal);
    }

    function updateCartSummary(subtotal) {
        const deliveryFee = subtotal > 0 ? (subtotal >= 30000 ? 0 : 3000) : 0;
        const total = subtotal + deliveryFee;

        document.getElementById('cart-subtotal').innerText = formatKRW(subtotal);
        document.getElementById('cart-delivery-fee').innerText = subtotal > 0 ? (deliveryFee === 0 ? '무료배송' : `+${formatKRW(deliveryFee)}`) : '0원';
        document.getElementById('cart-total').innerText = formatKRW(total);
    }

    function checkout() {
        if (cart.length === 0) {
            showToast('장바구니가 비어있습니다.');
            return;
        }
        cart = []; // Empty cart on success
        showView('success-view');
    }

    // ============================================
    // Auth Logic (로그인 / 회원가입)
    // TODO(BACKEND): 아래 함수들은 지금 더미 동작만 합니다.
    //  - handleLogin: POST /api/login (id, pw) -> 성공 시 세션 생성, 실패 시 에러 메시지
    //  - checkDuplicateId: GET /api/users/check?id=... -> 사용 가능 여부
    //  - submitSignup: POST /api/signup (id, pw, ...) -> 성공 시 로그인 화면 이동
    // ============================================
    function handleLogin() {
        const id = document.getElementById('login-id').value.trim();
        const pw = document.getElementById('login-pw').value.trim();
        const errorEl = document.getElementById('login-error-msg');

        if (!id || !pw) {
            errorEl.innerText = '아이디와 비밀번호를 모두 입력해주세요.';
            errorEl.classList.remove('hidden');
            return;
        }

        // TODO(BACKEND): 여기서 실제 로그인 API 호출로 교체
        errorEl.classList.add('hidden');
        showToast('로그인 기능은 준비 중입니다.');
    }

    function checkDuplicateId() {
        const id = document.getElementById('signup-id').value.trim();
        const msgEl = document.getElementById('signup-id-check-msg');

        if (!id) {
            msgEl.innerText = '아이디를 입력해주세요.';
            msgEl.className = 'text-body-sm mt-1 text-error';
            return;
        }

        // TODO(BACKEND): 여기서 실제 중복확인 API 호출로 교체
        msgEl.innerText = '사용 가능한 아이디입니다.';
        msgEl.className = 'text-body-sm mt-1 text-primary';
    }

    function submitSignup() {
        const id = document.getElementById('signup-id').value.trim();
        const pw = document.getElementById('signup-pw').value.trim();

        if (!id || !pw) {
            showToast('아이디와 비밀번호를 모두 입력해주세요.');
            return;
        }

        // TODO(BACKEND): 여기서 실제 회원가입 API 호출로 교체
        showView('login-view');
        showToast('회원가입이 완료되었습니다.');
    }

    // ============================================
    // Loading / Error 상태 헬퍼
    // TODO(BACKEND): API 연동 시 fetch의 loading/then/catch 각 단계에서 호출
    // ============================================
    function renderLoading(container, message) {
        container.innerHTML = `<div class="col-span-full py-20 text-center text-on-surface-variant">${message || '불러오는 중입니다...'}</div>`;
    }

    function renderError(container, message, onRetry) {
        container.innerHTML = `
            <div class="col-span-full py-20 text-center text-on-surface-variant">
                <span class="material-symbols-outlined text-6xl text-outline-variant mb-4 block">error_outline</span>
                <p class="mb-4">${message || '데이터를 불러오지 못했습니다.'}</p>
                <button class="border border-primary text-primary px-6 py-2 rounded-lg font-bold hover:bg-surface-container" id="retry-btn">다시 시도</button>
            </div>
        `;
        const retryBtn = container.querySelector('#retry-btn');
        if (retryBtn && typeof onRetry === 'function') {
            retryBtn.onclick = onRetry;
        }
    }

    // SPA View Switcher
    function showView(viewId, context = '') {
        const views = ['home-view', 'login-view', 'signup-view', 'cart-view', 'detail-view', 'success-view', 'category-view', 'search-view'];
        
        views.forEach(id => {
            const element = document.getElementById(id);
            if (element) {
                if (id === viewId) {
                    element.classList.remove('hidden-view');
                    element.classList.add('active-view');
                    window.scrollTo(0, 0);
                } else {
                    element.classList.add('hidden-view');
                    element.classList.remove('active-view');
                }
            }
        });

        const navItems = document.querySelectorAll('.nav-item');
        navItems.forEach(item => {
            if (item.innerText === context) {
                item.classList.add('nav-link-active');
            } else {
                item.classList.remove('nav-link-active');
            }
        });

        if (viewId === 'category-view') renderCategoryView(context);
        if (viewId === 'cart-view') renderCart();
        if (viewId === 'home-view' && !context) {
            // reset nav state
            navItems.forEach(item => item.classList.remove('nav-link-active'));
        }

        const sidebar = document.getElementById('side-nav');
        if (sidebar && sidebar.style.transform === 'translateX(0px)') toggleSidebar();
    }

    function renderCategoryView(context) {
        const titleEl = document.getElementById('category-title');
        const tabsEl = document.getElementById('category-tabs');
        const gridEl = document.getElementById('category-products-grid');

        titleEl.innerText = context;
        tabsEl.innerHTML = '';
        renderLoading(gridEl, '상품 정보를 불러오고 있습니다...');
        // TODO(BACKEND): API 실패 시 아래처럼 처리
        // renderError(gridEl, '상품을 불러오지 못했습니다.', () => renderCategoryView(context));

        let subTabs = (context === '베스트') ? ['베스트랭킹', '인기급상승'] : (context === '알뜰쇼핑' ? ['알뜰쇼핑', '반값세일'] : ['전체보기', '추천순', '신상품순', '낮은가격순']);

        subTabs.forEach((tab, index) => {
            const btn = document.createElement('button');
            btn.className = `px-6 py-4 text-body-md transition-all border-b-2 border-transparent hover:text-primary ${index === 0 ? 'sub-tab-active' : 'text-on-surface-variant'}`;
            btn.innerText = tab;
            btn.onclick = () => {
                document.querySelectorAll('#category-tabs button').forEach(b => b.classList.remove('sub-tab-active', 'text-on-surface'));
                btn.classList.add('sub-tab-active');
                renderProducts(gridEl);
            };
            tabsEl.appendChild(btn);
        });

        setTimeout(() => renderProducts(gridEl), 300);
    }

    function renderProducts(container) {
        container.innerHTML = MOCK_PRODUCTS.map(product => `
            <div class="group cursor-pointer" onclick="openDetail('${product.id}')">
                <div class="relative aspect-[3/4] rounded-xl overflow-hidden mb-4 bg-surface-container">
                    <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" src="${product.img}"/>
                    <button class="absolute bottom-4 right-4 bg-white/90 p-3 rounded-full shadow-md text-primary hover:bg-primary hover:text-white transition-all" onclick="event.stopPropagation(); addToCart('${product.id}', 1)">
                        <span class="material-symbols-outlined">add_shopping_cart</span>
                    </button>
                    ${product.tag ? `<span class="absolute top-4 left-4 bg-primary text-on-primary px-3 py-1 rounded text-label-md">${product.tag}</span>` : ''}
                </div>
                <p class="text-on-surface-variant text-body-sm mb-1">${product.name}</p>
                <h3 class="font-bold text-on-surface text-body-lg mb-2">${formatKRW(product.price)}</h3>
                <div class="flex items-center gap-1 text-primary">
                    <span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">star</span>
                    <span class="text-label-md font-bold">${product.rating} (${product.reviews})</span>
                </div>
            </div>
        `).join('');
    }

    // Sidebar Toggle
    function toggleSidebar() {
        const sidebar = document.getElementById('side-nav');
        const overlay = document.getElementById('side-overlay');
        const isOpen = sidebar.style.transform === 'translateX(0px)';

        if (isOpen) {
            sidebar.style.transform = 'translateX(-100%)';
            overlay.classList.add('hidden');
            document.body.style.overflow = 'auto';
        } else {
            sidebar.style.transform = 'translateX(0px)';
            overlay.classList.remove('hidden');
            document.body.style.overflow = 'hidden';
        }
    }

    // Category Selection
    function selectCategory(name) {
        const btns = document.querySelectorAll('.category-btn');
        btns.forEach(btn => {
            btn.classList.remove('bg-secondary-container', 'text-on-secondary-container', 'font-bold');
            btn.classList.add('text-on-surface-variant');
        });
        const activeBtn = Array.from(btns).find(b => b.innerText.includes(name));
        if (activeBtn) {
            activeBtn.classList.add('bg-secondary-container', 'text-on-secondary-container', 'font-bold');
            activeBtn.classList.remove('text-on-surface-variant');
        }
        showView('category-view', name);
    }

    // Search
    function handleSearch(event) {
        if (event.key === 'Enter') {
            const keyword = document.getElementById('search-input').value;
            if (keyword.trim()) {
                document.getElementById('search-keyword').innerText = keyword;
                showView('search-view');
            } else {
                showToast('검색어를 입력해주세요.');
            }
        }
    }

    // Toast
    function showToast(message) {
        const toast = document.getElementById("toast");
        toast.innerText = message;
        toast.className = "show";
        setTimeout(function(){ toast.className = toast.className.replace("show", ""); }, 3000);
    }

    function toggleNotifications() {
        const badge = document.getElementById('notif-badge');
        badge.classList.toggle('hidden');
        showToast(badge.classList.contains('hidden') ? '알림을 모두 읽었습니다.' : '새로운 알림이 있습니다.');
    }

    function toggleFavorite(btn) {
        const icon = btn.querySelector('.material-symbols-outlined');
        const isFilled = icon.style.fontVariationSettings.includes("'FILL' 1");
        icon.style.fontVariationSettings = isFilled ? "'FILL' 0" : "'FILL' 1";
        showToast(isFilled ? '찜 목록에서 삭제되었습니다.' : '찜 목록에 추가되었습니다.');
    }

    // Header Animation
    window.addEventListener('scroll', () => {
        const header = document.querySelector('header');
        if (window.scrollY > 20) {
            header.classList.add('shadow-md', 'h-16');
            header.classList.remove('h-20');
        } else {
            header.classList.remove('shadow-md', 'h-16');
            header.classList.add('h-20');
        }
    });

    // Initialize with first product if detail view is forced but generic detail trigger should be used
    currentDetailProduct = MOCK_PRODUCTS[0];
    updateDetailDisplay();
    function switchDetailTab(tabId) {
        const tabs = ["desc","info","qna"];
        tabs.forEach(function(tab){
            document.getElementById("content-"+tab).classList.add("hidden");
            document.getElementById("tab-"+tab).className =
                "flex-1 py-4 text-center font-bold text-on-surface-variant hover:text-primary transition-colors";
        });

        document.getElementById("content-"+tabId).classList.remove("hidden");
        document.getElementById("tab-"+tabId).className =
            "flex-1 py-4 text-center font-bold border-b-2 border-primary text-primary";
    }

</script>
</body></html>
