<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="manage.client.ClientService" %>
<%@ page import="manage.client.ClientDTO" %>
<%@ include file="../login/loginCheck.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Users</title>
<link rel="shortcut icon" href="../images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/dashboard.css" rel="stylesheet">
<link href="../css/user.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script type="text/javascript">
$(function(){
    function searchUser(){
        let keyword = $("#searchInput").val().toLowerCase().trim();

        $(".user-row").each(function(){
            let name = $(this).data("name").toLowerCase();
            let email = $(this).data("email").toLowerCase();
            let phone = $(this).data("phone");
            if(name.includes(keyword) || email.includes(keyword) || phone.includes(keyword)){
                $(this).show();
            }else{
                $(this).hide();
            }
        });
    }//searchUser
    
    $("#searchBtn").click(function(){
        let keyword=$("#searchInput").val();
        location.href="adminUsers.jsp?currentPage=1&keyword="+encodeURIComponent(keyword);
    });

    $("#searchInput").keypress(function(e){
        if(e.key === "Enter"){
            let keyword=$("#searchInput").val();
            location.href="adminUsers.jsp?currentPage=1&keyword="+encodeURIComponent(keyword);
        }
    });

    $("#sortBtn").click(function(){
        $("#sortMenu").toggle();
    });//click

    $("#sortMenu li").click(function(){
        let type = $(this).data("sort");
        let rows = $(".user-row").get();

        rows.sort(function(a,b){
            let aName = $(a).data("name");
            let bName = $(b).data("name");
            let aDate = new Date($(a).data("date"));
            let bDate = new Date($(b).data("date"));

            switch(type){
                case "nameAsc": return aName.localeCompare(bName);
                case "nameDesc": return bName.localeCompare(aName);
                case "dateAsc": return aDate - bDate;
                case "dateDesc": return bDate - aDate;
            }
        });

        $(".user-table tbody").html(rows);
        $("#sortMenu").hide();
    });

    // 바깥 클릭 시 정렬 메뉴 닫기
    $(document).click(function(e){
        if(!$(e.target).closest(".sort-box").length){
            $("#sortMenu").hide();
        }
    });//click
});

$(function(){
	let selectedRow = null;
	$(document).on("click", ".user-row", function(){
	    let clientId = $(this).data("id");
	    if (selectedRow === this) {
	        $("#userDetail").hide();
	        $(this).removeClass("selected");
	        selectedRow = null;
	        return;
	    }
	    $(".user-row").removeClass("selected");
	    $(this).addClass("selected");
	    selectedRow = this;
	    $.ajax({
	        url: "clientDetail.jsp",
	        type: "get",
	        dataType: "json",
	        data: {
	            clientId: clientId
	        },
	        success: function(data){
	            $("#detailName").text(data.name);
	            $("#detailEmail").text(data.email);
	            $("#detailPhone").text(data.phone);
	            $("#detailDate").text(data.joinDate);
	            $("#detailPayment").text(data.totalPayment);
	            $("#resetPasswordBtn").data("id", clientId);
	            $("#userDetail").show();
	        },
	        error: function(){
	            alert("회원 상세 정보를 불러오는 중 오류가 발생했습니다.");
	        }
	    });
	});

	$("#resetPasswordBtn").click(function(){
	    let clientId = $(this).data("id");
	    if (!clientId) {
	        alert("회원을 먼저 선택해주세요.");
	        return;
	    }
	    $.ajax({
	        url: "resetPassword.jsp",
	        type: "get",
	        dataType: "json",
	        data: {
	            clientId: clientId
	        },
	        success: function(data){
	            $("#newPassword").text(data.newPw);
	            new bootstrap.Modal(
	                document.getElementById("resetPasswordModal")
	            ).show();
	        },
	        error: function(){
	            alert("비밀번호 초기화 처리 중 오류가 발생했습니다.");
	        }
	    });
	});

	$("#resetConfirmBtn").click(function(){
	    alert("비밀번호가 초기화되었습니다.");
	    bootstrap.Modal.getInstance(
	        document.getElementById("resetPasswordModal")
	    ).hide();
	});
});
</script>
</head>

