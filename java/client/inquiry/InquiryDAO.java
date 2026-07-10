package client.inquiry;

import java.io.File;
import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import dbcon.DbConnection;
import dbcon.Path;


public class InquiryDAO {

	private static InquiryDAO iqDAO;
	
	private InquiryDAO() {
		
	}
	
	public static InquiryDAO getInstance() {
		if(iqDAO==null) {
			iqDAO=new InquiryDAO();
		}
		return iqDAO;
	}
	
	//회원별 문의 목록 조회(일대일문의만)
	public List<InquiryDTO> selectList(String clientNo){
		
		List<InquiryDTO> list=new ArrayList<InquiryDTO>();
		DbConnection dbcon = DbConnection.getInstance();
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			String sql="SELECT i.INQUIRY_ID, i.INQUIRY_TITLE, i.INQUIRY_DATE, i.ANSWER_STATUS FROM INQUIRY i INNER JOIN INQUIRY_TYPE t ON i.INQUIRY_CODE=t.INQUIRY_CODE WHERE CLIENT_NO =? AND t.INQUIRY_CODE IN ('TYP000001','TYP000002') AND (i.INQUIRY_STATUS IS NULL OR i.INQUIRY_STATUS <> 'Y') ORDER BY i.INQUIRY_DATE DESC";
			
			pstmt=con.prepareStatement(sql);
			
			pstmt.setString(1, clientNo);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				InquiryDTO iDTO = new InquiryDTO();
				iDTO.setInquiryId(rs.getString("INQUIRY_ID"));
				iDTO.setInquiryTitle(rs.getString("INQUIRY_TITLE"));
				iDTO.setInquiryDate(rs.getDate("INQUIRY_DATE"));
				iDTO.setAnswerStatus(rs.getString("ANSWER_STATUS"));
				
				list.add(iDTO);
			}
		}catch(Exception e) {
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
	//회원별 문의 상세 조회
	public InquiryDTO selectDetail(String inquiryId) {
		
		InquiryDTO iDTO=null;
		DbConnection dbcon = DbConnection.getInstance();
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			String sql="SELECT i.INQUIRY_ID,i.INQUIRY_DATE,i.INQUIRY_TITLE,i.INQUIRY_SECRET,i.INQUIRY_CONTENT,i.ANSWER_STATUS,i.ANSWER,i.ANSWER_DATE t.INQUIRY_NAME,t.INQUIRY_TYPE "
					+ "FROM INQUIRY i "
					+ "INNER JOIN INQUIRY_TYPE t ON i.INQUIRY_CODE=t.INQUIRY_CODE "
					+ "WHERE i.INQUIRY_ID = ? AND t.INQUIRY_CODE IN ('TYP000001','TYP000002')";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, inquiryId);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				iDTO = new InquiryDTO();
				iDTO.setInquiryId(rs.getString("INQUIRY_ID"));
				iDTO.setInquiryDate(rs.getDate("INQUIRY_DATE"));
				iDTO.setInquiryTitle(rs.getString("INQUIRY_TITLE"));
				iDTO.setInquirySecret(rs.getString("INQUIRY_SECRET"));
				iDTO.setInquiryContent(rs.getString("INQUIRY_CONTENT"));
				iDTO.setAnswerStatus(rs.getString("ANSWER_STATUS"));
				iDTO.setAnswer(rs.getString("ANSWER"));
				iDTO.setAnswerDate(rs.getDate("ANSWER_DATE"));
				iDTO.setInquiryName(rs.getString("INQUIRY_NAME"));
				iDTO.setInquiryType(rs.getString("INQUIRY_TYPE"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				dbcon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return iDTO;
	}

	//문의 내역 삭제 (본인 글만 삭제 가능하도록 client_no로 소유자 확인, 소프트 삭제)
	public int deleteInquiry(String inquiryId, String clientNo) {

		int cnt = 0;
		DbConnection dbcon = DbConnection.getInstance();

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

			String sql = "DELETE FROM INQUIRY WHERE INQUIRY_ID = ? AND CLIENT_NO=? ";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, inquiryId);
			pstmt.setString(2, clientNo);

			cnt = pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbcon.dbClose(null, pstmt, con);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return cnt;
	}
	//신규 주문/결제 문의 등록
		public int insertOrderInquiry(InquiryDTO iDTO) {
			

	        int cnt = 0;

	        DbConnection dbcon = DbConnection.getInstance();
	        
	        Connection con = null;
	        PreparedStatement pstmt = null;

	        
			
			try {
				
				con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

	            StringBuilder sql = new StringBuilder();

	            sql.append(" INSERT INTO INQUIRY ");
	            sql.append(" (INQUIRY_DATE, INQUIRY_TITLE, ");
	            sql.append(" INQUIRY_SECRET, INQUIRY_CONTENT, ");
	            sql.append(" ANSWER_STATUS, INQUIRY_STATUS, ");
	            sql.append(" INQUIRY_CODE, CLIENT_NO , OPTION_ID) ");
	            sql.append(" VALUES ");
	            sql.append(" (SYSDATE, ?, ?, ?, ");
	            sql.append(" '답변대기','Y', 'TYP000001',?, ?) "); 
	            
	            pstmt = con.prepareStatement(sql.toString());
	            

	            pstmt.setString(1, iDTO.getInquiryTitle());
	            pstmt.setString(2, iDTO.getInquirySecret());
	            pstmt.setString(3, iDTO.getInquiryContent());
	            pstmt.setString(4, iDTO.getClientNo());
	            pstmt.setString(5, iDTO.getOptionNo());

	            cnt = pstmt.executeUpdate();

	        } catch(Exception e) {
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
		//신규 서비스/기타 문의 등록
		public int insertServiceInquiry(InquiryDTO iDTO) {
			
			
			int cnt = 0;
			
			DbConnection dbcon = DbConnection.getInstance();
			
			Connection con = null;
			PreparedStatement pstmt = null;
			
			
			
			try {
				
				con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
				
				StringBuilder sql = new StringBuilder();
				
				sql.append(" INSERT INTO INQUIRY ");
				sql.append(" (INQUIRY_DATE, INQUIRY_TITLE, ");
				sql.append(" INQUIRY_SECRET, INQUIRY_CONTENT, ");
				sql.append(" ANSWER_STATUS, INQUIRY_STATUS, ");
				sql.append(" INQUIRY_CODE, CLIENT_NO , OPTION_ID) ");
				sql.append(" VALUES ");
				sql.append(" (SYSDATE, ?, ?, ?, ");
				sql.append(" '답변대기','Y', 'TYP000002',?, ?) "); 
				
				pstmt = con.prepareStatement(sql.toString());
				
				
				pstmt.setString(1, iDTO.getInquiryTitle());
				pstmt.setString(2, iDTO.getInquirySecret());
				pstmt.setString(3, iDTO.getInquiryContent());
				pstmt.setString(4, iDTO.getClientNo());
				pstmt.setString(5, iDTO.getOptionNo());
				
				cnt = pstmt.executeUpdate();
				
			} catch(Exception e) {
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
}//class
