package client.claimChk;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class ClaimChkDAO {
	private static ClaimChkDAO cDAO;
	private ClaimChkDAO() {}
	
	public static ClaimChkDAO getInstance() {
		if (cDAO == null) {
			cDAO = new ClaimChkDAO();
		}
		return cDAO;
	} // getInstance()
	
	public List<ClaimDTO> selectClaimByUserID(String userID, RangeDTO rDTO) throws SQLException{
		List<ClaimDTO> cList = new ArrayList<ClaimDTO>();
		ClaimDTO cDTO = null;
		DbConnection dbcon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    String query = "select claim_id, requestdate, reason, reason_detail, status, processingdate from claim clm join order_details od on clm.ORDER_DETAILS_ID=od.ORDER_DETAILS_ID join orders o on od.ORDER_ID = o.ORDER_ID where client_no = ? and claim_type = ?";
	    

		
		try {
		    con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
		    
		    pstmt = con.prepareStatement(query);
		    pstmt.setString(1,userID);
		    pstmt.setString(1,rDTO.getStatus());

		
		    rs = pstmt.executeQuery();
		    while (rs.next()) {
		    	cDTO = new ClaimDTO();
		    	cDTO.setClaimID(rs.getString("claim_id"));
		    	cDTO.setRequestDate(rs.getString("requestdate"));
		    	cDTO.setReason(rs.getString("reason"));
		    	cDTO.setReasonDetail(rs.getString("reason_detail"));
		    	cDTO.setClaimStatus(rs.getString("status"));
		    	cDTO.setProcessingDate(rs.getString("processingdate"));
		    	
		    	cList.add(cDTO);
		    }
		} finally {
		    // 5. 자원 해제
		    dbcon.dbClose(rs, pstmt, con);
		}
		return cList;
	}
	
	public ClaimDTO selectClaimDetail(String claimId) throws SQLException {
		ClaimDTO cDTO = null;
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "	select claim_type, requestdate, reason, reason_detail, status, processingdate from claim clm join order_details od on clm.ORDER_DETAILS_ID=od.ORDER_DETAILS_ID join orders o on od.ORDER_ID = o.ORDER_ID where claim_id=?	";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,claimId);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				cDTO = new ClaimDTO();
				cDTO.setClaimType(rs.getString("claim_type"));
				cDTO.setRequestDate(rs.getString("requestdate"));
				cDTO.setReason(rs.getString("reason"));
				cDTO.setReasonDetail(rs.getString("reason_detail"));
				cDTO.setClaimStatus(rs.getString("status"));
				cDTO.setProcessingDate(rs.getString("processingdate"));
			}
		} finally { 
			// 6.연결 끊기
			dbcon.dbClose(null, pstmt, con);
		} // end finally
		return cDTO;
	}

}
