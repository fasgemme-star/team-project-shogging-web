package manage.addproduct;

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
public class ProductDTO {
	private String prdID;
	private String category;
	private String prdName;
	private String prdDescription;
	private int price;
	private int minPurchae;
	private int maxPurchase;
	private int discount; 
	private String manufacturer;
	private String origin;
	private String underAgePurchase;
	private int weight;
	private String expirationDate;
	private String storageType;
	private String salesUnit;
	private String additionalInfo;
	private String notice;
	private String prdType;

}
