package manage.client;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RangeDTO {
	private int startNum, endNum;
	private int totalCnt;
	private int pageCnt;
	private String keyword;
	
	private String startDate;
	private String endDate;
}
