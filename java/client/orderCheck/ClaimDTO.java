package client.orderCheck;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ClaimDTO {
	private String clientID;
	private String orderDetailsID;
	private String claimType;
	private String reason;
	private String reasonDetail;
	private List<String> img;
}
