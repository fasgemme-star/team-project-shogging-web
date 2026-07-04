package manage.inquiry;

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
public class InquiryDTO {
	private String inquiryID;
	private String clientNo;
	private String clientName;
	private String title;
	private String content;
	private String inquiryDate;
	private String status;
	private String answer;
	private String answerDate;
	private String inquiryType;
	private String orderID;

}
