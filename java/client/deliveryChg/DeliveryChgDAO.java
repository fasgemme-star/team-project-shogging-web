package client.deliveryChg;

import java.io.File;
import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;
public class DeliveryChgDAO {
	
	private static DeliveryChgDAO dDAO;
	
	private DeliveryChgDAO() {
		
	}
	
	public static DeliveryChgDAO getInstance() {
		if(dDAO==null) {
			dDAO=new DeliveryChgDAO();
		}
		return dDAO;
	}
	//회원별 배송지 목록 조회
	public List<DeliveryDTO> selectDeliveryList(String clientNo){
		
		List<DeliveryDTO> list=new ArrayList<>();
		
		DbConnection dbcon = DbConnection.getInstance();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			String sql="SELECT DELIVERY_POSTCODE,DELIVERY_ADDR,FIRST_DESTINATION "
					+ "FROM DELIVERY_DESTINATION "
					+ "WHERE CLIENT_NO=?";
			
			pstmt=con.prepareStatement(sql);
			
			pstmt.setString(1, clientNo);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				DeliveryDTO dDTO=new DeliveryDTO();
				dDTO.setDeliveryPost(rs.getString("DELIVERY_POSTCODE"));
				dDTO.setDeliveryAddr(rs.getString("DELIVERY_ADDR"));
				dDTO.setFirstDestination("Y".equals(rs.getString("FIRST_DESTINATION")));
				
				list.add(dDTO);
			}
			
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				dbcon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return list;
		
	}
	
	//신규 배송지 등록
	public int insertNewDelivery(DeliveryDTO dDTO) {
		
		int cnt=0;
		
		DbConnection dbcon = DbConnection.getInstance();
		Connection con=null;
		PreparedStatement pstmt=null;
		
		
		StringBuilder sql = new StringBuilder();

		sql.append("INSERT INTO DELIVERY_DESTINATION ");
		sql.append("(DELIVERY_POSTCODE, DELIVERY_ADDR, RECIPIENT, ");
		sql.append("RECIPIENT_PHONE, FIRST_DESTINATION, ");
		sql.append("DELIVERY_INPUT_DATE, CLIENT_NO) ");
		sql.append("VALUES (?, ?, ?, ?, ?, SYSDATE, ?)");		
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			pstmt=con.prepareStatement(sql.toString());
			
			pstmt.setString(1, dDTO.getDeliveryPost());
			pstmt.setString(2, dDTO.getDeliveryAddr());
			pstmt.setString(3, dDTO.getRecipient());
			pstmt.setString(4, dDTO.getRecipientPhone());
			pstmt.setString(5, dDTO.isFirstDestination() ? "Y" : "N");
			pstmt.setString(6, dDTO.getClientNo());
			
			cnt=pstmt.executeUpdate();
			
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				dbcon.dbClose(null, pstmt, con);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return cnt;
	}
	
	//배송지 정보 삭제
	public int removeDelivery(DeliveryDTO dDTO) {
		
		 int cnt = 0;
		 DbConnection dbcon = DbConnection.getInstance();

		    Connection con = null;
		    PreparedStatement pstmt = null;


		    try {
		    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

		        String sql = "DELETE FROM DELIVERY_DESTINATION "
		                   + "WHERE CLIENT_NO = ? AND DELIVERY_ID = ?";

		        pstmt = con.prepareStatement(sql);

		        pstmt.setString(1, dDTO.getClientNo());
		        pstmt.setString(2, dDTO.getDeliveryID());

		        cnt = pstmt.executeUpdate();

		    } catch (SQLException e) {
		        e.printStackTrace();
		    } finally {
		    	try {
					dbcon.dbClose(null, pstmt, con);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		    }

		    return cnt;
	}
}
