package manage.ordermanagement;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RangeDTO {
	private int startNum;
	private int endNum;
	private String searchType;
	private String keyword;
	private String delivery_status;
	private String startDate;
	private String endDate;
	
	public void setDelivery_status(String status) {
		switch (status) {
		case "paid":
			delivery_status = "결제완료";
			break;
		case "ready":
			delivery_status = "배송대기";
			break;
		case "delivery":
			delivery_status = "배송중";
			break;
		case "complete":
			delivery_status = "배송완료";
			break;
		case "cancel":
			delivery_status = "취소요청";
			break;
		default:
			delivery_status = null;
		}
	}
		
}

