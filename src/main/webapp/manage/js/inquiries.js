/**
 * 
 */
const emptyState = document.getElementById("emptyState");
const detailContent = document.getElementById("detailContent");

let selectedItem = null;

document.querySelectorAll(".inquiry-item").forEach(item => {
    item.addEventListener("click", function() {

        // 이미 선택된 항목을 다시 클릭한 경우
        if(selectedItem === this){
            detailContent.style.display = "none";
            emptyState.style.display = "flex";
            this.classList.remove("selected");
            selectedItem = null;
            return;
        }

        // 기존 선택 해제
        document.querySelectorAll(".inquiry-item").forEach(i => {
            i.classList.remove("selected");
        });

        // 새 항목 선택
        this.classList.add("selected");
        selectedItem = this;

        emptyState.style.display = "none";
        detailContent.style.display = "block";

        // 여기서 문의 데이터 변경
        // customerName.textContent = ...
        // questionText.textContent = ...
    });
});

function openOrderModal(orderNo) {
	document.getElementById("modalOrderNo").textContent = orderNo;
	document.getElementById("orderModal").style.display = "block";
}
function closeOrderModal() {
	document.getElementById("orderModal").style.display = "none";
}
// 팝업 바깥 영역 클릭 시 닫기
window.onclick = function(event) {
	const modal = document.getElementById("orderModal");
	if (event.target == modal) {
		modal.style.display = "none";
	}
}
