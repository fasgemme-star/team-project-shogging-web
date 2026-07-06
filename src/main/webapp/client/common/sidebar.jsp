<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- SideNavBar (Category) -->
<aside class="fixed left-0 top-0 h-full w-64 bg-surface-container-lowest border-r border-surface-variant z-[60] -translate-x-full transition-transform duration-300" id="side-nav">
<div class="flex flex-col gap-base p-gutter-sm mt-20">
<div class="mb-6 px-2">
<h2 class="text-headline-sm font-headline-sm text-primary">품목별 카테고리</h2>
<p class="text-body-sm text-on-surface-variant">신선한 채소를 만나보세요</p>
</div>
<div class="flex flex-col gap-1">
<button class="category-btn flex items-center gap-3 p-3 text-on-surface-variant hover:bg-surface-container rounded-lg transition-transform hover:translate-x-1" onclick="selectCategory('잎채소')">
<span class="material-symbols-outlined">eco</span> 잎채소
            </button>
<button class="category-btn flex items-center gap-3 p-3 text-on-surface-variant hover:bg-surface-container rounded-lg transition-transform hover:translate-x-1" onclick="selectCategory('뿌리채소')">
<span class="material-symbols-outlined">psychology_alt</span> 뿌리채소
            </button>
<button class="category-btn flex items-center gap-3 p-3 text-on-surface-variant hover:bg-surface-container rounded-lg transition-transform hover:translate-x-1" onclick="selectCategory('열매채소')">
<span class="material-symbols-outlined">egg_alt</span> 열매채소
            </button>
<button class="category-btn flex items-center gap-3 p-3 text-on-surface-variant hover:bg-surface-container rounded-lg transition-transform hover:translate-x-1" onclick="selectCategory('버섯류')">
<span class="material-symbols-outlined">nature</span> 버섯류
            </button>
<button class="category-btn flex items-center gap-3 p-3 text-on-surface-variant hover:bg-surface-container rounded-lg transition-transform hover:translate-x-1" onclick="selectCategory('나물류')">
<span class="material-symbols-outlined">grass</span> 나물류
            </button>
<button class="category-btn flex items-center gap-3 p-3 text-on-surface-variant hover:bg-surface-container rounded-lg transition-transform hover:translate-x-1" onclick="selectCategory('특수채소')">
<span class="material-symbols-outlined">compost</span> 특수채소
            </button>
</div>
</div>
<button class="absolute top-4 right-4 material-symbols-outlined" onclick="toggleSidebar()">close</button>
</aside>
<div class="fixed inset-0 bg-black/20 z-[55] hidden" id="side-overlay" onclick="toggleSidebar()"></div>
