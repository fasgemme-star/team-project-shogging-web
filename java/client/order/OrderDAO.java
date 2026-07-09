package client.order;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class OrderDAO {
	private static OrderDAO oDAO;
	private OrderDAO() {}
	
	public static OrderDAO getInstance() {
		if (oDAO == null) {
			oDAO = new OrderDAO();
		}
		return oDAO;
	} // getInstance()
	
	public OrderDTO selectRecipeInfo(String clientNo) throws SQLException {
		OrderDTO oDTO = null;
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			String query = "	select CLIENT_NAME, CLIENT_TEL, CLIENT_EMAIL, RECIPIENT, RECIPIENT_PHONE, DELIVERY_ADDR from client c join DELIVERY_DESTINATION dd on c.CLIENT_NO = dd.CLIENT_NO where c.client_no = ? and FIRST_DESTINATION ='T'	";
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, clientNo);
			
			rs = pstmt.executeQuery();

			while (rs.next()) {
				oDTO = new OrderDTO();
				oDTO.setClientName(rs.getString("CLIENT_NAME"));
				oDTO.setPhone(rs.getString("CLIENT_TEL"));
				oDTO.setEmail(rs.getString("CLIENT_EMAIL"));
				oDTO.setRecipient(rs.getString("RECIPIENT"));
				oDTO.setRecipientPhone(rs.getString("RECIPIENT_PHONE"));
				oDTO.setAddr(rs.getString("DELIVERY_ADDR"));
			}
			
		} finally {
			dbcon.dbClose(rs, pstmt, con);
		} 
		
		return oDTO;
	}
	
	/**
	 * 장바구니에서 선택된 물건 조회
	 * @param clientNo
	 * @param selectedOptionIds
	 * @return
	 * @throws SQLException
	 */
	public List<OrderDTO> selectChoicedProduct(String clientNo, String[] selectedOptionIds) throws SQLException {
	    List<OrderDTO> oList = new ArrayList<OrderDTO>();
	    DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    StringBuilder questionMarks = new StringBuilder();
	    for (int i = 0; i < selectedOptionIds.length; i++) {
	        questionMarks.append("?");
	        if (i < selectedOptionIds.length - 1) {
	            questionMarks.append(",");
	        }
	    }
	    
	    String query = "SELECT po.option_id, po.option_name, po.price, po.discount, sc.quantity "
	                 + "FROM shopping_cart sc "
	                 + "JOIN product_option po ON sc.option_id = po.option_id "
	                 + "WHERE sc.client_no = ? AND sc.option_id IN (" + questionMarks.toString() + ")";
	                 
	    try {
	        con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
	        pstmt = con.prepareStatement(query);
	        
	        // 3. 파라미터 바인딩
	        pstmt.setString(1, clientNo);
	        
	        // 가변적인 IN 조건 파라미터 바인딩 (인덱스는 2부터 시작)
	        for (int i = 0; i < selectedOptionIds.length; i++) {
	            pstmt.setString(i + 2, selectedOptionIds[i]);
	        }
	        
	        rs = pstmt.executeQuery();
	        
	        // 4. 결과 매핑
	        while (rs.next()) {
	            OrderDTO oDTO = new OrderDTO();
	            oDTO.setPrdID(rs.getString("option_id"));
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
	
	// 주문서 페이지
	//-----------
	// 결제 버튼
	/**
	 * 실제 주문 생성: ORDERS 1건 + ORDER_DETAILS N건(장바구니 항목 수만큼) INSERT.
	 * 주의: 기존 코드는
	 *   1) insert문 컬럼 5개(order_id, order_date, total_amount, order_status, client_no)에 값이 4개뿐이라 실행 시 SQL 오류가 나고,
	 *   2) 존재하지 않는 컬럼명(ORDER_STATUS, 실제로는 DELIVERY_STATUS)을 사용했으며,
	 *   3) ORDER_DETAILS(주문 상세/품목)는 아예 INSERT하지 않아서
	 *   결제를 눌러도 실제 주문이 저장되지 않고(마이페이지 주문내역에 절대 나타나지 않음) 있었다.
	 * @return 생성된 order_id (실패 시 null)
	 */
	public String insertOrder(String clientNo, int totalAmount, List<client.cart.OrderDTO> items) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmtMaxId = null;
		PreparedStatement pstmtOrder = null;
		PreparedStatement pstmtDetail = null;
		ResultSet rs = null;
		String queryMaxID = "SELECT MAX(order_id) FROM orders";
		String queryOrder = "INSERT INTO orders(order_id, order_date, total_amount, delivery_status, client_no) VALUES (?, SYSDATE, ?, ?, ?)";
		String queryDetail = "INSERT INTO order_details(order_id, option_id, quantity) VALUES (?, ?, ?)";
		String nextOrderId = null;

		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			con.setAutoCommit(false);

			String maxId = null;
			pstmtMaxId = con.prepareStatement(queryMaxID);
			rs = pstmtMaxId.executeQuery();
			if (rs.next()) {
				maxId = rs.getString(1);
			}

			nextOrderId = "O000001";
			if (maxId != null && maxId.startsWith("O")) {
				try {
					int num = Integer.parseInt(maxId.substring(1));
					num++;
					nextOrderId = String.format("O%06d", num);
				} catch (NumberFormatException e) {
					nextOrderId = "O000001";
				}
			}

			pstmtOrder = con.prepareStatement(queryOrder);
			pstmtOrder.setString(1, nextOrderId);
			pstmtOrder.setInt(2, totalAmount);
			pstmtOrder.setString(3, "결제완료");
			pstmtOrder.setString(4, clientNo);
			pstmtOrder.executeUpdate();

			if (items != null && !items.isEmpty()) {
				pstmtDetail = con.prepareStatement(queryDetail);
				for (client.cart.OrderDTO item : items) {
					pstmtDetail.setString(1, nextOrderId);
					pstmtDetail.setString(2, item.getOptionId());
					pstmtDetail.setInt(3, item.getQuantity());
					pstmtDetail.addBatch();
				}
				pstmtDetail.executeBatch();
			}

			con.commit();

		} catch (SQLException e) {
			if (con != null) {
				try {
					con.rollback();
				} catch (SQLException ex) {
					ex.printStackTrace();
				}
			}
			throw e;
		} finally {
			if (con != null) {
				try {
					con.setAutoCommit(true);
				} catch (SQLException e) {
					// ignore
				}
			}
			dbcon.dbClose(rs, pstmtMaxId, null);
			dbcon.dbClose(null, pstmtOrder, null);
			dbcon.dbClose(null, pstmtDetail, con);
		}

		return nextOrderId;
	}// insertOrder
	
}
