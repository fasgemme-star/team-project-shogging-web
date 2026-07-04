package signup;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBConnection;
import kr.co.sist.dao.GetConnection;

public class SignupDAO {

	private static SignupDAO sDAO;
	
	private SignupDAO() {
		
	}
	
	public static SignupDAO getInstance() {
		if(sDAO==null) {
			sDAO=new SignupDAO();
		}
		return sDAO;
	}
	//아이디 중복 확인
	public int selectID(ClientDTO cDTO) {
		 int cnt = 0;

		    Connection con = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;

		    GetConnection gc=GetConnection.getInstance();
			
			try {
				
				con=gc.getConn("dbcp");

		        String sql =
		                "SELECT COUNT(*) FROM CLIENT WHERE CLIENT_ID = ?";

		        pstmt = con.prepareStatement(sql);
		        pstmt.setString(1, cDTO.getClientId());

		        rs = pstmt.executeQuery();

		        if(rs.next()) {
		            cnt = rs.getInt(1);
		        }

		    } catch(SQLException se) {
		        se.printStackTrace();
		    } finally {
		    	try {
					gc.dbClose(rs, pstmt, con);
				} catch (SQLException e) {
					e.printStackTrace();
				}
		    }

		    return cnt;
	}
	//신규 회원 정보 삽입(회원가입 처리)
	public int insertClient(ClientDTO cDTO) {
		 	int rowCnt = 0;

		    Connection con = null;
		    PreparedStatement pstmt = null;

		    GetConnection gc=GetConnection.getInstance();
			
			try {
				
				con=gc.getConn("dbcp");

		        StringBuilder sql = new StringBuilder();

		        sql.append("insert into client(");
		        sql.append("client_id, client_hash, ");
		        sql.append("client_name, client_email, client_tel, ");
		        sql.append("client_birth, client_ip, client_check, ");
		        sql.append("client_start_date, client_delete_account, client_last_date");
		        sql.append(") values(");
		        sql.append(" ?, ?, ?, ?, ?, ?, ?, ?, sysdate, 'N', null");
		        sql.append(")");

		        pstmt = con.prepareStatement(sql.toString());

		        pstmt.setString(1, cDTO.getClientId());
		        pstmt.setString(2, cDTO.getClientHash()); 
		        pstmt.setString(3, cDTO.getClientName());
		        pstmt.setString(4, cDTO.getClientEmail());
		        pstmt.setString(5, cDTO.getClientTel());
		        pstmt.setString(6, cDTO.getClientBirth());
		        pstmt.setString(7, cDTO.getClientIp());
		        pstmt.setString(8, "정상");

		        rowCnt = pstmt.executeUpdate();

		    } catch(SQLException se) {
		        se.printStackTrace();
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
