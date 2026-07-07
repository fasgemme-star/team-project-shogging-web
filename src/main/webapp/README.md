# JSP 전환 결과물 안내

`ddd.html` (JS로 뷰만 토글하던 SPA + mock 데이터) 를 서블릿 없이 **JSP + 기존 client 패키지 Service 클래스**로만 동작하는
멀티 페이지 구조로 나눴습니다.

## 폴더 구조 / 배치 방법

```
webapp/
 ├─ common/
 │   ├─ header.jsp        (공통 상단 네비 + 사이드바, 모든 페이지 상단에서 include)
 │   ├─ footer.jsp         (공통 푸터 + 공통 스크립트 + flash 토스트 메시지, 모든 페이지 하단에서 include)
 │   ├─ productCard.jspf   (상품 카드 1개 - home/category/search 공용, ProductDTO p 필요)
 │   ├─ style.css
 │   └─ signup-style.css
 ├─ home.jsp               (메인 - UserMainService)
 ├─ category.jsp           (카테고리별 목록 + 페이징 - UserMainService)
 ├─ search.jsp             (상품 검색 - ProductSearchService)
 ├─ login.jsp / logout.jsp (LoginService)
 ├─ signup.jsp             (SignupService)
 ├─ productDetail.jsp      (ProductDetailService)
 ├─ cart.jsp               (장바구니 조회 - CartService)
 ├─ cartAdd.jsp            (장바구니 담기 액션 - CartService.addCart)
 ├─ checkout.jsp           (주문하기 액션 - 아래 "제약사항" 참고)
 ├─ orderSuccess.jsp
 ├─ index.jsp              (진입점, home.jsp로 리다이렉트)
 └─ images/                (배너 이미지 - 원본 client/usermain/images 복사본)
```

이 전체를 톰캣 프로젝트의 webapp 루트(예: `WebContent/`, `src/main/webapp/`)에 그대로 넣으시면 됩니다.

기존 `client` 패키지(Service/DAO/DTO)는 컴파일된 `.class` 파일이 `WEB-INF/classes/client/...` 경로에
있어야 각 JSP의 `<jsp:useBean class="client.xxx.XxxService">` 가 정상 동작합니다. 이미 쓰시던 프로젝트 구조 그대로
`WEB-INF/classes` 밑에 패키지 구조가 잡혀 있으면 별도 작업은 필요 없습니다.

또한 `common/header.jsp`, `common/footer.jsp`, `common/productCard.jspf` 는 JSTL(core/fmt/functions)을 사용하므로
`jstl.jar`, `taglibs-standard-*.jar` (혹은 Jakarta EE 버전이면 해당 groupId) 가 `WEB-INF/lib`에 있어야 합니다.

## 메소드 연결 요약

| 화면 | 파일 | 연결된 클래스/메소드 |
|---|---|---|
| 홈 | home.jsp | `UserMainService.searchBest()`, `.searchSale()`, `.getBannerImages()` |
| 카테고리 | category.jsp | `UserMainService.getCategory()`, `.totalCount()`, `.totalPage()`, `.pageScale()` (베스트/알뜰쇼핑/신상품은 searchBest/searchSale로 분기) |
| 검색 | search.jsp | `ProductSearchService.searchProduct()` |
| 로그인 | login.jsp | `LoginService.login()` → 성공 시 `session`에 clientNo/clientId/clientName 저장 |
| 로그아웃 | logout.jsp | `session.invalidate()` |
| 회원가입 | signup.jsp | `SignupService.checkDupId()`, `.addUser()` |
| 상품상세 | productDetail.jsp | `ProductDetailService.getProductInfo()` |
| 장바구니 담기 | cartAdd.jsp | `CartService.addCart()` |
| 장바구니 조회 | cart.jsp | `CartService.getCartList()` |
| 주문하기 | checkout.jsp | `CartService.clearCart()` |

서블릿 없이 각 JSP가 **자기 자신에게 POST/GET으로 self-submit** 하는 방식(전형적인 "JSP만으로 처리" 패턴)을 사용했습니다.
페이지 상단 스크립틀릿에서 `request.getMethod()` / `request.getParameter(...)` 로 분기해서 처리 후 `response.sendRedirect(...)` 합니다.

## 알려드려야 할 제약사항 (그대로 두었고, 필요하시면 다음 단계로 손봐드릴 수 있습니다)

1. **장바구니 개별 수정/삭제 불가**
   `CartDAO.selectCart()` 쿼리가 `option_name, price, discount, quantity` 만 SELECT 하고 `option_id`(=prdID)를
   반환하지 않습니다. 그래서 `cart.jsp` 목록에서 항목별 수량 변경/삭제 버튼을 만들 수가 없어서 지금은 **조회 전용**으로만
   구현했습니다. `CartDAO.selectCart()` SQL에 `option_id`를 추가해서 `OrderDTO`에 실어주시면 `cartUpdate.jsp`,
   `cartDelete.jsp` 를 마저 만들어 붙일 수 있습니다.

2. **결제/주문 생성 로직 미구현**
   `client.order.OrderService` 의 `processPayment()`, `getOrder()`, `calculateTotalPrice()` 등이 현재
   빈 값(`return ""`, `return 0`)만 반환하는 스텁 상태입니다. 그래서 `checkout.jsp`는 실제 주문 테이블에 데이터를
   넣지 않고 **장바구니만 비운 뒤** 완료 화면으로 보냅니다. 실제 주문 저장이 필요하면 `OrderService`/`OrderDAO`
   구현이 먼저 필요합니다.

3. **회원가입 폼 필드 조정**
   원본 html에는 주소/성별 입력이 있었지만, `ClientDTO`/`SignupDAO.insertClient()` 에는 해당 컬럼이 없어서
   (주소는 배송지 테이블 쪽 이슈로 보임) 폼에서 제거하고 대신 실제 컬럼인 `client_birth`(생년월일)를 입력받도록
   맞췄습니다. 배송지 주소가 필요하시면 `DeliveryDTO`/`DeliveryChgService` 쪽과 별도로 연결해야 합니다.

4. **비밀번호 해싱**
   `SignupService.addUser()` 내부에서 `HashUtil.hashingPassword()` 를 호출해서 해싱하므로, JSP에서는 평문
   비밀번호를 `ClientDTO.setClientHash()`에 그대로 담아 넘기기만 하면 됩니다(이미 그렇게 구현함).

## 추가로 필요하신 것

- 장바구니 개별 삭제/수정까지 필요하시면 위 1번 DAO 쿼리부터 손봐드릴게요.
- 실제 주문/결제 저장(OrderService/OrderDAO 구현)까지 필요하신가요?
- 로그인 필요 없는 비회원 장바구니(세션 기반)도 원하시면 구조를 바꿔야 합니다.
- 카테고리 사이드바 목록을 DB(CATEGORY 테이블)에서 동적으로 가져오도록 바꿔드릴까요? (지금은 하드코딩)

필요한 부분 말씀해주시면 이어서 작업하겠습니다.
