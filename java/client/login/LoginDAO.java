package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBConnection;
import kr.co.sist.dao.GetConnection;
import signup.ClientDTO;

public class LoginDAO {

	private static LoginDAO lDAO;
	
	private LoginDAO() {
		
	}
	
	public static LoginDAO getInstance() {
		if(lDAO==null) {
			lDAO=new LoginDAO();
		}
		return lDAO;
	}
	//로그인 정보(아이디 및 비밀번호)일치 여부 확인
	public ClientDTO selectLoginInfo(String clientId, String clientPassword) {
		
		ClientDTO cDTO=new ClientDTO();
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		GetConnection gc=GetConnection.getInstance();
		
		try {
			
			con=gc.getConn("dbcp");
			
			StringBuilder sql=new StringBuilder();
			sql.append("SELECT CLIENT_NO,CLIENT_ID, CLIENT_NAME ");
			sql.append("FROM CLIENT ");
			sql.append("WHERE CLIENT_ID=? AND CLIENT_HASH=? ");
			
			pstmt=con.prepareStatement(sql.toString());
			
			pstmt.setString(1, clientId);
			pstmt.setString(2, clientPassword);
			
			rs=pstmt.executeQuery();
			
			if(rs.next()) {

                cDTO = new ClientDTO();

                cDTO.setClientNo(rs.getString("client_NO"));
                cDTO.setClientId(rs.getString("client_id"));
                cDTO.setClientName(rs.getString("client_name"));

            }
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				gc.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return cDTO;
	}
}
