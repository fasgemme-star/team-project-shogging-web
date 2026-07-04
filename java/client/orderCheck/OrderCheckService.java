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

}
