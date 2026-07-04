package manage.admin;

import java.sql.SQLException;

public class AdminService {
	private AdminDAO aDAO = AdminDAO.getInstance();
	
	public int login(String id, String pw) {
		int result = 0;
		try {
			result = aDAO.selectAdmin(id, pw);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// login
	
	public int changePW(AdminDTO aDTO, String newPW) {
		int result = 0;
		
		//로그인 성공 여부 저장
		int checkAdmin = 0;
		try {
			checkAdmin = aDAO.selectAdmin(aDTO.getAdminID(), aDTO.getAdminPW());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if (checkAdmin == 1) {//로그인성공
			try {
				if(aDAO.updatePW(aDTO, newPW) == 1) {
					//변경성공
				}else {
					//변경실패
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} else {//로그인 실패
			System.out.println("로그인실패");
		}
		
		return result;
	}// changePW
	
	public AdminDTO getAdminInfo(String id) {
		AdminDTO aDTO = null;
		
		try {
			aDTO = aDAO.selectAdminInfo(id);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return aDTO;
	}// AdminDTO

}
