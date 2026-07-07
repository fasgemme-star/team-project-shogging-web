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
		PreparedStatement pstmtOption = null;
		ResultSet rs = null;
		int cnt = 0;
		String queryMaxID = "SELECT MAX(PRODUCT_ID) FROM product";
		String queryProduct = "INSERT INTO product(PRODUCT_ID, CATEGORY_ID, PRODUCT_NAME, DESCRIPTION, MIN_PURCHASE, MAX_PURCHASE, MANUFACTURER, ORIGIN, UNDERAGE_PURCHASE, EXPIRATION_DATE, STORAGE_TYPE, UNIT, NOTICE) "
				+ "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		String queryProductOption = "insert into product_option(option_name, PRICE, DISCOUNT, WEIGHT, stockquantity,product_id) values(?, ?, ?, ?, ?, ?)";
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
			pstmtProduct.setInt(5, pDTO.getMinPurchae());
			pstmtProduct.setInt(6, pDTO.getMaxPurchase());
			pstmtProduct.setString(7, pDTO.getManufacturer());
			pstmtProduct.setString(8, pDTO.getOrigin());
			pstmtProduct.setString(9, pDTO.getUnderAgePurchase());
			pstmtProduct.setString(10, pDTO.getExpirationDate());
			pstmtProduct.setString(11, pDTO.getStorageType());
			pstmtProduct.setString(12, pDTO.getSalesUnit());
			pstmtProduct.setString(13, pDTO.getNotice());

			cnt += pstmtProduct.executeUpdate();
			
			pstmtOption = con.prepareStatement(queryProductOption);
			String optionName = pDTO.getPrdName() + " " + pDTO.getWeight() + "kg";
			pstmtOption.setString(1,optionName);
			pstmtOption.setInt(2,pDTO.getPrice());
			pstmtOption.setInt(3,pDTO.getDiscount());
			pstmtOption.setInt(4,pDTO.getWeight());
			pstmtOption.setInt(5,pDTO.getQuantity());
			pstmtOption.setString(6,nextProductId);
			
			cnt = pstmtOption.executeUpdate();

			if (productNo != null && imgList != null && !imgList.isEmpty()) {
				pstmtImg = con.prepareStatement(queryImg);

				for (ImageDTO img : imgList) {
					pstmtImg.setString(1, img.getImageType());
					pstmtImg.setString(2, img.getUrl());
					pstmtImg.setString(3, nextProductId);
					pstmtImg.addBatch();
				}

				pstmtImg.executeBatch(); // 일괄 실행
				cnt++;
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
			dbcon.dbClose(null, pstmtOption, null);
			dbcon.dbClose(null, pstmtImg, con);
		} // end finally

		return cnt;
	}// insertProduct
	
}
