package manage.inquiry;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InquiryService {
	private InquiryDAO iDAO = InquiryDAO.getInstance();
	
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

	public List<InquiryDTO> getInquiryList(RangeDTO rDTO){
		List<InquiryDTO> iList = new ArrayList<InquiryDTO>();
		try {
			iList = iDAO.selectInquiryList(rDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return iList;
	}// getInquiryList
	
	public InquiryDTO getInquiryDetail(String inquiryID) {
		InquiryDTO iDTO = new InquiryDTO();
		try {
			iDTO = iDAO.selectInquiryDetail(inquiryID);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return iDTO;
	}// getInquiryDetail
	
	
	public int answerInquiry(String inquiryID, String answer) {
		int result = 0;
		try {
			result = iDAO.updateInquiryAnswer(inquiryID, answer);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// answerInquiry
	
	public int deleteInquiry(String inquiryID) {
		int result = 0;

		try {
			result = iDAO.deleteInquiry(inquiryID);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}// deleteInquiry
	
	public OrderDTO getOrderDetail(String orderID) {
		OrderDTO oDTO = new OrderDTO();
		try {
			oDTO = iDAO.selectOrderDetail(orderID);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return oDTO;
	}// getOrderDetail
	
}
