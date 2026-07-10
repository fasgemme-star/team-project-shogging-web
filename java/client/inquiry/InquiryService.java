package client.inquiry;

import java.util.List;

public class InquiryService {

	private InquiryDAO iqDAO;
	
	public InquiryService() {
		iqDAO=InquiryDAO.getInstance();
	}
	//회원별 1:1문의 내역 목록 조회
	public List<InquiryDTO> getInquiryList(String clientId){
		return iqDAO.selectList(clientId);
	}
	//1:1 문의 상세 내역 조회
	public InquiryDTO getInquiryDetail(String inquiryId) {
		return iqDAO.selectDetail(inquiryId);
	}
	//문의 내역 삭제
	public boolean deleteInquiry(String inquiryId, String clientNo) {
		return iqDAO.deleteInquiry(inquiryId, clientNo) > 0;
	}
	
	public int insertOrderInquiry(InquiryDTO iDTO) {
		
		return insertOrderInquiry(iDTO);
	}
	public int insertServiceInquiry(InquiryDTO iDTO) {
		
		return insertServiceInquiry(iDTO);
	}
}
