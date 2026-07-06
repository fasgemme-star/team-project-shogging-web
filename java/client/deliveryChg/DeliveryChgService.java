package client.deliveryChg;

import java.util.List;



import client.signup.ClientDTO;

public class DeliveryChgService {

	private DeliveryChgDAO dDAO;
	
	public DeliveryChgService() {
		dDAO=DeliveryChgDAO.getInstance();
	}
	 // 회원별 배송지 목록 조회
    public List<DeliveryDTO> getDeliveryList(String clientNo) {
        return dDAO.selectDeliveryList(clientNo);
    }

    // 신규 배송지 등록
    public boolean addDelivery(DeliveryDTO dDTO, ClientDTO loginUser) {
    	if(dDTO == null) {
            return false;
        }
    	
    	dDTO.setClientNo(loginUser.getClientNo());

        return dDAO.insertNewDelivery(dDTO) == 1;
    }

    // 배송지 삭제
    public boolean deleteDelivery(String clientNo, String deliveryId) {

        DeliveryDTO dDTO = new DeliveryDTO();
        dDTO.setClientNo(clientNo);
        dDTO.setDeliveryID(deliveryId);

        return dDAO.removeDelivery(dDTO) == 1;
    }
	
}
