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

## 이번에 수정한 내용 (2026-07-09)

1. **상세페이지 이미지가 안 나오던 문제**
   `src/main/webapp/images/` 안의 상품 이미지 파일명이 실수로 전부 소문자(`p000001_t.png` 등)로 바뀌어 있었습니다.
   DB에 저장된 URL은 대문자(`P000001_t.png`, 상품 ID 생성 규칙과 동일)라서 리눅스/톰캣의 대소문자 구분 파일시스템에서
   404가 나던 것이었습니다. 원래 커밋(`이미지 이름 변경`)의 대문자 파일명으로 복원했습니다. 배포 서버에도 같은 이미지
   폴더를 올리실 때 대소문자를 그대로 유지해주세요.

2. **상세페이지 가격 관련**
   `ProductDetailDAO.selectProductInfo()` 쿼리/매핑 자체는 목록 페이지(홈/검색/카테고리)와 동일한 구조로 정상 동작하는
   것을 확인했습니다. 특정 상품만 0원으로 보인다면 해당 `PRODUCT_OPTION.PRICE` 값이 DB에 실제로 0으로 들어있는지
   먼저 확인 부탁드립니다(목록에서는 정상 가격이 보이는 상품인데도 상세페이지에서만 0이 나온다면 다시 알려주세요).

3. **마이페이지 배송지 삭제 안 되던 문제**
   `DeliveryChgDAO.selectDeliveryList()`가 `DELIVERY_ID`, `RECIPIENT`, `RECIPIENT_PHONE` 컬럼을 SELECT하지 않아서
   `myPage.jsp`의 삭제 폼(hidden `deliveryId`)에 항상 빈 값이 들어갔고, `deliveryDelete.jsp`가 매번 "삭제 실패" 처리를
   하고 있었습니다. 해당 컬럼들을 SELECT에 추가하고 DTO에 채우도록 수정했습니다.

4. **주문내역이 실제로 저장되지 않던(하드코딩처럼 보이던) 문제**
   `checkoutProcess.jsp`가 결제 버튼을 눌러도 장바구니만 비우고 `ORDERS`/`ORDER_DETAILS`에는 아무것도 저장하지
   않아서, 마이페이지 주문내역(`OrderCheckService`)이 항상 비어있거나 예전에 수동으로 넣어둔 데이터만 보였습니다.
   - `client.order.OrderDAO.insertOrder(...)`를 다시 작성: 존재하지 않는 컬럼(`ORDER_STATUS`)과 값 개수가 맞지 않던
     INSERT문을 고치고, `ORDER_DETAILS`(주문한 상품/수량)까지 함께 저장하도록 했습니다.
   - `client.cart.CartDAO.selectCart()`가 `option_id`를 내려주지 않아 주문 상세를 저장할 방법이 없었던 부분도
     `option_id`를 추가해서 해결했습니다.
   - 장바구니를 비우는 `CartService.clearCart()`는 이름과 달리 "품절 상품만" 지우는 메소드라 결제 후 정리용으로 쓸 수
     없어서, 회원의 장바구니를 전부 비우는 `CartService.clearAllCart(clientNo)`를 새로 추가해 연결했습니다.
   - 이제 결제하기를 누르면 실제로 `ORDERS`/`ORDER_DETAILS`에 주문이 생성되고, 마이페이지 주문내역/관리자 주문관리
     화면에도 정상적으로 나타납니다.

## 알려드려야 할 남은 제약사항

1. **결제/PG 연동 미구현**
   실제 결제사(PG) 연동은 되어있지 않습니다. "결제하기"를 누르면 결제 없이 바로 주문(결제완료 상태)이 생성됩니다.

2. **회원가입 폼 필드 조정**
   원본 html에는 주소/성별 입력이 있었지만, `ClientDTO`/`SignupDAO.insertClient()` 에는 해당 컬럼이 없어서
   (주소는 배송지 테이블 쪽 이슈로 보임) 폼에서 제거하고 대신 실제 컬럼인 `client_birth`(생년월일)를 입력받도록
   맞췄습니다. 배송지 주소가 필요하시면 `DeliveryDTO`/`DeliveryChgService` 쪽과 별도로 연결해야 합니다.

3. **비밀번호 해싱**
   `SignupService.addUser()` 내부에서 `HashUtil.hashingPassword()` 를 호출해서 해싱하므로, JSP에서는 평문
   비밀번호를 `ClientDTO.setClientHash()`에 그대로 담아 넘기기만 하면 됩니다(이미 그렇게 구현함).

## 추가로 필요하신 것

- 카테고리 사이드바 목록을 DB(CATEGORY 테이블)에서 동적으로 가져오도록 바꿔드릴까요? (지금은 하드코딩)
- 비회원 장바구니(세션 기반)도 원하시면 구조를 바꿔야 합니다.

필요한 부분 말씀해주시면 이어서 작업하겠습니다.
