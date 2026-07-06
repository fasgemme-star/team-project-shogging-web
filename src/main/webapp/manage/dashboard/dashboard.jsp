<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="manage.dashboard.DashBoardService"%>
<%@ include file="../login/loginCheck.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<link rel="shortcut icon" href="http://localhost/jsp_prj/manage/images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/dashboard.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<%
DashBoardService dbs = new DashBoardService();

request.setAttribute("totalSales", dbs.getTotalSales());
request.setAttribute("newClientCount", dbs.getNewClientCount());
request.setAttribute("nowItemCount", dbs.getNowItemCount());
request.setAttribute("nonResponseCount", dbs.getNonResponseInquiryCount());

request.setAttribute("newClientStatistics", dbs.getNewClientStatistics());
request.setAttribute("dropOutClientStatistics", dbs.getDropOutClientStatistics());

request.setAttribute("bestProductList", dbs.getBestProductList());
%>

<!-- 그래프에 사용할 배열 -->
<script>
const newClientData = [
	<%
	int[] newClient = (int[]) request.getAttribute("newClientStatistics");

	if (newClient != null) {
		for (int i = 0; i < newClient.length; i++) {
			out.print(newClient[i]);
			if (i != newClient.length - 1) {
				out.print(",");
			}//end if
		}//end for
	}//end if 
	%>
];

const dropOutData = [
	<%
	int[] dropOut = (int[]) request.getAttribute("dropOutClientStatistics");

	if (dropOut != null) {
		for (int i = 0; i < dropOut.length; i++) {
			out.print(dropOut[i]);
			if (i != dropOut.length - 1) {
				out.print(",");
			}//end if
		}//end for
	}//end if
	%>
];
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
					<h3>Dashboard</h3>
				</div>
			</div>

			<!-- 카드 -->
			<div class="card-area">
				<div class="info-card">
					<div class="title">연 총 매출</div>
					<div class="value">
						₩ <fmt:formatNumber value="${ totalSales }" pattern="#,###,###"/>
					</div>
				</div>
				<div class="info-card">
					<div class="title">주간 신규 회원 수</div>
					<div class="value">
						<c:out value="${ newClientCount }"/>건
					</div>
				</div>
				<div class="info-card">
					<div class="title">현재 판매 중인 상품</div>
					<div class="value">
						<c:out value="${ nowItemCount }"/>개
					</div>
				</div>
				<div class="info-card">
					<div class="title">미답변 문의</div>
					<div class="value">
						<c:out value="${ nonResponseCount }"/>건
					</div>
				</div>
			</div>

			<!-- 그래프 -->
			<div class="graph-card">
				<h5>회원 등록 수 / 탈퇴 회원 수</h5>
				<canvas id="myChart"></canvas>
			</div>

			<!-- Top5 -->
			<div class="top5-card">
				<h5>베스트 물품 Top5</h5>
				<%
				Map<String, Integer> bestProductList = (Map<String, Integer>) request.getAttribute("bestProductList");
				
				if (bestProductList != null && !bestProductList.isEmpty()) {
				int rank = 1;
				
				for (Map.Entry<String, Integer> entry : bestProductList.entrySet()) {
				%>
				<div class="top-product">
				<div>
				<%= rank %>. <%= entry.getKey() %>
				</div>
				<div>
				<strong><%= entry.getValue() %>건 </strong>
				</div>
				</div>
				<%
				rank++;
				}
				}
				%>
			</div>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="../js/dashboard.js"></script>
</body>
</html>
