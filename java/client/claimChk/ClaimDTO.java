package client.claimChk;

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
	private String claimID;
	private String orderID;
	private String optionID;
	private String prdName;
	private String clientName;
	private String clientTel;
	private String claimType;
	private int claimCnt;
	private String requestDate;
	private String reason;
	private String reasonDetail;
	private String claimStatus;
	private String processingDate;
	private List<String> img;
}
