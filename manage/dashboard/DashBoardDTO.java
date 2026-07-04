package manage.dashboard;

import java.util.List;
import java.util.Map;

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
public class DashBoardDTO {
	private int totalSales;
	private int totalClient;
	private int newClientWeek;
	private int nonResponseInquiry;
	private int[] newClientMonth;
	private int[] dropOutClient;
	private List<Map<String, Integer>> bestProduct;

}
