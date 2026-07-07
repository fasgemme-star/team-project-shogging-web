package client.productDetail;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
@Setter
@Getter
@ToString
public class ProductDTO {
	private String prdID;
	private String prdName;
	private String optionName;
	private String shortInfo;
	private String prdType;
	private int price;
	private String notification;
	private String description;
	private int discount;
	private String manufacturer;
	private String storageType;
	private String origin;
	private int underagePurchase;
	private int weight;
	private Date expirationDate;
	private String unit;
	private int minPurchase;
	private int maxPurchase;
	private Date productInputDate;
	private String categoryName;
	private String img;
	private String url;          
	private String imageType;
	private String optionNo;
	public ProductDTO() {
		super();
	}
	public ProductDTO(String prdID, String prdName, String optionName, String shortInfo, String prdType, int price,
			String notification, String description, int discount, String manufacturer, String storageType,
			String origin, int underagePurchase, int weight, Date expirationDate, String unit, int minPurchase,
			int maxPurchase, Date productInputDate, String categoryName, String img, String url, String imageType,
			String optionNo) {
		super();
		this.prdID = prdID;
		this.prdName = prdName;
		this.optionName = optionName;
		this.shortInfo = shortInfo;
		this.prdType = prdType;
		this.price = price;
		this.notification = notification;
		this.description = description;
		this.discount = discount;
		this.manufacturer = manufacturer;
		this.storageType = storageType;
		this.origin = origin;
		this.underagePurchase = underagePurchase;
		this.weight = weight;
		this.expirationDate = expirationDate;
		this.unit = unit;
		this.minPurchase = minPurchase;
		this.maxPurchase = maxPurchase;
		this.productInputDate = productInputDate;
		this.categoryName = categoryName;
		this.img = img;
		this.url = url;
		this.imageType = imageType;
		this.optionNo = optionNo;
	}
	
	
}
