<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="manage.ordermanagement.RangeDTO" %>
<%@ page import="manage.ordermanagement.OrderDTO" %>
<%@ page import="manage.ordermanagement.OrderManagementService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../login/loginCheck.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order</title>
<link rel="shortcut icon" href="../images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/dashboard.css" rel="stylesheet">
<link href="../css/order.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script type="text/javascript">
$(function(){
    const searchBtn = document.getElementById("searchBtn");
    const resetBtn = document.getElementById("resetBtn");
    const allCheck = document.getElementById("allCheck");
    const dateBtns = document.querySelectorAll(".date-btn");

    // 날짜를 yyyy-MM-dd 형식으로 변환
    function formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        return year + "-" + month + "-" + day;
    }

    // 초기화 버튼
    resetBtn.addEventListener("click", function(){
        dateBtns.forEach(function(btn){
            btn.classList.remove("active");
        });
        // 기본값: 1개월
        dateBtns[2].classList.add("active");
        document.getElementById("startDate").value = "";
        document.getElementById("endDate").value = "";
        document.getElementById("orderStatus").value = "";
        document.getElementById("category").value = "";

        // 전체 체크도 해제
        allCheck.checked = false;
        document.querySelectorAll(
            "#orderTableBody input[type=checkbox]"
        ).forEach(function(check){
            check.checked = false;
        });
    });

    // 전체 체크
    allCheck.addEventListener("change", function(){
        const checks = document.querySelectorAll(
            "#orderTableBody input[type=checkbox]"
        );
        checks.forEach(function(check){
            check.checked = allCheck.checked;
        });
    });

    // 개별 체크박스 상태에 따라 전체 체크박스 변경
    document.querySelectorAll(
        "#orderTableBody input[type=checkbox]"
    ).forEach(function(check){
        check.addEventListener("change", function(){
            const checks = document.querySelectorAll(
                "#orderTableBody input[type=checkbox]"
            );
            const checkedCount = document.querySelectorAll(
                "#orderTableBody input[type=checkbox]:checked"
            ).length;
            allCheck.checked = checks.length === checkedCount;
        });
    });

    // 오늘 / 1주일 / 1개월 / 3개월 버튼
    dateBtns.forEach(function(btn){
        btn.addEventListener("click", function(){
            dateBtns.forEach(function(dateBtn){
                dateBtn.classList.remove("active");
            });
            this.classList.add("active");
            const endDate = new Date();
            const startDate = new Date();
            const text = this.textContent.trim();
            if(text === "오늘"){
                // 시작일과 종료일 모두 오늘
            } else if(text === "1주일"){
                startDate.setDate(endDate.getDate() - 7);
            } else if(text === "1개월"){
                startDate.setMonth(endDate.getMonth() - 1);
            } else if(text === "3개월"){
                startDate.setMonth(endDate.getMonth() - 3);
            }
            document.getElementById("startDate").value = formatDate(startDate);
            document.getElementById("endDate").value = formatDate(endDate);
        });
    });

    // 취소 요청 모달
    document.querySelectorAll(".cancel-btn").forEach(function(btn){
        btn.addEventListener("click", function(){
            const orderNo = this.dataset.orderNo;
            console.log("취소 요청 주문번호:", orderNo);
            const modal = new bootstrap.Modal(
                document.getElementById("cancelModal")
            );
            modal.show();
        });
    });

    // 교환 요청 모달
    document.querySelectorAll(".claim-btn").forEach(function(btn){
        btn.addEventListener("click", function(){
            const modal = new bootstrap.Modal(
                document.getElementById("exchangeModal")
            );
            modal.show();
        });
    });

    // 배송 처리 버튼
    document.getElementById("deliveryBtn").addEventListener("click", function(){
        const orderNo = this.dataset.orderNo;
        console.log("배송 처리 주문번호:", orderNo);
        // 나중에 배송 처리 Controller 호출
    });
});
</script>
</head>

