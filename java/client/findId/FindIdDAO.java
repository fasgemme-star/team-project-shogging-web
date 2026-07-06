package client.findId;

import java.io.File;


import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import client.signup.ClientDTO;
import dbcon.DbConnection;
import dbcon.Path;

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
		DbConnection dbcon = DbConnection.getInstance();
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		
		try {
			
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
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
				dbcon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }//try
		
		return cDTO;
		
	}//selectClientId
	
}//class
