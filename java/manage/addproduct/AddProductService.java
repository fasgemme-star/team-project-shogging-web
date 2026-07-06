package manage.addproduct;

import java.sql.SQLException;
import java.util.List;


public class AddProductService {
	private AddProductDAO aDAO = AddProductDAO.getInstance();

	
	/**
	 * @param pDTO
	 * @param imgList
	 * @return 3: 성공, 나머지: 실패
	 */
	public int addProduct(ProductDTO pDTO, List<ImageDTO> imgList) {
		int result=0;
		try {
			result = aDAO.insertProduct(pDTO, imgList);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
		return result;
	}// addProduct

}
