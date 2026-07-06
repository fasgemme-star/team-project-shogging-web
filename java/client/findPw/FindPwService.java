package client.findPw;


import client.signup.HashUtil;

public class FindPwService {

	private FindPwDAO fpwDAO;
	
	public FindPwService() {
		fpwDAO=FindPwDAO.getInstance();
	}
	//회원 아이디와 이메일 정보로 비밀번호 존재여부 확인
	public boolean findPassword(String clientId, String clientEmail) {
		return fpwDAO.selectClientPW(clientId, clientEmail)!=null;
	}
	//비밀번호 변경
	public boolean resetPassword(String clientId, String newPw) {

	    String hashedPw =HashUtil.hashingPassword(newPw);

	    return fpwDAO.updateClientPw(clientId, hashedPw) > 0;
	}
}
