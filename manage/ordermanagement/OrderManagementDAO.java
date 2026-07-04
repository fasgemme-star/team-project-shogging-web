package manage.ordermanagement;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class OrderManagementDAO {
	private static OrderManagementDAO oDAO;
	private OrderManagementDAO() {}
	
	public static OrderManagementDAO getInstance() {
		if (oDAO == null) {
			oDAO = new OrderManagementDAO();
		}
		return oDAO;
	} // getInstance()
	
	
	public List<OrderDTO> selectOrderList(RangeDTO rDTO) throws SQLException{
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    StringBuilder query = new StringBuilder();
		/*
		 * query.
		 * append("	select od.order_details_id, o.order_id, o.delivery_status, o.order_date, po.option_id, po.option_name, po.price, po.price*(1 - po.discount * 0.01) discount_price, od.quantity, o.total_amount, od.claim_id	"
		 * ); query.append( "	from orders o	"); query.append(
		 * "	join order_details od on o.order_id = od.order_id	");
		 * query.append("	join product_option po on po.option_id = od.option_id	");
		 * query.append( "	join product p on p.product_id = po.product_id	");
		 * query.append( "	WHERE 1=1	");
		 * 
		 * if (rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
		 * query.append("AND PRODUCT_NAME LIKE ? "); } if (rDTO.getDelivery_status() !=
		 * null && !rDTO.getDelivery_status().equals("전체") &&
		 * !rDTO.getDelivery_status().isEmpty()) { query.append("AND STATUS = ? "); } if
		 * (rDTO.getStartDate() != null && !rDTO.getStartDate().isEmpty() &&
		 * rDTO.getEndDate() != null && !rDTO.getEndDate().isEmpty()) { query.
		 * append("AND REG_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 1 "
		 * ); } query.append("ORDER BY PRODUCT_ID DESC");
		 */
	    query.append("SELECT order_details_id, order_id, delivery_status, order_date, ");
	    query.append("       option_id, option_name, price, discount_price, quantity, total_amount, claim_id ");
	    query.append("FROM ( ");
	    query.append("    SELECT ROWNUM n, t.* ");
	    query.append("    FROM ( ");
	    
	    // 2. 메인 데이터 조회 쿼리 (기존 코드)
	    query.append("        SELECT od.order_details_id, o.order_id, o.delivery_status, o.order_date, ");
	    query.append("               po.option_id, po.option_name, po.price, ");
	    query.append("               po.price*(1 - po.discount * 0.01) discount_price, ");
	    query.append("               od.quantity, o.total_amount, od.claim_id ");
	    query.append("        FROM orders o ");
	    query.append("        JOIN order_details od ON o.order_id = od.order_id ");
	    query.append("        JOIN product_option po ON po.option_id = od.option_id ");
	    query.append("        JOIN product p ON p.product_id = po.product_id ");
	    query.append("        WHERE 1=1 ");
	    
	    // 동적 쿼리 조건
	    if (rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
	        query.append("        AND p.PRODUCT_NAME LIKE ? "); // 식별자를 위해 p. 추가 권장
	    }
	    if (rDTO.getDelivery_status() != null && !rDTO.getDelivery_status().equals("전체") && !rDTO.getDelivery_status().isEmpty()) {
	        query.append("        AND STATUS = ? "); // 필요시 o.delivery_status 등으로 테이블 명시 권장
	    }
	    if (rDTO.getStartDate() != null && !rDTO.getStartDate().isEmpty() && 
	            rDTO.getEndDate() != null && !rDTO.getEndDate().isEmpty()) {
	        query.append("        AND REG_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') + 1 ");
	    }
	    
	    // 정렬
	    query.append("        ORDER BY p.PRODUCT_ID DESC ");
	    
	    // 3. 페이징 래핑 종료 및 조건 추가
	    query.append("    ) t ");
	    query.append(") ");
	    query.append("WHERE n BETWEEN ? AND ? ");
	    
	    try {
            con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
            pstmt = con.prepareStatement(query.toString());

            // 3. 파라미터 매핑 (paramIndex 가변 증가 방식)
            int paramIndex = 1;
            
            if (rDTO.getKeyword() != null && !rDTO.getKeyword().trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + rDTO.getKeyword() + "%");
            }
            if (rDTO.getDelivery_status() != null && !rDTO.getDelivery_status().equals("전체") && !rDTO.getDelivery_status().isEmpty()) {
                pstmt.setString(paramIndex++, rDTO.getDelivery_status());
            }
            if (rDTO.getStartDate() != null && !rDTO.getStartDate().isEmpty() && 
            		rDTO.getEndDate() != null && !rDTO.getEndDate().isEmpty()) {
            	pstmt.setString(paramIndex++, rDTO.getStartDate());
            	pstmt.setString(paramIndex++, rDTO.getEndDate());
            }
            pstmt.setInt(paramIndex++, rDTO.getStartNum());
            pstmt.setInt(paramIndex++, rDTO.getEndNum());
            // 4. 쿼리 실행 및 결과 담기
            rs = pstmt.executeQuery();
            while (rs.next()) {
                OrderDTO oDTO = new OrderDTO();
                oDTO.setOrderDetailsID(rs.getString("order_details_id"));
                oDTO.setOrderID(rs.getString("order_id"));
                oDTO.setDeliveryStatus(rs.getString("delivery_status"));
                oDTO.setOrderDate(rs.getString("order_date"));
                oDTO.setOptionID(rs.getString("option_id")); 
                oDTO.setPrdName(rs.getString("option_name")); 
                oDTO.setPrice(rs.getInt("price")); 
                oDTO.setDiscountPrice(rs.getInt("discount_price")); 
                oDTO.setQuantity(rs.getInt("quantity")); 
                oDTO.setTotalAmount(rs.getInt("total_amount")); 
                oDTO.setClaimID(rs.getString("claim_id")); 
                
                oList.add(oDTO);
            }
        } finally {
            // 5. 자원 해제
            dbcon.dbClose(rs, pstmt, con);
        }
 
		
		return oList;
	}// selectOrderList
		
	public int updateDeliveryStatus(String orderID) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmtMaxTN = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String queryMaxTN = "SELECT MAX(tracking_number) FROM orders";
		String query = "update orders set tracking_number = ? where order_id = ?";
		
		int cnt = 0;
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			con.setAutoCommit(false);
			
			String TrackingNumber = null;
			pstmtMaxTN = con.prepareStatement(queryMaxTN);
			rs = pstmtMaxTN.executeQuery();
			if (rs.next()) {
				TrackingNumber = rs.getString(1);
			}
			
			String nextTrackingNumber = "TN000001";
			if (TrackingNumber != null && TrackingNumber.startsWith("TN")) {
	            try {
	                int num = Integer.parseInt(TrackingNumber.substring(2));
	                num++;
	                nextTrackingNumber = String.format("TN%06d", num);
	            } catch (NumberFormatException e) {
	            	
	            }
	        }
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, nextTrackingNumber);
	        pstmt.setString(2, orderID);
			cnt = pstmt.executeUpdate();
			con.commit();
		}catch(SQLException e) {
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
					e.printStackTrace();
				}
			}
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, null);
			dbcon.dbClose(null, pstmtMaxTN, con);
		} // end finally
		
		return cnt;
	}// updateDeliveryStatus
	
	public int updateClaimStatus(String claimID, String result) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		String query = "update claim set status=?, processingdate=sysdate where claim_id = ?";
		
		int cnt = 0;
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, result);
			pstmt.setString(2, claimID);
			
			cnt = pstmt.executeUpdate();
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		
		return cnt;
	}// updateClaimStatus
	
	/**
	 * @param OrderDetailid 주문상세ID
	 * @param i 0: 반품, 1: 취소
	 * @return
	 * @throws SQLException 
	 */
	public ClaimDTO selectClaimDetail(String claimID, int i) throws SQLException {
		ClaimDTO cDTO = null;
		List<String> iList =  new ArrayList<String>();
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt2 = null;
	    ResultSet rs = null;
	    ResultSet rs2 = null;
	    String cQuery = "SELECT CLAIM_ID, REQUESTDATE, CLAIM_TYPE, CLIENT_NAME, CLIENT_TEL, od.OPTION_ID, OPTION_NAME, po.price, od.quantity "
				  + "FROM claim clm JOIN order_details od ON clm.order_details_id = od.order_details_id JOIN orders o ON o.order_id = od.order_id "
				  + "JOIN client c ON c.client_no = o.client_no JOIN product_option po ON po.option_id = od.option_id WHERE claim_id = ?";
 
	String rQuery = "SELECT CLAIM_ID, REQUESTDATE, CLAIM_TYPE, CLIENT_NAME, CLIENT_TEL, od.OPTION_ID, OPTION_NAME, po.price, od.quantity, clm.reason, clm.reason_detail "
				  + "FROM claim clm JOIN order_details od ON clm.order_details_id = od.order_details_id JOIN orders o ON o.order_id = od.order_id "
				  + "JOIN client c ON c.client_no = o.client_no JOIN product_option po ON po.option_id = od.option_id WHERE claim_id = ?";     
	
	String rQueryImg = "SELECT file_name FROM claim_image WHERE claim_id = ?";
	    
	    try {
            con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
    	    if (i == 0) {				// 취소
    	    	pstmt = con.prepareStatement(cQuery);
    	    	pstmt.setString(1, claimID);
    	    	rs = pstmt.executeQuery();
    	    	
    	    	if (rs.next()) {
    	    		cDTO =  new ClaimDTO();
    	    		cDTO.setClaimID(rs.getString("CLAIM_ID"));
    	    		cDTO.setRequestDate(rs.getString("REQUESTDATE"));
    	    		cDTO.setClaimType(rs.getString("CLAIM_TYPE"));
    	    		cDTO.setClientName(rs.getString("CLIENT_NAME"));
    	    		cDTO.setClientTel(rs.getString("CLIENT_TEL"));
    	    		cDTO.setOptionID(rs.getString("OPTION_ID"));
    	    		cDTO.setPrdName(rs.getString("OPTION_NAME"));
    	    		cDTO.setPrice(rs.getInt("price"));
    	    		cDTO.setQuantity(rs.getInt("quantity"));
    	    	}
    	    	
    	    	
    	    	
    	    } else if (i == 1) {		// 반품/교환
    	    	pstmt = con.prepareStatement(rQueryImg);
    	    	pstmt.setString(1, claimID);
    	    	rs = pstmt.executeQuery();
    	    	
    	    	while(rs.next()) {
    	    		iList.add(rs.getString("file_name"));
    	    	}
    	    	
    	    	pstmt2 = con.prepareStatement(rQuery);
    	    	pstmt2.setString(1, claimID);
    	    	rs2 = pstmt2.executeQuery();

    	    	if (rs2.next()) {
    	    		cDTO =  new ClaimDTO();
    	    		cDTO.setClaimID(rs2.getString("CLAIM_ID"));
    	    		cDTO.setRequestDate(rs2.getString("REQUESTDATE"));
    	    		cDTO.setClaimType(rs2.getString("CLAIM_TYPE"));
    	    		cDTO.setClientName(rs2.getString("CLIENT_NAME"));
    	    		cDTO.setClientTel(rs2.getString("CLIENT_TEL"));
    	    		cDTO.setOptionID(rs2.getString("OPTION_ID"));
    	    		cDTO.setPrdName(rs2.getString("OPTION_NAME"));
    	    		cDTO.setPrice(rs2.getInt("price"));
    	    		cDTO.setQuantity(rs2.getInt("quantity"));
    	    		cDTO.setReason(rs2.getString("reason"));
    	    		cDTO.setReasonDetail(rs2.getString("reason_detail"));
    	    	}
    	    	if (cDTO != null) {
                    cDTO.setImg(iList);
                }
    	    	
    		}// end else if

        } finally {
            // 5. 자원 해제
        	if( pstmt2 != null) {
        		dbcon.dbClose(rs2, pstmt2, null);
        	}
            dbcon.dbClose(rs, pstmt, con);
        }

		return cDTO;
		
	}
	
}
