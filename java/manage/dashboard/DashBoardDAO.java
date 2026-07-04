package manage.dashboard;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

import dbcon.DbConnection;
import dbcon.Path;

public class DashBoardDAO {
	private static DashBoardDAO dDAO;
	private DashBoardDAO() {}
	
	public static DashBoardDAO getInstance() {
		if (dDAO == null) {
			dDAO = new DashBoardDAO();
		}
		return dDAO;
	} // getInstance()
	
	public int selectTotalSales() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select sum(total_amount) sum from orders";
		int total = 0;
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				total = rs.getInt("sum");
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
		
		return total;
	}// selectTotalSales
	
	public int selectNewClientWeekly() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "SELECT count(1) cnt FROM client WHERE client_start_date >= SYSDATE-7";
		int total = 0;
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				total = rs.getInt("cnt");
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
		
		return total;
		
	}// selectNewClientWeekly
	
	public int selectProductOnNow() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select count(1) cnt from product p join product_option po on p.product_id = po.product_id where is_deleted = 'N'";
		int cnt = 0;
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				cnt = rs.getInt("cnt");
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
		
		return cnt;
	}// selectProductOnNow
	
	public int selectNonInquiryCount() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder query = new StringBuilder();
		int total = 0;
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			query.append("select count(1) cnt from inquiry where answer_status = '대기중'");
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				total = rs.getInt("cnt");
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
		
		return total;
	}// selectNonInquiryCount
	
	public int[] selectNewClientCount() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] newClientArr = new int[12];
		String query = "SELECT cnt, year FROM( "
				 + "SELECT count(1) cnt, to_char(CLIENT_START_DATE,'YYYY-MM') as year FROM client WHERE client_delete_account = 'N' "
				 + "GROUP BY to_char(CLIENT_START_DATE,'YYYY-MM') ORDER BY year) "
				 + "WHERE year BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-12),'YYYY')||'-01' AND TO_CHAR(ADD_MONTHS(SYSDATE,-12),'YYYY')||'-12'";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			while(rs.next()) {
				String yearMonth = rs.getString("year"); 
				int month = Integer.parseInt(yearMonth.substring(5, 7)); 
				newClientArr[month - 1] = rs.getInt("cnt"); 
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
		
		return newClientArr;
	}// selectNewClientCount
	
	public int[] selectclientDropOut() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] dropOutArr = new int[12]; // 1~12월 데이터를 담을 배열 초기화
		
		String query = "SELECT cnt, year FROM( "
					 + "SELECT count(1) cnt, to_char(CLIENT_START_DATE,'YYYY-MM') as year FROM client WHERE client_delete_account = 'Y' "
					 + "GROUP BY to_char(CLIENT_START_DATE,'YYYY-MM') ORDER BY year) "
					 + "WHERE year BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-12),'YYYY')||'-01' AND TO_CHAR(ADD_MONTHS(SYSDATE,-12),'YYYY')||'-12'";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			while(rs.next()) {
				String yearMonth = rs.getString("year"); 
				int month = Integer.parseInt(yearMonth.substring(5, 7)); 
				dropOutArr[month - 1] = rs.getInt("cnt");
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
		
		return dropOutArr;
	}// selectclientDropOut
	
	public Map<String, Integer> selectBestProduct() throws SQLException{
		Map<String, Integer> product = new LinkedHashMap<>();
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "	SELECT po.option_name, SUM(od.quantity) AS quantity FROM order_details od JOIN product_option po ON od.option_id = po.option_id GROUP BY po.option_id, po.option_name ORDER BY quantity DESC FETCH FIRST 5 ROWS ONLY	";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				product.put(rs.getString("option_name"), rs.getInt("quantity"));
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
				
		return product;
	}// selectBestProduct
	
}
