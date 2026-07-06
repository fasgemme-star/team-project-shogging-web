package client.productDetail;

import java.sql.Date;

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
	public ProductDTO() {
		super();
	}
	public ProductDTO(String prdID, String prdName, String optionName, String shortInfo, String prdType, int price,
			String notification, String description, int discount, String manufacturer, String storageType,
			String origin, int underagePurchase, int weight, Date expirationDate, String unit, int minPurchase,
			int maxPurchase, Date productInputDate, String categoryName, String img, String url, String imageType) {
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
	}
	public String getPrdID() {
		return prdID;
	}
	public void setPrdID(String prdID) {
		this.prdID = prdID;
	}
	public String getPrdName() {
		return prdName;
	}
	public void setPrdName(String prdName) {
		this.prdName = prdName;
	}
	public String getOptionName() {
		return optionName;
	}
	public void setOptionName(String optionName) {
		this.optionName = optionName;
	}
	public String getShortInfo() {
		return shortInfo;
	}
	public void setShortInfo(String shortInfo) {
		this.shortInfo = shortInfo;
	}
	public String getPrdType() {
		return prdType;
	}
	public void setPrdType(String prdType) {
		this.prdType = prdType;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getNotification() {
		return notification;
	}
	public void setNotification(String notification) {
		this.notification = notification;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public int getDiscount() {
		return discount;
	}
	public void setDiscount(int discount) {
		this.discount = discount;
	}
	public String getManufacturer() {
		return manufacturer;
	}
	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}
	public String getStorageType() {
		return storageType;
	}
	public void setStorageType(String storageType) {
		this.storageType = storageType;
	}
	public String getOrigin() {
		return origin;
	}
	public void setOrigin(String origin) {
		this.origin = origin;
	}
	public int getUnderagePurchase() {
		return underagePurchase;
	}
	public void setUnderagePurchase(int underagePurchase) {
		this.underagePurchase = underagePurchase;
	}
	public int getWeight() {
		return weight;
	}
	public void setWeight(int weight) {
		this.weight = weight;
	}
	public Date getExpirationDate() {
		return expirationDate;
	}
	public void setExpirationDate(Date expirationDate) {
		this.expirationDate = expirationDate;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public int getMinPurchase() {
		return minPurchase;
	}
	public void setMinPurchase(int minPurchase) {
		this.minPurchase = minPurchase;
	}
	public int getMaxPurchase() {
		return maxPurchase;
	}
	public void setMaxPurchase(int maxPurchase) {
		this.maxPurchase = maxPurchase;
	}
	public Date getProductInputDate() {
		return productInputDate;
	}
	public void setProductInputDate(Date productInputDate) {
		this.productInputDate = productInputDate;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getImageType() {
		return imageType;
	}
	public void setImageType(String imageType) {
		this.imageType = imageType;
	}
	@Override
	public String toString() {
		return "ProductDTO [prdID=" + prdID + ", prdName=" + prdName + ", optionName=" + optionName + ", shortInfo="
				+ shortInfo + ", prdType=" + prdType + ", price=" + price + ", notification=" + notification
				+ ", description=" + description + ", discount=" + discount + ", manufacturer=" + manufacturer
				+ ", storageType=" + storageType + ", origin=" + origin + ", underagePurchase=" + underagePurchase
				+ ", weight=" + weight + ", expirationDate=" + expirationDate + ", unit=" + unit + ", minPurchase="
				+ minPurchase + ", maxPurchase=" + maxPurchase + ", productInputDate=" + productInputDate
				+ ", categoryName=" + categoryName + ", img=" + img + ", url=" + url + ", imageType=" + imageType + "]";
	}
	
	
}
