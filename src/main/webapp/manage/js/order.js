/**
 * 
 */
document.addEventListener("DOMContentLoaded", function(){

	const searchBtn=document.getElementById("searchBtn");
	const resetBtn=document.getElementById("resetBtn");
	const allCheck=document.getElementById("allCheck");

	searchBtn.addEventListener("click", function(){
		const startDate= document.getElementById("startDate").value;
		const endDate= document.getElementById("endDate").value;
		const status= document.getElementById("orderStatus").value;
		const category= document.getElementById("category").value;

		console.log("조회");
		console.log(startDate);
		console.log(endDate);
		console.log(status);
		console.log(category);

		// 나중에 AJAX 또는 form 전송
	});

	resetBtn.addEventListener("click", function(){

	    document.querySelectorAll(".date-btn").forEach(function(btn){
	        btn.classList.remove("active");
	    });

	    document.querySelectorAll(".date-btn")[2].classList.add("active");
	    document.getElementById("startDate").value = "";
	    document.getElementById("endDate").value = "";
	    document.getElementById("orderStatus").value = "";
	    document.getElementById("category").value = "";
		
	});

	allCheck.addEventListener("change", function(){
		const checks= document.querySelectorAll(
				"#orderTableBody input[type=checkbox]"
			);

		checks.forEach(function(check){
			check.checked=allCheck.checked;
		});
	});

});

document.addEventListener("DOMContentLoaded", function(){
	const dateBtns=document.querySelectorAll(".date-btn");

	dateBtns.forEach(function(btn){
		btn.addEventListener("click", function(){

			dateBtns.forEach(function(b){
				b.classList.remove("active");
			});

			this.classList.add("active");
			const endDate=new Date();
			const startDate=new Date();
			const text=this.textContent;

			if(text==="오늘"){
			}
			else if(text==="1주일"){
				startDate.setDate(endDate.getDate()-7);
			}
			else if(text==="1개월"){
				startDate.setMonth(endDate.getMonth()-1);
			}
			else if(text==="3개월"){
				startDate.setMonth(endDate.getMonth()-3);
			}

			document.getElementById("startDate").value= formatDate(startDate);

			document.getElementById("endDate").value= formatDate(endDate);
		});
	});

	function formatDate(date){

		const year=date.getFullYear();
		const month=String(
			date.getMonth()+1
		).padStart(2,"0");

		const day=String(
			date.getDate()
		).padStart(2,"0");

		return `${year}-${month}-${day}`;
	}
});

document.addEventListener("DOMContentLoaded", function () {
    // 취소 요청
    document.querySelectorAll(".cancel-btn").forEach(btn => {
        btn.addEventListener("click", function () {
            const modal =
                new bootstrap.Modal(
                    document.getElementById("cancelModal")
                );
            modal.show();
        });
    });

    // 교환 요청
    document.querySelectorAll(".claim-btn").forEach(btn => {
        btn.addEventListener("click", function () {
            const modal =
                new bootstrap.Modal(
                    document.getElementById("exchangeModal")
                );
            modal.show();
        });
    });
});
