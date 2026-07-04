package dbcon;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Connection 얻기와 연결 끊기 05.12.2026 Singleton Pattern 도입.
 */
public class DbConnection {
	// 객체가 생성된 상태를 저장하기 위해서 static 상태로 선언
	private static DbConnection dbCon;

	/**
	 * 객체를 클래스 외부에서 생성할 수 없다
	 */
	private DbConnection() {
	}// DbConnection

	/**
	 * 한개의 객체만 생성하는 method
	 * 
	 * @return 한개의 객체
	 */
	public static DbConnection getInstance() {
		if (dbCon == null) {
			dbCon = new DbConnection();
		} // end if
		return dbCon;
	}// getInstance

	/**
	 * DBMS와 연결된 Connection을 반환하는 일.
	 * 
	 * @param prop DBMS 의 정보를 로딩한 객체
	 * @return Connection
	 * @throws SQLException
	 */
	public Connection getConn(File file) throws SQLException {

		Connection con = null;

		if (!file.exists()) { // 설정 정보를 가진 파일이 해당 경로에 존재하지 않으면
			// DB작업을 할 필요가 없다.
			return null;
		} // end if
		
		Properties prop = new Properties();
		try {
			
			prop.load(new FileInputStream(file));
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		// 1.드라이버 로딩
		try {
			Class.forName("oracle.jdbc.OracleDriver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		// 2.커넥션 얻기
		String url = prop.getProperty("url");
		String id = prop.getProperty("id");
		String pw = prop.getProperty("pw");

		con = DriverManager.getConnection(url, id, pw);

		return con;
	} // getConn

	public void dbClose(ResultSet rs, Statement stmt, Connection con) throws SQLException {

		try {
			if (rs != null) {
				rs.close();
			} // end if

			if (stmt != null) {
				stmt.close();
			} // end if

		} finally {
			if (con != null) {
				con.close();
			} // end if
		} // end finally

	}// dbClose
}// class
