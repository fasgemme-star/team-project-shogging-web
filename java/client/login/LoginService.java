package client.login;


import client.signup.ClientDTO;
import client.signup.HashUtil;

public class LoginService {

	private LoginDAO lDAO;
	
	public LoginService() {
		lDAO=LoginDAO.getInstance();
	}
	//회원아이디와 비밀번호로 로그인처리(로그인 성공시 회원 정보 반환)
	public ClientDTO login(String clientId, String password) {
		
		String hashPw = HashUtil.hashingPassword(password);

	    return lDAO.selectLoginInfo(clientId, hashPw);
	}
	
}
