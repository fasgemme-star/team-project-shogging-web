package client.prdInquiry;

import java.util.List;


import client.inquiry.InquiryDTO;

public class PrdInquiryService {

	private PrdInquiryDAO piDAO;
	
	public PrdInquiryService() {
		piDAO=PrdInquiryDAO.getInstance();
	}
	
	//상품별 문의 목록 조회
	public List<InquiryDTO> getInquiryList(String prdId){
		return piDAO.selectInquiryList(prdId);
	}
	//문의 상세 내용 조회
	public InquiryDTO getInquiryDetail(int inquiryId) {

        return piDAO.selectInquiryDetail(inquiryId);
    }
	//신규 상품 문의 등록
	public boolean registerInquiry(InquiryDTO dto) {

        return piDAO.insertInquiry(dto) > 0;
    }

//	//상품 문의 내용 수정
//	public boolean modifyInquiry(InquiryDTO dto) {
//
//        return piDAO.updateInquiry(dto) > 0;
//    }
//	//상품 문의 삭제
//	public boolean deleteInquiry(String inquiryId) {
//
//        return piDAO.deleteInquiry(inquiryId) > 0;
//    }
//
//	//상품 문의 답변(댓글) 등록
//	public boolean registerReply(String inquiryId, String replyContent) {
//
//        return piDAO.updateReply(inquiryId, replyContent) > 0;
//    }
	//상품문의 비밀글 등
	public boolean getPrivatePost(String inquiryId) {

		return piDAO.getPrivatePost(inquiryId);
    }
}
