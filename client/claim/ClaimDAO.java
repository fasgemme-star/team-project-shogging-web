package client.claim;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class ClaimDAO {
	private static ClaimDAO cDAO;
	private ClaimDAO() {}
	
	public static ClaimDAO getInstance() {
		if (cDAO == null) {
			cDAO = new ClaimDAO();
		}
		return cDAO;
	} // getInstance()
		
	/**
	 * @param cDTO
	 * @return	1: 성공, 0: 실패
	 * @throws SQLException
	 */
	public int insertClaim(ClaimDTO cDTO) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		String query = "	insert into claim(claim_type, reason, reason_detail) values(?,?,?)	";
		int cnt = 0;
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,cDTO.getClaimType());
			pstmt.setString(2,cDTO.getReason());
			pstmt.setString(3,cDTO.getReasonDetail());
			cnt = pstmt.executeUpdate();
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		return cnt;
	}// insertClaim

	/**
	 * @param cDTO
	 * @return 1: 취소 성공, 0: 취소 실패
	 * @throws SQLException
	 */
	public int selectClaimCancel(ClaimDTO cDTO) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "	select * from order_details od join orders o on od.order_id = o.order_id where client_no = ? and order_details_id = ? and delivery_status != '배송중'	";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,cDTO.getClientID());
			pstmt.setString(2,cDTO.getOrderDetailsID());
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				return 1;
			} else {
				return 0;
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
	}
	
	

}
