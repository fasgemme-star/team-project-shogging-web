<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<body class="bg-background text-on-surface font-body-md overflow-x-hidden">
<div id="toast">메시지가 표시됩니다.</div>
<!-- TopNavBar -->
<header class="fixed top-0 left-0 right-0 z-50 bg-surface border-b border-surface-variant transition-all duration-300">
<div class="flex justify-between items-center w-full px-margin-desktop h-20 max-w-max-width mx-auto">
<!-- Brand Logo -->
<div class="cursor-pointer flex items-center gap-2" onclick="showView('home-view')">
<span class="text-headline-md font-headline-md font-bold text-primary">프레시마켓</span>
</div>
<!-- Navigation Links -->
<nav class="hidden md:flex items-center gap-gutter-md h-full">
<button class="text-on-surface-variant hover:text-primary transition-colors font-bold flex items-center gap-1 h-full px-1" onclick="toggleSidebar()">
<span class="material-symbols-outlined">menu</span> 카테고리
            </button>
<a class="text-on-surface-variant hover:text-primary transition-colors h-full flex items-center px-1 nav-item" href="javascript:void(0)" onclick="showView('category-view', '신상품')">신상품</a>
<a class="text-on-surface-variant hover:text-primary transition-colors h-full flex items-center px-1 nav-item" href="javascript:void(0)" onclick="showView('category-view', '베스트')">베스트</a>
<a class="text-on-surface-variant hover:text-primary transition-colors h-full flex items-center px-1 nav-item" href="javascript:void(0)" onclick="showView('category-view', '알뜰쇼핑')">알뜰쇼핑</a>
</nav>
<!-- Trailing Icons -->
<div class="flex items-center gap-gutter-sm">
<div class="relative hidden lg:block mr-4">
<input class="bg-surface-container-low border border-outline-variant rounded-full py-2 px-6 w-64 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-body-sm" id="search-input" onkeyup="handleSearch(event)" placeholder="검색어를 입력해주세요" type="text"/>
<span class="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 text-on-surface-variant cursor-pointer" onclick="handleSearch({key:'Enter'})">search</span>
</div>
<button class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" onclick="showView('cart-view')">shopping_cart</button>
<%--
    TODO(UI): 로그인 상태별 헤더 분기 지점
    - 비로그인: person 아이콘 -> showView('login-view')
    - 로그인:   닉네임/아바타 + 로그아웃, 마이페이지 등 (디자인 확정 후 아래 scriptlet 안에 마크업 채우기)
    - session.getAttribute("loginUser") 를 백엔드에서 세팅해주는 걸 전제로 함
--%>
<% if (session.getAttribute("loginUser") == null) { %>
<button class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" onclick="showView('login-view')">person</button>
<% } else { %>
<%-- TODO(UI): 로그인 상태 헤더 디자인 나오면 이 블록 채우기 --%>
<button class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" onclick="showView('login-view')">person</button>
<% } %>
<div class="relative">
<button class="material-symbols-outlined p-2 hover:bg-surface-container-low rounded-full transition-all text-on-surface-variant" onclick="toggleNotifications()">notifications</button>
<span class="absolute top-2 right-2 w-2 h-2 bg-error rounded-full hidden" id="notif-badge"></span>
</div>
</div>
</div>
</header>
