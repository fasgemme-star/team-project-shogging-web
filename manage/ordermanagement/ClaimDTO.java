package manage.ordermanagement;


import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class ClaimDTO {
	private String order_detail_ID;
	
	private String claimID;
	private String requestDate;
	private String claimType;
	private String clientName;
	private String clientTel;
	private List<String> img;
	
	private int price;
	
	private String optionID;
	private String prdName;
	private int quantity;
	
	private String reason;
	private String reasonDetail;
	private int claimCnt;
	private String claimStatus;
	private String processingDate;

}
