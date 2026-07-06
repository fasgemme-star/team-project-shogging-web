package client.bestSale;

import java.io.File;



import client.productDetail.*;
import client.usermain.*;
import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class BestSaleDAO {

	private static BestSaleDAO bsDAO;
	
	private BestSaleDAO() {
		
	}
	
	public static BestSaleDAO getInstance() {
		if(bsDAO==null) {
			bsDAO=new BestSaleDAO();
		}
		return bsDAO;
	}
	//베스트 상품 조회
	public List<ProductDTO> bestProduct(RangeDTO rDTO){
		
		List<ProductDTO> list=new ArrayList<>();
		DbConnection dbcon = DbConnection.getInstance();

	    Connection con=null;
	    PreparedStatement pstmt=null;
	    ResultSet rs=null;
	    
	    
	    try {
	    	
	    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
	    	
	    	String sql=" SELECT pi.url, p.PRODUCT_ID,p.PRODUCT_NAME,p.SHORTINFO,po.DISCOUNT,po.PRICE, SUM(od.QUANTITY) sales_count "
	    			+ "FROM ORDER_DETAILS od  "
	    			+ "INNER JOIN PRODUCT_OPTION po ON od.OPTION_ID = po.OPTION_ID  "
	    			+ "INNER JOIN PRODUCT p ON po.PRODUCT_ID = p.PRODUCT_ID  "
	    			+ "INNER JOIN PRODUCT_IMAGE  pi ON pi.PRODUCT_ID = p.PRODUCT_ID  "
	    			+ "WHERE pi.IMAGE_TYPE ='THUMB' "
	    			+ "GROUP BY pi.url, p.PRODUCT_ID, p.PRODUCT_NAME, p.SHORTINFO,po.DISCOUNT, po.PRICE "
	    			+ "ORDER BY sales_count DESC";
	    	
	    	pstmt=con.prepareStatement(sql);
	    	
	    	rs=pstmt.executeQuery();
	    	
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
	//인기급상숭 상품 조회
	public List<ProductDTO> risingProduct(RangeDTO rDTO){
		
		List<ProductDTO> list=new ArrayList<>();

		DbConnection dbcon = DbConnection.getInstance();
	    Connection con=null;
	    PreparedStatement pstmt=null;
	    ResultSet rs=null;
	    
	    
	    try {
	    	
	    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
	    	
	    	String sql="SELECT pi.URL, p.PRODUCT_ID, p.PRODUCT_NAME,po.DISCOUNT, po.PRICE, p.SHORTINFO,SUM(od.QUANTITY) AS sales_count "
	    			+ "FROM ORDER_DETAILS od "
	    			+ "INNER JOIN ORDERS o ON od.ORDER_ID = o.ORDER_ID    "
	    			+ "INNER JOIN PRODUCT_OPTION po ON od.OPTION_ID = po.OPTION_ID "
	    			+ "INNER JOIN PRODUCT p ON po.PRODUCT_ID = p.PRODUCT_ID "
	    			+ "INNER JOIN PRODUCT_IMAGE  pi ON pi.PRODUCT_ID = p.PRODUCT_ID  "
	    			+ "WHERE o.ORDER_DATE >= SYSDATE - 7 AND pi.IMAGE_TYPE ='THUMB'  "
	    			+ "GROUP BY pi.URL, p.PRODUCT_ID,p.PRODUCT_NAME,po.DISCOUNT,po.PRICE, p.SHORTINFO "
	    			+ "ORDER BY sales_count DESC";
	    	
	    	pstmt=con.prepareStatement(sql);
	    	
	    	rs=pstmt.executeQuery();
	    	
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
	
	//알뜰 쇼핑 상품 조회
	public List<ProductDTO> economyProduct(RangeDTO rDTO){
		
		List<ProductDTO> list=new ArrayList<>();
		DbConnection dbcon = DbConnection.getInstance();

	    Connection con=null;
	    PreparedStatement pstmt=null;
	    ResultSet rs=null;
	    
	    
	    try {
	    	
	    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
	    	
	    	String sql="SELECT pi.URL ,p.PRODUCT_ID, p.PRODUCT_NAME,po.DISCOUNT , po.PRICE, p.SHORTINFO "
	    			+ "FROM PRODUCT p  "
	    			+ "JOIN product_option po ON p.product_ID=po.product_id  "
	    			+ "JOIN PRODUCT_IMAGE pi ON pi.PRODUCT_ID =p.PRODUCT_ID  "
	    			+ "WHERE po.DISCOUNT >0 AND pi.IMAGE_TYPE ='THUMB' "
	    			+ "ORDER BY po.PRICE ASC";
	    	
	    	pstmt=con.prepareStatement(sql);
	    	
	    	rs=pstmt.executeQuery();
	    	
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
	
	//반값 세일 상품 조회
	public List<ProductDTO> halfSaleProduct(RangeDTO rDTO){
		
		List<ProductDTO> list=new ArrayList<>();

		DbConnection dbcon = DbConnection.getInstance();
	    Connection con=null;
	    PreparedStatement pstmt=null;
	    ResultSet rs=null;
	    
	    
	    try {
	    	
	    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
	    	
	    	String sql="SELECT pi.URL,p.PRODUCT_ID, p.PRODUCT_NAME, po.PRICE, po.discount, p.SHORTINFO  "
	    			+ "FROM PRODUCT p  "
	    			+ "JOIN product_option po ON p.product_ID=po.product_id  "
	    			+ "JOIN PRODUCT_IMAGE pi ON pi.PRODUCT_ID =p.PRODUCT_ID  "
	    			+ "WHERE po.DISCOUNT >=50 AND pi.IMAGE_TYPE  ='THUMB'  "
	    			+ "ORDER BY DISCOUNT DESC";
	    	
	    	pstmt=con.prepareStatement(sql);
	    	
	    	rs=pstmt.executeQuery();
	    	
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
	
	
}
