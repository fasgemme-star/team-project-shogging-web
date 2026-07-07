<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="manage.addproduct.AddProductService" %>
<%@ page import="manage.addproduct.ImageDTO" %>
<%@ include file="../login/loginCheck.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Product</title>
<link rel="shortcut icon" href="../images/favicon.png"/>
<link href="../css/bootstrap.min.css" rel="stylesheet">
<link href="../css/dashboard.css" rel="stylesheet">
<link href="../css/addProduct.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
let selectedInput = "";
let selectedPreview = "";
let selectedCard = null;

$(function(){
    $(".accordion-header").click(function(){
        let content=$(this).next(".accordion-content");
        let arrow=$(this).find(".arrow");
        
        if(content.hasClass("show")){
            content.removeClass("show");
            arrow.html("&#9662;");
        }else{
            content.addClass("show");
            arrow.html("&#9652;");
        }
    });

    $("#productName").on("input",function(){
        $("#nameCount").text($(this).val().length);
    });
    
    $("#productDesc").on("input",function(){
        $("#descCount").text($(this).val().length);
    });

    $(".image-btn").click(function(){
        selectedInput=$(this).data("target");
        selectedPreview=$(this).data("preview");
        selectedCard=null;

        $(".image-card").removeClass("selected");
        $("#imageModal").css("display","flex");
    });

    $("#closeImageModal,#cancelImageBtn").click(function(){
        $("#imageModal").hide();
    });

    $(document).on("click",".image-card",function(){
        $(".image-card").removeClass("selected");
        $(this).addClass("selected");
        selectedCard=$(this);
    });

    $("#selectImageBtn").click(function(){
        if(selectedCard==null){
            alert("이미지를 선택하세요.");
            return;
        }
        let url=selectedCard.data("url");

        $("#"+selectedInput).val(url);
        $("#"+selectedPreview).attr("src",url);
        $("#imageModal").hide();
    });
});

</script>

</head>

