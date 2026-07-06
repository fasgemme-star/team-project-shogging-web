package client.productSearch;

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

public class ProductSearchDAO {

	private static ProductSearchDAO psDAO;
	
	private ProductSearchDAO() {
		
	}
	
	public static ProductSearchDAO getInstance() {
		if(psDAO==null) {
			psDAO=new ProductSearchDAO();
		}
		return psDAO;
	}
	//상품명 검색을 통한 상품 목록 조회 
	public List<ProductDTO> selectProduct(String prdName){
		
		List<ProductDTO> list = new ArrayList<ProductDTO>();

		DbConnection dbcon = DbConnection.getInstance();
		
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

		
		try {
			
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));

            StringBuilder sql = new StringBuilder();

            sql.append(" SELECT pi.URL ,p.PRODUCT_ID, p.PRODUCT_NAME , p.SHORTINFO , po.OPTION_NAME  , po.PRICE, po.DISCOUNT  ");
            sql.append(" FROM PRODUCT p  ");
            sql.append(" JOIN PRODUCT_OPTION po ON p.PRODUCT_ID =po.PRODUCT_ID  ");
            sql.append(" JOIN PRODUCT_IMAGE pi ON pi.PRODUCT_ID =p.PRODUCT_ID   ");
            sql.append(" WHERE PRODUCT_NAME LIKE ? AND pi.IMAGE_TYPE ='THUMB' ");

            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, "%" + prdName + "%");

            rs = pstmt.executeQuery();

            ProductDTO pDTO = null;

            while(rs.next()) {

                pDTO = new ProductDTO();

                pDTO.setUrl(rs.getString("URL"));
                pDTO.setPrdID(rs.getString("PRODUCT_ID"));
                pDTO.setPrdName(rs.getString("PRODUCT_NAME"));
                pDTO.setPrdType(rs.getString("PRODUCT_TYPE"));
                pDTO.setPrice(rs.getInt("PRICE"));
                pDTO.setDiscount(rs.getInt("DISCOUNT"));

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
}
