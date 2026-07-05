<%@page import="manage.inquiry.InquiryDTO"%>
<%@page import="manage.inquiry.RangeDTO"%>
<%@page import="manage.inquiry.InquiryService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../login/loginCheck.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Inquiries</title>
<link rel="shortcut icon" href="../images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/dashboard.css" rel="stylesheet">
<link href="../css/inquiries.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script type="text/javascript">
$(function(){
    const emptyState = document.getElementById("emptyState");
    const detailContent = document.getElementById("detailContent");
    let selectedItem = null;
    
    const searchInput = document.querySelector(".search-box input");
    const filterButtons = document.querySelectorAll(".filter-tabs button");

    let currentStatus = "all";

    function filterInquiryList() {
        const keyword = searchInput.value.trim().toLowerCase();
        document.querySelectorAll(".inquiry-item").forEach(function(item) {
            const clientName = (item.dataset.clientName || "").toLowerCase();
            const title = (item.dataset.title || "").toLowerCase();
            const status = item.dataset.status || "";
            const isKeywordMatched = clientName.includes(keyword) || title.includes(keyword);
            let isStatusMatched = true;

            if (currentStatus === "waiting") {
                isStatusMatched = (status === "대기중");
            } else if (currentStatus === "complete") {
                isStatusMatched = (status === "답변완료");
            }

            if (isKeywordMatched && isStatusMatched) {
                item.style.display = "block";
            } else {
                item.style.display = "none";
            }
        });
    }

    searchInput.addEventListener("input", function() {
        filterInquiryList();
    });

    filterButtons.forEach(function(button) {
        button.addEventListener("click", function() {
            filterButtons.forEach(function(btn) {
                btn.classList.remove("active");
            });
            this.classList.add("active");
            if (this.textContent.trim() === "전체") {
                currentStatus = "all";
            } else if (this.textContent.trim() === "미처리") {
                currentStatus = "waiting";
            } else if (this.textContent.trim() === "완료") {
                currentStatus = "complete";
            }
            filterInquiryList();
        });
    });

    document.querySelectorAll(".inquiry-item").forEach(function(item) {
    	item.addEventListener("click", function() {
    	    if (selectedItem === this) {
    	        detailContent.style.display = "none";
    	        emptyState.style.display = "flex";
    	        this.classList.remove("selected");
    	        selectedItem = null;
    	        return;
    	    }
    	    
    	    document.querySelectorAll(".inquiry-item").forEach(function(i) {
    	        i.classList.remove("selected");
    	    });

    	    this.classList.add("selected");
    	    selectedItem = this;

    	    emptyState.style.display = "none";
    	    detailContent.style.display = "block";

    	    document.getElementById("customerName").textContent = this.dataset.clientName;
    	    document.getElementById("customerId").textContent = this.dataset.clientNo;
    	    document.getElementById("inquiryType").textContent = this.dataset.inquiryType;
    	    document.getElementById("inquiryTitle").textContent = this.dataset.title;
    	    document.getElementById("inquiryDate").textContent = this.dataset.inquiryDate;
    	    document.getElementById("questionText").textContent = this.dataset.content;

    	    const orderDetailsId = this.dataset.orderDetailsId;
    	    const orderBox = document.getElementById("orderBox");

    	    if (orderDetailsId) {
    	        orderBox.textContent = "주문번호 " + orderDetailsId + " >";
    	        orderBox.onclick = function() {
    	            openOrderModal(orderDetailsId);
    	        };
    	    } else {
    	        orderBox.textContent = "연결된 주문 정보가 없습니다.";
    	        orderBox.onclick = null;
    	    }

    	    document.getElementById("answerText").value = this.dataset.answer || "";
    	});
    });

    window.openOrderModal = function(orderDetailsId) {
        $.ajax({
            url: "orderDetails.jsp",
            type: "get",
            dataType: "json",
            data: {
                orderDetailsId: orderDetailsId
            },
            success: function(order) {
                document.getElementById("modalOrderNo").textContent = order.orderId || "-";
                document.getElementById("modalPrdName").textContent = order.prdName || "-";
                document.getElementById("modalQuantity").textContent =
                    (order.quantity || 0) + "개";
                document.getElementById("modalTotalAmount").textContent =
                    Number(order.totalAmount || 0).toLocaleString("ko-KR") + "원";
                document.getElementById("modalOrderDate").textContent =
                    order.orderDate || "-";
                document.getElementById("modalDeliveryStatus").textContent =
                    order.deliveryStatus || "-";

                document.getElementById("orderModal").style.display = "block";
            },
            error: function() {
                alert("주문 상세 정보를 불러오지 못했습니다.");
            }
        });
    };

    window.closeOrderModal = function() {
        document.getElementById("orderModal").style.display = "none";
    };
    
    document.querySelector(".reply-btn").addEventListener("click", function() {
    	if (selectedItem === null) {
    		alert("답변할 문의를 선택해주세요.");
    		return;
    	}
    	const inquiryID = selectedItem.dataset.inquiryId;
    	const answer = document.getElementById("answerText").value.trim();

    	if (!answer) {
    	    alert("답변 내용을 입력해주세요.");
    	    return;
    	}

    	$.ajax({
    	    url: "answerInquiry.jsp",
    	    type: "post",
    	    dataType: "json",
    	    data: {
    	        inquiryID: inquiryID,
    	        answer: answer
    	    },
    	    success: function(data) {
    	        if (data.result > 0) {
    	            alert("답변이 등록되었습니다.");

    	            selectedItem.dataset.answer = answer;
    	            selectedItem.dataset.status = "답변완료";

    	            const statusElement = selectedItem.querySelector(".status");
    	            statusElement.textContent = "완료";
    	            statusElement.classList.remove("waiting");
    	            statusElement.classList.add("complete");

    	            location.reload();
    	        } else {
    	            alert("답변 등록에 실패했습니다.");
    	        }
    	    },
    	    error: function() {
    	        alert("답변 등록 중 오류가 발생했습니다.");
    	    }
    	});
    });

    document.querySelector(".delete-btn").addEventListener("click", function() {
    	if (selectedItem === null) {
    		alert("삭제할 문의를 선택해주세요.");
    		return;
    	}
    	const inquiryID = selectedItem.dataset.inquiryId;

    	if (!confirm("선택한 문의를 삭제하시겠습니까?")) {
    	    return;
    	}

    	$.ajax({
    	    url: "deleteInquiry.jsp",
    	    type: "post",
    	    dataType: "json",
    	    data: {
    	        inquiryID: inquiryID
    	    },
    	    success: function(data) {
    	        if (data.result > 0) {
    	            alert("문의가 삭제되었습니다.");
    	            selectedItem.remove();
    	            detailContent.style.display = "none";
    	            emptyState.style.display = "flex";
    	            selectedItem = null;
    	        } else {
    	            alert("문의 삭제에 실패했습니다.");
    	        }
    	    },
    	    error: function() {
    	        alert("문의 삭제 중 오류가 발생했습니다.");
    	    }
    	});
    });

    window.onclick = function(event) {
        const modal = document.getElementById("orderModal");
        if (event.target === modal) {
            modal.style.display = "none";
        }
    };
});
</script>

