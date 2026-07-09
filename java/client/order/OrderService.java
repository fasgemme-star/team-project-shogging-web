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

	/**
	 * 결제하기: 장바구니 항목들을 실제 ORDERS/ORDER_DETAILS 로 저장한다.
	 * 주의: 기존 processPayment(OrderDTO)는 존재하지 않는 컬럼/틀린 파라미터 개수로 항상 SQL 오류가 났고
	 * ORDER_DETAILS(주문 품목)는 저장하지도 않아서, 결제를 눌러도 마이페이지 주문내역에 절대 나타나지 않았다.
	 * @return 생성된 order_id (실패 시 null)
	 */
	public String placeOrder(String clientNo, int totalAmount, List<client.cart.OrderDTO> items) {
		try {
			return oDAO.insertOrder(clientNo, totalAmount, items);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}// placeOrder
}
