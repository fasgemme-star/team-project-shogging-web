package manage.searchproduct;

import java.util.List;

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
	private String prdType;
	private String status;
	private String prdDescription;
	private int price;
	private String notice;
	private int minPurchae;
	private int maxPurchase;
	private int discount; 
	private List<String> img; 
	private String manufacturer;
	private String origin;
	private int underAgePurchase;
	private int weight;
	private String expirationDate;
	private String storageType;
	private String salesUnit;
	private String additionalInfo;
	
	private int quantity;

}
