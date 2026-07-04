package manage.client;

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
	private String clientNo;
	private String clientName;
	private String email;
	private String phone;
	private String joinDate;
	private int totalPayment;
}
