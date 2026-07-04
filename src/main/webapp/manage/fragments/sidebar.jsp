<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="uri" value="${pageContext.request.requestURI}" />

<script type="text/javascript">
function toggleProductsMenu(event) {
    event.preventDefault();

    document.getElementById("productsSubMenu")
            .classList.toggle("show");
}//toggleProductsMenu
</script>

<!-- 사이드바 -->
		<div class="sidebar">
			<div class="logo">
				<h3>
					프레시마켓 <span>Admin</span>
				</h3>
			</div>

			<ul>
				<li class="${fn:contains(uri,'dashboard.jsp') ? 'active' : ''}"><a href="../dashboard/dashboard.jsp"> Dashboard </a></li>
				<li class="${fn:contains(uri,'Products') ? 'active' : ''}"><a href="#" onclick="toggleProductsMenu(event)">Products </a>
					<ul id="productsSubMenu" class="sub-menu ${fn:contains(uri,'Products') ? 'show' : ''}">
						<li class="${fn:contains(uri,'vieweditProducts.jsp') ? 'active' : ''}"><a href="../Products/vieweditProducts.jsp"> View/Edit Products </a></li>
						<li class="${fn:contains(uri,'addProduct.jsp') ? 'active' : ''}"><a href="../Products/addProduct.jsp"> Add Product </a></li>
					</ul></li>
				<li class="${fn:contains(uri,'adminCategories.jsp') ? 'active' : ''}"><a href="../Categories/adminCategories.jsp"> Categories
				</a></li>
				<li class="${fn:contains(uri,'adminOrder.jsp') ? 'active' : ''}"><a href="../order/adminOrder.jsp"> Order </a></li>
				<li class="${fn:contains(uri,'adminUsers.jsp') ? 'active' : ''}"><a href="../user/adminUsers.jsp"> Users </a></li>
				<li class="${fn:contains(uri,'adminInquiries.jsp') ? 'active' : ''}"><a href="../inquiries/adminInquiries.jsp"> Inquiries </a></li>
			</ul>
			<div class="bottom-menu">
				<ul>
					<li class="${fn:contains(uri,'settings.jsp') ? 'active' : ''}"><a href="../dashboard/settings.jsp"> Settings </a></li>
					<li><a href="../login/logout.jsp" class="logout">Logout</a></li>
				</ul>
			</div>
		</div>