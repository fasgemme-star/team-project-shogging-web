package findId;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBConnection;
import kr.co.sist.dao.GetConnection;
import signup.ClientDTO;

public class FindIdDAO {

	private static FindIdDAO fidDAO;
	
	private FindIdDAO() {
	
	}
	
	public static FindIdDAO getInstance() {
		if(fidDAO==null) {
			fidDAO=new FindIdDAO();
		}
		return fidDAO;
	}//FindIdDAO
	
	//회원 이름과 이메일 정보로 회원 ID조회
	public ClientDTO selectClientId(String clientName, String clientEmail) {
		
		ClientDTO cDTO = null;
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		GetConnection gc=GetConnection.getInstance();
		
		try {
			
			con=gc.getConn("dbcp");
			
			String sql="SELECT CLIENT_ID FROM CLIENT WHERE CLIENT_NAME=? AND CLIENT_EMAIL=?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, clientName);
			pstmt.setString(2, clientEmail);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {

			    cDTO = new ClientDTO();

			    cDTO.setClientId(rs.getString("CLIENT_ID"));

			}
			
		}catch(SQLException se) {
		    se.printStackTrace();
	    } finally {
	    	try {
				gc.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				e.printStackTrace();
			}
	    }//try
		
		return cDTO;
		
	}//selectClientId
	
}//class
