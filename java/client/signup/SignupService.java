package client.signup;


public class SignupService {

	private SignupDAO sDAO;
	
	public SignupService() {
		sDAO=SignupDAO.getInstance();
	}
	
	//신규 회원 정보 등록(회원가입 성공 여부 반환)
    public boolean addUser(ClientDTO cDTO) {
    	
    	if (cDTO == null) {
			return false;
		}

    	if (checkDupId(cDTO)) {
    	    return false;
    	}

    	cDTO.setClientHash(
    	        HashUtil.hashingPassword(cDTO.getClientHash()));

        return sDAO.insertClient(cDTO) == 1;
    }
    //아이디 중복 체크
    public boolean checkDupId(ClientDTO cDTO) {
    	
    	if (cDTO == null ||
    	        cDTO.getClientId() == null ||
    	        cDTO.getClientId().trim().isEmpty()) {
    	        return true;
    	    }

    	    return sDAO.selectID(cDTO) > 0;
    }
}
