package client.productDetail;

public class ProductDetailService {
	
	private ProductDetailDAO pdDAO;
	
	public ProductDetailService() {
		pdDAO=ProductDetailDAO.getInstance();
	}
	
	//상품 ID로 상품 기본 정보 조회
	public ProductDTO getProductInfo(String optionNO) {
		return pdDAO.selectProductInfo(optionNO);
	}
	//상품 ID로 상품 상세 정보 조회
	public ProductDTO getProductDetail(String optionNO) {
		return pdDAO.selectProductDetail(optionNO);
		
	}
	
}
