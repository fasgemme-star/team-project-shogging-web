package client.order;

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
public class OrderDTO {
	private String clientID;
	private String clientName;
	private String phone;
	private String email;
	private String recipient;
	private String recipientPhone;
	private String addr;
	
	private String cartID;
	private String orderID;
	private String prdName;
	private String prdID;
	private String orderDate;
	private int totalAmount;
	private String orderStatus;
	private String deliveryStatus;
	private String deliveryRequest;
	private String deliveryStartDate;
	private String deliveryCompletionDate;
	private int quantity;
	private int price;
	private int discount;
}
