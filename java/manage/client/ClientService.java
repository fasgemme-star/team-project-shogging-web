package manage.client;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;

import client.signup.HashUtil;

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
			cnt=cDAO.selectClientCount(rDTO);
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
		String hash = HashUtil.hashingPassword(randomPW);
		try {
			cDAO.updateClientPW(ClientID, hash);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return randomPW;
	}// changeClientPW
	
	public void sendEmail(String id, String newPW) {
		 final String username = "dldnjstjr0521@gmail.com"; 
	        final String password = "agxjfsugomxlqorh"; 


	        String to = "won05210@naver.com"; // 받는 사람 메일
	        String subject = "변경된 비밀번호입니다";
	        String body = "변경된 비밀번호는 [" + newPW + "] 입니다.";

	        Properties props = new Properties();
	        props.put("mail.smtp.auth", "true");
	        props.put("mail.smtp.starttls.enable", "true");
	        props.put("mail.smtp.host", "smtp.gmail.com");
	        props.put("mail.smtp.port", "587");

	        Session session = Session.getInstance(props, new Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(username, password);
	            }
	        });

	        try {
	            Message message = new MimeMessage(session);
	            message.setFrom(new InternetAddress(username));
	            message.setRecipients(
	                    Message.RecipientType.TO,
	                    InternetAddress.parse(to)
	            );
	            message.setSubject(subject);
	            message.setText(body);

	           // Transport.send(message);
	        } catch (MessagingException e) {
	            e.printStackTrace();
	        }
	    
	}
}
