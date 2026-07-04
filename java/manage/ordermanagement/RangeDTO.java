package manage.ordermanagement;

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
public class RangeDTO {
	private int startNum;
	private int endNum;
	private String searchType;
	private String keyword;
	private String delivery_status;
	private String startDate;
	private String endDate;
}
