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
	
	public int insertPayment(OrderDTO orderDTO) {
		return 0;
	}// insertPayment
	
	public String insertOrder(OrderDTO orderDTO) {
        return null;
    }// insertOrder
	
       

	
}