<body>
	<div class="wrapper">

		<!-- 사이드바 -->
		<c:import url="../fragments/sidebar.jsp"></c:import>

		<%
		RangeDTO rDTO = new RangeDTO();
		
		rDTO.setStartDate(request.getParameter("startDate"));
		rDTO.setEndDate(request.getParameter("endDate"));
		rDTO.setDelivery_status(request.getParameter("delivery_status"));
		
		String currentPage = request.getParameter("currentPage");
		
		int page = 1;
		
		if (currentPage != null && !currentPage.isEmpty()) {
		page = Integer.parseInt(currentPage);
		}
		
		int pageScale = 10;
		
		rDTO.setStartNum((page - 1) * pageScale + 1);
		rDTO.setEndNum(page * pageScale);
		
		OrderManagementService oms = new OrderManagementService();
		
		List<OrderDTO> orderList = oms.getOrderList(rDTO);
		
		request.setAttribute("orderList", orderList);
		request.setAttribute("rangeDTO", rDTO);
		request.setAttribute("currentPage", page);
		%>

		<!-- 메인 -->
		<div class="main">

			<!-- 헤더 -->
			<div class="top-header">
				<div>
					<h3>Order</h3>
				</div>
			</div>

			<!-- 내용 -->
			<div class="order-wrap">
				<h2 class="page-title">주문목록</h2>

				<!-- 검색 영역 -->
				<form action="adminOrder.jsp" method="get" id="searchForm">
				<div class="search-box">
					<div class="search-row">
						<label>조회기간</label>
						<button type="button" class="date-btn">오늘</button>
						<button type="button" class="date-btn">1주일</button>
						<button type="button" class="date-btn active">1개월</button>
						<button type="button" class="date-btn">3개월</button>
						<input type="date" id="startDate"> ~ <input type="date" id="endDate">
					</div>

					<div class="search-row">
						<label>처리상태</label> <select id="orderStatus">
							<option value="">전체</option>
							<option value="paid">결제완료</option>
							<option value="ready">배송준비중</option>
							<option value="delivery">배송중</option>
							<option value="complete">배송완료</option>
							<option value="cancel">취소요청</option>
						</select>
					</div>

					<div class="search-row">
						<label>상품구분</label> <select id="category">
							<option value="">전체</option>
							<option value="vegetable">채소</option>
							<option value="fruit">과일</option>
						</select>
					</div>

					<div class="search-btn-area">
						<button type="button" id="resetBtn">초기화</button>
						<button type="button" id="searchBtn">조회</button>
					</div>

				</div>
				</form>

				<!-- 주문 목록 -->
				<table class="order-table">
					<thead>
						<tr>
							<th><input type="checkbox" id="allCheck"></th>
							<th>No.</th>
							<th>주문번호</th>
							<th>회원ID</th>
							<th>상품명</th>
							<th>주문일</th>
							<th>결제금액</th>
							<th>수량</th>
							<th>주문상태</th>
							<th>클레임</th>
						</tr>
					</thead>

					<tbody id="orderTableBody">
					<c:if test="${empty orderList}">
						<tr>
							<td colspan="10">조회된 주문 내역이 없습니다.</td>
						</tr>
					</c:if>
					<c:forEach var="order" items="${orderList}" varStatus="status">
						<tr>
							<td>
								<input type="checkbox" name="selectedOrder" value="${order.orderID}">
							</td>
							<td>${status.count}</td>
							<td>${order.orderID}</td>
							<td>${order.clientID}</td>
							<td>${order.prdName}</td>
							<td>${order.orderDate}</td>
							<td>${order.totalAmount}원</td>
							<td>${order.quantity}</td>
							<td>
								${order.orderStatus}
								<c:if test="${not empty order.deliveryStatus}">
								<br>
								<span>${order.deliveryStatus}</span>
								</c:if>
							</td>
							<td>
								<c:choose>
									<c:when test="${not empty order.claimID}">
										<button type="button" class="cancel-btn" data-order-id="${order.orderID}" data-claim-id="${order.claimID}">
											클레임 상세
										</button>
									</c:when>
									<c:otherwise>
										-
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>

				<div class="bottom-btn">
					<button type="button" id="deliveryBtn" data-order-no="202506200001">배송처리</button>
				</div>

			</div>
		</div>
	</div>
	<script src="../js/bootstrap.bundle.min.js"></script>

	<!-- 취소 요청 상세 -->
	<div class="modal fade" id="cancelModal" tabindex="-1">
		<div class="modal-dialog modal-xl">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">취소요청 상세</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<div class="modal-body">
					<table class="table table-bordered">
						<tr>
						    <th>클레임번호</th>
						    <td id="claimID"></td>
						    <th>취소요청일시</th>
						    <td id="requestDate"></td>
						</tr>
						<tr>
						    <th>클레임상태</th>
						    <td id="claimStatus"></td>
						    <th>구매자연락처</th>
						    <td id="clientTel"></td>
						</tr>
					</table>

					<h6>취소요청 상품</h6>
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>No</th>
								<th>상품코드</th>
								<th>상품명</th>
								<th>단가</th>
								<th>취소수량</th>
							</tr>
						</thead>
						<tbody id="claimProductBody"></tbody>
					</table>
				</div>

				<div class="modal-footer">
					<button class="btn btn-danger">취소완료 처리</button>
					<button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 교환 요청 상세 -->
	<div class="modal fade" id="exchangeModal" tabindex="-1">
		<div class="modal-dialog modal-xl">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">교환 / 반품 요청 상세</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<table class="table table-bordered">
						<tr>
							<th>클레임번호</th>
							<td>57724</td>
							<th>클레임요청일</th>
							<td>2025-07-03</td>
						</tr>
						<tr>
							<th>주문자ID</th>
							<td>홍길동</td>
							<th>연락처</th>
							<td>010-1234-5678</td>
						</tr>
					</table>
					<h6>상품정보</h6>
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>No</th>
								<th>상품번호</th>
								<th>상품명</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>1</td>
								<td>P20230401</td>
								<td>친환경 바른계란</td>
								<td>교환요청</td>
							</tr>
						</tbody>
					</table>
					<div class="mt-3">
						<h6>상세사유</h6>
						<textarea class="form-control" rows="4" readonly>
						상품이 파손된 상태로 배송되었습니다.
                    	</textarea>
					</div>
				</div>

				<div class="modal-footer">
					<button class="btn btn-primary">교환승인</button>
					<button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

</body>

</html>