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
<link href="../css/pagination.css" rel="stylesheet">
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
        const form = document.getElementById("searchForm");
        $("#keyword").val("");
        $("#category").val("");
        $("#orderStatus").val("");
        $("#startDate").val("");
        $("#endDate").val("");
        $("#period").val("all");
        $("#pageSize").val("20");
        $(".date-btn").removeClass("active");

        allCheck.prop("checked", false);
        $("#orderTableBody input[type=checkbox]").prop("checked", false);

        let pageInput = form.querySelector("input[name='page']");

        if (!pageInput) {
            pageInput = document.createElement("input");
            pageInput.type = "hidden";
            pageInput.name = "page";
            form.appendChild(pageInput);
        }
        pageInput.value = "1";
        form.submit();
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
    	const orderIDs = [];

        $("#orderTableBody input[type=checkbox]:checked").each(function(){
            const status = $(this).closest("tr").find(".delivery-status").text().trim();
            if (status === "배송중") {
                orderIDs.push(this.value);
            }
        });

        if (orderIDs.length === 0) {
            alert("배송중인 주문만 배송처리할 수 있습니다.");
            return;
        }

        $.ajax({
            url: "deliveryProcess.jsp",
            type: "POST",
            traditional: true,
            data: {
                orderIDs: orderIDs
            },
            success: function(res){
                alert("배송처리 완료: "+res+"건");
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
            url: "cancelDetail.jsp",
            type: "GET",
            dataType: "json",
            data: {
                claimID: claimID
            },
            success: function(data){
            	$("#cancelModal").data("claim-id", data.claimID);
                $("#claimID").text(data.claimID);
                $("#requestDate").text(data.requestDate);
                $("#clientName").text(data.clientName);
                $("#clientTel").text(data.clientTel);
                $("#claimStatus").text(data.claimStatus);

                let html = "";
                $.each(data.products, function(i, item){
                    html += "<tr>"
                          + "<td>" + (i + 1) + "</td>"
                          + "<td>" + (item.order_detail_ID === "null" ? "-" : item.order_detail_ID) + "</td>"
                          + "<td>" + item.prdName + "</td>"
                          + "<td>" + item.price + "</td>"
                          + "<td>" + item.quantity + "</td>"
                          + "</tr>";
                });

                $("#cancelProductBody").html(html);
                
                new bootstrap.Modal(
                    document.getElementById("cancelModal")
                ).show();
            },
            error: function(xhr, status, error){
                alert("취소 상세 조회 실패");
            }
        });
    });
    
    $(".exchange-btn").on("click", function(){
        const claimID=$(this).data("claim-id");
        $.ajax({
            url:"exchangeDetail.jsp",
            type:"GET",
            dataType:"json",
            data:{
                claimID:claimID
            },
            success:function(data){
            	$("#exchangeModal").data("claim-id", data.claimID);
                $("#exchangeClaimID").text(data.claimID);
                $("#exchangeRequestDate").text(data.requestDate);
                $("#exchangeClientName").text(data.clientName);
                $("#exchangeClientTel").text(data.clientTel);
                $("#exchangePrdName").text(data.products[0].prdName);
                $("#exchangeReason").text("반품 사유 : "+data.reason);
                $("#exchangeReasonDetail").text(data.reasonDetail);
                
                let imageHtml = "";
                if (data.img && data.img.length > 0) {
                    $.each(data.img, function(i, imageName){
                        imageHtml += "<img src='../upload/" + imageName + "' "
                                  + "alt='반품 요청 이미지' "
                                  + "style='width:150px; height:150px; object-fit:cover; margin-right:10px;'>";
                    });
                } else {
                    imageHtml = "첨부 이미지가 없습니다.";
                }

                $("#claimImage").html(imageHtml);
                
                let html = "";
                $.each(data.products, function(i, item){
                    html += "<tr>"
                          + "<td>" + (i + 1) + "</td>"
                          + "<td>" + (item.claimStatus === "null" ? "-" : item.claimStatus) + "</td>"
                          + "<td>" + item.optionID + "</td>"
                          + "<td>" + item.price + "</td>"
                          + "<td>" + item.prdName + "</td>"
                          + "<td>" + item.quantity + "</td>"
                          + "</tr>";
                });
                $("#exchangeProductBody").html(html);
                new bootstrap.Modal(
                    document.getElementById("exchangeModal")
                ).show();
            }
        });
    });
    
    $("#exchangeCompleteBtn").on("click", function(){
        const claimID = $("#exchangeModal").data("claim-id");
        if (!claimID) {
            alert("클레임 번호를 찾을 수 없습니다.");
            return;
        }
        $.ajax({
            url: "claimProcess.jsp",
            type: "POST",
            dataType: "json",
            data: {
                claimID: claimID,
                result: "처리완료"
            },
            success: function(data){
                if (data.success) {
                    alert("교환/반품 처리가 완료되었습니다.");
                    bootstrap.Modal.getInstance(
                        document.getElementById("exchangeModal")
                    ).hide();
                    location.reload();
                } else {
                    alert("교환/반품 처리에 실패했습니다.");
                }
            },
            error: function(xhr){
                console.log(xhr.responseText);
                alert("교환/반품 처리 중 오류가 발생했습니다.");
            }
        });
    });

    $("#exchangeRejectBtn").on("click", function(){
        const claimID = $("#exchangeModal").data("claim-id");
        if (!claimID) {
            alert("클레임 번호를 찾을 수 없습니다.");
            return;
        }
        $.ajax({
            url: "claimProcess.jsp",
            type: "POST",
            dataType: "json",
            data: {
                claimID: claimID,
                result: "거절"
            },
            success: function(data){
                if (data.success) {
                    alert("교환/반품 요청을 거절했습니다.");
                    bootstrap.Modal.getInstance(
                        document.getElementById("exchangeModal")
                    ).hide();
                    location.reload();
                } else {
                    alert("교환/반품 거절 처리에 실패했습니다.");
                }
            },
            error: function(xhr){
                console.log(xhr.responseText);
                alert("교환/반품 거절 중 오류가 발생했습니다.");
            }
        });
    });
    
    $("#cancelCompleteBtn").on("click", function(){
        const claimID = $("#cancelModal").data("claim-id");
        if (!claimID) {
            alert("클레임 번호를 찾을 수 없습니다.");
            return;
        }
        $.ajax({
            url: "claimProcess.jsp",
            type: "POST",
            dataType: "json",
            data: {
                claimID: claimID,
                result: "처리완료"
            },
            success: function(data){
                if (data.success) {
                    alert("취소 처리가 완료되었습니다.");
                    bootstrap.Modal.getInstance(
                        document.getElementById("cancelModal")
                    ).hide();
                    location.reload();
                } else {
                    alert("취소 처리에 실패했습니다.");
                }
            },
            error: function(xhr){
                console.log(xhr.responseText);
                alert("취소 처리 중 오류가 발생했습니다.");
            }
        });
    });

    $("#cancelRejectBtn").on("click", function(){
        const claimID = $("#cancelModal").data("claim-id");
        if (!claimID) {
            alert("클레임 번호를 찾을 수 없습니다.");
            return;
        }
        $.ajax({
            url: "claimProcess.jsp",
            type: "POST",
            dataType: "json",
            data: {
                claimID: claimID,
                result: "취소거절"
            },
            success: function(data){
                if (data.success) {
                    alert("취소 요청을 거절했습니다.");

                    bootstrap.Modal.getInstance(
                        document.getElementById("cancelModal")
                    ).hide();
                    location.reload();
                } else {
                    alert("취소 거절 처리에 실패했습니다.");
                }
            },
            error: function(xhr){
                console.log(xhr.responseText);
                alert("취소 거절 처리 중 오류가 발생했습니다.");
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
		String status = request.getParameter("status");
		if (status == null) {
		    status = "";
		}
		rDTO.setDelivery_status(status);
		
		if(startDate == null || startDate.equals("")) {
		    startDate = null;
		}
		if(endDate == null || endDate.equals("")) {
		    endDate = null;
		}
		
		String pageParam = request.getParameter("currentPage");
		String pageSizeParam = request.getParameter("pageSize");
		int currentPage = 1;
		int pageSize = 20;
		
		if(pageParam != null && !pageParam.isEmpty()) {
		    currentPage = Integer.parseInt(pageParam);
		}
		if(pageSizeParam != null && !pageSizeParam.isEmpty()) {
		    pageSize = Integer.parseInt(pageSizeParam);
		}
		
		if(keyword != null && !keyword.isEmpty()) {
		    rDTO.setKeyword(keyword);
		}
		if(delivery_status != null && !delivery_status.isEmpty()) {
		    rDTO.setDelivery_status(delivery_status);
		}
		
		rDTO.setStartDate(startDate);
		rDTO.setEndDate(endDate);
		
		OrderManagementService oms = new OrderManagementService();
		RangeDTO countDTO = new RangeDTO();
		
		if(keyword != null && !keyword.isEmpty()) {
		    countDTO.setKeyword(keyword);
		}
		if(delivery_status != null && !delivery_status.isEmpty()) {
		    countDTO.setDelivery_status(delivery_status);
		}
		
		countDTO.setStartDate(startDate);
		countDTO.setEndDate(endDate);
		countDTO.setStartNum(1);
		countDTO.setEndNum(999999);
		
		List<OrderDTO> countList = new ArrayList<>();
		try {
		    countList = oms.getOrderList(countDTO);
		} catch(Exception e) {
		    e.printStackTrace();
		}
		
		int totalCount = countList.size();
		int totalPage = (int)Math.ceil((double)totalCount / pageSize);
		
		int pageBlock = 4;
		int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
		int endPage = startPage + pageBlock - 1;

		if(endPage > totalPage){
		    endPage = totalPage;
		}
		
		int startNum = (currentPage - 1) * pageSize + 1;
		int endNum = currentPage * pageSize;
		
		rDTO.setStartNum(startNum);
		rDTO.setEndNum(endNum);
		
		List<OrderDTO> orderList = new ArrayList<>();
		
		try {
		    orderList = oms.getOrderList(rDTO);
		} catch(Exception e) {
		    orderList = new ArrayList<>();
		    throw new RuntimeException(
		        "주문 목록 조회 중 오류 발생",e
		    );
		}

		request.setAttribute("orderList", orderList);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("pageSize", pageSize);
		request.setAttribute("totalPage", totalPage);
		request.setAttribute("totalCount", totalCount);
		request.setAttribute("startPage", startPage);
		request.setAttribute("endPage", endPage);
		
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
						    <option value="" <%= status.equals("") ? "selected" : "" %>>전체</option>
						    <option value="paid" <%= status.equals("paid") ? "selected" : "" %>>결제완료</option>
						    <option value="ready" <%= status.equals("ready") ? "selected" : "" %>>배송대기</option>
						    <option value="delivery" <%= status.equals("delivery") ? "selected" : "" %>>배송중</option>
						    <option value="complete" <%= status.equals("complete") ? "selected" : "" %>>배송완료</option>
						    <option value="cancel" <%= status.equals("cancel") ? "selected" : "" %>>취소요청</option>
						</select>
					</div>

					<div class="search-row">
						<label>상품구분</label><select id="category">
							<option value="">전체</option>
							<option>채소</option>
							<option>과일</option>
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
								<span class="delivery-status">${order.deliveryStatus}</span>
								</c:if>
							</td>
							<td>
							<c:choose>
							    <c:when test="${empty order.claimID}">
							        -
							    </c:when>
							    <c:when test="${order.claimName eq '취소'}">
							        <button type="button" class="cancel-btn" data-claim-id="${order.claimID}">취소 요청</button>
							    </c:when>
							    <c:when test="${order.claimName eq '교환'}">
							        <button type="button" class="exchange-btn" data-claim-id="${order.claimID}">교환 요청</button>
							    </c:when>
							    <c:when test="${order.claimName eq '반품'}">
							        <button type="button" class="exchange-btn" data-claim-id="${order.claimID}">반품 요청</button>
							    </c:when>
							</c:choose>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				
				<div id="divPagination-wrap" class="pagination" style="text-align:center">
				<c:if test="${totalCount > 0}">
				    <!-- 이전 그룹 -->
				    <c:if test="${startPage > 1}">
				        <a class="page"
				           href="adminOrder.jsp?currentPage=${startPage-1}&pageSize=${pageSize}&keyword=${param.keyword}&orderStatus=${param.orderStatus}&startDate=${param.startDate}&endDate=${param.endDate}">
				            ◀
				        </a>
				    </c:if>
				
				    <c:forEach var="i" begin="${startPage}" end="${endPage}">
				        <c:choose>
				            <c:when test="${i == currentPage}">
				                <span class="page active">${i}</span>
				            </c:when>
				            <c:otherwise>
				                <a class="page"
				                   href="adminOrder.jsp?currentPage=${i}&pageSize=${pageSize}&keyword=${param.keyword}&orderStatus=${param.orderStatus}&startDate=${param.startDate}&endDate=${param.endDate}">
				                    ${i}
				                </a>
				            </c:otherwise>
				        </c:choose>
				    </c:forEach>
				
				    <!-- 다음 그룹 -->
				    <c:if test="${endPage < totalPage}">
				        <a class="page"
				           href="adminOrder.jsp?currentPage=${endPage+1}&pageSize=${pageSize}&keyword=${param.keyword}&orderStatus=${param.orderStatus}&startDate=${param.startDate}&endDate=${param.endDate}">
				            ▶
				        </a>
				    </c:if>
				</c:if>
				</div>

				<div class="bottom-btn">
					<button type="button" id="deliveryBtn">배송처리</button>
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
					<h6>취소접수 정보</h6>
					<table class="table table-bordered">
						<tr>
						    <th>클레임 번호</th>
						    <td id="claimID"></td>
						    <th>취소요청 일시</th>
						    <td id="requestDate"></td>
						</tr>
						<tr>
						    <th>클레임 상태</th>
						    <td id="claimStatus"></td>
						    <th colspan="2"></th>
						</tr>
						<tr>
						    <th>구매자 이름</th>
						    <td id="clientName"></td>
						    <th>구매자 연락처</th>
						    <td id="clientTel"></td>
						</tr>
					</table>

					<h6>취소요청 상품</h6>
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>No</th>
								<th>개별주문번호</th>
								<th>상품명</th>
								<th>판매가</th>
								<th>취소수량</th>
							</tr>
						</thead>
						<tbody id="cancelProductBody"></tbody>
					</table>
				</div>

				<div class="modal-footer">
				    <button type="button" class="btn btn-danger" id="cancelCompleteBtn">취소 완료</button>
				    <button type="button" class="btn btn-secondary" id="cancelRejectBtn">취소 거절</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 반품/교환 요청 상세 -->
	<div class="modal fade" id="exchangeModal" tabindex="-1">
		<div class="modal-dialog modal-xl">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">교환 / 반품 요청 상세</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<h6>반품접수 정보</h6>
					<table class="table table-bordered">
				    <tr>
				        <th>클레임번호</th>
				        <td id="exchangeClaimID"></td>
				        <th>반품요청일시</th>
				        <td id="exchangeRequestDate"></td>
				    </tr>
				    <tr>
				        <th>구매자이름</th>
				        <td id="exchangeClientName"></td>
				        <th>구매자연락처</th>
				        <td id="exchangeClientTel"></td>
				    </tr>
					</table>
					<h6>반품요청 상품</h6>
					<table class="table table-bordered">
					    <thead>
					        <tr>
					            <th>No</th>
					            <th>클레임상태</th>
					            <th>옵션번호?</th>
					            <th>가격</th>
					            <th>상품명</th>
					            <th>수량</th>
					        </tr>
					    </thead>
					    <tbody id="exchangeProductBody"></tbody>
					</table>
					<h6>반품 정보</h6>
					<table class="table table-bordered">
						<tr>
							<th>반품 사유</th>
				        	<td>
				        		<div id="exchangePrdName" style="font-weight:bold; color:#009652; font-size:23px; margin-bottom:10px; margin-left: 3px;"></div>
								<div id="exchangeReason" style="font-weight:bold;; margin-bottom:8px; margin-left: 3px;"></div>
								<div id="exchangeReasonDetail" style="padding:10px; border:1px solid #ddd; border-radius:5px; 
									background:#f8f9fa; white-space:pre-wrap; margin-bottom:12px;"></div>
								<div id="claimImage" style="display:flex; flex-wrap:wrap; gap:10px;"></div>
				        	</td>
						</tr>
					</table>

					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="exchangeCompleteBtn">교환/반품 완료</button>
						<button type="button" class="btn btn-secondary" id="exchangeRejectBtn">교환/반품 거절</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

</html>