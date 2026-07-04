package manage.admin;

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
public class AdminDTO {
	private String adminID;
	private String adminPW;
	private String adminName;
	private String Tel;
	private String adminEmail;
}
