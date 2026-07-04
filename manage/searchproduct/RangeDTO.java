package manage.searchproduct;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RangeDTO {
	public String keyword;
	public String status;
	public String category;
	public String startDate;
	public String endDate;
	private int startNum, endNum;
	private int totalCnt;
    private int activeCnt;
	
}
