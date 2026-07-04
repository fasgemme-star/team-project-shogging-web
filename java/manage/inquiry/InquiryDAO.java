package manage.inquiry;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class InquiryDAO {
	private static InquiryDAO iDAO;
	private InquiryDAO() {}
	
	public static InquiryDAO getInstance() {
		if (iDAO == null) {
			iDAO = new InquiryDAO();
		}
		return iDAO;
	} // getInstance()
	
	public int selectInquiryCnt() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select count(1) cnt from inquiry where ANSWER_STATUS = '대기중'";
		int cnt = 0;
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				cnt = rs.getInt("cnt");
			}

		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
		
		return cnt;
	}// selectInquiryCnt

	/**
	 * @param status 전체: 0, 미처리: 1, 완료: 2
	 * @return
	 * @throws SQLException
	 */
	
	public List<InquiryDTO> selectInquiryList(RangeDTO rDTO) throws SQLException{
		List<InquiryDTO> iList = new ArrayList<InquiryDTO>();
		InquiryDTO iDTO = null;
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    StringBuilder sb = new StringBuilder();

	    sb.append("SELECT client_no, client_name, inquiry_id, inquiry_title, inquiry_content, ");
	    sb.append("       inquiry_date, answer_status, answer, answer_date, inquiry_type, order_details_id ");
	    sb.append("FROM ( ");
	    sb.append("    SELECT ROWNUM n, t.* ");
	    sb.append("    FROM ( ");
	    sb.append("        SELECT c.client_no, ");
	    sb.append("               c.client_name, ");
	    sb.append("               i.inquiry_id, ");
	    sb.append("               i.inquiry_title, ");
	    sb.append("               i.inquiry_content, ");
	    sb.append("               i.inquiry_date, ");
	    sb.append("               i.answer_status, ");
	    sb.append("               i.answer, ");
	    sb.append("               i.answer_date, ");
	    sb.append("               it.inquiry_type, ");
	    sb.append("               od.order_details_id ");
	    sb.append("        FROM client c ");
	    sb.append("        JOIN orders o ");
	    sb.append("          ON c.client_no = o.client_no ");
	    sb.append("        JOIN order_details od ");
	    sb.append("          ON o.order_id = od.order_id ");
	    sb.append("        JOIN inquiry i ");
	    sb.append("          ON od.order_details_id = i.order_details_id ");
	    sb.append("        JOIN inquiry_type it ");
	    sb.append("          ON i.inquiry_code = it.inquiry_code ");
	    sb.append("        WHERE 1 = 1 ");
	    
	    try {
            con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
            //전체: 0, 미처리: 1, 완료: 2
            if (rDTO.getStatus() != 0) {
            	sb.append(" AND	ANSWER_STATUS = ?	");
            }
            int index = 0;
   
            
            sb.append("        ORDER BY i.inquiry_date DESC ");
            sb.append("    ) t ");
            sb.append(") ");
            sb.append("WHERE n BETWEEN ? AND ?");
            pstmt = con.prepareStatement(sb.toString());
            
            if(rDTO.getStatus() == 1) {
            	pstmt.setString(++index,"대기중");
            } else if (rDTO.getStatus() == 2) {
            	pstmt.setString(++index,"답변완료");
            }
    		pstmt.setInt(++index, rDTO.getStartNum());
			pstmt.setInt(++index, rDTO.getEndNum());
			
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	iDTO = new InquiryDTO();
            	iDTO.setClientNo(rs.getString("client_no"));
            	iDTO.setClientName(rs.getString("client_name"));
            	iDTO.setInquiryID(rs.getString("INQUIRY_ID"));
            	iDTO.setTitle(rs.getString("INQUIRY_TITLE"));
            	iDTO.setContent(rs.getString("INQUIRY_CONTENT"));
            	iDTO.setInquiryDate(rs.getString("INQUIRY_DATE"));
            	iDTO.setStatus(rs.getString("ANSWER_STATUS"));
            	iDTO.setAnswer(rs.getString("ANSWER"));
            	iDTO.setAnswerDate(rs.getString("ANSWER_DATE"));
            	iDTO.setInquiryType(rs.getString("INQUIRY_TYPE"));
            	iDTO.setOrderID(rs.getString("ORDER_DETAILS_ID"));
           
            	iList.add(iDTO);
            }
        } finally {
            // 5. 자원 해제
            dbcon.dbClose(rs, pstmt, con);
        }

		return iList;
	}// selectInquiryList
	
	public InquiryDTO selectInquiryDetail(String inqudityID) throws SQLException {
		InquiryDTO iDTO = new InquiryDTO();
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    StringBuilder query = new StringBuilder();
		query.append("	select c.client_no, c.client_name, INQUIRY_TITLE, INQUIRY_CONTENT,	");
		query.append( "	INQUIRY_DATE, ANSWER_STATUS, ANSWER, ANSWER_DATE, it.INQUIRY_TYPE, od.ORDER_DETAILS_ID	");
		query.append( "	from client c	");
		query.append( "	join orders o on c.CLIENT_NO = o.CLIENT_NO	");
		query.append("	join ORDER_DETAILS od on o.ORDER_ID = od.ORDER_ID	");
		query.append("	join inquiry i on od.ORDER_DETAILS_ID = i.ORDER_DETAILS_ID	");
		query.append( "	join INQUIRY_TYPE it on i.INQUIRY_CODE = it.INQUIRY_CODE where inquiry_id = ? ");

		try {
		    con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
		    
		    pstmt = con.prepareStatement(query.toString());
		    pstmt.setString(1,inqudityID);

		
		    rs = pstmt.executeQuery();
		    if (rs.next()) {
		    	iDTO.setClientNo(rs.getString("client_no"));
		    	iDTO.setClientName(rs.getString("client_name"));
		    	iDTO.setTitle(rs.getString("INQUIRY_TITLE"));
		    	iDTO.setContent(rs.getString("INQUIRY_CONTENT"));
		    	iDTO.setInquiryDate(rs.getString("INQUIRY_DATE"));
		    	iDTO.setStatus(rs.getString("ANSWER_STATUS"));
		    	iDTO.setAnswer(rs.getString("ANSWER"));
		    	iDTO.setAnswerDate(rs.getString("ANSWER_DATE"));
		    	iDTO.setInquiryType(rs.getString("INQUIRY_TYPE"));
		    	iDTO.setOrderID(rs.getString("ORDER_DETAILS_ID"));
		    }
		} finally {
		    // 5. 자원 해제
		    dbcon.dbClose(rs, pstmt, con);
		}

		return iDTO;
	}// selectInquiryDetail
		
	public int updateInquiryAnswer(String inquiryID, String answer) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		String query = "update inquiry set answer = ?, answer_status = '답변완료', answer_date = sysdate where inquiry_id = ?";
		int cnt = 0;
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, answer);
			pstmt.setString(2, inquiryID);
			
			cnt = pstmt.executeUpdate();
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		
		return cnt;
	}// updateInquiryAnswer
	
	public int deleteInquiry(String inquiryID) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		String query = "update inquiry set inquiry_status = 'Y' where inquiry_id = ?";
		int cnt = 0;
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, inquiryID);
			
			cnt = pstmt.executeUpdate();
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		
		return cnt;
	}// deleteInquiry
	
	public OrderDTO selectOrderDetail(String orderID) throws SQLException {
		OrderDTO oDTO = new OrderDTO();
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String query = "SELECT od.order_details_id, o.order_id, o.delivery_status, o.order_date, po.option_id, po.option_name, po.price, po.price*(1 - po.discount * 0.01) discount_price, od.quantity, o.total_amount "
				 + "FROM orders o JOIN order_details od ON o.order_id = od.order_id "
				 + "JOIN product_option po ON po.option_id = od.option_id "
				 + "JOIN product p ON p.product_id = po.product_id "
				 + "WHERE order_details_id = ?";
		try {
            con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, orderID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
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
            }
        } finally {
            // 5. 자원 해제
            dbcon.dbClose(rs, pstmt, con);
        }
		return oDTO;
	}// selectOrderDetail
	
}
