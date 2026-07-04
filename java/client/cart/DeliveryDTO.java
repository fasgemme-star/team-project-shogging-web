package client.cart;

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
public class DeliveryDTO {
    private String deliveryId;
    private String deliveryPost;
    private String deliveryAddr;
    private String clientNo;
    private String clientName;
    private String clientTel;
    private String deliveryName;
    private String deliveryTel;
    private String firstDestination;
    private String inputDate;
    private String request;
}
