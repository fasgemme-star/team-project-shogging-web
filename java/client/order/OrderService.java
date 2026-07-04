package client.order;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderService {
	OrderDAO oDAO = OrderDAO.getInstance();
	
	public OrderDTO getRecipeInfo(String clientNo) {
		OrderDTO oDTO = new OrderDTO();
		try {
			oDTO = oDAO.selectRecipeInfo(clientNo);
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return oDTO;
	}
	
	public List<OrderDTO> getOrderList(String clientNo, String[] selectedOptionIds){
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		try {
			oDAO.selectChoicedProduct(clientNo, selectedOptionIds);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return oList;
	}
	public String getOrder(String orderId) {
	    return "";
	}// getOrder

	public String selectDeliveryAddr(String clientId) {
	    return "";
	}// selectDeliveryAddr

	public String writeDeliveryRequest(String orderId, String deliveryRequest) {
	    return "";
	}// writeDeliveryRequest

	public String getOrderProduct(String orderId) {
	    return "";
	}// getOrderProduct

	public int calculateTotalPrice(OrderDTO oDTO) {
	    return 0;
	}// calculateTotalPrice

	public String processPayment(OrderDTO oDTO) {
	    return "";
	}// processPayment
}
