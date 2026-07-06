<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="manage.searchproduct.SearchProductService"%>
<%@page import="manage.searchproduct.ProductDTO"%>
<%@page import="manage.searchproduct.RangeDTO"%>
<%@ include file="../login/loginCheck.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View/Edit Products</title>
<link rel="shortcut icon" href="http://localhost/jsp_prj/manage/images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/dashboard.css" rel="stylesheet">
<link href="../css/vieweditProducts.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
function resetSearch() {
    const form = document.getElementById("searchForm");

    document.getElementById("keyword").value = "";
    document.getElementById("category").value = "";
    document.querySelector("input[name='status'][value='전체']").checked = true;
    document.getElementById("startDate").value = "";
    document.getElementById("endDate").value = "";
    document.getElementById("period").value = "all";
    document.getElementById("pageSize").value = "20";

    let pageInput = form.querySelector("input[name='page']");
    
    if (!pageInput) {
        pageInput = document.createElement("input");
        pageInput.type = "hidden";
        pageInput.name = "page";
        form.appendChild(pageInput);
    }
    pageInput.value = "1";
    form.submit();
}//resetSearch

function formatDate(date) {
    let year = date.getFullYear();
    let month = String(date.getMonth() + 1).padStart(2, "0");
    let day = String(date.getDate()).padStart(2, "0");

    return year + "-" + month + "-" + day;
}//formatDate

function selectPeriod(btn) {
    let period = btn.dataset.period;
    let today = new Date();
    let startDate = new Date();
    let endDate = new Date();

    if (period === "today") {
        startDate = new Date(today);
    } else if (period === "week") {
        startDate.setDate(today.getDate() - 6);
    } else if (period === "month") {
        startDate.setMonth(today.getMonth() - 1);
    } else if (period === "3month") {
        startDate.setMonth(today.getMonth() - 3);
    } else if (period === "6month") {
        startDate.setMonth(today.getMonth() - 6);
    } else if (period === "year") {
        startDate.setFullYear(today.getFullYear() - 1);
    } else if (period === "all") {
        document.getElementById("startDate").value = "";
        document.getElementById("endDate").value = "";
        document.getElementById("period").value = "all";
        document.querySelectorAll(".date-btns button").forEach(function(item) {
            item.classList.remove("active");
        });
        btn.classList.add("active");
        return;
    }

    document.getElementById("startDate").value = formatDate(startDate);
    document.getElementById("endDate").value = formatDate(endDate);
    document.getElementById("period").value = period;
    document.querySelectorAll(".date-btns button").forEach(function(item) {
        item.classList.remove("active");
    });
    btn.classList.add("active");
}//selectPeriod

function changePageSize() {
    let form = document.getElementById("searchForm");
    let pageInput = form.querySelector("input[name='page']");
    if (!pageInput) {
        pageInput = document.createElement("input");
        pageInput.type = "hidden";
        pageInput.name = "page";
        form.appendChild(pageInput);
    }
    pageInput.value = "1";
    form.submit();
}//changePageSize

function checkAllProducts(check){
    let products = document.querySelectorAll(".productCheck");
    products.forEach(function(item){
        item.checked = check.checked;
    });
}//checkAllProducts

function checkProduct(){
    let products = document.querySelectorAll(".productCheck");
    let checked = document.querySelectorAll(".productCheck:checked");
    document.getElementById("checkAll").checked =
        (products.length == checked.length);
}//checkProduct

function deleteProduct(){
    let checked = document.querySelectorAll(".productCheck:checked");
    if(checked.length == 0){
        alert("삭제할 상품을 선택하세요.");
        return;
    }
    if(!confirm("선택한 상품을 삭제하시겠습니까?")){
        return;
    }
    let form = document.getElementById("deleteForm");
    form.innerHTML = "";
    checked.forEach(function(item){
        let input = document.createElement("input");
        input.type = "hidden";
        input.name = "prdID";
        input.value = item.value;
        form.appendChild(input);
    });
    form.submit();
}//deleteProduct

function openEditModal(productNo, productName, quantity){
    document.getElementById("editProductNo").value = productNo;
    document.getElementById("editName").value = productName;
    document.getElementById("editStock").value = quantity;
    document.getElementById("editModal").style.display = "flex";
}//openEditModal

function closeEditModal(){
    document.getElementById("editModal").style.display = "none";
}//closeEditModal

</script>
</head>

