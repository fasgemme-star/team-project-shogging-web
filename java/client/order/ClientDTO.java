package client.order;

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
public class ClientDTO {
	private String clientID;
	private String clientHash;
	private String clientName;
	private String clientEmail;
	private String clientIDTel;
	private String clientBirth;
	private String clientIP;
	private String clientCheck;
	private String clientStartDate;
	private String clientDeleteAccount;
	private String clientLastDate;
	private String deliveryPost;
	private String deliveryAddr;
}
