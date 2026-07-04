<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*"%>
<%@ page import="manage.admin.AdminService" %>
<%@ page import="manage.admin.AdminDTO" %>
<%@ include file="../login/loginCheck.jsp" %>
<%
Boolean result = (Boolean)request.getAttribute("result");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Settings</title>
<link rel="shortcut icon" href="http://localhost/jsp_prj/manage/images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/dashboard.css" rel="stylesheet">
<link href="../css/settings.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
function openPwModal() {
	document.getElementById("pwModal").style.display = "flex";
}

function closePwModal() {
	document.getElementById("pwModal").style.display = "none";
	document.getElementById("pw").value = "";
	document.getElementById("newPw").value = "";
	document.getElementById("checkPw").value = "";
	document.getElementById("pwMsg").innerHTML = "";
}

function changePw() {
	let newPw = document.getElementById("newPw").value;
	let checkPw = document.getElementById("checkPw").value;

	if (pw === "" || newPw === "" || checkPw === "") { 
		pwMsg.innerHTML = "모든 비밀번호를 입력해주세요.";
		return;
	}
	
	if (newPw !== checkPw) {
		document.getElementById("pwMsg").innerHTML = "새 비밀번호가 일치하지 않습니다.";
		return;
	}
	document.getElementById("pwForm").submit();
}

function successConfirm() {
	document.getElementById("successModal").style.display = "none";
}

</script>

</head>
<body>
	<div class="wrapper">

		<!-- 사이드바 -->
		<c:import url="../fragments/sidebar.jsp"></c:import>
		
		<%
		AdminService as = new AdminService();
		
		String adminID = (String) session.getAttribute("adminId");
		AdminDTO adminInfo = as.getAdminInfo(adminId);
		
		pageContext.setAttribute("adminInfo", adminInfo);
		%>

		<!-- 메인 -->
		<div class="main">
			<!-- 헤더 -->
			<div class="top-header">
				<div>
					<h3>Settings</h3>
				</div>
			</div>

			<!-- 개인정보 -->
			<div class="info">
				<h3>관리자 설정</h3>
				<div class="personalInfo">
					<h4>계정정보</h4>
					<table class="info-table">
						<tr>
							<th>이름</th>
							<td><c:out value="${ adminInfo.adminName }"/></td>
						</tr>
						<tr>
							<th>아이디</th>
							<td><c:out value="${ adminInfo.adminID }"/></td>
						</tr>
						<tr>
							<th>연락처</th>
							<td><c:out value="${ adminInfo.tel }"/></td>
						</tr>
						<tr>
							<th>이메일</th>
							<td><c:out value="${ adminInfo.adminEmail }"/></td>
						</tr>
					</table>
					<button class="password-btn" onclick="openPwModal()">비밀번호 변경</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 비밀번호 변경 -->
	<div class="pw-modal" id="pwModal">
		<div class="pw-box">
			<h4>비밀번호 변경</h4>
			<form action="changePw.jsp" method="post" id="pwForm">
				<label>현재 비밀번호</label> <input type="password" name="pw" id="pw">
				<label>새 비밀번호</label> <input type="password" name="newPw" id="newPw">
				<label>새 비밀번호 확인</label> <input type="password" id="checkPw">
				<p id="pwMsg"></p>
				<button type="button" onclick="changePw()">확인</button>
				<button type="button" onclick="closePwModal()">취소</button>
			</form>
		</div>
	</div>

	<!-- 성공 팝업 -->
	<div class="success-modal" id="successModal">
		<div class="success-box">
			<h4>알림</h4>
			<p>비밀번호 변경 성공</p>
			<button onclick="successConfirm()">확인</button>
		</div>
	</div>
	<%
	if (result != null) {
		if (result) {
			%>
			<script>
			document.getElementById("successModal").style.display = "flex";
			</script>
		<%
		} else {
			%>
			<script>
			document.getElementById("pwModal").style.display = "flex";
	    	document.getElementById("pwMsg").innerHTML = "현재 비밀번호가 일치하지 않습니다.";
			</script>
		<%
		}
	}
	%>
</body>
</html>
