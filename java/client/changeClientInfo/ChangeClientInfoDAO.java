package changeClientInfo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.sist.dao.GetConnection;
import signup.ClientDTO;

public class ChangeClientInfoDAO {

	private static ChangeClientInfoDAO cciDAO;
	
	private ChangeClientInfoDAO() {
		
	}
	
	public static ChangeClientInfoDAO getInstance() {
		if(cciDAO==null) {
			cciDAO=new ChangeClientInfoDAO();
		}
		return cciDAO;
	}
	//회원 비밀번호 일치 여부 확인
	public boolean verifyPassword(String clientID, String hashPassword) {
		boolean flag = false;

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    GetConnection gc = GetConnection.getInstance();

	    try {

	        con = gc.getConn("dbcp");

	        StringBuilder sql = new StringBuilder();

	        sql.append("SELECT COUNT(*) ");
	        sql.append("FROM client ");
	        sql.append("WHERE client_id = ? ");
	        sql.append("AND client_hash = ?");

	        pstmt = con.prepareStatement(sql.toString());

	        pstmt.setString(1, clientID);
	        pstmt.setString(2, hashPassword);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            flag = rs.getInt(1) == 1;
	        }

	    } catch (SQLException se) {
	        se.printStackTrace();
	    } finally {
	    	try {
				gc.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				e.printStackTrace();
			}
	    }

	    return flag;
	}
	//회원 정보 수정(조회)
	public ClientDTO selectUserInfo(String clientID) {
		ClientDTO cDTO=null;
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		GetConnection gc=GetConnection.getInstance();
		
		try {
			con=gc.getConn("dbcp");
			
			String sql = "SELECT CLIENT_ID, CLIENT_NAME, CLIENT_EMAIL, CLIENT_TEL, CLIENT_BIRTH, CLIENT_CHECK " +
                    "FROM CLIENT WHERE CLIENT_ID = ?";

       pstmt = con.prepareStatement(sql);
       pstmt.setString(1, clientID);

       rs = pstmt.executeQuery();

       if (rs.next()) {
           cDTO = new ClientDTO();

           cDTO.setClientId(rs.getString("CLIENT_ID"));
           cDTO.setClientName(rs.getString("CLIENT_NAME"));
           cDTO.setClientEmail(rs.getString("CLIENT_EMAIL"));
           cDTO.setClientTel(rs.getString("CLIENT_TEL"));
           cDTO.setClientBirth(rs.getString("CLIENT_BIRTH"));
           cDTO.setClientCheck(rs.getString("CLIENT_CHECK"));
       	}

		} catch (Exception e) {
			e.printStackTrace();
   		} finally {
   			try {
				gc.dbClose(rs, pstmt, con);
			} catch (Exception e) {
				e.printStackTrace();
			}
   		}

		return cDTO;

				
	}
	//회원 정보 수정(업데이)
	public int updateUserInfo(ClientDTO cDTO) {
		
		int rowCnt = 0;

	    Connection con = null;
	    PreparedStatement pstmt = null;

	    GetConnection gc = GetConnection.getInstance();

	    try {

	        con = gc.getConn("dbcp");

	        StringBuilder sql = new StringBuilder();
	        sql.append("UPDATE client ");
	        sql.append("SET client_name = ?, ");
	        sql.append("    client_email = ?, ");
	        sql.append("    client_tel = ? ");
	        sql.append("WHERE client_id = ?");

	        pstmt = con.prepareStatement(sql.toString());

	        pstmt.setString(1, cDTO.getClientName());
	        pstmt.setString(2, cDTO.getClientEmail());
	        pstmt.setString(3, cDTO.getClientTel());
	        pstmt.setString(4, cDTO.getClientId());

	        rowCnt = pstmt.executeUpdate();

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            gc.dbClose(null, pstmt, con);
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    return rowCnt;
		
		
	}
	//회원 비밀번호 변경
	public int updatePassword(String clientID, String newPassword) {
		int rowCnt = 0;

	    Connection con = null;
	    PreparedStatement pstmt = null;

	    GetConnection gc = GetConnection.getInstance();

	    try {

	        con = gc.getConn("dbcp");

	        StringBuilder sql = new StringBuilder();

	        sql.append("UPDATE client ");
	        sql.append("SET client_hash = ?, ");
	        sql.append("    client_last_date = SYSDATE ");
	        sql.append("WHERE client_id = ?");

	        pstmt = con.prepareStatement(sql.toString());

	        pstmt.setString(1, newPassword);
	        pstmt.setString(2, clientID);

	        rowCnt = pstmt.executeUpdate();

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            gc.dbClose(null, pstmt, con);
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    return rowCnt;
	}
	//회원 탈퇴 처리
	public int deleteMember(String clientID) {
		int rowCnt = 0;

	    Connection con = null;
	    PreparedStatement pstmt = null;

	    GetConnection gc = GetConnection.getInstance();

	    try {

	        con = gc.getConn("dbcp");

	        StringBuilder sql = new StringBuilder();

	        sql.append("UPDATE client ");
	        sql.append("SET client_delete_account = 'Y', ");
	        sql.append("    client_last_date = SYSDATE ");
	        sql.append("WHERE client_id = ?");

	        pstmt = con.prepareStatement(sql.toString());

	        pstmt.setString(1, clientID);

	        rowCnt = pstmt.executeUpdate();

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            gc.dbClose(null, pstmt, con);
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    return rowCnt;
	}
}
