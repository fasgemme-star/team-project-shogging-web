package client.deliveryChg;

import java.util.Date;

public class DeliveryDTO {
	
	private String deliveryID;
	private String deliveryPost;
	private String deliveryAddr;
	private String recipient;
	private String recipientPhone;
	private boolean firstDestination;
	private Date inputDate;
	private String clientNo;
	public DeliveryDTO() {
		super();
	}
	public DeliveryDTO(String deliveryID, String deliveryPost, String deliveryAddr, String recipient,
			String recipientPhone, boolean firstDestination, Date inputDate, String clientNo) {
		super();
		this.deliveryID = deliveryID;
		this.deliveryPost = deliveryPost;
		this.deliveryAddr = deliveryAddr;
		this.recipient = recipient;
		this.recipientPhone = recipientPhone;
		this.firstDestination = firstDestination;
		this.inputDate = inputDate;
		this.clientNo = clientNo;
	}
	public String getDeliveryID() {
		return deliveryID;
	}
	public void setDeliveryID(String deliveryID) {
		this.deliveryID = deliveryID;
	}
	public String getDeliveryPost() {
		return deliveryPost;
	}
	public void setDeliveryPost(String deliveryPost) {
		this.deliveryPost = deliveryPost;
	}
	public String getDeliveryAddr() {
		return deliveryAddr;
	}
	public void setDeliveryAddr(String deliveryAddr) {
		this.deliveryAddr = deliveryAddr;
	}
	public String getRecipient() {
		return recipient;
	}
	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}
	public String getRecipientPhone() {
		return recipientPhone;
	}
	public void setRecipientPhone(String recipientPhone) {
		this.recipientPhone = recipientPhone;
	}
	public boolean isFirstDestination() {
		return firstDestination;
	}
	public void setFirstDestination(boolean firstDestination) {
		this.firstDestination = firstDestination;
	}
	public Date getInputDate() {
		return inputDate;
	}
	public void setInputDate(Date inputDate) {
		this.inputDate = inputDate;
	}
	public String getClientNo() {
		return clientNo;
	}
	public void setClientNo(String clientNo) {
		this.clientNo = clientNo;
	}
	@Override
	public String toString() {
		return "DeliveryDTO [deliveryID=" + deliveryID + ", deliveryPost=" + deliveryPost + ", deliveryAddr="
				+ deliveryAddr + ", recipient=" + recipient + ", recipientPhone=" + recipientPhone
				+ ", firstDestination=" + firstDestination + ", inputDate=" + inputDate + ", clientNo=" + clientNo
				+ "]";
	}
	
	
}
