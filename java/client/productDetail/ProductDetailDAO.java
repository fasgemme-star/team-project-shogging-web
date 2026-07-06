package client.productDetail;

import java.io.File;
import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dbcon.DbConnection;
import dbcon.Path;
public class ProductDetailDAO {

private static ProductDetailDAO pdDAO;
	
	private ProductDetailDAO() {
		
	}
	
	public static ProductDetailDAO getInstance() {
		if(pdDAO==null) {
			pdDAO=new ProductDetailDAO();
		}
		return pdDAO;
	}
	//상품 기본 정보 조회
	public ProductDTO selectProductInfo(String prdID) {
		
		ProductDTO pDTO = null;

		DbConnection dbcon = DbConnection.getInstance();
		
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    
	    try {
	    	
	    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

	        StringBuilder sql = new StringBuilder();

	        sql.append(" SELECT p.PRODUCT_ID , p.PRODUCT_NAME ,p.PRODUCT_TYPE ,p.NOTICE ,p.SHORTINFO , ");
	        sql.append(" p.MANUFACTURER ,p.ORIGIN,p.UNDERAGE_PURCHASE ,p.UNIT ,p.MIN_PURCHASE ,p.MAX_PURCHASE , ");
	        sql.append(" po.OPTION_NAME ,po.PRICE ,po.DISCOUNT,pi.URL  ");
	        sql.append(" FROM PRODUCT p ");
	        sql.append(" JOIN PRODUCT_OPTION po ON p.PRODUCT_ID=po.PRODUCT_ID  ");
	        sql.append(" JOIN PRODUCT_IMAGE pi ON p.PRODUCT_ID=pi.PRODUCT_ID  ");
	        sql.append(" AND pi.IMAGE_TYPE = 'THUMB' ");
	        sql.append(" WHERE PRODUCT_ID = ? ");

	        pstmt = con.prepareStatement(sql.toString());
	        pstmt.setString(1, prdID);

	        rs = pstmt.executeQuery();

	        if(rs.next()) {

	        	pDTO = new ProductDTO();

	        	pDTO.setPrdID(rs.getString("PRODUCT_ID"));
	        	pDTO.setPrdName(rs.getString("PRODUCT_NAME"));
	        	pDTO.setPrdType(rs.getString("PRODUCT_TYPE"));
	        	pDTO.setNotification(rs.getString("NOTICE"));
	        	pDTO.setShortInfo(rs.getString("SHORTINFO"));
	        	pDTO.setManufacturer(rs.getString("MANUFACTURER"));
	        	pDTO.setOrigin(rs.getString("ORIGIN"));
	        	pDTO.setUnderagePurchase(rs.getInt("UNDERAGE_PURCHASE"));
	        	pDTO.setUnit(rs.getString("UNIT"));
	        	pDTO.setMinPurchase(rs.getInt("MIN_PURCHASE"));
	        	pDTO.setMaxPurchase(rs.getInt("MAX_PURCHASE"));

	        	pDTO.setOptionName(rs.getString("OPTION_NAME"));
	        	pDTO.setPrice(rs.getInt("PRICE"));
	        	pDTO.setDiscount(rs.getInt("DISCOUNT"));

	        	pDTO.setImg(rs.getNString("IMG"));

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

	    return pDTO;
		
	}
	//상품 상세 설명 및 내용 조회
	public ProductDTO selectProductDetail(String prdID) {
		
		ProductDTO pDTO = null;

		DbConnection dbcon = DbConnection.getInstance();
		
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    
	    try {
	    	
	    	con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

	        StringBuilder sql = new StringBuilder();

	        sql.append(" SELECT * ");
	        sql.append(" FROM PRODUCT_IMAGE  ");
	        sql.append(" WHERE IMAGE_TYPE IN ('DETAIL','CONTENT') and PRODUCT_ID = ? ");

	        pstmt = con.prepareStatement(sql.toString());
	        pstmt.setString(1, prdID);

	        rs = pstmt.executeQuery();

	        if(rs.next()) {

	        	pDTO = new ProductDTO();

	        	pDTO.setImg(rs.getString("PRODUCT_IMG_ID"));
	        	pDTO.setUrl(rs.getString("URL"));
	        	pDTO.setImageType(rs.getString("IMAGE_TYPE"));
	        	pDTO.setPrdID(rs.getString("PRODUCT_ID"));

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

	    return pDTO;
		
	}
}
