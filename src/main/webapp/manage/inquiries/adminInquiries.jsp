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
	
});
</script>

</head>

<body>
	<div class="wrapper">

		<!-- 사이드바 -->
		<c:import url="../fragments/sidebar.jsp"></c:import>

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
						<button class="wait-btn">대기 2건</button>
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
						<div class="inquiry-item">
							<div class="item-top">
								<span class="category">배송문의</span> <span class="date">2024-05-21
									09:15</span>
							</div>
							<div class="title">배송된 날짜가 일부러 배송이 왔습니다.</div>
							<div class="item-bottom">
								<span class="user">김정수</span> <span class="status waiting">미처리</span>
							</div>
						</div>
						<div class="inquiry-item">
							<div class="item-top">
								<span class="category">배송문의</span> <span class="date">2024-05-21
									10:30</span>
							</div>
							<div class="title">다음 주문 건의 문의드립니다.</div>
							<div class="item-bottom">
								<span class="user">이현민</span> <span class="status waiting">미처리</span>
							</div>
						</div>
						<div class="inquiry-item">
							<div class="item-top">
								<span class="category">회원정보</span> <span class="date">2024-05-20
									14:22</span>
							</div>
							<div class="title">회원 등급 산정 기준이 궁금해요.</div>
							<div class="item-bottom">
								<span class="user">박성훈</span> <span class="status complete">완료</span>
							</div>
						</div>
					</div>
				</div>

				<!-- 오른쪽 상세 영역 -->
				<div class="inquiry-detail">

					<div id="emptyState" class="empty-state">
						<!-- <div class="empty-icon">📩</div>
						<h3>문의를 선택해주세요</h3>
						<p>왼쪽 목록에서 문의를 클릭하면 상세 내용이 표시됩니다.</p> -->
					</div>

					<!-- 문의 선택 시 보임 -->
					<div id="detailContent" style="display: none;">

						<!-- 고객 정보 -->
						<div class="customer-info">
							<img src="../images/profile.png" class="profile">
							<div>
								<div class="customer-name">김철수</div>
								<div class="customer-id">user_209384</div>
							</div>
						</div>

						<!-- 문의 내용 -->
						<div class="inquiry-content">
							<div class="content-header">
								<div>
									<div class="category">배송 / 파손</div>
									<h2>배송된 사과가 일부 파손되어 왔습니다.</h2>
								</div>
								<div class="date">2024-05-21 09:15</div>
							</div>
							<p class="question-text">어제 저녁에 주문한 사과 박스를 오늘 아침에 받았는데, 하단에
								있는 사과 3개가 심하게 눌려서 왔네요. 신선식품이라 교환이나 환불 처리가 어떻게 되는지 궁금합니다.</p>
							<div class="order-box" onclick="openOrderModal('ORD-9982')">주문번호 ORD-9982 ></div>
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
										<strong>상품명</strong> 사과 5kg
									</p>
									<p>
										<strong>수량</strong> 1개
									</p>
									<p>
										<strong>결제금액</strong> 35,000원
									</p>
									<p>
										<strong>주문일</strong> 2024-05-20
									</p>
									<p>
										<strong>배송상태</strong> 배송완료
									</p>
								</div>
							</div>
						</div>

						<!-- 답변 작성 -->
						<div class="reply-section">
							<h4>답변 작성하기</h4>
							<textarea placeholder="고객님께 전달할 답변을 입력해주세요..."></textarea>
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
	<script src="http://localhost/jsp_prj/manage/js/inquiries.js"></script>

</body>

</html>