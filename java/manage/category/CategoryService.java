package manage.category;

import java.sql.SQLException;
import java.util.List;


public class CategoryService {
	private CategoryDAO cDAO = CategoryDAO.getInstance();
	
	public List<CategoryDTO> showCategroy(){
		List<CategoryDTO> cList = null;
		try {
			cList = cDAO.selectCategoryList();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cList;
	}// showCategroy
	
	public int addCategory(String name) {
		try {
			if (cDAO.insertCategory(name) == 1) {
				//추가 성공
			} else {
				// 추가 실패
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}// addCategory

	public int modifyCategory(String categoryID, String newName) {
		int result = 0;
		try {
			result = cDAO.updateCategory(categoryID, newName);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// modifyCategory
	
	public int removeCategory(String categoryID) {
		int result = 0;
		try {
			result = cDAO.deleteCategory(categoryID);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// removeCategory
	
}
