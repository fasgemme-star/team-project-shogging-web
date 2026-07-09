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
function searchOrder() {
    $("#searchForm").submit();
}//searchOrder

function resetSearch() {
    const form = document.getElementById("searchForm");

    document.getElementById("category").value = "";
    document.getElementById("orderStatus").value = "";
    document.getElementById("startDate").value = "";
    document.getElementById("endDate").value = "";
    document.getElementById("period").value = "all";

    $(".date-btn").removeClass("active");

    $("#allCheck").prop("checked", false);
    $("#orderTableBody input[type='checkbox']").prop("checked", false);

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

function checkAll(check) {
    $("#orderTableBody input[type='checkbox']")
        .prop("checked", check.checked);
}//checkAll

function checkOrder() {
    let total = $("#orderTableBody input[type='checkbox']").length;
    let checked = $("#orderTableBody input[type='checkbox']:checked").length;

    $("#allCheck").prop("checked", total === checked);
}//checkOrder

function formatDate(date) {
    let year = date.getFullYear();
    let month = String(date.getMonth() + 1).padStart(2, "0");
    let day = String(date.getDate()).padStart(2, "0");

    return year + "-" + month + "-" + day;
}//formatDate

function selectPeriod(btn) {
    let today = new Date();
    let startDate = new Date();
    let endDate = new Date();
    let period = btn.dataset.period;

    if (period === "today") {
        startDate = new Date(today);
    } else if (period === "week") {
        startDate.setDate(today.getDate() - 7);
    } else if (period === "month") {
        startDate.setMonth(today.getMonth() - 1);
    } else if (period === "3month") {
        startDate.setMonth(today.getMonth() - 3);
    } else if (period === "all") {
        document.getElementById("startDate").value = "";
        document.getElementById("endDate").value = "";
        document.getElementById("period").value = "all";
        document.querySelectorAll(".date-btn").forEach(function(item) {
            item.classList.remove("active");
        });
        btn.classList.add("active");
        return;
    }

    document.getElementById("startDate").value = formatDate(startDate);
    document.getElementById("endDate").value = formatDate(endDate);
    document.getElementById("period").value = period;
    document.querySelectorAll(".date-btn").forEach(function(item) {
        item.classList.remove("active");
    });

    btn.classList.add("active");
}//selectPeriod

function processDelivery() {
    let orderIDs = [];

    $("#orderTableBody input[type='checkbox']:checked").each(function () {
        let status = $(this).closest("tr").find(".delivery-status").text().trim();
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
        success: function(res) {
            alert("배송처리 완료: " + res + "건");
            location.reload();
        },
        error: function() {
            alert("배송처리 실패");
        }
    });
}//processDelivery

function openCancelDetail(btn) {
    let claimID = $(btn).data("claim-id");

    $.ajax({
        url: "cancelDetail.jsp",
        type: "GET",
        dataType: "json",
        data: {
            claimID: claimID
        },
        success: function(data) {
            $("#cancelModal").data("claim-id", data.claimID);
            $("#claimID").text(data.claimID);
            $("#requestDate").text(data.requestDate);
            $("#clientName").text(data.clientName);
            $("#clientTel").text(data.clientTel);
            $("#claimStatus").text(data.claimStatus);

            let html = "";
            $.each(data.products, function(i, item) {
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
        error: function() {
            alert("취소 상세 조회 실패");
        }
    });
}//openCancelDetail

function openExchangeDetail(btn) {
    let claimID = $(btn).data("claim-id");

    $.ajax({
        url: "exchangeDetail.jsp",
        type: "GET",
        dataType: "json",
        data: {
            claimID: claimID
        },
        success: function(data) {
            $("#exchangeModal").data("claim-id", data.claimID);
            $("#exchangeClaimID").text(data.claimID);
            $("#exchangeRequestDate").text(data.requestDate);
            $("#exchangeClientName").text(data.clientName);
            $("#exchangeClientTel").text(data.clientTel);
            $("#exchangePrdName").text(data.products[0].prdName);
            $("#exchangeReason").text("반품 사유 : " + data.reason);
            $("#exchangeReasonDetail").text(data.reasonDetail);

            let imageHtml = "";

            if (data.img && data.img.length > 0) {
                $.each(data.img, function(i, imageName) {
                    imageHtml += "<img src='../upload/" + imageName + "' "
                              + "alt='반품 요청 이미지' "
                              + "style='width:150px; height:150px; object-fit:cover; margin-right:10px;'>";
                });
            } else {
                imageHtml = "첨부 이미지가 없습니다.";
            }

            $("#claimImage").html(imageHtml);
            let html = "";

            $.each(data.products, function(i, item) {
                html += "<tr>"
                      + "<td>" + (i + 1) + "</td>"
                      + "<td>" + (item.claimStatus === "null" ? "-" : item.claimStatus) + "</td>"
                      + "<td>" + item.order_detail_ID + "</td>"
                      + "<td>" + item.price + "</td>"
                      + "<td>" + item.prdName + "</td>"
                      + "<td>" + item.quantity + "</td>"
                      + "</tr>";
            });
            $("#exchangeProductBody").html(html);

            new bootstrap.Modal(
                document.getElementById("exchangeModal")
            ).show();
        },
        error: function() {
            alert("교환 상세 조회 실패");
        }
    });
}//openExchangeDetail

function completeExchange() {
    let claimID = $("#exchangeModal").data("claim-id");

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
        success: function(data) {
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
        error: function(xhr) {
            console.log(xhr.responseText);
            alert("교환/반품 처리 중 오류가 발생했습니다.");
        }
    });
}//completeExchange

function rejectExchange() {
    let claimID = $("#exchangeModal").data("claim-id");

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
        success: function(data) {
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
        error: function(xhr) {
            console.log(xhr.responseText);
            alert("교환/반품 거절 중 오류가 발생했습니다.");
        }
    });
}//rejectExchange

function completeCancel() {
    let claimID = $("#cancelModal").data("claim-id");

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
        success: function(data) {
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
        error: function(xhr) {
            console.log(xhr.responseText);
            alert("취소 처리 중 오류가 발생했습니다.");
        }
    });
}//completeCancel

function rejectCancel() {
    let claimID = $("#cancelModal").data("claim-id");

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
        success: function(data) {
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
        error: function(xhr) {
            console.log(xhr.responseText);
            alert("취소 거절 처리 중 오류가 발생했습니다.");
        }
    });
}//rejectCancel