<body>
	<div class="wrapper">
		<!-- 사이드바 -->
		<c:import url="../fragments/sidebar.jsp"></c:import>

		<%
		request.setCharacterEncoding("UTF-8");
		
		SearchProductService sps = new SearchProductService();
		
		String keyword = request.getParameter("keyword");
		String status = request.getParameter("status");
		String category = request.getParameter("category");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		String pageParam = request.getParameter("page");
		String pageSizeParam = request.getParameter("pageSize");
		int currentPage = 1;
		int pageSize = 20;
		
		if (pageParam != null && !pageParam.isEmpty()) {
		    currentPage = Integer.parseInt(pageParam);
		}
		
		if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
		    pageSize = Integer.parseInt(pageSizeParam);
		}
		
		RangeDTO rDTO = new RangeDTO();
		
		int total=sps.getTotalCount();
		int onSale=sps.getOnSaleCount();
		int soldout=sps.getSoldoutCount();
		request.setAttribute("total", total);
		request.setAttribute("onSale", onSale);
		request.setAttribute("soldout", soldout);
		
		rDTO.setKeyword(keyword);
		rDTO.setCategory(category);
		rDTO.setStartDate(startDate);
		rDTO.setEndDate(endDate);
		
		if (status == null || "전체".equals(status) || status.trim().isEmpty()) {
		    rDTO.setStatus(null);
		} else {
		    rDTO.setStatus(status);
		}
		if (category == null || "".equals(category) || "전체".equals(category)) {
		    rDTO.setCategory(null);
		} else {
		    rDTO.setCategory(category);
		}

		int startNum = (currentPage - 1) * pageSize + 1;
		int endNum = currentPage * pageSize;
		
		rDTO.setStartNum(startNum);
		rDTO.setEndNum(endNum);
		
		List<ProductDTO> productList = sps.searchItem(rDTO);
		request.setAttribute("productList", productList);
		
		int totalCount = sps.getSelectedCount(rDTO);

		RangeDTO saleDTO = new RangeDTO();
		saleDTO.setKeyword(keyword);
		saleDTO.setCategory(category);
		saleDTO.setStartDate(startDate);
		saleDTO.setEndDate(endDate);
		saleDTO.setStatus("판매중");
		
		int onSaleCount = sps.getSelectedCount(saleDTO);
		
		RangeDTO soldDTO = new RangeDTO();
		soldDTO.setKeyword(keyword);
		soldDTO.setCategory(category);
		soldDTO.setStartDate(startDate);
		soldDTO.setEndDate(endDate);
		soldDTO.setStatus("품절");
		
		String period = request.getParameter("period");
		int soldoutCount = sps.getSelectedCount(soldDTO);
		int totalPage = (int)Math.ceil((double)totalCount / pageSize);
		
		request.setAttribute("totalCount", totalCount);
		request.setAttribute("onSaleCount", onSaleCount);
		request.setAttribute("soldoutCount", soldoutCount);
		
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("pageSize", pageSize);
		request.setAttribute("totalPage", totalPage);
		%>

		<!-- 메인 -->
		<div class="main">
			<!-- 헤더 -->
			<div class="top-header">
				<div>
					<h3>View/Edit Products</h3>
				</div>
			</div>
			<!-- 내용 -->
			<div class="card product-wrap">
				<!-- 통계 -->
				<div class="status-box">
					<div class="status-item">
						<p>전체</p>
						<h3>
							${total} <span>건</span>
						</h3>
					</div>
					<div class="status-item">
						<p>판매중</p>
						<h3>
							${onSale} <span>건</span>
						</h3>
					</div>
					<div class="status-item">
						<p>품절</p>
						<h3>
							${soldout} <span>건</span>
						</h3>
					</div>
				</div>

				<!-- 검색 -->
				<form action="vieweditProducts.jsp" method="get" id="searchForm">
				<input type="hidden" id="period" name="period" value="<%= request.getParameter("period") == null ? "3month" : request.getParameter("period") %>">
				<div class="search-area">
					<div class="search-row">
						<div class="search-title">검색어</div>
						<div class="search-content">
						<input type="text" id="keyword" name="keyword" class="form-control" 
								value="<%= keyword == null ? "" : keyword %>" placeholder="상품명을 입력하세요">
						</div>
					</div>
					<div class="search-row">
						<div class="search-title">판매상태</div>
						<div class="search-content">
						<label>
							<input type="radio" name="status" value="전체" <%= status == null || "전체".equals(status) ? "checked" : "" %>>
							전체
						</label>
						<label>
							<input type="radio" name="status" value="판매중" <%= "판매중".equals(status) ? "checked" : "" %>>
							판매중
						</label>
						<label>
							<input type="radio" name="status" value="품절" <%= "품절".equals(status) ? "checked" : "" %>>
							품절
						</label>
						</div>
					</div>
					<div class="search-row">
						<div class="search-title">카테고리</div>
						<div class="search-content">
							<select id="category" name="category" class="form-select">
								<option value="">전체</option>
								<option value="과일" <%= "과일".equals(category) ? "selected" : "" %>>과일</option>
								<option value="채소" <%= "채소".equals(category) ? "selected" : "" %>>채소</option>
							</select>
						</div>
					</div>
					<div class="search-row">
						<div class="search-title">기간</div>
						<div class="search-content">
							<div class="date-btns">
								<button type="button" class="<%= "today".equals(period) ? "active" : "" %>" data-period="today" onclick="selectPeriod(this)">오늘</button>
								<button type="button" class="<%= "week".equals(period) ? "active" : "" %>" data-period="week" onclick="selectPeriod(this)">1주일</button>
								<button type="button" class="<%= "month".equals(period) ? "active" : "" %>" data-period="month" onclick="selectPeriod(this)">1개월</button>
								<button type="button" class="<%= "3month".equals(period) ? "active" : "" %>" data-period="3month" onclick="selectPeriod(this)">3개월</button>
								<button type="button" class="<%= "6month".equals(period) ? "active" : "" %>" data-period="6month" onclick="selectPeriod(this)">6개월</button>
								<button type="button" class="<%= "year".equals(period) ? "active" : "" %>" data-period="year" onclick="selectPeriod(this)">1년</button>
								<button type="button" class="<%= (period == null || "all".equals(period)) ? "active" : "" %>" data-period="all" onclick="selectPeriod(this)">전체</button>
							</div>
							<div class="date-input">
								<input type="date" id="startDate" name="startDate" value="<%= startDate == null ? "" : startDate %>">~
								<input type="date" id="endDate" name="endDate" value="<%= endDate == null ? "" : endDate %>">
							</div>
						</div>
					</div>
					<div class="search-button">
						<button type="button" class="btn-reset" onclick="resetSearch()">초기화</button>
						<button type="submit" class="btn-search">조회</button>
					</div>
				</div>
				
				<!-- 목록 -->
				<div class="list-top">
					<span>상품목록 <b>${ totalCount }</b>개</span> 
					<select id="pageSize" name="pageSize" onchange="changePageSize()">
						<option value="10" <%= pageSize == 10 ? "selected" : "" %>>10개씩</option>
						<option value="20" <%= pageSize == 20 ? "selected" : "" %>>20개씩</option>
						<option value="40" <%= pageSize == 40 ? "selected" : "" %>>40개씩</option>
					</select>
				</div>
				</form>

				<table class="table table-bordered table-hover align-middle text-center">
					<thead>
						<tr>
							<th><input type="checkbox" id="checkAll" onclick="checkAllProducts(this)"></th>
							<th>수정</th>
							<th>복사</th>
							<th>상품번호</th>
							<th>상품명</th>
							<th>판매상태</th>
							<th>재고</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="product" items="${productList}">
							<tr>
								<td><input type="checkbox" class="productCheck" onclick="checkProduct()"
									value="${product.prdID}"></td>
								<td>
									<button class="btn btn-sm btn-outline-secondary"
										onclick="openEditModal('${product.prdID}','${product.prdName}','${product.quantity}')">
										수정</button>
								</td>
								<td>
									<button class="btn btn-sm btn-warning copy-btn"
										data-product-no="${product.prdID}">복사</button>
								</td>
								<td>${product.prdID}</td>
								<td>${product.prdName}</td>
								<td>${product.status}</td>
								<td>${product.quantity}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<div id="divPagination-wrap" style="text-align:center">
			    <c:if test="${totalPage > 1}">
			        <c:forEach var="i" begin="1" end="${totalPage}">
			            <c:choose>
			                <c:when test="${i == currentPage}">
			                    [${i}]
			                </c:when>
			                <c:otherwise>
			                    <a href="vieweditProducts.jsp?page=${i}&pageSize=${pageSize}&keyword=${param.keyword}&status=${param.status}&category=${param.category}&startDate=${param.startDate}&endDate=${param.endDate}&period=${param.period}">
			                        [${i}]
			                    </a>
			                </c:otherwise>
			            </c:choose>
			        </c:forEach>
			    </c:if>
				</div>

				<form id="deleteForm" method="post" action="deleteProduct.jsp"></form>
				
				<div class="delete-btn">
					<button type="button" id="deleteBtn" onclick="deleteProduct()">상품삭제</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 상품 수정 모달 -->
	<div id="editModal" class="modal-overlay">

		<div class="modal-box">
		 	<form action="changeProduct.jsp" method="post">
			<div class="modal-header">
				<span>상품 정보</span>
				<button type="button" id="closeModal" onclick="closeEditModal()">&times;</button>
			</div>
			<div class="modal-body">
				<input type="hidden" id="editProductNo" name="prdID">
				<div class="form-group">
					<label>카테고리 <span class="required">*</span></label> <select
						id="editCategory">
						<option>채소</option>
						<option>과일</option>
					</select>
				</div>
				<div class="form-group">
					<label>상품명 <span class="required">*</span></label>
					<input type="text" id="editName" name="prdName">
				</div>
				<div class="form-group">
					<label>판매 가격</label>
					<div class="price-box">
						<span>₩</span> <input type="text" id="editPrice">
					</div>
				</div>
				<div class="form-group">
					<label>재고 수량</label>
					<div class="stock-box">
						<button type="button" id="minusBtn">-</button>
						<input type="text" id="editStock" value="5" name="stock">
						<button type="button" id="plusBtn">+</button>
					</div>
				</div>
			</div>

			<div class="modal-footer">
				<button type="button" id="cancelBtn" onclick="closeEditModal()">취소</button>
				<button id="saveBtn">저장하기</button>
			</div>
			</form>
		</div>
	</div>
</body>
</html>