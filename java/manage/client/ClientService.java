package manage.client;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;

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
	
	public int getRangeCount(RangeDTO rDTO) {
		int cnt=0;
		try {
			cDAO.selectClientCount(rDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cnt;
	}
	
	
	
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
		sendEmail(ClientID,randomPW);
		try {
			cDAO.updateClientPW(ClientID, randomPW);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return randomPW;
	}// changeClientPW
	
	public void sendEmail(String id, String newPW) {
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.test.com");
	    props.put("mail.smtp.port", "587");
	    
	    Session session = Session.getDefaultInstance(props);
	    String email = null;;
		try {
			email = cDAO.selectEmail(id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
        try {
        	
        	
            MimeMessage message = new MimeMessage(session);

            message.setFrom(new InternetAddress("admin@test.com"));
            message.setRecipient(Message.RecipientType.TO,
                    new InternetAddress(email));

            message.setSubject("변경된 비밀번호입니다.");
            message.setText(newPW);

            // 실제 발송 시 사용
            // Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
	    
	}
}
