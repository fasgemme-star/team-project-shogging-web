package client.bestSale;

import java.util.List;
import client.productDetail.*;
import client.usermain.*;



public class BestSaleService {

	private BestSaleDAO bsDAO;
	
	public BestSaleService() {
		bsDAO=BestSaleDAO.getInstance();
	}
	
	//베스트 랭킹 목록 조회
	public List<ProductDTO> searchBest(RangeDTO rDTO){
		return bsDAO.bestProduct(rDTO);
	}
	//인기급상승 목록 조회
	public List<ProductDTO> searchRising(RangeDTO rDTO){
		return bsDAO.risingProduct(rDTO);
	}
	//알뜰쇼핑 목록조회
	public List<ProductDTO> searchEconomy(RangeDTO rDTO){
		return bsDAO.economyProduct(rDTO);
	}
	//반값세일 목록조회
	public List<ProductDTO> searchHalfSale(RangeDTO rDTO){
		return bsDAO.halfSaleProduct(rDTO);
	}
//	//베스트 랭킹 상품 총 개수
//	public int getTotalBestCount(RangeDTO rDTO) {
//		return bsDAO.getTotalBestCount(rDTO);
//	}
//	//인기 급상승 상품 총개수
//	public int getTotalRisingCount(RangeDTO rDTO) {
//		return bsDAO.getTotalRisingCount(rDTO);
//	}
//	//알뜰쇼핑 상품 총개수
//	public int getTotalEconomyCount(RangeDTO rDTO) {
//		return bsDAO.getTotalEconomyCount(rDTO);
//	}
//	//반값세일 상품 총개수
//	public int getTotalHalfSaleCount(RangeDTO rDTO) {
//		return bsDAO.getTotalHalfSaleCount(rDTO);
//	}
	
	
	
}