<body>
	<div class="wrapper">

		<!-- 사이드바 -->
		<c:import url="../fragments/sidebar.jsp"></c:import>

		<jsp:useBean id="rDTO" class="manage.client.RangeDTO" scope="page"/>
		<jsp:setProperty name="rDTO" property="*"/>
		<%
		ClientService cs = new ClientService();
		
		String keyword = request.getParameter("keyword");
		if (keyword != null) {
			rDTO.setKeyword(keyword.trim());
		}
		
		String tempPage = request.getParameter("currentPage");
		int currentPage = 1;
		
		if (tempPage != null && !tempPage.trim().isEmpty()) {
			try {
				currentPage = Integer.parseInt(tempPage);
			} catch (NumberFormatException nfe) {
				currentPage = 1;
			}
		}
		
		int pageScale = 10;
		int totalCnt = cs.getTotalCount();
		int pageCnt = (int)Math.ceil((double)totalCnt / pageScale);
		
		if (currentPage < 1) {
			currentPage = 1;
		}
		
		if (pageCnt > 0 && currentPage > pageCnt) {
			currentPage = pageCnt;
		}
		
		int startNum = (currentPage - 1) * pageScale + 1;
		int endNum = currentPage * pageScale;
		
		rDTO.setStartNum(startNum);
		rDTO.setEndNum(endNum);
		rDTO.setTotalCnt(totalCnt);
		rDTO.setPageCnt(pageCnt);
		
		List<ClientDTO> clientList = cs.getClientList(rDTO);
		
		pageContext.setAttribute("clientList", clientList);
		pageContext.setAttribute("currentPage", currentPage);
		pageContext.setAttribute("rDTO", rDTO);
		pageContext.setAttribute("newCount", cs.getNewCount());
		%>

		<!-- 메인 -->
		<div class="main">

			<!-- 헤더 -->
			<div class="top-header">
				<div>
					<h3>Users</h3>
				</div>
			</div>

			<!-- 내용 -->
			<div class="users-page">

				<!-- 상단 통계 -->
				<div class="user-summary">
					<div class="summary-card">
						<div class="summary-icon">👥</div>
						<div>
							<div class="summary-title">전체 사용자</div>
							<div class="summary-count">${ rDTO.totalCnt }명</div>
						</div>
					</div>

					<div class="summary-card">
						<div class="summary-icon">📝</div>
						<div>
							<div class="summary-title">신규 가입</div>
							<div class="summary-count">+${ newCount }명</div>
						</div>
					</div>
				</div>

				<!-- 목록 + 상세 -->
				<div class="user-content">
					<!-- 왼쪽 -->
					<div class="user-list-box">
						<div class="search-area">
							<input type="text" id="searchInput" value="${param.keyword}" placeholder="이름, 이메일, 전화번호 검색">
							<button type="button" id="searchBtn">검색</button>
							<div class="sort-box">
								<button type="button" id="sortBtn">정렬 ⇔</button>
								<ul id="sortMenu" class="sort-menu">
									<li data-sort="nameAsc">이름 오름차순</li>
									<li data-sort="nameDesc">이름 내림차순</li>
									<li data-sort="dateAsc">가입일 오름차순</li>
									<li data-sort="dateDesc">가입일 내림차순</li>
								</ul>
							</div>
						</div>

						<table class="user-table">
							<thead>
								<tr>
									<th>사용자</th>
									<th>이메일</th>
									<th>전화번호</th>
									<th>가입일</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${ empty clientList }">
								<tr>
								<td colspan="4">사용자가 존재하지 않습니다.</td>
								</tr>
								</c:if>
								<c:forEach var="client" items="${ clientList }">
								<tr class="user-row" data-id="${ client.clientNo }" 
									data-name="${ client.clientName }" data-email="${ client.email }" 
									data-phone="${ client.phone }" data-date="${ client.joinDate }">
									<td>${ client.clientName }</td>
									<td>${ client.email }</td>
									<td>${ client.phone }</td>
									<td>${ client.joinDate }</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
						<div id="divPagination-wrap" style="text-align:center">
						<c:if test="${rDTO.pageCnt > 0}">
						    <c:forEach var="i" begin="1" end="${rDTO.pageCnt}">
						        <c:choose>
						            <c:when test="${i == currentPage}">
						                <b>[${i}]</b>
						            </c:when>
						            <c:otherwise>
						                <a href="adminUsers.jsp?currentPage=${i}&keyword=${param.keyword}">
						                    [${i}]
						                </a>
						            </c:otherwise>
						        </c:choose>
						    </c:forEach>
						</c:if>
						</div>
					</div>

					<!-- 오른쪽 -->
					<div class="user-detail" id="userDetail" style="display: none;">
						<div class="profile-image">👤</div>
						<h4 id="detailName"></h4>
						<p id="detailEmail"></p>
						<hr>
						<p>	📞 <span id="detailPhone"></span></p>
						<p> 📅 <span id="detailDate"></span></p>
						<p> 💰 <span id="detailPayment"></span></p>
						<button class="delete-btn" id="resetPasswordBtn">비밀번호 초기화</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="resetPasswordModal" tabindex="-1">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">비밀번호 초기화</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal">
					</button>
				</div>
				<div class="modal-body">새 비밀번호<br><span id="newPassword"></span></div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="resetConfirmBtn">확인</button>
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
	<script src="../js/bootstrap.bundle.min.js"></script>
</body>

</html>