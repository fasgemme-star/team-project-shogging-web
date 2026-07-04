package inquiry;

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
}
