package client.productSearch;

import java.util.List;


import client.productDetail.ProductDTO;

public class ProductSearchService {

	private ProductSearchDAO psDAO;
	
	public ProductSearchService() {
		psDAO=ProductSearchDAO.getInstance();
	}
	
	//상품명 검색을 통한 상품 목록 조회 
	public List<ProductDTO> searchProduct(String prdName){
		
		return psDAO.selectProduct(prdName);
	}
	
	
}
