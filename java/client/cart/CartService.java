package client.cart;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class CartService {
	CartDAO cDAO = CartDAO.getInstance();
	
	public int addCart(CartDTO cDTO) {
		int result = 0;
		try {
			result = cDAO.insertCart(cDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// addCart

	public List<OrderDTO> getCartList(String clientID) {
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		try {
			oList = cDAO.selectCart(clientID);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    return oList;
	}// getCartList
	
	public List<OrderDTO> getCartListSoldOut(String clientID) {
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		try {
			oList = cDAO.selectCartSoldOut(clientID);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return oList;
	}// getCartList

	public int updateCart(CartDTO cDTO) {
		int result = 0;
		try {
			result = cDAO.updateCart(cDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// updateCart

	public int deleteCart(CartDTO cDTO) {
		int result = 0;
		try {
			result = cDAO.deleteCart(cDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// deleteCart

	public int clearCart(CartDTO cDTO) {
		int result = 0;
		try {
			result = cDAO.deleteCartAll(cDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// deleteCart


	public List<DeliveryDTO> getDelivery(String clientNo) {
		List<DeliveryDTO> dList = new ArrayList<DeliveryDTO>();
		try {
			dList = cDAO.selectDelivery(clientNo);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return dList;
	}// selectDelivery
}
