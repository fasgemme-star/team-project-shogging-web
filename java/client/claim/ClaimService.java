package client.claim;

import java.sql.SQLException;

public class ClaimService {
	ClaimDAO cDAO = ClaimDAO.getInstance();
	
	public boolean requestCancel(ClaimDTO cDTO) {
		boolean flag= false;
		try {
			if(cDAO.selectClaimCancel(cDTO) == 1) {
				flag = true;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		};
		
	    return flag;
	}// requestCancel

	public boolean requestClaim(ClaimDTO cDTO) {
		boolean flag= false;
		try {
			if(cDAO.insertClaim(cDTO) == 1) {
				flag = true;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return flag;
	}// requestReturn

}
