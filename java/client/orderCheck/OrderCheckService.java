package client.orderCheck;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderCheckService {
	OrderCheckDAO oDAO = OrderCheckDAO.getInstance();
	
	public List<OrderDTO> searchOrderChk(RangeDTO rDTO, String clientNO) {
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		try {
			oList = oDAO.selectOrderChkList(rDTO, clientNO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    return oList;
	}// searchOrderChk

	// 주문 내역 삭제
	public boolean deleteOrder(String orderId, String clientNo) {
		try {
			return oDAO.deleteOrderChk(orderId, clientNo) > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}// deleteOrder

}
