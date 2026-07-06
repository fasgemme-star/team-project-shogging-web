package client.usermain;

import java.io.File;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import client.productDetail.ProductDTO;
import dbcon.DbConnection;
import dbcon.Path;
public class UserMainDAO {

	private static UserMainDAO umDAO;
	
	private UserMainDAO() {
		
		
	}
	
	public static UserMainDAO getInstance() {
		if(umDAO==null) {
			umDAO=new UserMainDAO();
		}
		return umDAO;
	}
	
	//베스트 상품 목록 조회 
	public List<ProductDTO> selectBest(){
		
		
		List<ProductDTO> list=new ArrayList<>();
		
		DbConnection dbcon = DbConnection.getInstance();
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		
		try {
			
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			String sql=" SELECT pi.url, p.PRODUCT_ID,p.PRODUCT_NAME,p.SHORTINFO,po.DISCOUNT,po.PRICE, SUM(od.QUANTITY) sales_count "
					+ "FROM ORDER_DETAILS od "
					+ "INNER JOIN PRODUCT_OPTION po ON od.OPTION_ID = po.OPTION_ID "
					+ "INNER JOIN PRODUCT p ON po.PRODUCT_ID = p.PRODUCT_ID "
					+ "INNER JOIN PRODUCT_IMAGE pi ON pi.PRODUCT_ID =p.PRODUCT_ID "
					+ "WHERE pi.IMAGE_TYPE ='THUMB' "
					+ "GROUP BY pi.url, p.PRODUCT_ID, p.PRODUCT_NAME, p.SHORTINFO,po.DISCOUNT, po.PRICE "
					+ "ORDER BY sales_count DESC";
			
			pstmt=con.prepareStatement(sql);
			
			rs=pstmt.executeQuery();
			
			while (rs.next()) {
				ProductDTO pDTO=new ProductDTO();
				
				pDTO.setUrl(rs.getString("URL"));
				pDTO.setPrdID(rs.getString("PRODUCT_ID"));
	    	    pDTO.setPrdName(rs.getString("PRODUCT_NAME"));
	    	    pDTO.setDiscount(rs.getInt("DISCOUNT"));
	    	    pDTO.setPrice(rs.getInt("PRICE"));
	    	    pDTO.setShortInfo(rs.getString("SHORTINFO"));
				
				list.add(pDTO);
			}
			
		} catch (Exception e) {
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
	
	//세일 상품 목록 조회 
	public List<ProductDTO> selectSale(){
		
		List<ProductDTO> list=new ArrayList<>();
		
		DbConnection dbcon = DbConnection.getInstance();
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			
			String sql="SELECT pi.url,p.PRODUCT_ID, p.PRODUCT_NAME,po.DISCOUNT, po.PRICE, p.SHORTINFO "
					+ "FROM PRODUCT p  "
					+ "INNER JOIN product_option po ON p.product_ID=po.product_id "
					+ "INNER JOIN PRODUCT_IMAGE pi ON pi.PRODUCT_ID =p.PRODUCT_ID "
					+ "WHERE po.DISCOUNT >0 AND pi.IMAGE_TYPE ='THUMB' "
					+ "ORDER BY po.DISCOUNT DESC";
			
			pstmt=con.prepareStatement(sql);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				
				ProductDTO pDTO=new ProductDTO();
				
				pDTO.setUrl(rs.getString("URL"));
				pDTO.setPrdID(rs.getString("PRODUCT_ID"));
	    	    pDTO.setPrdName(rs.getString("PRODUCT_NAME"));
	    	    pDTO.setDiscount(rs.getInt("DISCOUNT"));
	    	    pDTO.setPrice(rs.getInt("PRICE"));
	    	    pDTO.setShortInfo(rs.getString("SHORTINFO"));
				
				list.add(pDTO);
				
			}
			
			
		} catch (Exception e) {
			
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
	
	//카테고리별 상품 목록 조회
	public List<ProductDTO> selectCategory(RangeDTO range){

	    List<ProductDTO> list = new ArrayList<>();

	    DbConnection dbcon = DbConnection.getInstance();
	    
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;


	    try {

	    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

	        String sql =
	        		"SELECT * " +
	        		"FROM ( " +
	        		"    SELECT A.*, ROWNUM RN " +
	        		"    FROM ( " +
	        		"        SELECT p.PRODUCT_ID, " +
	        		"               p.PRODUCT_NAME, " +
	        		"               p.SHORTINFO, " +
	        		"               po.PRICE, " +
	        		"               po.DISCOUNT, " +
	        		"               pi.URL " +
	        		"        FROM PRODUCT p " +
	        		"        INNER JOIN PRODUCT_OPTION po " +
	        		"            ON p.PRODUCT_ID = po.PRODUCT_ID " +
	        		"        INNER JOIN CATEGORY c " +
	        		"            ON p.CATEGORY_ID = c.CATEGORY_ID " +
	        		"        INNER JOIN PRODUCT_IMAGE pi " +
	        		"            ON p.PRODUCT_ID = pi.PRODUCT_ID " +
	        		"        WHERE c.CATEGORY_NAME = ? " +
	        		"          AND pi.IMAGE_TYPE = 'THUMB' " +
	        		"        ORDER BY p.PRODUCT_ID DESC " +
	        		"    ) A " +
	        		"    WHERE ROWNUM <= ? " +
	        		") " +
	        		"WHERE RN >= ?";

	        pstmt = con.prepareStatement(sql);

	        pstmt.setString(1, range.getKeyword());
	        pstmt.setInt(2, range.getEndNum());
	        pstmt.setInt(3, range.getStartNum());

	        rs = pstmt.executeQuery();

	        while(rs.next()) {

	            ProductDTO pDTO = new ProductDTO();

	            pDTO.setUrl(rs.getString("URL"));
				pDTO.setPrdID(rs.getString("PRODUCT_ID"));
	    	    pDTO.setPrdName(rs.getString("PRODUCT_NAME"));
	    	    pDTO.setDiscount(rs.getInt("DISCOUNT"));
	    	    pDTO.setPrice(rs.getInt("PRICE"));
	    	    pDTO.setShortInfo(rs.getString("SHORTINFO"));

	            list.add(pDTO);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	    	try {
				dbcon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }

	    return list;
	}
	
	//카테고리별 전체 상품 개수
	public int selectTotalCount(RangeDTO range) {

	    int cnt = 0;

	    DbConnection dbcon = DbConnection.getInstance();
	    
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;


	    try {

	    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

	        String sql =
	        "SELECT COUNT(*) " +
	        "FROM PRODUCT p " +
	        "INNER JOIN CATEGORY c " +
	        "ON p.CATEGORY_ID = c.CATEGORY_ID " +
	        "WHERE c.CATEGORY_NAME = ?";

	        pstmt = con.prepareStatement(sql);

	        pstmt.setString(1, range.getKeyword());

	        rs = pstmt.executeQuery();

	        if(rs.next()) {
	            cnt = rs.getInt(1);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	    	try {
				dbcon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }

	    return cnt;
	}

	
}
