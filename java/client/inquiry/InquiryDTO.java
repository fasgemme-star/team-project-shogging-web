package client.inquiry;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
@Getter
@Setter
@ToString
public class InquiryDTO {
	
	private String inquiryId;
	private Date inquiryDate;
	private String inquiryTitle;
	private String inquirySecret;
	private String inquiryContent;
	private String answerStatus;
	private String answer;
	private Date answerDate;
	private String OrderDetailsId;
	private String inquiryName;
	private String inquiryType;
	private String clientNO;
	private String productId;
	private String clientNo;
	
	public InquiryDTO() {
		super();
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getClientNo() {
		return clientNo;
	}

	public void setClientNo(String clientNo) {
		this.clientNo = clientNo;
	}

	public InquiryDTO(String inquiryId, Date inquiryDate, String inquiryTitle, String inquirySecret,
			String inquiryContent, String answerStatus, String answer, Date answerDate, String orderDetailsId,
			String inquiryName, String inquiryType, String clientNO) {
		super();
		this.inquiryId = inquiryId;
		this.inquiryDate = inquiryDate;
		this.inquiryTitle = inquiryTitle;
		this.inquirySecret = inquirySecret;
		this.inquiryContent = inquiryContent;
		this.answerStatus = answerStatus;
		this.answer = answer;
		this.answerDate = answerDate;
		OrderDetailsId = orderDetailsId;
		this.inquiryName = inquiryName;
		this.inquiryType = inquiryType;
		this.clientNO = clientNO;
	}
	
	
}