</script>
</head>

<body>
	<div class="wrapper">

		<!-- 사이드바 -->
		<c:import url="../fragments/sidebar.jsp"></c:import>

		<%
		RangeDTO rDTO = new RangeDTO();
		
		String keyword = request.getParameter("keyword");
		String category = request.getParameter("category");
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
		int pageSize = 15;
		
		if(pageParam != null && !pageParam.isEmpty()) {
		    currentPage = Integer.parseInt(pageParam);
		}
		if(pageSizeParam != null && !pageSizeParam.isEmpty()) {
		    pageSize = Integer.parseInt(pageSizeParam);
		}
		if (category == null || "".equals(category) || "전체".equals(category)) {
		    rDTO.setCategory(null);
		} else {
		    rDTO.setCategory(category);
		}
		
		if(keyword != null && !keyword.isEmpty()) {
		    rDTO.setKeyword(keyword);
		}
		if(delivery_status != null && !delivery_status.isEmpty()) {
		    rDTO.setDelivery_status(delivery_status);
		}
		
		rDTO.setStartDate(startDate);
		rDTO.setEndDate(endDate);
		rDTO.setCategory(category);
		
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
		
		String period = request.getParameter("period");
		if(period == null || period.equals("")){
		    period = "all";
		}
		
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
				<input type="hidden" id="period" name="period" value="<%= period %>">
				<div class="search-box">
					<div class="search-row">
						<label>조회기간</label>
						<button type="button" class="date-btn <%= "today".equals(period) ? "active" : "" %>" data-period="today" onclick="selectPeriod(this)">오늘</button>
						<button type="button" class="date-btn <%= "week".equals(period) ? "active" : "" %>" data-period="week" onclick="selectPeriod(this)">1주일</button>
						<button type="button" class="date-btn <%= "month".equals(period) ? "active" : "" %>" data-period="month" onclick="selectPeriod(this)">1개월</button>
						<button type="button" class="date-btn <%= "3month".equals(period) ? "active" : "" %>" data-period="3month" onclick="selectPeriod(this)">3개월</button>
						<button type="button" class="date-btn <%= ("all".equals(period)) ? "active" : "" %>" data-period="all" onclick="selectPeriod(this)">전체</button>
						<input type="date" id="startDate" name="startDate" value="<%= startDate == null ? "" : startDate %>"> ~ <input type="date" id="endDate" name="endDate" value="<%= endDate == null ? "" : endDate %>">
					</div>

					<div class="search-row">
						<label>처리상태</label><select id="orderStatus" name="orderStatus">
						    <option value="" <%= "".equals(delivery_status) ? "selected" : "" %>>전체</option>
						    <option value="paid" <%= "paid".equals(delivery_status) ? "selected" : "" %>>결제완료</option>
						    <option value="ready" <%= "ready".equals(delivery_status) ? "selected" : "" %>>배송대기</option>
						    <option value="delivery" <%= "delivery".equals(delivery_status) ? "selected" : "" %>>배송중</option>
						    <option value="complete" <%= "complete".equals(delivery_status) ? "selected" : "" %>>배송완료</option>
						    <option value="cancel" <%= "cancel".equals(delivery_status) ? "selected" : "" %>>취소요청</option>
						</select>
					</div>

					<div class="search-row">
						<label>상품구분</label><select id="category" name="category">
							<option value="">전체</option>
							<option  value="채소" <%= "채소".equals(category) ? "selected" : "" %>>채소</option>
							<option  value="과일" <%= "과일".equals(category) ? "selected" : "" %>>과일</option>
							<option  value="음료" <%= "음료".equals(category) ? "selected" : "" %>>음료</option>
						</select>
					</div>

					<div class="search-btn-area">
						<button type="button" id="searchBtn" onclick="searchOrder()">조회</button>
						<button type="button" id="resetBtn" onclick="resetSearch()">초기화</button>
					</div>

				</div>
				</form>

				<!-- 주문 목록 -->
				<table class="order-table">
					<thead>
						<tr>
							<th><input type="checkbox" id="allCheck" onchange="checkAll(this)"></th>
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
								<input type="checkbox" name="selectedOrder" value="${order.orderID}" onchange="checkOrder()">
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
							        <button type="button" class="cancel-btn" data-claim-id="${order.claimID}" onclick="openCancelDetail(this)">취소 요청</button>
							    </c:when>
							    <c:when test="${order.claimName eq '교환'}">
							        <button type="button" class="exchange-btn" data-claim-id="${order.claimID}" onclick="openExchangeDetail(this)">교환 요청</button>
							    </c:when>
							    <c:when test="${order.claimName eq '반품'}">
							        <button type="button" class="exchange-btn" data-claim-id="${order.claimID}" onclick="openExchangeDetail(this)">반품 요청</button>
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
					<button type="button" id="deliveryBtn" onclick="processDelivery()">배송처리</button>
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
				    <button type="button" class="btn btn-danger" id="cancelCompleteBtn" onclick="completeCancel()">취소 완료</button>
				    <button type="button" class="btn btn-secondary" id="cancelRejectBtn" onclick="rejectCancel()">취소 거절</button>
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
					            <th>주문 상세 번호</th>
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
						<button type="button" class="btn btn-primary" id="exchangeCompleteBtn" onclick="completeExchange()">교환/반품 완료</button>
						<button type="button" class="btn btn-secondary" id="exchangeRejectBtn" onclick="rejectExchange()">교환/반품 거절</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

</html>