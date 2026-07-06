<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="manage.category.CategoryService"%>
<%@page import="manage.category.CategoryDTO"%>
<%@ include file="../login/loginCheck.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Categories</title>
<link rel="shortcut icon" href="http://localhost/jsp_prj/manage/images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/dashboard.css" rel="stylesheet">
<link href="../css/categories.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
$(function() {
	// 수정 버튼
	$(".edit-btn").click(function() {
		$("#editCategoryNo").val($(this).data("no"));
		$("#editCategoryName").val($(this).data("name"));
		$("#editCategoryModal").css("display", "flex");
	});

	// 수정 모달 닫기
	$("#editCloseBtn,#editCancelBtn").click(function() {
		$("#editCategoryModal").hide();
	});

	// 추가 모달 열기
	$("#addCategoryBtn").click(function() {
		$("#categoryModal").css("display", "flex");
		$("#categoryName").val("");
		$("#categoryName").focus();
	});

	// 추가 모달 닫기
	$("#closeModal,#cancelBtn").click(function() {
		$("#categoryModal").hide();
	});

	// 바깥 클릭
	$(window).click(function(e) {
		if (e.target == $("#categoryModal")[0]) {
			$("#categoryModal").hide();
		}
		if (e.target == $("#editCategoryModal")[0]) {
			$("#editCategoryModal").hide();
		}
	});

	// 추가 저장
	$("#saveBtn").click(function() {
		if($("#categoryName").val().trim() == "") {
	        alert("카테고리명을 입력해주세요.");
	        $("#categoryName").focus();
	        return;
	    }
		$.ajax({
			url : "addCategory.jsp",
			type : "POST",
			data : {
				categoryName : $("#categoryName").val()
			},
			success : function() {
				location.reload();
			}
		});
	});

	// 수정 저장
	$("#editSaveBtn").click(function() {
		if ($("#editCategoryName").val().trim() == "") {
	        alert("카테고리명을 입력해주세요.");
	        $("#editCategoryName").focus();
	        return;
	    }
		$.ajax({
	        url : "modifyCategory.jsp",
	        type : "POST",
	        data : {
	            categoryId : $("#editCategoryNo").val(),
	            categoryName : $("#editCategoryName").val(),
	        },
	        success : function() {
	            location.reload();
	        }
	    });
	});
	
	// 삭제
	$("#deleteCategoryBtn").click(function() {
		let categoryId = $("#editCategoryNo").val();
		let categoryName = $("#editCategoryName").val();
	
		if (!confirm("'" + categoryName + "' 카테고리를 삭제하시겠습니까?")) {
			return;
		}

		$.ajax({
			url: "removeCategory.jsp",
			type: "POST",
			data: {
				categoryId: categoryId
			},
			success: function(result) {
				if ($.trim(result) === "1") {
					alert("카테고리가 삭제되었습니다.");
					location.reload();
				} else {
					alert("카테고리 삭제에 실패했습니다.");
				}
			},
			error: function() {
				alert("삭제 중 오류가 발생했습니다.");
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
		CategoryService cs = new CategoryService();
		List<CategoryDTO> categoryList=cs.showCategroy();
		pageContext.setAttribute("categoryList", categoryList);
		%>

		<!-- 메인 -->
		<div class="main">
			<div class="top-header">
				<div>
					<h3>Categories</h3>
				</div>
			</div>
			<div class="product-wrap">
				<div class="category-header">
					<h4>카테고리</h4>
					<span class="category-count">총 ${categoryList.size()}개</span>
				</div>
				<div class="category-list">
					<c:forEach var="category" items="${categoryList}">
						<div class="category-card">
							<div class="category-left">
								<span>&gt;</span>
								<div class="category-info">
									<span class="category-name">${category.categoryName}</span>
									<button class="edit-btn" data-no="${category.categoryID}"
										data-name="${category.categoryName}">✎</button>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
				<button class="add-category-btn" id="addCategoryBtn">＋ 카테고리 추가하기</button>
			</div>
		</div>
	</div>

	<!-- 카테고리 수정 모달 -->
	<div id="editCategoryModal" class="modal">
		<div class="modal-content">
		<form action="adminCategories.jsp" method="post" id="editCategoryForm">
			<input type="hidden" name="mode" value="modify">
			<div class="modal-header">
				<h3>카테고리 수정</h3>
				<span id="editCloseBtn" class="close">&times;</span>
			</div>
			<div class="modal-body">
				<input type="hidden" id="editCategoryNo" name="categoryId">
				<label>카테고리명</label>
				<input type="text" id="editCategoryName" name="categoryName">
			</div>
			<div class="modal-footer">
				<button type="button" class="delete-btn" id="deleteCategoryBtn">삭제</button>
				<button type="button" class="cancel-btn" id="editCancelBtn">취소</button>
				<button type="button" class="save-btn" id="editSaveBtn">저장</button>
			</div>
		</form>
		</div>
	</div>

	<!-- 카테고리 추가 모달 -->
	<div id="categoryModal" class="modal">
		<div class="modal-content">
		<form action="adminCategories.jsp" method="post" id="addCategoryForm">
			<input type="hidden" name="mode" value="add">
			<div class="modal-header">
				<h3>새 카테고리 추가</h3>
				<span id="closeModal" class="close">&times;</span>
			</div>
			<div class="modal-body">
				<label>카테고리명</label>
				<input type="text" id="categoryName" name="categoryName" placeholder="카테고리명을 입력하세요">
			</div>
			<div class="modal-footer">
				<button type="button" class="cancel-btn" id="cancelBtn">취소</button>
				<button type="button" class="save-btn" id="saveBtn">저장</button>
			</div>
		</form>
		</div>
	</div>
</body>

</html>