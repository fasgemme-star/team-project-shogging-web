package client.prdInquiry;

import java.io.File;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import client.inquiry.InquiryDTO;
import dbcon.DbConnection;
import dbcon.Path;
public class PrdInquiryDAO {

	private static PrdInquiryDAO piDAO;
	
	private PrdInquiryDAO() {
		
	}
	
	public static PrdInquiryDAO getInstance() {
		if(piDAO==null) {
			piDAO=new PrdInquiryDAO();
		}
		return piDAO;
	}
	
	//상품별 문의 목록 조회
	public List<InquiryDTO> selectInquiryList(String prdId) {
		
		List<InquiryDTO> list = new ArrayList<>();

		DbConnection dbcon = DbConnection.getInstance();
		
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

       
		try {
			
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

            StringBuilder sql = new StringBuilder();

            sql.append(" SELECT INQUIRY_ID, INQUIRY_DATE , INQUIRY_TITLE, ANSWER_STATUS ");
            sql.append(" FROM INQUIRY ");
            sql.append(" WHERE INQUIRY_CODE='TYP000003' ");
            sql.append(" ORDER BY INQUIRY_DATE DESC ");

            pstmt = con.prepareStatement(sql.toString());

            rs = pstmt.executeQuery();

            while(rs.next()) {

                InquiryDTO iDTO = new InquiryDTO();

                iDTO.setInquiryId(rs.getString("INQUIRY_ID"));
                iDTO.setInquiryDate(rs.getDate("INQUIRY_DATE"));
                iDTO.setInquiryTitle(rs.getString("INQUIRY_TITLE"));
                iDTO.setAnswerStatus(rs.getString("ANSWER_STATUS"));

                list.add(iDTO);
            }

        } catch(Exception e) {
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
    
	//문의 상세 내용 조회 
	public InquiryDTO selectInquiryDetail(int inquiryId) {

        InquiryDTO iDto = null;

        DbConnection dbcon = DbConnection.getInstance();
        
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		
		try {
			
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

            StringBuilder sql = new StringBuilder();

            sql.append(" SELECT INQUIRY_ID, INQUIRY_DATE,INQUIRY_TITLE,INQUIRY_SECRET,INQUIRY_CONTENT,ANSWER_STATUS,ANSWER,ANSWER_DATE ");
            sql.append(" FROM INQUIRY ");
            sql.append(" WHERE INQUIRY_CODE='TYP000003' AND INQUIRY_ID = ? ");

            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1, inquiryId);

            rs = pstmt.executeQuery();
            

            if(rs.next()) {

                InquiryDTO iDTO= new InquiryDTO();

                iDTO.setInquiryId(rs.getString("INQUIRY_ID"));
                iDTO.setInquiryDate(rs.getDate("INQUIRY_DATE"));
                iDTO.setInquiryTitle(rs.getString("INQUIRY_TITLE"));
                iDTO.setInquirySecret(rs.getString("INQUIRY_SECRET"));
                iDTO.setInquiryContent(rs.getString("INQUIRY_CONTENT"));
                iDTO.setAnswerStatus(rs.getString("ANSWER_STATUS"));
                iDTO.setAnswer(rs.getString("ANSWER"));
                iDTO.setAnswerDate(rs.getDate("ANSWER_DATE"));
            }

        } catch(Exception e) {
            e.printStackTrace();
        }finally {
        	try {
				dbcon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

        return iDto;
    }
	
	//신규 상품 문의 등록
	public int insertInquiry(InquiryDTO dto) {

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
            sql.append(" ANSWER_STATUS, INQUIRY_STATUS) "); 
            sql.append(" VALUES ");
            sql.append(" (SYSDATE, ?, ?, ?, ");
            sql.append(" '답변대기', '정상') "); 
            
            pstmt = con.prepareStatement(sql.toString());
            

            pstmt.setString(1, dto.getInquiryTitle());
            pstmt.setString(2, dto.getInquirySecret());
            pstmt.setString(3, dto.getInquiryContent());

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
            
            
	//상품 문의 내용 수정
//	public int updateInquiry(InquiryDTO dto) {
//
//        int cnt = 0;
//
//        Connection con = null;
//        PreparedStatement pstmt = null;
//
//        GetConnection gc=GetConnection.getInstance();
//		
//		try {
//			
//			con=gc.getConn("dbcp");
//
//            StringBuilder sql = new StringBuilder();
//
//            sql.append(" UPDATE INQUIRY ");
//            sql.append(" SET INQUIRY_TITLE = ?, ");
//            sql.append(" INQUIRY_SECRET = ?, ");
//            sql.append(" INQUIRY_CONTENT = ? ");
//            sql.append(" WHERE INQUIRY_ID = ? ");
//
//            pstmt = con.prepareStatement(sql.toString());
//
//            pstmt.setString(1, dto.getInquiryTitle());
//            pstmt.setString(2, dto.getInquirySecret());
//            pstmt.setString(3, dto.getInquiryContent());
//            pstmt.setString(4, dto.getInquiryId());
//
//            cnt = pstmt.executeUpdate();
//
//        } catch(Exception e) {
//            e.printStackTrace();
//        }
//
//        return cnt;
//    }
	//상품 문의 삭제
//	public int deleteInquiry(String inquiryId) {
//
//        int cnt = 0;
//
//        Connection con = null;
//        PreparedStatement pstmt = null;
//
//        GetConnection gc=GetConnection.getInstance();
//		
//		try {
//			
//			con=gc.getConn("dbcp");
//
//            StringBuilder sql = new StringBuilder();
//
//            sql.append(" UPDATE INQUIRY ");
//            sql.append(" SET INQUIRY_STATUS = '삭제' ");
//            sql.append(" WHERE INQUIRY_ID = ? ");
//
//            pstmt = con.prepareStatement(sql.toString());
//
//            pstmt.setString(1, inquiryId);
//
//            cnt = pstmt.executeUpdate();
//
//        } catch(Exception e) {
//            e.printStackTrace();
//        }
//
//        return cnt;
//    }

	//상품 문의 답변(댓글) 등록 및 수정 
//
//	public int updateReply(String inquiryId, String answer) {
//    int cnt = 0;
//
//    Connection con = null;
//    PreparedStatement pstmt = null;
//
//    GetConnection gc=GetConnection.getInstance();
//	
//	try {
//		
//		con=gc.getConn("dbcp");
//
//        StringBuilder sql = new StringBuilder();
//
//        sql.append(" UPDATE INQUIRY ");
//        sql.append(" SET ANSWER = ?, ");
//        sql.append(" ANSWER_STATUS = '답변완료', ");
//        sql.append(" ANSWER_DATE = SYSDATE ");
//        sql.append(" WHERE INQUIRY_ID = ? ");
//
//        pstmt = con.prepareStatement(sql.toString());
//
//        pstmt.setString(1, answer);
//        pstmt.setString(2, inquiryId);
//
//        cnt = pstmt.executeUpdate();
//
//    } catch(Exception e) {
//        e.printStackTrace();
//    }
//
//    return cnt;
//	}
	
	//비밀글 여부 확인
	public boolean getPrivatePost(String inquiryId) {

        boolean flag = false;

        DbConnection dbcon = DbConnection.getInstance();
        
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        
		
		try {
			
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

            String sql =
                    "SELECT INQUIRY_SECRET FROM INQUIRY WHERE INQUIRY_ID = ?";

            pstmt = con.prepareStatement(sql);

            pstmt.setString(1, inquiryId);

            rs = pstmt.executeQuery();

            if(rs.next()) {

                flag = "Y".equals(rs.getString("INQUIRY_SECRET"));
            }

        } catch(Exception e) {
            e.printStackTrace();
        }finally {
        	try {
				dbcon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }

        return flag;
    }
   



	
}
