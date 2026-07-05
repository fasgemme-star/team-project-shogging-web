<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>관리자 로그인</title>
<link rel="shortcut icon" href="http://localhost/jsp_prj/manage/images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/sign-in.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
$(function(){
	$("#id").keyup(function(evt){
		if(evt.which == 13){
			chkNull();
		}//end if
	});//keyup
	$("#password").keyup(function(evt){
		if(evt.which == 13){
			chkNull();
		}//end if
	});//keyup
	$("#btnSubmit").click(function(){
		chkNull();
	});//click
});

function chkNull(){
	//아이디가 입력 되었는지?
	var id=$("#id").val();
	if(id.replace(/ /g,"")==""){
		$("#id").focus();
		return;
	}//end if
	
	$("#password").focus();
	//비번 입력되었는지?
	var pass=$("#password").val();
	if(pass.replace(/ /g,"")==""){
		$("#password").focus();
		return;
	}//end if
	
	//아이디와 비번이 모두 입력되었다면 로그인 처리 페이지로 이동.
	$("#loginForm")[0].submit();
}//chkNull
</script>

</head>

<body class="d-flex justify-content-center align-items-center vh-100">
	<main class="form-signin w-100 m-auto">
		<form action="loginProcess.jsp" method="post" name="loginForm" id="loginForm" onsubmit="return false;">
			<img class="mb-4" src="../images/logo.png" width="159" height="40">
			<h1 class="h3 mb-3 fw-normal" style="text-align: center; font-size: 25px; font-weight: bold;">로그인</h1>
			<div class="form-floating">
				<input type="text" class="form-control" id="id" name="id"
					placeholder="아이디를 입력하세요"> <label for="id">
					아이디를 입력해주세요</label>
			</div>
			<div class="form-floating">
				<input type="password" class="form-control" id="password" name="password"
					placeholder="비밀번호를 입력하세요"> <label for="password">비밀번호를 입력해주세요</label>
			</div>
			
			<!-- 아이디나 비밀번호 확인, 틀렸다면 if 안으로 -->
			<c:if test="${ param.flag == 'N' }">
			<div class="form-floating">
			<span style="color:#FF0000" id="warning">아이디나 비밀번호를 확인해주세요</span>
			<script type="text/javascript">
				for(var i=0; i<5; i++){
					$("#warning").fadeOut(500).fadeIn(500);				
				}//end for
				$("#warning").fadeOut(1500);
			</script>
			</div>
			</c:if>
			
			<button class="btn w-100 py-2" style="background-color: #7CB342" id="btnSubmit">로그인</button>
		</form>
	</main>
	<script src="../js/bootstrap.bundle.min.js"></script>
</body>
</html>