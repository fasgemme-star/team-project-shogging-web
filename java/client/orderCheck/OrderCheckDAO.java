package client.orderCheck;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class OrderCheckDAO {
	private static OrderCheckDAO oDAO;
	private OrderCheckDAO() {}
	
	public static OrderCheckDAO getInstance() {
		if (oDAO == null) {
			oDAO = new OrderCheckDAO();
		}
		return oDAO;
	} // getInstance()

	public List<OrderDTO> selectOrderChkList(RangeDTO rDTO, String client_no) throws SQLException {
		List<OrderDTO> oList = new ArrayList<OrderDTO>();
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    ResultSet rs = null;
	    OrderDTO oDTO = null;
	    PreparedStatement pstmt = null;
		StringBuilder query = new StringBuilder();
		/*
		 * query.
		 * append("	select o.order_id, option_name, po.PRICE, po.DISCOUNT, o.DELIVERY_STATUS	"
		 * )
		 * .append("	from orders o join ORDER_DETAILS od on o.order_id=od.order_id join PRODUCT_OPTION po on od.OPTION_ID=po.OPTION_ID	"
		 * ) .append("	where client_no = ? and 1=1	");
		 * 
		 * if (rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
		 * query.append("AND option_name LIKE ? "); } if (rDTO.getDate() != null &&
		 * !rDTO.getDate().isEmpty()) {
		 * query.append("AND order_date BETWEEN ADD_MONTHS(SYSDATE, -?) AND SYSDATE ");
		 * }
		 */
		query.append("SELECT order_id, option_name, PRICE, DISCOUNT, DELIVERY_STATUS ");
	    query.append("FROM ( ");
	    query.append("    SELECT ROWNUM n, t.* ");
	    query.append("    FROM ( ");
	    
	    // 2. 메인 데이터 조회 쿼리
	    query.append("        SELECT o.order_id, po.option_name, po.PRICE, po.DISCOUNT, o.DELIVERY_STATUS ");
	    query.append("        FROM orders o ");
	    query.append("        JOIN ORDER_DETAILS od ON o.order_id = od.order_id ");
	    query.append("        JOIN PRODUCT_OPTION po ON od.OPTION_ID = po.OPTION_ID ");
	    query.append("        WHERE o.client_no = ? "); // o.client_no로 별칭 명시
	    
	    // 3. 동적 쿼리 조건 추가
	    if (rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
	        query.append("        AND po.option_name LIKE ? "); // po.option_name으로 별칭 명시
	    }
	    if (rDTO.getDate() != null && !rDTO.getDate().isEmpty()) {
	        query.append("        AND o.order_date BETWEEN ADD_MONTHS(SYSDATE, -?) AND SYSDATE ");
	    }
	    
	    // 4. 페이징 시 순서 보장을 위한 정렬 (최신순) 및 페이징 구문 닫기
	    query.append("        ORDER BY o.order_date DESC "); // 정렬 기준 추가
	    query.append("    ) t ");
	    query.append(") ");
	    query.append("WHERE n BETWEEN ? AND ? ");
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
            pstmt = con.prepareStatement(query.toString());
            
            int paramIndex = 1;
            pstmt.setString(paramIndex++, client_no);
            if (rDTO.getKeyword() != null && !rDTO.getKeyword().trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + rDTO.getKeyword() + "%");
            }
            if (rDTO.getDate() != null && !rDTO.getDate().isEmpty()) {
                pstmt.setString(paramIndex++, rDTO.getDate());
            }
            pstmt.setInt(paramIndex++, rDTO.getStartNum());
            pstmt.setInt(paramIndex++, rDTO.getEndNum());
            rs = pstmt.executeQuery();
            while(rs.next()) {
            	oDTO = new OrderDTO();
            	oDTO.setOrderID(rs.getString("order_id"));
            	oDTO.setPrdName(rs.getString("option_name"));
            	oDTO.setPrice(rs.getInt("PRICE"));
            	oDTO.setDiscount(rs.getInt("DISCOUNT"));
            	oDTO.setDeliveryStatus(rs.getString("DELIVERY_STATUS"));
            	oList.add(oDTO);
            }
            
		} finally {
			dbcon.dbClose(rs, pstmt, con);
		}
	    return oList;
	}// selectOrderChkList


	

}
