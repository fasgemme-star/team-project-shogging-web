package manage.admin;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dbcon.DbConnection;
import dbcon.Path;

public class AdminDAO {
	private static AdminDAO aDAO;
	private AdminDAO() {}
	
	public static AdminDAO getInstance() {
		if (aDAO == null) {
			aDAO = new AdminDAO();
		}
		return aDAO;
	} // getInstance()
	
	/**
	 * @param id
	 * @param pw
	 * @return 1: 로그인 성공, 0: 실패
	 * @throws SQLException
	 */
	public int selectAdmin(String id, String pw) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select manager_id from manager where manager_id = ? and manager_hash = ?";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return 1;
			}else {
				return 0;
			}
		} finally { 
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
	}// selectAdmin
	
	/**
	 * @param aDTO
	 * @param newPW
	 * @return 1: 성공, 0: 실패
	 * @throws SQLException
	 */
	public int updatePW(AdminDTO aDTO, String newPW) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		int cnt = 0;
		String query = "update manager set manager_hash = ? where manager_id = ?";
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, newPW);
			pstmt.setString(2, aDTO.getAdminID());
			cnt = pstmt.executeUpdate();
			
			
			
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		
		return cnt;
	}// updatePW
	
	public AdminDTO selectAdminInfo(String id) throws SQLException {
		AdminDTO aDTO = new AdminDTO();
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select MANAGER_NAME, MANAGER_ID, MANAGER_TEL, MANAGER_EMAIL from manager where manager_id = ?";
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				aDTO.setAdminName(rs.getString("MANAGER_NAME"));
				aDTO.setAdminID(rs.getString("MANAGER_ID"));
				aDTO.setTel(rs.getString("MANAGER_TEL"));
				aDTO.setAdminEmail(rs.getString("MANAGER_EMAIL"));
			}// end if
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(rs, pstmt, con);
		} // end finally
		return aDTO;
	}// selectAdminInfo
	
}
