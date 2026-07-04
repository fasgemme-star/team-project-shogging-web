package manage.dashboard;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;


public class DashBoardService {
	private DashBoardDAO dDAO = DashBoardDAO.getInstance();
	
	public int getTotalSales() {
		int total = 0;
		try {
			total = dDAO.selectTotalSales();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return total;
	}// getTotalSales

	public int getNewClientCount() {
		int total = 0;
		try {
			total = dDAO.selectTotalSales();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return total;
	}// getNewClientCount
	
	public int getNowItemCount() {
		int cnt = 0;
		try {
			cnt = dDAO.selectProductOnNow();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cnt;
	}// getNowItemCount
	
	public int getNonResponseInquiryCount() {
		int total = 0;
		try {
			total = dDAO.selectNonInquiryCount();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return total;
	}// getNonResponseInquiryCount
	
	public int[] getNewClientStatistics() {
		int[] arr = null;
		try {
			arr = dDAO.selectNewClientCount();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return arr;
	}// getNewClientStatistics
	
	public int[] getDropOutClientStatistics() {
		int[] a = null;
		try {
			a = dDAO.selectclientDropOut();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return a;
	}// getDropOutClientStatistics
	
	public Map<String, Integer> getBestProductList(){
		Map<String, Integer> bMap = new LinkedHashMap<String,Integer>();
		try {
			bMap = dDAO.selectBestProduct();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return bMap;
	}// getBestProductList
	
}
