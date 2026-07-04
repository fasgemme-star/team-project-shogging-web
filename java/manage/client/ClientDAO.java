package manage.client;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class ClientDAO {
	private static ClientDAO cDAO;
	private ClientDAO() {}
	
	public static ClientDAO getInstance() {
		if (cDAO == null) {
			cDAO = new ClientDAO();
		}
		return cDAO;
	} // getInstance()
	
	public int selectTotalClient() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select count(1) cnt from client";
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
	}// selectTotalClient
	
	public int selectNewClient() throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "select count(1) cnt from client where client_start_date >= SYSDATE-30";
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
		
	}// selectNewClient
	
	public List<ClientDTO> selectClientList(RangeDTO rDTO) throws SQLException{
		List<ClientDTO> cList = new ArrayList<ClientDTO>();
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    StringBuilder query = new StringBuilder();
	    
	    query.append(" select CLIENT_NO, CLIENT_NAME, CLIENT_EMAIL, CLIENT_TEL, CLIENT_START_DATE from( ")
	    .append("		select rownum n, CLIENT_NO, CLIENT_NAME, CLIENT_EMAIL, CLIENT_TEL, CLIENT_START_DATE from(  ")
	    .append("		select CLIENT_NO, CLIENT_NAME, CLIENT_EMAIL, CLIENT_TEL, CLIENT_START_DATE from client where CLIENT_DELETE_ACCOUNT = 'N' and 1=1 ");
	    
	    if (rDTO.getKeyword() != null && !rDTO.getKeyword().trim().isEmpty()) {
	        query.append("AND (CLIENT_NAME LIKE ? OR CLIENT_EMAIL LIKE ? OR CLIENT_TEL LIKE ?) ");
	    }
	    
	    query.append("		order by client_start_date desc ))  ")
	    .append("		where n between ? and ?  ");
	    
	    try {
            con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
            pstmt = con.prepareStatement(query.toString());

            int paramIndex = 1;
            
            if (rDTO.getKeyword() != null && !rDTO.getKeyword().trim().isEmpty()) {
                String searchPattern = "%" + rDTO.getKeyword().trim() + "%";
                pstmt.setString(paramIndex++, searchPattern); // CLIENT_NAME 매핑
                pstmt.setString(paramIndex++, searchPattern); // CLIENT_EMAIL 매핑
                pstmt.setString(paramIndex++, searchPattern); // CLIENT_PHONE 매핑
            }
            pstmt.setInt(paramIndex++, rDTO.getStartNum()); 
            pstmt.setInt(paramIndex++, rDTO.getEndNum()); 
            
            // 4. 쿼리 실행 및 결과 담기
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ClientDTO cDTO = new ClientDTO();
                cDTO.setClientNo(rs.getString("CLIENT_NO"));
                cDTO.setClientName(rs.getString("CLIENT_NAME"));
                cDTO.setEmail(rs.getString("CLIENT_EMAIL"));
                cDTO.setPhone(rs.getString("CLIENT_TEL"));
                cDTO.setJoinDate(rs.getString("CLIENT_START_DATE"));
                
                cList.add(cDTO);
            }
        } finally {
            // 5. 자원 해제
            dbcon.dbClose(rs, pstmt, con);
        }

		return cList;
	}// selectClientList
	
	public ClientDTO selectClientDetail(String clientID) throws SQLException {
		ClientDTO cDTO = new ClientDTO();
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String query = "SELECT c.CLIENT_NAME, c.CLIENT_EMAIL, c.CLIENT_TEL, c.CLIENT_START_DATE, NVL(SUM(o.TOTAL_AMOUNT), 0) AS TOTAL_AMOUNT "
				 + "FROM client c LEFT OUTER JOIN orders o ON c.client_no = o.client_no "
				 + "WHERE c.client_no = ? "
				 + "GROUP BY c.CLIENT_NAME, c.CLIENT_EMAIL, c.CLIENT_TEL, c.CLIENT_START_DATE";
	    
	    try {
            con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, clientID);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                cDTO.setClientName(rs.getString("CLIENT_NAME"));
                cDTO.setEmail(rs.getString("CLIENT_EMAIL"));
                cDTO.setPhone(rs.getString("CLIENT_TEL"));
                cDTO.setJoinDate(rs.getString("CLIENT_START_DATE"));
                cDTO.setTotalPayment(rs.getInt("TOTAL_AMOUNT"));
            }
        } finally {
            // 5. 자원 해제
            dbcon.dbClose(rs, pstmt, con);
        }

		return cDTO;
	}// selectClientDetail
	
	/**
	 * @param ClientNo
	 * @param newPW 랜덤 비밀번호
	 * @return 1: 성공, 0: 실패
	 * @throws SQLException
	 */
	public int updateClientPW(String ClientNo, String newPW) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String query = "	update client set client_hash=? where client_no = ?	";
	    
	    int cnt = 0;
	    
	    try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, newPW);
			pstmt.setString(2, ClientNo);
			cnt = pstmt.executeUpdate();

		} finally {

			dbcon.dbClose(null, pstmt, con);

		} // end finally
		
		return cnt;
	}// updateClientPW
	
	public String selectEmail(String id) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String query = " select CLIENT_EMAIL from client where client_id = ?";
	    String email = null;
	    try {
            con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, id);

            rs = pstmt.executeQuery();
            if (rs.next()) {
            	email = rs.getString("CLIENT_EMAIL");
            }
        } finally {
            // 5. 자원 해제
            dbcon.dbClose(rs, pstmt, con);
        }

		return email;
	}
	
	//파일출력 메소드 추가
}
