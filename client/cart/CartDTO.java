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
public class CartDTO {
    private String cartID;
    private String clientNo;
    private String prdID;
    private int quantity;
    private int price;
    private String cartInputDate;

}
