package manage.client;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClientService {
	private ClientDAO cDAO = ClientDAO.getInstance();
	
	public int totalCount(RangeDTO rDTO) {
		return 0;
	}// totalCount
	
	public int pageScale(int num) {
		return 0;
	}// pageScale
	
	public int totalPage(int totalCnt, int pageScale) {
		return 0;
	}// totalPage
	
	public int startNum(int totalPage, int pageScale) {
		return 0;
	}// startNum
	
	public int endNum(int totalpage, int pageScale) {
		return 0;
	}// endNum
	
	public int getTotalCount() {
		int result = 0;
		try {
			result = cDAO.selectTotalClient();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// getTotalCount

	public int getNewCount() {
		int result = 0;
		try {
			result = cDAO.selectNewClient();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// getNewCount
	
	public List<ClientDTO> getClientList(RangeDTO rDTO){
		List<ClientDTO> cList = new ArrayList<ClientDTO>();
		try {
			cList = cDAO.selectClientList(rDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cList;
	}// getClientList
	
	public ClientDTO getClientDEtail(String ClientID) {
		ClientDTO cDTO = new ClientDTO();
		try {
			cDTO = cDAO.selectClientDetail(ClientID);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cDTO;
	}// getClientDEtail
	
	public String changeClientPW(String ClientID) {
		String randomPW = PasswordGenerator.generatePassword(10);	
		try {
			cDAO.updateClientPW(ClientID, randomPW);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return randomPW;
	}// changeClientPW
	
		
}
