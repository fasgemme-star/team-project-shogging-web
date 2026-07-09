package client.payment;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/**
 * 토스페이먼츠 결제 승인(confirm) API 호출을 담당하는 유틸 클래스.
 *
 * 별도 라이브러리 추가 필요 없음 — 프로젝트에 이미 있는
 * WEB-INF/lib/json-simple-1.1.1.jar (org.json.simple.*) 를 사용합니다.
 */
public class TossPaymentService {

    // TODO: 정식 운영 전환 시 실제 발급받은 시크릿 키(live_gsk_...)로 교체하고,
    //       소스코드에 하드코딩하지 말고 환경변수 또는 web.xml context-param 등으로 분리하세요.
    private static final String SECRET_KEY = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6";
    private static final String CONFIRM_URL = "https://api.tosspayments.com/v1/payments/confirm";

    private static final HttpClient HTTP_CLIENT = HttpClient.newHttpClient();

    /**
     * 결제 승인 요청 결과를 담는 결과 객체.
     */
    public static class ConfirmResult {
        public final boolean success;
        public final int statusCode;
        public final JSONObject body; // 원본 응답이 필요하면 이걸 직접 써도 됨

        ConfirmResult(boolean success, int statusCode, JSONObject body) {
            this.success = success;
            this.statusCode = statusCode;
            this.body = body;
        }

        private String getField(String key, String defaultValue) {
            if (body == null) return defaultValue;
            Object value = body.get(key);
            return value != null ? value.toString() : defaultValue;
        }

        public String getErrorCode() {
            return getField("code", null);
        }

        public String getErrorMessage() {
            return getField("message", "알 수 없는 오류가 발생했습니다.");
        }

        public String getMethod() {
            return getField("method", "-");
        }

        public String getApprovedAt() {
            return getField("approvedAt", "-");
        }
    }

    /**
     * Toss 결제 승인 API를 호출합니다.
     *
     * @param paymentKey Toss가 발급한 결제 건 식별자 (successUrl 콜백에서 전달됨)
     * @param orderId    가맹점에서 발급한 주문번호
     * @param amount     결제 금액. 반드시 서버가 알고 있는 "실제 주문 금액"과 일치하는지
     *                   호출 전에 먼저 검증해야 합니다(클라이언트가 위변조할 수 있으므로).
     */
    @SuppressWarnings("unchecked")
    public ConfirmResult confirmPayment(String paymentKey, String orderId, int amount) throws Exception {
        JSONObject requestBody = new JSONObject();
        requestBody.put("paymentKey", paymentKey);
        requestBody.put("orderId", orderId);
        requestBody.put("amount", amount);

        String encodedAuth = Base64.getEncoder()
                .encodeToString((SECRET_KEY + ":").getBytes(StandardCharsets.UTF_8));

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(CONFIRM_URL))
                .header("Authorization", "Basic " + encodedAuth)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toJSONString(), StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());

        JSONObject responseBody;
        try {
            responseBody = (JSONObject) new JSONParser().parse(response.body());
        } catch (Exception parseError) {
            // 토스가 JSON이 아닌 응답을 준 경우(네트워크 오류 페이지 등) 대비
            responseBody = new JSONObject();
            responseBody.put("code", "PARSE_ERROR");
            responseBody.put("message", "응답을 해석할 수 없습니다: " + response.body());
        }

        boolean success = response.statusCode() == 200;
        return new ConfirmResult(success, response.statusCode(), responseBody);
    }
}
