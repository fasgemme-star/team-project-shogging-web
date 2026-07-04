package manage.ordermanagement;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderManagementService {
	private OrderManagementDAO oDAO = OrderManagementDAO.getInstance();
	
	public int totalCount(RangeDTO rDTO) {
		return 0;
	}// totalCount
	
	public int pageScale(int num) {
		return 0;
	}// pageScale
	
	public int totalPage(int totalCnt, int pageScale) {
		return 0;
	}// totalPage
	
	public int startNum(int totalPage, int pageScale) {
		return 0;
	}// startNum
	
	public int endNum(int totalpage, int pageScale) {
		return 0;
	}// endNum
	
	public List<OrderDTO> getOrderList(RangeDTO rDTO){
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		try {
			oList = oDAO.selectOrderList(rDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return oList;
	}// getOrderList
	
	public OrderDTO getOrderDetail(String orderID) {
		OrderDTO oDTO = new OrderDTO();
		return oDTO;
	}// getOrderDetail
	
	
	public boolean processDelivery(String orderID) {
		try {
			oDAO.updateDeliveryStatus(orderID);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return true;
	}// processDelivery
	
	/**
	 * @param claimID
	 * @param i 0: 반품, 1: 취소
	 * @return
	 */
	public ClaimDTO getClaimDetail(String claimID, int i) {
		ClaimDTO cDTO = new ClaimDTO();
		try {
			cDTO = oDAO.selectClaimDetail(claimID, i);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cDTO;
	}// getClaimDetail
	
	public boolean processClaimStatus(String claimID, String result) {
		boolean flag = false;
		try {
			oDAO.updateClaimStatus(claimID,result);
			flag=true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return flag;
	}// approveCancle
	
	

}
