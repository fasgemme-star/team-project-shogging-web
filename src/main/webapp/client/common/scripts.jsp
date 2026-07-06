<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    // ============================================
    // 서버 연동 기본값
    // isELIgnored="true" 가 상위 index.jsp 에 걸려있어 include된 조각들에서
    // EL(${...})이 무시될 수 있으므로, 컨텍스트 경로/로그인 상태는 스크립틀릿으로 내려준다.
    // ============================================
    const CTX = '<%= request.getContextPath() %>';
    const IS_LOGGED_IN = <%= (session.getAttribute("loginUser") != null) %>;

    // State Management
    let currentDetailProduct = null;
    let detailQuantity = 1;
    let cartItems = []; // CartServlet(/api/cart) 조회 결과 캐시 (렌더링/수량조작용)

    // Helper: Currency Format
    function formatKRW(number) {
        return new Intl.NumberFormat('ko-KR').format(number || 0) + '원';
    }

    // ============================================
    // 공용 fetch 헬퍼
    // ============================================
    function apiGet(path) {
        return fetch(CTX + path, { credentials: 'same-origin' })
            .then(res => res.json());
    }

    function apiPost(path, paramsObj) {
        const body = new URLSearchParams();
        Object.keys(paramsObj || {}).forEach(key => body.append(key, paramsObj[key]));

        return fetch(CTX + path, {
            method: 'POST',
            credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        }).then(res => res.json());
    }

    // ============================================
    // 상품 카드 렌더링 (홈 / 카테고리 / 검색 결과 공통)
    // CategoryServlet, HomeServlet, ProductSearchServlet 이 내려주는
    // { id, name, shortInfo, price, discount, finalPrice, img } 형태를 기준으로 한다.
    // ============================================
    function buildProductCard(product) {
        const hasDiscount = product.discount > 0;
        return `
            <div class="group cursor-pointer" onclick="openDetail('${product.id}')">
                <div class="relative aspect-[3/4] rounded-xl overflow-hidden mb-4 bg-surface-container">
                    <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" src="${product.img || ''}"/>
                    <button class="absolute bottom-4 right-4 bg-white/90 p-3 rounded-full shadow-md text-primary hover:bg-primary hover:text-white transition-all" onclick="event.stopPropagation(); addToCart('${product.id}', 1)">
                        <span class="material-symbols-outlined">add_shopping_cart</span>
                    </button>
                    ${hasDiscount ? `<span class="absolute top-4 left-4 bg-primary text-on-primary px-3 py-1 rounded text-label-md">${product.discount}% 할인</span>` : ''}
                </div>
                <p class="text-on-surface-variant text-body-sm mb-1">${product.shortInfo || product.name}</p>
                <h3 class="font-bold text-on-surface text-body-lg mb-2">${formatKRW(product.finalPrice)}</h3>
            </div>
        `;
    }

    function renderProductGrid(container, items) {
        if (!items || items.length === 0) {
            container.innerHTML = '<div class="col-span-full py-20 text-center text-on-surface-variant">상품이 없습니다.</div>';
            return;
        }
        container.innerHTML = items.map(buildProductCard).join('');
    }

    // ============================================
    // 홈 화면: HomeServlet(/api/home)
    // ============================================
    function renderHome() {
        const gridEl = document.getElementById('home-best-grid');
        if (!gridEl) return;
        renderLoading(gridEl, '상품 정보를 불러오고 있습니다...');

        apiGet('/api/home')
            .then(data => renderProductGrid(gridEl, data.best))
            .catch(() => renderError(gridEl, '상품을 불러오지 못했습니다.', renderHome));
    }

    // ============================================
    // 상품 상세: ProductDetailServlet(/api/product)
    // ============================================
    function openDetail(productId) {
        apiGet('/api/product?id=' + encodeURIComponent(productId))
            .then(product => {
                if (!product || product.error) {
                    showToast((product && product.error) || '상품 정보를 불러오지 못했습니다.');
                    return;
                }
                currentDetailProduct = product;
                detailQuantity = 1;

                document.getElementById('detail-name').innerText = product.name;
                document.getElementById('detail-price').innerText = formatKRW(product.finalPrice);
                document.getElementById('detail-image').src = product.img || '';

                updateDetailDisplay();
                showView('detail-view');
            })
            .catch(() => showToast('상품 정보를 불러오지 못했습니다.'));
    }

    function updateDetailQuantity(delta) {
        detailQuantity = Math.max(1, detailQuantity + delta);
        updateDetailDisplay();
    }

    function updateDetailDisplay() {
        if (!currentDetailProduct) return;
        document.getElementById('detail-quantity').innerText = detailQuantity;
        document.getElementById('detail-total-price').innerText = formatKRW(currentDetailProduct.finalPrice * detailQuantity);
        document.getElementById('detail-minus-btn').disabled = detailQuantity <= 1;
    }

    function addToCartFromDetail() {
        if (!currentDetailProduct) return;
        addToCart(currentDetailProduct.id, detailQuantity);
    }

    // ============================================
    // 장바구니: CartServlet(/api/cart)
    // 주의: CartDAO.selectCart()가 옵션ID를 내려주지 않아 서버가 응답하는
    // 각 라인에는 식별자가 없다. 그래서 담기(add)는 실제 서버와 연동되지만,
    // 이미 장바구니에 있는 라인의 수량 변경/삭제는 이번 화면 안에서만 반영되는
    // 로컬 동작이다. 영속적으로 만들려면 CartDAO.selectCart()의 SELECT 절과
    // client.cart.OrderDTO 에 option_id 를 추가해야 한다.
    // ============================================
    function addToCart(productId, quantity) {
        if (!IS_LOGGED_IN) {
            showToast('로그인이 필요합니다.');
            showView('login-view');
            return;
        }

        apiPost('/api/cart', { action: 'add', prdId: productId, qty: quantity })
            .then(data => {
                if (data.success) {
                    showToast('장바구니에 상품을 담았습니다.');
                } else if (data.requireLogin) {
                    showToast('로그인이 필요합니다.');
                    showView('login-view');
                } else {
                    showToast('장바구니 담기에 실패했습니다.');
                }
            })
            .catch(() => showToast('장바구니 담기에 실패했습니다.'));
    }

    function updateCartQuantity(index, delta) {
        const item = cartItems[index];
        if (!item) return;
        item.quantity = Math.max(1, item.quantity + delta);
        item.lineTotal = item.finalPrice * item.quantity;
        renderCartFromCache();
    }

    function removeFromCart(index) {
        cartItems.splice(index, 1);
        renderCartFromCache();
    }

    function renderCart() {
        const container = document.getElementById('cart-items-container');

        if (!IS_LOGGED_IN) {
            container.innerHTML = `
                <div class="py-20 text-center text-on-surface-variant">
                    로그인이 필요합니다.<br/>
                    <button class="mt-4 border border-primary text-primary px-6 py-2 rounded-lg font-bold hover:bg-surface-container" onclick="showView('login-view')">로그인 하러 가기</button>
                </div>`;
            updateCartSummary(0);
            return;
        }

        renderLoading(container, '장바구니를 불러오고 있습니다...');

        apiGet('/api/cart')
            .then(data => {
                cartItems = data.items || [];
                renderCartFromCache();
            })
            .catch(() => renderError(container, '장바구니를 불러오지 못했습니다.', renderCart));
    }

    function renderCartFromCache() {
        const container = document.getElementById('cart-items-container');

        if (cartItems.length === 0) {
            container.innerHTML = '<div class="py-20 text-center text-on-surface-variant">장바구니가 비어 있습니다.</div>';
            updateCartSummary(0);
            return;
        }

        container.innerHTML = cartItems.map((item, index) => `
            <div class="flex items-center gap-4 p-6 bg-white rounded-xl border border-surface-variant">
                <div class="flex-1">
                    <h4 class="font-bold text-on-surface">${item.name}</h4>
                    <p class="text-body-sm text-on-surface-variant mb-2">${formatKRW(item.finalPrice)}</p>
                    <div class="flex items-center border border-outline-variant bg-white rounded-lg w-fit">
                        <button class="p-1 hover:bg-surface-container transition-colors disabled:opacity-30" onclick="updateCartQuantity(${index}, -1)" ${item.quantity <= 1 ? 'disabled' : ''}>
                            <span class="material-symbols-outlined text-[18px]">remove</span>
                        </button>
                        <span class="px-4 font-bold text-sm">${item.quantity}</span>
                        <button class="p-1 hover:bg-surface-container transition-colors" onclick="updateCartQuantity(${index}, 1)">
                            <span class="material-symbols-outlined text-[18px]">add</span>
                        </button>
                    </div>
                </div>
                <div class="text-right">
                    <p class="font-bold text-on-surface text-lg">${formatKRW(item.finalPrice * item.quantity)}</p>
                    <button class="text-on-surface-variant hover:text-error material-symbols-outlined mt-2" onclick="removeFromCart(${index})">delete</button>
                </div>
            </div>
        `).join('');

        const subtotal = cartItems.reduce((acc, item) => acc + (item.finalPrice * item.quantity), 0);
        updateCartSummary(subtotal);
    }

    function updateCartSummary(subtotal) {
        const deliveryFee = subtotal > 0 ? (subtotal >= 30000 ? 0 : 3000) : 0;
        const total = subtotal + deliveryFee;

        document.getElementById('cart-subtotal').innerText = formatKRW(subtotal);
        document.getElementById('cart-delivery-fee').innerText = subtotal > 0 ? (deliveryFee === 0 ? '무료배송' : `+${formatKRW(deliveryFee)}`) : '0원';
        document.getElementById('cart-total').innerText = formatKRW(total);
    }

    // ============================================
    // 주문: OrderServlet(/api/order/checkout)
    // 주의: client.order.OrderDAO.insertOrder()/insertPayment() 가 아직
    // 미구현 스텁(항상 null/0 반환)이라 실제 DB 저장은 되지 않는다.
    // 화면 흐름(장바구니 -> 주문완료)만 서버 호출과 연결해둔 상태다.
    // ============================================
    function checkout() {
        if (!IS_LOGGED_IN) {
            showToast('로그인이 필요합니다.');
            showView('login-view');
            return;
        }
        if (cartItems.length === 0) {
            showToast('장바구니가 비어있습니다.');
            return;
        }

        apiPost('/api/order/checkout', {})
            .then(data => {
                if (data.requireLogin) {
                    showToast('로그인이 필요합니다.');
                    showView('login-view');
                    return;
                }
                cartItems = [];
                showView('success-view');
            })
            .catch(() => showToast('주문 처리 중 오류가 발생했습니다.'));
    }

    // ============================================
    // Auth Logic (로그인 / 회원가입)
    // LoginServlet(/api/login), SignupServlet(/api/signup)
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

        apiPost('/api/login', { loginId: id, loginPw: pw })
            .then(data => {
                if (data.success) {
                    errorEl.classList.add('hidden');
                    showToast('로그인되었습니다.');
                    setTimeout(() => window.location.reload(), 500);
                } else {
                    errorEl.innerText = data.message || '로그인에 실패했습니다.';
                    errorEl.classList.remove('hidden');
                }
            })
            .catch(() => {
                errorEl.innerText = '로그인 처리 중 오류가 발생했습니다.';
                errorEl.classList.remove('hidden');
            });
    }

    function checkDuplicateId() {
        const id = document.getElementById('signup-id').value.trim();
        const msgEl = document.getElementById('signup-id-check-msg');
        msgEl.classList.remove('hidden');

        if (!id) {
            msgEl.innerText = '아이디를 입력해주세요.';
            msgEl.className = 'text-body-sm mt-1 text-error';
            return;
        }

        apiGet('/api/signup?id=' + encodeURIComponent(id))
            .then(data => {
                if (data.available) {
                    msgEl.innerText = '사용 가능한 아이디입니다.';
                    msgEl.className = 'text-body-sm mt-1 text-primary';
                } else {
                    msgEl.innerText = '이미 사용 중인 아이디입니다.';
                    msgEl.className = 'text-body-sm mt-1 text-error';
                }
            })
            .catch(() => {
                msgEl.innerText = '중복 확인 중 오류가 발생했습니다.';
                msgEl.className = 'text-body-sm mt-1 text-error';
            });
    }

    function submitSignup() {
        const id = document.getElementById('signup-id').value.trim();
        const pw = document.getElementById('signup-pw').value.trim();

        if (!id || !pw) {
            showToast('아이디와 비밀번호를 모두 입력해주세요.');
            return;
        }

        apiPost('/api/signup', { signupId: id, signupPw: pw })
            .then(data => {
                if (data.success) {
                    showView('login-view');
                    showToast('회원가입이 완료되었습니다.');
                } else {
                    showToast(data.message || '회원가입에 실패했습니다.');
                }
            })
            .catch(() => showToast('회원가입 처리 중 오류가 발생했습니다.'));
    }

    // ============================================
    // Loading / Error 상태 헬퍼
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
            navItems.forEach(item => item.classList.remove('nav-link-active'));
        }

        const sidebar = document.getElementById('side-nav');
        if (sidebar && sidebar.style.transform === 'translateX(0px)') toggleSidebar();
    }

    // ============================================
    // 카테고리 화면: CategoryServlet(/api/category)
    // ============================================
    function renderCategoryView(context) {
        const titleEl = document.getElementById('category-title');
        const tabsEl = document.getElementById('category-tabs');
        const gridEl = document.getElementById('category-products-grid');

        titleEl.innerText = context;
        tabsEl.innerHTML = '';

        const isBestSaleGroup = (context === '베스트' || context === '알뜰쇼핑');
        let subTabs = context === '베스트' ? ['베스트랭킹', '인기급상승']
            : context === '알뜰쇼핑' ? ['알뜰쇼핑', '반값세일']
            : ['전체보기'];

        subTabs.forEach((tab, index) => {
            const btn = document.createElement('button');
            btn.className = `px-6 py-4 text-body-md transition-all border-b-2 border-transparent hover:text-primary ${index === 0 ? 'sub-tab-active' : 'text-on-surface-variant'}`;
            btn.innerText = tab;
            btn.onclick = () => {
                document.querySelectorAll('#category-tabs button').forEach(b => b.classList.remove('sub-tab-active', 'text-on-surface'));
                btn.classList.add('sub-tab-active');
                fetchAndRenderCategory(isBestSaleGroup ? tab : context, gridEl);
            };
            tabsEl.appendChild(btn);
        });

        fetchAndRenderCategory(isBestSaleGroup ? subTabs[0] : context, gridEl);
    }

    function fetchAndRenderCategory(apiName, gridEl) {
        renderLoading(gridEl, '상품 정보를 불러오고 있습니다...');

        apiGet('/api/category?name=' + encodeURIComponent(apiName) + '&page=1')
            .then(data => renderProductGrid(gridEl, data.items))
            .catch(() => renderError(gridEl, '상품을 불러오지 못했습니다.', () => fetchAndRenderCategory(apiName, gridEl)));
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

    // Category Selection (사이드바의 잎채소/뿌리채소 등)
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

    // ============================================
    // 검색: ProductSearchServlet(/api/search)
    // ============================================
    function handleSearch(event) {
        if (event.key === 'Enter') {
            const keyword = document.getElementById('search-input').value.trim();
            if (!keyword) {
                showToast('검색어를 입력해주세요.');
                return;
            }

            document.getElementById('search-keyword').innerText = keyword;
            showView('search-view');

            const gridEl = document.getElementById('search-results-grid');
            const countEl = document.getElementById('search-result-count');
            renderLoading(gridEl, '검색 중입니다...');

            apiGet('/api/search?keyword=' + encodeURIComponent(keyword))
                .then(data => {
                    countEl.innerText = `총 ${data.count}개의 상품이 검색되었습니다.`;
                    renderProductGrid(gridEl, data.items);
                })
                .catch(() => renderError(gridEl, '검색 결과를 불러오지 못했습니다.', () => handleSearch(event)));
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

    // 최초 진입 시 홈 화면 베스트 상품을 서버에서 불러온다.
    renderHome();
</script>
</body></html>
