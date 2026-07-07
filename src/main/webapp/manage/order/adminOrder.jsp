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
    const searchBtn = $("#searchBtn");
    const resetBtn = $("#resetBtn");
    const allCheck = $("#allCheck");

    searchBtn.on("click", function(){
        $("#searchForm").submit();
    });

    resetBtn.on("click", function(){
        $(".date-btn").removeClass("active");
        $(".date-btn").eq(2).addClass("active");
        $("#startDate").val("");
        $("#endDate").val("");
        $("#orderStatus").val("");
        $("#category").val("");
        allCheck.prop("checked", false);
        $("#orderTableBody input[type=checkbox]").prop("checked", false);
    });

    allCheck.on("change", function(){
        $("#orderTableBody input[type=checkbox]")
            .prop("checked", this.checked);
    });

    $("#orderTableBody").on("change", "input[type=checkbox]", function(){
        const total = $("#orderTableBody input[type=checkbox]").length;
        const checked = $("#orderTableBody input[type=checkbox]:checked").length;

        allCheck.prop("checked", total === checked);
    });
    
    $(".date-btn").on("click", function () {
        $(".date-btn").removeClass("active");
        $(this).addClass("active");

        const today = new Date();
        const startDate = new Date();
        const buttonText = $(this).text().trim();

        if (buttonText === "오늘") {
            startDate.setDate(today.getDate());
        } else if (buttonText === "1주일") {
            startDate.setDate(today.getDate() - 7);
        } else if (buttonText === "1개월") {
            startDate.setMonth(today.getMonth() - 1);
        } else if (buttonText === "3개월") {
            startDate.setMonth(today.getMonth() - 3);
        }

        function formatDate(date) {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, "0");
            const day = String(date.getDate()).padStart(2, "0");
            return year + "-" + month + "-" + day;
        }
        $("#startDate").val(formatDate(startDate));
        $("#endDate").val(formatDate(today));
    });

    $("#deliveryBtn").on("click", function(){
        const orderIDs = $("#orderTableBody input[type=checkbox]:checked")
            .map(function(){ return this.value; }).get();

        if(orderIDs.length === 0){
            alert("선택된 주문이 없습니다.");
            return;
        }

        $.ajax({
            url: "../deliveryProcess.jsp",
            type: "POST",
            traditional: true,
            data: {
                orderIDs: orderIDs
            },
            success: function(res){
                alert("배송처리 완료: " + res + "건");
                location.reload();
            },
            error: function(){
                alert("배송처리 실패");
            }
        });
    });

    $(".cancel-btn").on("click", function(){
        const claimID = $(this).data("claim-id");
        $.ajax({
            url: "../claimDetail.jsp",
            type: "GET",
            data: { claimID: claimID },
            success: function(res){
                const data = JSON.parse(res);
                
                $("#claimID").text(data.claimID);
                $("#requestDate").text(data.requestDate);
                $("#clientName").text(data.clientName);
                $("#clientTel").text(data.tel);

                let productHtml = `
                    <tr>
                        <td>1</td>
                        <td>${data.product.optionID}</td>
                        <td>${data.product.prdName}</td>
                        <td>${data.status}</td>
                    </tr>
                `;
                $("#claimProductBody").html(productHtml);
                $("#reasonDetail").val(data.reasonDetail || "");

                let imgHtml = "";

                if(data.images && data.images.length > 0){
                    data.images.forEach(function(img){
                        imgHtml += `
                            <img src="../upload/${img}"
                                 style="width:120px;height:120px;
                                        margin:5px;
                                        border:1px solid #ddd;">
                        `;
                    });
                } else {
                    imgHtml = "<p>이미지 없음</p>";
                }
                $("#claimImageArea").html(imgHtml);
                new bootstrap.Modal(
                    document.getElementById("cancelModal")
                ).show();
            }
        });
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
		
		String keyword = request.getParameter("keyword");
		String delivery_status = request.getParameter("orderStatus");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		if(startDate == null || startDate.equals("")) startDate = null;
		if(endDate == null || endDate.equals("")) endDate = null;
		
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
		
		if(keyword != null && !keyword.equals("")){
		    rDTO.setKeyword(keyword);
		}

		if(delivery_status != null && !delivery_status.equals("")){
		    rDTO.setDelivery_status(delivery_status);
		}
		
		//rDTO.setKeyword(keyword);
		//rDTO.setDelivery_status(delivery_status);
		rDTO.setStartDate(startDate);
		rDTO.setEndDate(endDate);
		
		int startNum = (currentPage - 1) * pageSize + 1;
		int endNum = currentPage * pageSize;
		
		rDTO.setStartNum(startNum);
		rDTO.setEndNum(endNum);
		
		OrderManagementService oms = new OrderManagementService();
		List<OrderDTO> orderList = new ArrayList<>();
		try {
		    orderList = oms.getOrderList(rDTO);
		} catch (Exception e) {
		    orderList = new ArrayList<>();
		    throw new RuntimeException("주문 목록 조회 중 오류 발생", e);
		}
		
		int totalCount = oms.totalCount(rDTO);
		int totalPage = (int)Math.ceil((double)totalCount / pageSize);
		
		request.setAttribute("orderList", orderList);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("pageSize", pageSize);
		request.setAttribute("totalPage", totalPage);
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
						<input type="date" id="startDate" name="startDate"> ~ <input type="date" id="endDate" name="endDate">
					</div>

					<div class="search-row">
						<label>처리상태</label><select id="orderStatus" name="orderStatus">
							<option value="">전체</option>
							<option value="paid">결제완료</option>
							<option value="ready">배송준비중</option>
							<option value="delivery">배송중</option>
							<option value="complete">배송완료</option>
							<option value="cancel">취소요청</option>
						</select>
					</div>

					<div class="search-row">
						<label>상품구분</label><select id="category">
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
										<button type="button" class="cancel-btn" data-claim-id="${order.claimID}">
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
				
				<div style="text-align:center; margin-top:20px;">
				<c:if test="${totalPage > 1}">
				    <c:forEach var="i" begin="1" end="${totalPage}">
				        <c:choose>
				            <c:when test="${i == currentPage}">
				                <b>[${i}]</b>
				            </c:when>
				            <c:otherwise>
				                <a href="adminOrder.jsp?
				                    page=${i}
				                    &pageSize=${pageSize}
				                    &keyword=${param.keyword}
				                    &orderStatus=${param.orderStatus}
				                    &startDate=${param.startDate}
				                    &endDate=${param.endDate}">
				                    [${i}]
				                </a>
				            </c:otherwise>
				        </c:choose>
				    </c:forEach>
				</c:if>
				</div>

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
				        <td id="claimID"></td>
				        <th>클레임요청일</th>
				        <td id="requestDate"></td>
				    </tr>
				    <tr>
				        <th>주문자ID</th>
				        <td id="clientName"></td>
				        <th>연락처</th>
				        <td id="clientTel"></td>
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
					    <tbody id="claimProductBody"></tbody>
					</table>
					<div class="mt-3">
					    <h6>상세사유</h6>
					    <textarea id="reasonDetail" class="form-control" rows="4" readonly></textarea>
					</div>
					<h6>첨부이미지</h6>
					<div id="claimImageArea"></div>
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