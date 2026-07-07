</main>

<%-- ===================== Footer ===================== --%>
<footer class="bg-surface-container mt-20">
  <div class="w-full py-margin-mobile px-margin-desktop flex flex-col md:flex-row justify-between items-center gap-gutter-md max-w-max-width mx-auto">
    <div class="flex flex-col gap-2 text-center md:text-left">
      <a class="font-headline-sm text-headline-sm font-bold text-primary cursor-pointer" href="${pageContext.request.contextPath}/home.jsp">프레시마켓</a>
      <p class="text-secondary font-body-sm text-body-sm">© 2024 프레시마켓. All rights reserved. 고객센터: 1588-0000</p>
    </div>
    <div class="flex gap-gutter-sm">
      <a class="text-on-surface-variant hover:text-on-surface transition-colors text-body-sm" href="javascript:void(0)" onclick="showToast('준비 중입니다.')">회사소개</a>
      <a class="text-on-surface-variant hover:text-on-surface transition-colors text-body-sm" href="javascript:void(0)" onclick="showToast('준비 중입니다.')">이용약관</a>
      <a class="text-primary font-bold underline text-body-sm" href="javascript:void(0)" onclick="showToast('준비 중입니다.')">개인정보처리방침</a>
    </div>
  </div>
</footer>

<script>
    // Toast
    function showToast(message) {
        const toast = document.getElementById("toast");
        toast.innerText = message;
        toast.className = "show";
        setTimeout(function(){ toast.className = toast.className.replace("show", ""); }, 3000);
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
</script>

<%--
    Flash message: 서버(스크립틀릿)에서 session.setAttribute("toastMsg", "...") 로 넣어두면
    redirect 후 이 페이지가 로드될 때 자동으로 토스트를 띄우고 세션에서 제거한다.
--%>
<c:if test="${not empty sessionScope.toastMsg}">
<script>
    window.addEventListener('DOMContentLoaded', function() {
        showToast("<c:out value='${sessionScope.toastMsg}'/>");
    });
</script>
<% session.removeAttribute("toastMsg"); %>
</c:if>

</body>
</html>
