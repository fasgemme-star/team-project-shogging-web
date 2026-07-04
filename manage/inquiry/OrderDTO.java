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
public class OrderDTO {
	private String clientID;
	private String cartID;
	private String orderID;
	private String prdName;
	private String orderDate;
	private int totalAmount;
	private String orderStatus;
	private String deliveryStatus;
	private String deliveryRequest;
	private String deliveryStartDate;
	private String deliveryCompletionDate;
	private int quantity;
	private int price;
	private String orderDetailsID;
	private String optionID;
	private int discountPrice;
}
