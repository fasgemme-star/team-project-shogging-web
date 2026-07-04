package client.claimChk;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClaimChkService {
	ClaimChkDAO cDAO = ClaimChkDAO.getInstance();
	
	public List<ClaimDTO> getClaimList(String userId, RangeDTO rDTO) {
		List<ClaimDTO> cList = new ArrayList<ClaimDTO>();
		try {
			cList = cDAO.selectClaimByUserID(userId, rDTO);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    return cList;
	}// getClaimList

	// 클레임 ID(claimId)로 특정 클레임 신청 건에 대한 상세 정보 조회
	public ClaimDTO getClaimDetail(String claimId) {
		ClaimDTO cDTO = new ClaimDTO();
		try {
			cDTO = cDAO.selectClaimDetail(claimId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    return cDTO;
	}// getClaimDetail
}