</head>

<body>
	<div class="wrapper">

		<!-- 사이드바 -->
		<c:import url="../fragments/sidebar.jsp"></c:import>

		<%
		InquiryService inquiryService = new InquiryService();

		RangeDTO rDTO = new RangeDTO();
		rDTO.startNum = 1;
		rDTO.endNum = 20;
		rDTO.status = 0;

		List<InquiryDTO> inquiryList = inquiryService.getInquiryList(rDTO);
		int waitingCount = 0;

		for (InquiryDTO inquiry : inquiryList) {
		    if ("대기중".equals(inquiry.getStatus())) {
		        waitingCount++;
		    }
		}

		request.setAttribute("inquiryList", inquiryList);
		request.setAttribute("waitingCount", waitingCount);
		%>

		<!-- 메인 -->
		<div class="main">

			<!-- 헤더 -->
			<div class="top-header">
				<div>
					<h3>Inquires</h3>
				</div>
			</div>

			<!-- 내용 -->
			<div class="inquiry-wrap">

				<!-- 왼쪽 문의 목록 -->
				<div class="inquiry-list">
					<div class="list-header">
						<h4>문의 관리</h4>
						<button class="wait-btn">대기 ${waitingCount}건</button>
					</div>
					<div class="search-box">
						<input type="text" placeholder="고객명, 제목 검색...">
					</div>
					<div class="filter-tabs">
						<button class="active">전체</button>
						<button>미처리</button>
						<button>완료</button>
					</div>
					<div class="inquiry-items">
						<c:choose>
						<c:when test="${empty inquiryList}">
						<div class="no-inquiry">조회된 문의가 없습니다.</div>
						</c:when>
					    <c:otherwise>
					        <c:forEach var="inquiry" items="${inquiryList}">
					        <div class="inquiry-item"
							    data-inquiry-id="${inquiry.inquiryID}"
							    data-client-no="${inquiry.clientNo}"
							    data-client-name="${inquiry.clientName}"
							    data-title="${inquiry.title}"
							    data-content="${inquiry.content}"
							    data-inquiry-date="${inquiry.inquiryDate}"
							    data-status="${inquiry.status}"
							    data-answer="${inquiry.answer}"
							    data-answer-date="${inquiry.answerDate}"
							    data-inquiry-type="${inquiry.inquiryType}"
							    data-order-details-id="${inquiry.orderID}">
					                <div class="item-top">
					                    <span class="category">${inquiry.inquiryType}</span>
					                    <span class="date">${inquiry.inquiryDate}</span>
					                </div>
					                <div class="title">${inquiry.title}</div>
					                <div class="item-bottom">
					                    <span class="user">${inquiry.clientName}</span>
					                    <c:choose>
					                        <c:when test="${inquiry.status eq '대기중'}">
					                            <span class="status waiting">미처리</span>
					                        </c:when>
					                        <c:otherwise>
					                            <span class="status complete">완료</span>
					                        </c:otherwise>
					                    </c:choose>
					                </div>
					            </div>
					        </c:forEach>
					    </c:otherwise>
					</c:choose>
					</div>
				</div>

				<!-- 오른쪽 상세 영역 -->
				<div class="inquiry-detail">

					<div id="emptyState" class="empty-state"></div>

					<!-- 문의 선택 시 보임 -->
					<div id="detailContent" style="display: none;">

						<!-- 고객 정보 -->
						<div class="customer-info">
							<img src="../images/profile.png" class="profile">
						<div>
							<div id="customerName" class="customer-name"></div>
							<div id="customerId" class="customer-id"></div>
						</div>
						</div>
						
						<!-- 문의 내용 -->
						<div class="inquiry-content">
						<div class="content-header">
							<div>
								<div id="inquiryType" class="category"></div>
								<h2 id="inquiryTitle"></h2>
							</div>
							<div id="inquiryDate" class="date"></div>
						</div>
						<p id="questionText" class="question-text"></p>
						<div id="orderBox" class="order-box"></div>
						</div>
						
						<!-- 주문 상세 팝업 -->
						<div id="orderModal" class="modal">
							<div class="modal-content">
								<span class="close" onclick="closeOrderModal()">&times;</span>
								<h2>주문 상세 정보</h2>
								<div class="order-info">
									<p>
										<strong>주문번호</strong> <span id="modalOrderNo"></span>
									</p>
									<p>
										<strong>상품명</strong>
										<span id="modalPrdName"></span>
									</p>
									<p>
										<strong>수량</strong>
										<span id="modalQuantity"></span>
									</p>
									<p>
										<strong>결제금액</strong>
										<span id="modalTotalAmount"></span>
									</p>
									<p>
										<strong>주문일</strong>
										<span id="modalOrderDate"></span>
									</p>
									<p>
										<strong>배송상태</strong>
										<span id="modalDeliveryStatus"></span>
									</p>
								</div>
							</div>
						</div>

						<!-- 답변 작성 -->
						<div class="reply-section">
							<h4>답변 작성하기</h4>
							<textarea id="answerText" placeholder="고객님께 전달할 답변을 입력해주세요..."></textarea>
							<div class="reply-actions">
								<button class="delete-btn">삭제</button>
								<button class="reply-btn">답변 전송</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

</html>