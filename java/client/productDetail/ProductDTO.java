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
	private String underagePurchase;
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
	@Override
	public String toString() {
		return "ProductDTO [prdID=" + prdID + ", prdName=" + prdName + ", optionName=" + optionName + ", shortInfo="
				+ shortInfo + ", prdType=" + prdType + ", price=" + price + ", notification=" + notification
				+ ", description=" + description + ", discount=" + discount + ", manufacturer=" + manufacturer
				+ ", storageType=" + storageType + ", origin=" + origin + ", underagePurchase=" + underagePurchase
				+ ", weight=" + weight + ", expirationDate=" + expirationDate + ", unit=" + unit + ", minPurchase="
				+ minPurchase + ", maxPurchase=" + maxPurchase + ", productInputDate=" + productInputDate
				+ ", categoryName=" + categoryName + ", img=" + img + ", url=" + url + ", imageType=" + imageType
				+ ", optionNo=" + optionNo + "]";
	}
	
	
	
}
