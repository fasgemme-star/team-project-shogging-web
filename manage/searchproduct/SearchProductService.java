package manage.searchproduct;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class SearchProductService {
	private SearchProductDAO spDAO = SearchProductDAO.getInstance();
	
	public int getTotalCount() {
		RangeDTO rDTO = new RangeDTO();
		try {
			rDTO = spDAO.selectCount();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int total = rDTO.getTotalCnt();
		return total;
	}
	
	public int getOnSaleCount() {
		RangeDTO rDTO = new RangeDTO();
		try {
			rDTO = spDAO.selectCount();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int onSaleCnt = rDTO.getActiveCnt();
		
		return onSaleCnt;
	}
	public int getSoldoutCount() {
		RangeDTO rDTO = new RangeDTO();
		try {
			rDTO = spDAO.selectCount();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int total = rDTO.getTotalCnt();
		int onSaleCnt = rDTO.getActiveCnt();
		int soldoutCnt = total - onSaleCnt;
		
		return soldoutCnt;
	}
	
	public List<ProductDTO> searchItem(RangeDTO rDTO){
		List<ProductDTO> pList = new ArrayList<ProductDTO>();
		try {
			pList = spDAO.selectSearchProduct(rDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return pList;
	}
	

	public void changeProduct(ProductDTO pDTO) {
	
		try {
			spDAO.updateProduct(pDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @param pDTO
	 * @return 1:성공, 0: 실패
	 */
	public int deleteProduct(ProductDTO pDTO) {
		int result = 0;
		try {
			result = spDAO.deleteProduct(pDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
}
