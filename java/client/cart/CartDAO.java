package client.cart;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class CartDAO {
	private static CartDAO cDAO;
	private CartDAO() {}
	
	public static CartDAO getInstance() {
		if (cDAO == null) {
			cDAO = new CartDAO();
		}
		return cDAO;
	} // getInstance()
	
	public int insertCart(CartDTO cDTO) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		String query = "insert into shopping_cart(client_no, option_id, quantity) values(?, ?, ?)";
		int cnt = 0;
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, cDTO.getClientNo());
			pstmt.setString(2, cDTO.getPrdID());
			pstmt.setInt(3, cDTO.getQuantity());
			cnt = pstmt.executeUpdate();
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		
		return cnt;
		
	}// insertCart

	public int updateCart(CartDTO cDTO) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		String query = "update shopping_cart set quantity = ? where client_no = ? and option_id = ?	";
		int cnt = 0;
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);
			
			pstmt.setInt(1, cDTO.getQuantity());
			pstmt.setString(2, cDTO.getClientNo());
			pstmt.setString(3, cDTO.getPrdID());
			cnt = pstmt.executeUpdate();
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		return cnt;
	}// updateCart

	public int deleteCart(CartDTO cDTO) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		int cnt = 0;
		String query = "	delete from shopping_cart where client_no = ? and option_id = ?	";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, cDTO.getClientNo());
			pstmt.setString(2, cDTO.getPrdID());
			cnt = pstmt.executeUpdate();
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		return cnt;
	}// deleteCart

	public int deleteCartAll(CartDTO cDTO) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		int cnt = 0;
		String query = "	delete from shopping_cart where client_no = ? and option_id = ? and option_id in (select option_id from product_option where STOCKQUANTITY = 0)	";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, cDTO.getClientNo());
			pstmt.setString(2, cDTO.getPrdID());
			cnt = pstmt.executeUpdate();
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		return cnt;
	}// clearCart

	// 주문 완료 후 장바구니 전체 비우기 (품절상품 조건 없이 회원의 장바구니를 전부 삭제)
	// 주의: deleteCartAll()은 이름과 달리 option_id가 있어야만(그것도 품절상품만) 지워지는 메소드라
	// 결제 완료 후 장바구니를 비우는 용도로는 쓸 수 없어서 별도로 추가함.
	public int deleteCartByClient(String clientNo) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		int cnt = 0;
		String query = "delete from shopping_cart where client_no = ?";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);

			pstmt.setString(1, clientNo);
			cnt = pstmt.executeUpdate();

		} finally {
			dbcon.dbClose(null, pstmt, con);
		}
		return cnt;
	}// deleteCartByClient
	
	public List<OrderDTO> selectCart(String id) throws SQLException{
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		OrderDTO oDTO = null;
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			// 주의: option_id 를 SELECT 하지 않으면 주문 생성(order_details insert) 시 어떤 옵션을
			// 주문했는지 알 수 없어서 결제하기가 실제 주문으로 이어지지 못한다. (option_id 추가로 수정)
			String query = "	select po.OPTION_ID, option_name, price, discount, quantity  from shopping_cart sc join product_option po on sc.OPTION_ID=po.OPTION_ID where STOCKQUANTITY != 0 and client_no = ?	";
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				oDTO = new OrderDTO();
				oDTO.setOptionId(rs.getString("OPTION_ID"));
				oDTO.setPrdName(rs.getString("option_name"));
				oDTO.setPrice(rs.getInt("price"));
				oDTO.setDiscount(rs.getInt("discount"));
				oDTO.setQuantity(rs.getInt("quantity"));
				
				oList.add(oDTO);
			}
			
		} finally {
			dbcon.dbClose(rs, pstmt, con);
		} 
		
		return oList;
	}
	
	public List<OrderDTO> selectCartSoldOut(String id) throws SQLException{
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		OrderDTO oDTO = null;
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			String query = "	select option_name, price, discount, quantity  from shopping_cart sc join product_option po on sc.OPTION_ID=po.OPTION_ID where STOCKQUANTITY = 0 and client_no = ?	";
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				oDTO = new OrderDTO();
				oDTO.setPrdName(rs.getString("option_name"));
				oDTO.setPrice(rs.getInt("price"));
				oDTO.setDiscount(rs.getInt("discount"));
				oDTO.setQuantity(rs.getInt("quantity"));
				
				oList.add(oDTO);
			}
			
		} finally {
			dbcon.dbClose(rs, pstmt, con);
		} 
		
		return oList;
	}
	
	public List<DeliveryDTO> selectDelivery(String clientNo) throws SQLException{
		List<DeliveryDTO> dList = new ArrayList<DeliveryDTO>();
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "	select DELIVERY_ADDR, RECIPIENT, RECIPIENT_PHONE, FIRST_DESTINATION from DELIVERY_DESTINATION where client_no=?	";
	
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, clientNo);
			
			
			rs = pstmt.executeQuery();
	        
	        // 4. 결과 매핑
	        while (rs.next()) {
	            DeliveryDTO dDTO = new DeliveryDTO();
	            dDTO.setDeliveryAddr(rs.getString("DELIVERY_ADDR"));
	            dDTO.setClientName(rs.getString("RECIPIENT"));
	            dDTO.setClientTel(rs.getString("RECIPIENT_PHONE"));
	            dDTO.setFirstDestination(rs.getString("FIRST_DESTINATION"));
	            
	            dList.add(dDTO);
	        }
		} finally {
			dbcon.dbClose(rs, pstmt, con);
		} 
		return dList;
	}
	
	public void updateDeliveryRequest(DeliveryDTO dDTO) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			String query = "	update orders set DELIVERY_REQUEST=? where client_no =? 	";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, dDTO.getRequest());
			pstmt.setString(1, dDTO.getClientNo());
			
			pstmt.executeUpdate();
			
			
		} finally {
			dbcon.dbClose(null, pstmt, con);
		} 
		
    }// updateDeliveryRequest
}
