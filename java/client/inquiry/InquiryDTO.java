package client.inquiry;

import java.sql.Date;

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
	
	public InquiryDTO() {
		super();
	}

	public InquiryDTO(String inquiryId, Date inquiryDate, String inquiryTitle, String inquirySecret,
			String inquiryContent, String answerStatus, String answer, Date answerDate, String orderDetailsId,
			String inquiryName, String inquiryType) {
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
	}

	public String getInquiryId() {
		return inquiryId;
	}

	public void setInquiryId(String inquiryId) {
		this.inquiryId = inquiryId;
	}

	public Date getInquiryDate() {
		return inquiryDate;
	}

	public void setInquiryDate(Date inquiryDate) {
		this.inquiryDate = inquiryDate;
	}

	public String getInquiryTitle() {
		return inquiryTitle;
	}

	public void setInquiryTitle(String inquiryTitle) {
		this.inquiryTitle = inquiryTitle;
	}

	public String getInquirySecret() {
		return inquirySecret;
	}

	public void setInquirySecret(String inquirySecret) {
		this.inquirySecret = inquirySecret;
	}

	public String getInquiryContent() {
		return inquiryContent;
	}

	public void setInquiryContent(String inquiryContent) {
		this.inquiryContent = inquiryContent;
	}

	public String getAnswerStatus() {
		return answerStatus;
	}

	public void setAnswerStatus(String answerStatus) {
		this.answerStatus = answerStatus;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public Date getAnswerDate() {
		return answerDate;
	}

	public void setAnswerDate(Date answerDate) {
		this.answerDate = answerDate;
	}

	public String getOrderDetailsId() {
		return OrderDetailsId;
	}

	public void setOrderDetailsId(String orderDetailsId) {
		OrderDetailsId = orderDetailsId;
	}

	public String getInquiryName() {
		return inquiryName;
	}

	public void setInquiryName(String inquiryName) {
		this.inquiryName = inquiryName;
	}

	public String getInquiryType() {
		return inquiryType;
	}

	public void setInquiryType(String inquiryType) {
		this.inquiryType = inquiryType;
	}

	@Override
	public String toString() {
		return "InquiryDTO [inquiryId=" + inquiryId + ", inquiryDate=" + inquiryDate + ", inquiryTitle=" + inquiryTitle
				+ ", inquirySecret=" + inquirySecret + ", inquiryContent=" + inquiryContent + ", answerStatus="
				+ answerStatus + ", answer=" + answer + ", answerDate=" + answerDate + ", OrderDetailsId="
				+ OrderDetailsId + ", inquiryName=" + inquiryName + ", inquiryType=" + inquiryType + "]";
	}

	
}
