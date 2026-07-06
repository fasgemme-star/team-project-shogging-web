package client.usermain;

import java.util.List;


import client.productDetail.ProductDTO;

public class UserMainService {

	private UserMainDAO umDAO;

    public UserMainService() {
        umDAO = UserMainDAO.getInstance();
    }
    
    public int pageScale() {
	   return 15;
    }
   
    //전체 페이지수 계산
   	public int totalPage(int totalCount, int pageScale) {
   		int page=totalCount/pageScale;
   		if(totalCount%pageScale!=0) {
   			page++;
   		}
   		return page;
   	}
   	//페이징 시작 번호 계산
   	public int startNum(int currentPage, int pageScale) {
   		return (currentPage -1)*pageScale+1;
   	}
   	//페이지 끝 번호 계산
   	public int endNum(int currentPage, int pageScale) {
   		return currentPage*pageScale;
   	}
   //조건별 전체 상품 개수 조회(페이징용)
   	public int totalCount(RangeDTO range) {
   		return umDAO.selectTotalCount(range);
   	}
   //베스트 상품 목록 검색 및 조회
    public List<ProductDTO> searchBest() {
        return umDAO.selectBest();
    }
    //세일 상품 목록 검색 및 조회
    public List<ProductDTO> searchSale() {
        return umDAO.selectSale();
    }
    //배너 광고 상품 목록 
    public String[] getBannerImages() {
    	
    	String[] banners=new String[3];
    	
    	banners[0]="images/imgbanner1.png";
    	banners[1]="images/imgbanner2.png";
    	banners[2]="images/imgbanner3.png";
    	
        return banners;
    }
    //카테고리별 상품 목록 조회
    public List<ProductDTO> getCategory(RangeDTO range) {

        int pageScale = pageScale();

        range.setStartNum(
                startNum(range.getCurrentPage(), pageScale));

        range.setEndNum(
                endNum(range.getCurrentPage(), pageScale));

        return umDAO.selectCategory(range);
    }
	
   

}
