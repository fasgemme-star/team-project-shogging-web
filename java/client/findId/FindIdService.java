package client.findId;

import client.signup.ClientDTO;

public class FindIdService {
	
	private FindIdDAO fidDAO;
	
	public FindIdService() {
		fidDAO=FindIdDAO.getInstance();
	}
	
	public ClientDTO findId(String clientName, String clientEmail) {
		return fidDAO.selectClientId(clientName, clientEmail);
	}
	
}
