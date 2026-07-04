package manage.addproduct;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import dbcon.DbConnection;
import dbcon.Path;

public class AddProductDAO {
	private static AddProductDAO aDAO;

	private AddProductDAO() {
	}

	public static AddProductDAO getInstance() {
		if (aDAO == null) {
			aDAO = new AddProductDAO();
		}
		return aDAO;
	} // getInstance()

	public int insertProduct(ProductDTO pDTO, List<ImageDTO> imgList) throws SQLException {
		DbConnection dbcon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmtProduct = null;
		PreparedStatement pstmtMaxId = null;
		PreparedStatement pstmtImg = null;
		ResultSet rs = null;
		int cnt = 0;
		String queryMaxID = "SELECT MAX(PRODUCT_ID) FROM product";
		String queryProduct = "INSERT INTO product(PRODUCT_ID, CATEGORY_ID, PRODUCT_NAME, DESCRIPTION, PRICE, MIN_PURCHASE, MAX_PURCHASE, DISCOUNT, MANUFACTURER, ORIGIN, UNDERAGE_PURCHASE, WEIGHT, EXPIRATION_DATE, STORAGE_TYPE, UNIT, NOTICE) "
				+ "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		String queryImg = "insert into PRODUCT_IMAGE(IMAGE_TYPE, URL, PRODUCT_ID) values(?,?,?)";
		try {
			con = dbcon.getConn(new File(Path.DATABASE_PROPERTIES));
			con.setAutoCommit(false);

			String productNo = null;
			pstmtMaxId = con.prepareStatement(queryMaxID);
			rs = pstmtMaxId.executeQuery();
			if (rs.next()) {
				productNo = rs.getString(1);
			}
			
			String nextProductId = "P000001";
			if (productNo != null && productNo.startsWith("P")) {
	            try {
	                int num = Integer.parseInt(productNo.substring(1));
	                num++;
	                nextProductId = String.format("P%06d", num);
	            } catch (NumberFormatException e) {
	                nextProductId = pDTO.getPrdID(); 
	            }
	        }
			
			

			pstmtProduct = con.prepareStatement(queryProduct);
			pstmtProduct.setString(1, nextProductId);
			pstmtProduct.setString(2, pDTO.getCategory());
			pstmtProduct.setString(3, pDTO.getPrdName());
			pstmtProduct.setString(4, pDTO.getPrdDescription());
			pstmtProduct.setInt(5, pDTO.getPrice());
			pstmtProduct.setInt(6, pDTO.getMinPurchae());
			pstmtProduct.setInt(7, pDTO.getMaxPurchase());
			pstmtProduct.setInt(8, pDTO.getDiscount());
			pstmtProduct.setString(9, pDTO.getManufacturer());
			pstmtProduct.setString(10, pDTO.getOrigin());
			pstmtProduct.setString(11, pDTO.getUnderAgePurchase());
			pstmtProduct.setInt(12, pDTO.getWeight());
			pstmtProduct.setString(13, pDTO.getExpirationDate());
			pstmtProduct.setString(14, pDTO.getStorageType());
			pstmtProduct.setString(15, pDTO.getSalesUnit());
			pstmtProduct.setString(16, pDTO.getNotice());

			cnt = pstmtProduct.executeUpdate();

			if (productNo != null && imgList != null && !imgList.isEmpty()) {
				pstmtImg = con.prepareStatement(queryImg);

				for (ImageDTO img : imgList) {
					pstmtImg.setString(1, img.getImageType());
					pstmtImg.setString(2, img.getUrl());
					pstmtImg.setString(3, nextProductId);
					pstmtImg.addBatch();
				}

				pstmtImg.executeBatch(); // 일괄 실행
			}
			con.commit();
		} catch (SQLException e) {
			if (con != null) {
				try {
					con.rollback();
				} catch (SQLException ex) {
					ex.printStackTrace();
				}
			}
			throw e;

		} finally {
			// 6.연결 끊기
			if (con != null) {
				try {
					con.setAutoCommit(true);
				} catch (Exception e) {
				}
			}
			dbcon.dbClose(rs, pstmtMaxId, null);
			dbcon.dbClose(null, pstmtProduct, null);
			dbcon.dbClose(null, pstmtImg, con);
		} // end finally

		return cnt;
	}// insertProduct
	
}
