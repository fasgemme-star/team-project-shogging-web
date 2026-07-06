package client.changeClientInfo;

import client.signup.ClientDTO;
import client.signup.HashUtil;

public class ChangeClientInfoService {
	
	private ChangeClientInfoDAO cciDAO;
	
	public ChangeClientInfoService() {
		cciDAO=ChangeClientInfoDAO.getInstance();
	}
	//회원 비밀번호 일치 여부 확인
	public boolean verifyPassword(String clientId, String password) {
		String hashPassword = HashUtil.hashingPassword(password);

        return cciDAO.verifyPassword(clientId, hashPassword);
	}
	//회원 정보 수정(조회)
	public ClientDTO getUserInfo(String clientId) {
        return cciDAO.selectUserInfo(clientId);
	}
	//회원 정보 수정(업데이트)
	public int modifyUserInfo(ClientDTO cDTO) {
		return cciDAO.updateUserInfo(cDTO);
	}
	//회원 비밀번호 변경
	public int changePassword(String clientId, String newPassword) {
		String hashPassword = HashUtil.hashingPassword(newPassword);

        return cciDAO.updatePassword(clientId, hashPassword);
	}
	//회원 탈퇴 처
	public int withdrawMember(String clientId) {
		return cciDAO.deleteMember(clientId);
	}
}