<body>
	<div class="wrapper">

		<!-- 사이드바 -->
		<c:import url="../fragments/sidebar.jsp"></c:import>

		<!-- 메인 -->
		<div class="main">
			<div class="top-header">
				<div>
					<h3>AddProduct</h3>
				</div>
			</div>
			
			<div class="product-wrap">
			<form action="addProductProcess.jsp" method="post" id="addProductForm">
				<div class="accordion">

					<!-- 기본정보 -->
					<div class="accordion-item">
						<div class="accordion-header">
							<span>기본정보 <span class="required">*</span></span> <span class="arrow">&#9662;</span>
						</div>

						<div class="accordion-content">
							<div class="input-group">
								<label for="category">카테고리 <span class="required">*</span></label> <select id="category"
									name="category">
									<option value="">카테고리를 선택하세요.</option>
									<option value="CAT000001">과일</option>
									<option value="CAT000002">채소</option>
								</select> 
							</div>
						</div>
					</div>

					<!-- 상품명 -->
					<div class="accordion-item">
						<div class="accordion-header">
							<span>상품명 <span class="required">*</span></span> <span
								class="arrow">&#9662;</span>
						</div>
						<div class="accordion-content">
							<!-- 상품명 -->
							<div class="input-row">
								<label for="productName">상품명 <span class="required">*</span></label>
								<div class="input-box">
									<input type="text" id="productName" name="prdName"
										maxlength="50" placeholder="상품명을 입력하세요."> <span
										class="count"> <span id="nameCount">0</span>/50자
									</span>
								</div>
							</div>
							<!-- 상품설명 -->
							<div class="input-row">
								<label for="productDesc">상품설명</label>
								<div class="input-box">
									<textarea id="productDesc" name="prdDescription" maxlength="150"
										placeholder="상품설명을 입력하세요."></textarea>
									<span class="count"><span id="descCount">0</span>/150자
									</span>
								</div>
							</div>
						</div>
					</div>

					<!-- 판매정보 -->
					<div class="accordion-item">
						<div class="accordion-header">
							<span>판매정보 <span class="required">*</span></span> <span
								class="arrow">&#9662;</span>
						</div>
						<div class="accordion-content">
							<!-- 가격 -->
							<div class="sale-row">
								<label for="price">가격</label>
								<div class="sale-input">
									<input type="number" id="price" name="price"> <span>원</span>
								</div>
							</div>
							<!-- 최소구매수량 -->
							<div class="sale-row">
								<label for="minQty">최소구매수량 <span class="required">*</span></label>
								<div class="sale-input">
									<input type="number" id="minQty" name="minPurchase" value="1" min="1">
									<span>개</span>
								</div>
							</div>
							<!-- 최대구매수량 -->
							<div class="sale-row">
								<label for="maxQty">최대구매수량</label>
								<div class="sale-input">
									<input type="number" id="maxQty" name="maxPurchase"
										value="999999999" max="999999999"> <span>개</span>
								</div>
							</div>
							<!-- 할인율 -->
							<div class="sale-row">
								<label for="discount">할인율</label>
								<div class="sale-input">
									<input type="number" id="discount" name="discount" min="0"> <span>%</span>
								</div>
							</div>
						</div>
					</div>

						<!-- 옵션 -->
						<div class="accordion-item">
							<div class="accordion-header">
								<span>옵션</span> <span class="arrow">&#9662;</span>
							</div>
							<div class="accordion-content">
							
								<!-- 이미지 -->
								<div class="option-title">이미지</div>
								<table class="image-table">
									<tr>
										<th width="60">NO</th>
										<th width="130">용도</th>
										<th>선택한 파일</th>
										<th width="110"></th>
									</tr>
									<tr>
										<td>1</td>
										<td>썸네일</td>
										<td>
											<input type="hidden" id="thumbImg" name="thumbImg">
											<input type="text" id="thumbFileName" readonly placeholder="선택된 이미지가 없습니다.">
										</td>
										<td>
											<button type="button" class="image-btn" data-target="thumbImg" data-preview="thumbPreview">등록하기</button>
										</td>
									</tr>
									<tr>
										<td>2</td>
										<td>대표이미지</td>
										<td>
											<input type="hidden" id="mainImg" name="mainImg">
											<input type="text" id="mainFileName" readonly placeholder="선택된 이미지가 없습니다.">
										</td>
										<td>
											<button type="button" class="image-btn" data-target="mainImg" data-preview="mainPreview">등록하기</button>
										</td>
									</tr>
									<tr>
										<td>3</td>
										<td>상품설명</td>
										<td>
											<input type="hidden" id="descImg" name="descImg">
											<input type="text" id="descFileName" readonly placeholder="선택된 이미지가 없습니다.">
										</td>
										<td>
											<button type="button" class="image-btn" data-target="descImg" data-preview="descPreview">등록하기</button>
										</td>
									</tr>
									<tr>
										<td>4</td>
										<td>상세정보</td>
										<td>
											<input type="hidden" id="detailImg" name="detailImg">
											<input type="text" id="detailFileName" readonly placeholder="선택된 이미지가 없습니다.">
										</td>
										<td>
											<button type="button" class="image-btn" data-target="detailImg" data-preview="detailPreview">등록하기</button>
										</td>
									</tr>
								</table>

								<!-- 제조사 -->
								<div class="form-row">
									<label>제조사</label> <input type="text" name="manufacturer">
								</div>

								<!-- 원산지 -->
								<div class="form-row">
									<label>원산지</label> <input type="text" name="origin">
								</div>

								<!-- 미성년자 구매 -->
								<div class="form-row">
									<label>미성년자 구매</label>
									<div class="radio-group">
										<label><input type="radio" name="underAgePurchase" value="0" checked> 가능</label> 
										<label><input type="radio" name="underAgePurchase" value="1"> 불가능</label>
									</div>
								</div>

								<!-- 무게 -->
								<div class="form-row">
									<label>무게(kg)</label> <input type="number" name="weight" min="1">
								</div>

								<!-- 유통기한 -->
								<div class="form-row">
									<label>유통기한</label> <input type="date" name="expirationDate">
								</div>

								<!-- 보관방법 -->
								<div class="form-row">
									<label>보관방법</label> 
									<select name="storageType">
										<option value="">선택</option>
										<option>냉장</option>
										<option>냉동</option>
										<option>실온</option>
									</select>
								</div>

								<!-- 판매단위 -->
								<div class="form-row">
									<label>판매단위</label> 
									<input type="text" name="salesUnit" placeholder="예) 1팩">
								</div>
								
								<!-- 수량 -->
								<div class="form-row">
									<label>판매수량</label> 
									<input type="text" name="quantity">
								</div>

								<!-- 추가정보 -->
								<div class="form-row">
									<label>추가정보</label>
									<textarea name="additionalInfo" rows="5"></textarea>
								</div>
							</div>
						</div>
					</div>

				<div class="btn-area">
					<button class="save-btn">저장</button>
				</div>
			</form>
			</div>
		</div>
	</div>

	<div id="imageModal" class="image-modal">
		<div class="image-modal-content">
			<div class="image-modal-header">
				<h3>이미지 선택</h3>
				<button type="button" id="closeImageModal">×</button>
			</div>

			<!-- 이미지 목록 -->
			<div class="image-list"></div>

			<!-- 하단 버튼 -->
			<div class="modal-footer">
				<button type="button" id="cancelImageBtn">취소</button>
				<button type="button" id="selectImageBtn">선택</button>
			</div>
		</div>
	</div>
</body>

</html>