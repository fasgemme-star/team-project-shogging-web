/*1 관리자 */
DROP TABLE manager
	CASCADE CONSTRAINTS;
/*2 회원 */
DROP TRIGGER trg_client_no;
DROP TABLE client
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_client_no;
------------------------------------------
/*3 장바구니 */
DROP TABLE shopping_cart
	CASCADE CONSTRAINTS;
------------------------------------------
/*4 상품 */
--DROP TRIGGER trg_product_id;
DROP TABLE product
	CASCADE CONSTRAINTS;
--DROP SEQUENCE seq_product_id;
/*5 상품이미지 */
DROP TRIGGER trg_product_img_id;
DROP TABLE product_image
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_product_img_id;
/*6 카테고리 */
DROP TRIGGER trg_category_id;
DROP TABLE category
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_category_id;
/*7 상품 옵션 */
DROP TRIGGER trg_option_id;
DROP TABLE product_option
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_option_id;
/*8 추가정보 */
DROP TRIGGER trg_additional_id;
DROP TABLE additional_info
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_additional_id;
------------------------------------------
/*9 주문 */
--DROP TRIGGER trg_order_id;
DROP TABLE orders
	CASCADE CONSTRAINTS;
--DROP SEQUENCE seq_order_id;
/*10 주문상세(물품1개) */
DROP TRIGGER trg_order_details_id;
DROP TABLE order_details
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_order_details_id;
/*11 결제 */
DROP TRIGGER trg_payment_id;
DROP TABLE PAYMENT
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_payment_id;
------------------------------------------
/*12 선택배송지 */
DROP TRIGGER trg_delivery_id;
DROP TABLE select_delivery
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_delivery_id;
/*13 배송지 */
DROP TABLE delivery_destination
	CASCADE CONSTRAINTS;
------------------------------------------
/*14 문의 */
DROP TRIGGER trg_inquiry_id;
DROP TABLE inquiry
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_inquiry_id;
/*15 문의유형 */
DROP TRIGGER trg_inquiry_type_id;
DROP TABLE inquiry_type
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_inquiry_type_id;
------------------------------------------
/*16 클레임 */
DROP TRIGGER trg_claim_id;
DROP TABLE claim
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_claim_id;
/*17 클레임이미지 */
DROP TRIGGER trg_claim_img_id;
DROP TABLE claim_image
	CASCADE CONSTRAINTS;
DROP SEQUENCE seq_claim_img_id;
------------------------------------------
/*1 관리자 */

CREATE TABLE manager (
	manager_ID VARCHAR2(30) NOT NULL, /* 관리자아이디 */
	manager_name VARCHAR2(50), /* 관리자명 */
	manager_hash VARCHAR2(255), /* 비밀번호 */
	manager_tel VARCHAR2(20), /* 전화번호 */
	manager_email VARCHAR2(200), /* 이메일 */
	manager_input_date DATE DEFAULT SYSDATE/* 입력일 */
);

ALTER TABLE manager
	ADD
		CONSTRAINT PK_manager
		PRIMARY KEY (
			manager_ID
		);

/*2 회원 */

CREATE TABLE client (
	client_No VARCHAR2(30) NOT NULL, /* 회원 번호 */
	client_ID VARCHAR2(30), /* 회원아이디 */
	client_hash VARCHAR2(255), /* 비밀번호 */
	client_name VARCHAR2(50), /* 회원명 */
	client_email VARCHAR2(100), /* 이메일 */
	client_tel VARCHAR2(20), /* 휴대폰 */
	client_birth DATE, /* 생년월일 */
	client_ip VARCHAR2(15), /* IP */
	client_check VARCHAR(1), /* 마케팅선택체크 */
	client_start_date DATE default sysdate, /* 가입일 */
	client_delete_account VARCHAR(1) default 'N', /* 탈퇴여부 */
	client_last_date DATE DEFAULT NULL/* 탈퇴일 */
);

ALTER TABLE client
ADD	CONSTRAINT PK_client
PRIMARY KEY (client_No);

ALTER TABLE client
ADD CONSTRAINT UK_client_ID
UNIQUE (client_ID);

CREATE SEQUENCE seq_client_no
START WITH 1
INCREMENT BY 1
MAXVALUE 999999
NOCYCLE
NOCACHE;

CREATE OR REPLACE TRIGGER trg_client_no
BEFORE INSERT ON client
FOR EACH ROW
BEGIN
  IF :NEW.client_No IS NULL THEN
    :NEW.client_No := 'C' || LPAD(seq_client_no.NEXTVAL, 6, '0');
  END IF;
END;
/
------------------------------------------
/*3 장바구니 */

CREATE TABLE shopping_cart (
	client_No VARCHAR2(30), /* 회원아이디 */
	option_ID VARCHAR2(100), /* 상품아이디 */
	quantity NUMBER(5), /* 수량 */
	input_date date default sysdate /* 추가일 */
);

ALTER TABLE shopping_cart
	ADD
		CONSTRAINT PK_shopping_cart
		PRIMARY KEY (
			client_No,
			option_ID
		);
------------------------------------------
/*4 상품 */

CREATE TABLE product (
	product_ID VARCHAR2(500) NOT NULL, /* 상품아이디 */
	product_name VARCHAR2(300), /* 상품명 */
	product_type VARCHAR2(50), /* 상품타입 */
	notice CLOB, /* 안내사항 */
	shortinfo VARCHAR2(60), 	/* 짧은 설명  */
	description VARCHAR2(600), /* 설명 */
	manufacturer VARCHAR2(90), /* 제조사 */
	origin VARCHAR2(90), /* 원산지 */
	underage_purchase VARCHAR(1), /* 미성년자구매 */
	expiration_date DATE, /* 유통기한 */
	storage_type VARCHAR2(100), /* 보관유형 */
	unit VARCHAR2(100),	/* 판매단위 */
	min_purchase NUMBER(5), /* 최소구매수량 */
	max_purchase NUMBER(10), /* 최대구매수량 */
	product_input_date DATE DEFAULT sysdate, /* 입력일 */
	category_ID VARCHAR2(500) /* 카테고리아이디 */
);
--CREATE SEQUENCE seq_product_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;
--
--CREATE OR REPLACE TRIGGER trg_product_id
--BEFORE INSERT ON product FOR EACH ROW
--BEGIN
--  IF :NEW.product_ID IS NULL THEN
--    :NEW.product_ID := 'P' || LPAD(seq_product_id.NEXTVAL, 6, '0');
--  END IF;
--END;
--/

ALTER TABLE product
	ADD
		CONSTRAINT PK_product
		PRIMARY KEY (
			product_ID
		);

/*5 상품이미지 */

CREATE TABLE product_image (
	product_img_id VARCHAR2(30) NOT NULL, /* 이미지아이디 */
	URL VARCHAR2(100),    /* URL */
	image_type VARCHAR2(50), /* 이미지종류 */
	product_ID VARCHAR2(500) /* 상품아이디 */
);

ALTER TABLE product_image
	ADD
		CONSTRAINT PK_product_image
		PRIMARY KEY (
			product_img_id
		);
CREATE SEQUENCE seq_product_img_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_product_img_id
BEFORE INSERT ON product_image FOR EACH ROW
BEGIN
  IF :NEW.product_img_id IS NULL THEN
    :NEW.product_img_id := 'IMG' || LPAD(seq_product_img_id.NEXTVAL, 6, '0');
  END IF;
END;
/
/*6 카테고리 */

CREATE TABLE category (
	category_ID VARCHAR2(500) NOT NULL, /* 카테고리아이디 */
	category_name VARCHAR2(50), /* 카테고리명 */
	isdeleted VARCHAR(1) default 'N'
);

ALTER TABLE category
	ADD
		CONSTRAINT PK_category
		PRIMARY KEY (
			category_ID
		);
CREATE SEQUENCE seq_category_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_category_id
BEFORE INSERT ON category FOR EACH ROW
BEGIN
  IF :NEW.category_ID IS NULL THEN
    :NEW.category_ID := 'CAT' || LPAD(seq_category_id.NEXTVAL, 6, '0');
  END IF;
END;
/
/*7 상품 옵션 */

CREATE TABLE product_option(
	option_id VARCHAR2(100) NOT NULL, /* 상품 옵션 아이디 */
	option_name VARCHAR2(300), /* 옵션명　*/
	price NUMBER(10), /* 가격 */
	discount NUMBER(10), /* 할인 */
	stockQuantity NUMBER(10), /* 재고　*/
	weight VARCHAR2(20), /* 중량 */
	is_deleted VARCHAR(1) default 'N', /* 삭제상태 */
	product_id VARCHAR2(500) /* 상품아이디　*/
);


ALTER TABLE product_option
	ADD
		CONSTRAINT PK_product_option
		PRIMARY KEY (
			option_id
		);
CREATE SEQUENCE seq_option_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_option_id
BEFORE INSERT ON product_option FOR EACH ROW
BEGIN
  IF :NEW.option_id IS NULL THEN
    :NEW.option_id := 'OPT' || LPAD(seq_option_id.NEXTVAL, 6, '0');
  END IF;
END;
/
/*8 추가정보 */

CREATE TABLE additional_info(
	additional_id VARCHAR2(30) NOT NULL,
	info_content CLOB,
	product_id VARCHAR2(500)
);

ALTER TABLE additional_info
	ADD
		CONSTRAINT PK_additional_info
		PRIMARY KEY (
			additional_id
		);
CREATE SEQUENCE seq_additional_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_additional_id
BEFORE INSERT ON additional_info FOR EACH ROW
BEGIN
  IF :NEW.additional_id IS NULL THEN
    :NEW.additional_id := 'ADD' || LPAD(seq_additional_id.NEXTVAL, 6, '0');
  END IF;
END;
/
------------------------------------------
/*9 주문 */

CREATE TABLE orders (
	order_ID VARCHAR2(30) NOT NULL, /* 주문아이디 */
	order_date DATE  default sysdate, /* 주문일자 */
	total_amount NUMBER(12), /* 총금액 */
	order_status VARCHAR2(30), /* 주문상태 */
	delivery_status VARCHAR2(30), /* 배송상태 */
	delivery_request VARCHAR2(500), /* 배송요청사항 */
	delivery_start_date DATE, /* 배송시작일 */
	Tracking_number VARCHAR2(100), /* 송장번호 */
	delivery_completion_date DATE, /* 배송완료일 */
	client_No VARCHAR2(30) /* 회원아이디 */
);

ALTER TABLE orders
	ADD
		CONSTRAINT PK_orders
		PRIMARY KEY (
			order_ID
		);
--CREATE SEQUENCE seq_order_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;
--
--CREATE OR REPLACE TRIGGER trg_order_id
--BEFORE INSERT ON orders FOR EACH ROW
--BEGIN
--  IF :NEW.order_ID IS NULL THEN
--    :NEW.order_ID := 'O' || LPAD(seq_order_id.NEXTVAL, 6, '0');
--  END IF;
--END;
--/
/*10 주문상세(물품1개) */

CREATE TABLE order_details (
	order_details_ID VARCHAR2(30) NOT NULL, /* 주문상세아이디 */
	quantity NUMBER(5), /* 수량 */
	price NUMBER(10), /* 단가 */
	option_ID VARCHAR2(100), /* 상품옵션아이디 */
	order_ID VARCHAR2(30) /* 주문아이디 */
);

ALTER TABLE order_details
	ADD
		CONSTRAINT PK_order_details
		PRIMARY KEY (
			order_details_ID
		);
CREATE SEQUENCE seq_order_details_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_order_details_id
BEFORE INSERT ON order_details FOR EACH ROW
BEGIN
  IF :NEW.order_details_ID IS NULL THEN
    :NEW.order_details_ID := 'OD' || LPAD(seq_order_details_id.NEXTVAL, 6, '0');
  END IF;
END;
/
/*11 결제 */

CREATE TABLE PAYMENT (
	paymentID VARCHAR2(200) NOT NULL, /* 결제ID */
	order_ID VARCHAR2(30), /* 주문아이디 */
	payment_type VARCHAR2(50), /* 결제타입 */
	payment_date DATE /* 결제일자 */
);

ALTER TABLE PAYMENT
	ADD
		CONSTRAINT PK_PAYMENT
		PRIMARY KEY (
			paymentID
		);
CREATE SEQUENCE seq_payment_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_payment_id
BEFORE INSERT ON PAYMENT FOR EACH ROW
BEGIN
  IF :NEW.paymentID IS NULL THEN
    :NEW.paymentID := 'PAY' || LPAD(seq_payment_id.NEXTVAL, 6, '0');
  END IF;
END;
/
------------------------------------------
/*12 선택배송지 */
CREATE TABLE select_delivery (
	delivery_ID VARCHAR2(30), /* 배송아이디 */
	order_ID VARCHAR2(30) /* 주문아이디 */
);

/*13 배송지 */

CREATE TABLE delivery_destination (
	delivery_ID VARCHAR2(30) NOT NULL, /* 배송아이디 */
	delivery_postcode VARCHAR2(30), /* 배송우편번호 */
	delivery_addr VARCHAR2(300), /* 배송주소 */
  recipient varchar2(300),   	/* 수신인명 */
  recipient_phone varchar2(100),	/* 수신인 전화 */
	first_destination VARCHAR(1), /* 기본배송지FLAG */
	delivery_input_date DATE  default sysdate, /* 입력일 */
	client_No VARCHAR2(30) /* 회원아이디 */
);

CREATE UNIQUE INDEX uq_default_delivery
ON delivery_destination (
    CASE
        WHEN first_destination = 'Y'
        THEN client_No
    END
);

ALTER TABLE delivery_destination
	ADD
		CONSTRAINT PK_delivery_destination
		PRIMARY KEY (
			delivery_ID
		);
CREATE SEQUENCE seq_delivery_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_delivery_id
BEFORE INSERT ON delivery_destination FOR EACH ROW
BEGIN
  IF :NEW.delivery_ID IS NULL THEN
    :NEW.delivery_ID := 'DLV' || LPAD(seq_delivery_id.NEXTVAL, 6, '0');
  END IF;
END;
/
------------------------------------------
/*14 문의 */

CREATE TABLE inquiry (
	inquiry_ID VARCHAR2(30) NOT NULL, /* 문의아이디 */
	inquiry_date DATE  default sysdate, /* 문의일자 */
	inquiry_title VARCHAR2(200), /* 제목 */
	inquiry_secret VARCHAR(1), /* 비밀글 */
	inquiry_content CLOB, /* 내용 */
	answer_status VARCHAR2(30), /* 답변상태 없어도 */
	answer CLOB, /* 답변 */
	answer_date DATE, /* 답변일자 */
	inquiry_status VARCHAR(1) default 'N',	/* 삭제상태 */
	inquiry_code VARCHAR2(30), /* 문의코드 */
	order_details_ID VARCHAR2(30), /* 주문상세아이디 */
	client_no VARCHAR2(30) NOT NULL
);

ALTER TABLE inquiry
	ADD
		CONSTRAINT PK_inquiry
		PRIMARY KEY (
			inquiry_ID
		);
CREATE SEQUENCE seq_inquiry_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_inquiry_id
BEFORE INSERT ON inquiry FOR EACH ROW
BEGIN
  IF :NEW.inquiry_ID IS NULL THEN
    :NEW.inquiry_ID := 'INQ' || LPAD(seq_inquiry_id.NEXTVAL, 6, '0');
  END IF;
END;
/
/*15 문의유형 */
CREATE TABLE inquiry_type (
	inquiry_code VARCHAR2(30) NOT NULL, /* 문의코드 */
	inquiry_name VARCHAR2(200), /* 문의명 */
	inquiry_type VARCHAR2(30) /* 문의유형 */
);

ALTER TABLE inquiry_type
	ADD
		CONSTRAINT PK_inquiry_type
		PRIMARY KEY (
			inquiry_code
		);
CREATE SEQUENCE seq_inquiry_type_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_inquiry_type_id
BEFORE INSERT ON inquiry_type FOR EACH ROW
BEGIN
  IF :NEW.inquiry_code IS NULL THEN
    :NEW.inquiry_code := 'TYP' || LPAD(seq_inquiry_type_id.NEXTVAL, 6, '0');
  END IF;
END;
/
------------------------------------------
/*16 클레임 */
CREATE TABLE claim (
	claim_ID VARCHAR2(30) NOT NULL, /* 클레임아이디 */
	claim_type VARCHAR2(20), /* 클레임유형 */
	requestdate DATE default sysdate, /* 요청일 */
	reason VARCHAR2(500), /* 사유 */
	reason_detail CLOB, /* 상세사유 */
	status VARCHAR2(30), /* 상태 */
	processingdate DATE, /* 처리일자 */
	order_details_ID VARCHAR2(30) /* 주문상세아이디 */
);

ALTER TABLE claim
	ADD
		CONSTRAINT PK_claim
		PRIMARY KEY (
			claim_ID
		);
CREATE SEQUENCE seq_claim_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_claim_id
BEFORE INSERT ON claim FOR EACH ROW
BEGIN
  IF :NEW.claim_ID IS NULL THEN
    :NEW.claim_ID := 'CLM' || LPAD(seq_claim_id.NEXTVAL, 6, '0');
  END IF;
END;
/
/*17 클레임이미지 */

CREATE TABLE claim_image (
	claim_img_ID VARCHAR2(30) NOT NULL, /* 이미지아이디 */
	claim_ID VARCHAR2(30) NOT NULL, /* 클레임아이디 */
	file_name VARCHAR2(500) /* 파일명 */
);

ALTER TABLE claim_image
	ADD
		CONSTRAINT PK_claim_image
		PRIMARY KEY (
			claim_img_ID,
			claim_ID
		);
CREATE SEQUENCE seq_claim_img_id START WITH 1 INCREMENT BY 1 MAXVALUE 999999 NOCYCLE NOCACHE;

CREATE OR REPLACE TRIGGER trg_claim_img_id
BEFORE INSERT ON claim_image FOR EACH ROW
BEGIN
  IF :NEW.claim_img_ID IS NULL THEN
    :NEW.claim_img_ID := 'CIMG' || LPAD(seq_claim_img_id.NEXTVAL, 6, '0');
  END IF;
END;
/
------------------------------------------
ALTER TABLE product
	ADD
		CONSTRAINT FK_category_TO_product
		FOREIGN KEY (
			category_ID
		)
		REFERENCES category (
			category_ID
		);

ALTER TABLE product_option
	ADD
		CONSTRAINT FK_product_TO_product_option
		FOREIGN KEY (
			product_ID
		)
		REFERENCES product (
			product_ID
		);

ALTER TABLE additional_info
	ADD
		CONSTRAINT FK_product_TO_additional_info
			FOREIGN KEY (
			product_ID
		)
		REFERENCES product (
			product_ID
		);

ALTER TABLE orders
	ADD
		CONSTRAINT FK_client_TO_order
		FOREIGN KEY (
			client_No
		)
		REFERENCES client (
			client_No
		);

ALTER TABLE shopping_cart
	ADD
		CONSTRAINT FK_client_TO_shopping_cart
		FOREIGN KEY (
			client_No
		)
		REFERENCES client (
			client_No
		);

ALTER TABLE shopping_cart
	ADD
		CONSTRAINT FK_product_option_TO_shopping_cart
		FOREIGN KEY (
			option_ID
		)
		REFERENCES product_option (
			option_id
		);

ALTER TABLE delivery_destination
	ADD
		CONSTRAINT FK_client_TO_delivery_destination
		FOREIGN KEY (
			client_No
		)
		REFERENCES client (
			client_No
		);

ALTER TABLE order_details
	ADD
		CONSTRAINT FK_product_option_TO_order_details
		FOREIGN KEY (
			option_ID
		)
		REFERENCES product_option (
			option_id
		);

ALTER TABLE order_details
	ADD
		CONSTRAINT FK_order_TO_order_details
		FOREIGN KEY (
			order_ID
		)
		REFERENCES orders (
			order_ID
		);

ALTER TABLE inquiry
	ADD
		CONSTRAINT FK_inquiry_type_TO_inquiry
		FOREIGN KEY (
			inquiry_code
		)
		REFERENCES inquiry_type (
			inquiry_code
		);

ALTER TABLE inquiry
	ADD
		CONSTRAINT FK_order_details_TO_inquiry
		FOREIGN KEY (
			order_details_ID
		)
		REFERENCES order_details (
			order_details_ID
		);

ALTER TABLE inquiry
	ADD
		CONSTRAINT FK_client_TO_inquiry
		FOREIGN KEY (
			client_no
		)
		REFERENCES client (
			client_no
		);


ALTER TABLE product_image
	ADD
		CONSTRAINT FK_product_TO_product_image
		FOREIGN KEY (
			product_ID
		)
		REFERENCES product (
			product_ID
		);

ALTER TABLE claim
	ADD
		CONSTRAINT FK_order_details_TO_claim
		FOREIGN KEY (
			order_details_ID
		)
		REFERENCES order_details (
			order_details_ID
		);

ALTER TABLE claim_image
	ADD
		CONSTRAINT FK_claim_TO_claim_image
		FOREIGN KEY (
			claim_ID
		)
		REFERENCES claim (
			claim_ID
		);

ALTER TABLE select_delivery
	ADD
		CONSTRAINT FK_delivery_destination_TO_select_delivery
		FOREIGN KEY (
			delivery_ID
		)
		REFERENCES delivery_destination (
			delivery_ID
		);

ALTER TABLE select_delivery
	ADD
		CONSTRAINT FK_order_TO_select_delivery
		FOREIGN KEY (
			order_ID
		)
		REFERENCES orders (
			order_ID
		);

ALTER TABLE PAYMENT
	ADD
		CONSTRAINT FK_order_TO_PAYMENT
		FOREIGN KEY (
			order_ID
		)
		REFERENCES orders (
			order_ID
		);
--------------------------------------------------------------
/* ===========================
   1. 관리자 (manager_ID 자동생성)
=========================== */
INSERT INTO manager (manager_id, manager_name, manager_hash, manager_tel, manager_email)
VALUES ('admin01','김관리', '1234', '010-1234-5541', 'admin01@test.com');


/* ===========================
   2. 회원 (client_No 자동생성: C0001, C0002, C0003...)
=========================== */
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES ('user01', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '홍길동', 'hong@test.com', '010-1111-1111', DATE '2000-01-01', '1.1.1.1', 'Y', DATE '2026-01-07');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES ('user02', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '김철수', 'kim@test.com', '010-2222-2222', DATE '1999-02-02', '2.2.2.2', 'N', DATE '2026-01-09');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES ('user03', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '이영희', 'lee@test.com', '010-3333-3333', DATE '2001-03-03', '3.3.3.3', 'Y', DATE '2026-01-10');


INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user04', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '박민수', 'park04@test.com', '010-1111-0004', DATE '2001-03-10', '1.1.1.4', 'Y', DATE '2026-01-12');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user05', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '최유리', 'choi05@test.com', '010-1111-0005', DATE '1997-11-30', '1.1.1.5', 'Y', DATE '2026-01-28');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user06', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '정다은', 'jung06@test.com', '010-1111-0006', DATE '1996-06-15', '1.1.1.6', 'Y', DATE '2026-02-02');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user07', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '강지훈', 'kang07@test.com', '010-1111-0007', DATE '2002-02-18', '1.1.1.7', 'Y', DATE '2026-02-10');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user08', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '윤수빈', 'yoon08@test.com', '010-1111-0008', DATE '1995-09-08', '1.1.1.8', 'Y', DATE '2026-02-17');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user09', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '한지민', 'han09@test.com', '010-1111-0009', DATE '1994-04-01', '1.1.1.9', 'Y', DATE '2026-02-26');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user10', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '오세훈', 'oh10@test.com', '010-1111-0010', DATE '1993-12-25', '1.1.1.10', 'Y', DATE '2026-03-01');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user11', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '신예은', 'shin11@test.com', '010-1111-0011', DATE '2000-10-19', '1.1.1.11', 'Y', DATE '2026-03-07');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user12', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '조현우', 'jo12@test.com', '010-1111-0012', DATE '1992-01-21', '1.1.1.12', 'Y', DATE '2026-03-14');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user13', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '백지훈', 'baek13@test.com', '010-1111-0013', DATE '1999-07-03', '1.1.1.13', 'Y', DATE '2026-03-22');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user14', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '서지은', 'seo14@test.com', '010-1111-0014', DATE '1998-02-13', '1.1.1.14', 'Y', DATE '2026-03-30');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user15', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '문가영', 'moon15@test.com', '010-1111-0015', DATE '2001-11-07', '1.1.1.15', 'Y', DATE '2026-04-02');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user16', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '임현수', 'lim16@test.com', '010-1111-0016', DATE '1995-05-28', '1.1.1.16', 'Y', DATE '2026-04-09');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user17', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '유민재', 'yu17@test.com', '010-1111-0017', DATE '1996-03-16', '1.1.1.17', 'Y', DATE '2026-04-15');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user18', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '송하늘', 'song18@test.com', '010-1111-0018', DATE '1997-12-11', '1.1.1.18', 'Y', DATE '2026-04-23');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user19', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '남도윤', 'nam19@test.com', '010-1111-0019', DATE '1994-09-09', '1.1.1.19', 'Y', DATE '2026-04-29');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user20', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '황예린', 'hwang20@test.com', '010-1111-0020', DATE '2002-07-27', '1.1.1.20', 'Y', DATE '2026-05-03');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user21', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '장우진', 'jang21@test.com', '010-1111-0021', DATE '1998-10-15', '1.1.1.21', 'Y', DATE '2026-05-08');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user22', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '권수아', 'kwon22@test.com', '010-1111-0022', DATE '1997-01-17', '1.1.1.22', 'Y', DATE '2026-05-14');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user23', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '노태윤', 'noh23@test.com', '010-1111-0023', DATE '1996-08-29', '1.1.1.23', 'Y', DATE '2026-05-19');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user24', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '안지수', 'ahn24@test.com', '010-1111-0024', DATE '1995-02-06', '1.1.1.24', 'Y', DATE '2026-05-24');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user25', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '고민재', 'go25@test.com', '010-1111-0025', DATE '1999-06-11', '1.1.1.25', 'Y', DATE '2026-05-30');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user26', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '배수현', 'bae26@test.com', '010-1111-0026', DATE '2000-04-05', '1.1.1.26', 'Y', DATE '2026-06-02');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user27', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '양지훈', 'yang27@test.com', '010-1111-0027', DATE '1998-12-18', '1.1.1.27', 'Y', DATE '2026-06-09');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user28', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '손다은', 'son28@test.com', '010-1111-0028', DATE '1997-09-21', '1.1.1.28', 'Y', DATE '2026-06-18');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user29', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '전하린', 'jeon29@test.com', '010-1111-0029', DATE '1996-01-08', '1.1.1.29', 'Y', DATE '2026-06-26');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES ('user30', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '홍길동', 'hong01@test.com', '010-1111-0001', DATE '2000-01-01', '1.1.1.1', 'Y', DATE '2025-12-03','Y', DATE '2026-01-03');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user31', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '김철수', 'kim02@test.com', '010-1111-0002', DATE '1999-05-12', '1.1.1.2', 'Y', DATE '2025-12-15','Y', DATE '2026-04-04');

INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user32', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '이영희', 'lee03@test.com', '010-1111-0003', DATE '1998-08-20', '1.1.1.3', 'Y', DATE '2026-01-05','Y', DATE '2026-05-21');
-- 1월 (가입 2명, 탈퇴 1명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user33', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '김민준', 'kim33@test.com', '010-1111-0033', DATE '1990-03-15', '1.1.1.33', 'Y', DATE '2025-01-01', 'Y', DATE '2025-01-20');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user34', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '이서연', 'lee34@test.com', '010-1111-0034', DATE '1992-07-22', '1.1.1.34', 'Y', DATE '2025-01-10');

-- 2월 (가입 1명, 탈퇴 1명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user35', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '박도윤', 'park35@test.com', '010-1111-0035', DATE '1995-11-05', '1.1.1.35', 'Y', DATE '2025-02-05', 'Y', DATE '2025-03-10');

-- 3월 (가입 3명, 탈퇴 2명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user36', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '최지우', 'choi36@test.com', '010-1111-0036', DATE '1998-01-30', '1.1.1.36', 'Y', DATE '2025-03-02', 'Y', DATE '2025-03-28');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user37', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '정하준', 'jeong37@test.com', '010-1111-0037', DATE '1991-05-14', '1.1.1.37', 'Y', DATE '2025-03-15', 'Y', DATE '2025-04-10');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user38', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '강서현', 'kang38@test.com', '010-1111-0038', DATE '1988-09-09', '1.1.1.38', 'Y', DATE '2025-03-20' );

-- 4월 (가입 4명, 탈퇴 1명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user39', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '조시우', 'cho39@test.com', '010-1111-0039', DATE '1996-12-25', '1.1.1.39', 'Y', DATE '2025-04-05', 'Y', DATE '2025-05-20');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user40', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '윤민서', 'yoon40@test.com', '010-1111-0040', DATE '1999-02-18', '1.1.1.40', 'Y', DATE '2025-04-10', 'Y', DATE '2025-06-10');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user41', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '장주원', 'jang41@test.com', '010-1111-0041', DATE '1993-04-04', '1.1.1.41', 'Y', DATE '2025-04-20', 'Y', DATE '2025-06-25');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user42', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '임다은', 'lim42@test.com', '010-1111-0042', DATE '1990-08-11', '1.1.1.42', 'Y', DATE '2025-04-25');

-- 5월 (가입 2명, 탈퇴 2명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user43', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '한건우', 'han43@test.com', '010-1111-0043', DATE '1985-10-29', '1.1.1.43', 'Y', DATE '2025-05-10', 'Y', DATE '2025-08-05');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user44', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '오지민', 'oh44@test.com', '010-1111-0044', DATE '1997-03-01', '1.1.1.44', 'Y', DATE '2025-05-25', 'Y', DATE '2025-08-20');

-- 6월 (가입 1명, 탈퇴 2명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user45', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '서지훈', 'seo45@test.com', '010-1111-0045', DATE '1994-06-17', '1.1.1.45', 'Y', DATE '2025-06-05', 'Y', DATE '2025-09-10');

-- 7월 (가입 3명, 탈퇴 1명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user46', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '신채원', 'shin46@test.com', '010-1111-0046', DATE '1992-09-21', '1.1.1.46', 'Y', DATE '2025-07-05', 'Y', DATE '2025-09-20');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user47', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '권우진', 'kwon47@test.com', '010-1111-0047', DATE '1989-12-12', '1.1.1.47', 'Y', DATE '2025-07-15');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user48', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '황수아', 'hwang48@test.com', '010-1111-0048', DATE '2000-01-08', '1.1.1.48', 'Y', DATE '2025-07-25', 'Y', DATE '2025-10-05');

-- 8월 (가입 2명, 탈퇴 2명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user49', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '안선우', 'ahn49@test.com', '010-1111-0049', DATE '1995-05-05', '1.1.1.49', 'Y', DATE '2025-08-05', 'Y', DATE '2025-10-15');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user50', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '송지유', 'song50@test.com', '010-1111-0050', DATE '1998-08-15', '1.1.1.50', 'Y', DATE '2025-08-20', 'Y', DATE '2025-10-25');

-- 9월 (가입 4명, 탈퇴 3명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user51', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '전연우', 'jeon51@test.com', '010-1111-0051', DATE '1991-02-28', '1.1.1.51', 'Y', DATE '2025-09-05', 'Y', DATE '2025-11-05');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user52', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '홍하은', 'hong52@test.com', '010-1111-0052', DATE '1993-11-11', '1.1.1.52', 'Y', DATE '2025-09-15', 'Y', DATE '2025-11-15');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user53', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '유서준', 'yoo53@test.com', '010-1111-0053', DATE '1987-07-07', '1.1.1.53', 'Y', DATE '2025-09-25', 'Y', DATE '2025-11-25');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user54', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '고지아', 'ko54@test.com', '010-1111-0054', DATE '1996-04-30', '1.1.1.54', 'Y', DATE '2025-09-28', 'Y', DATE '2025-11-30');

-- 10월 (가입 1명, 탈퇴 3명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user55', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '문예준', 'moon55@test.com', '010-1111-0055', DATE '1999-10-10', '1.1.1.55', 'Y', DATE '2025-10-15', 'Y', DATE '2025-12-05');

-- 11월 (가입 2명, 탈퇴 4명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user56', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '양소윤', 'yang56@test.com', '010-1111-0056', DATE '1990-01-20', '1.1.1.56', 'Y', DATE '2025-11-10', 'Y', DATE '2025-12-10');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user57', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '손준우', 'son57@test.com', '010-1111-0057', DATE '1994-08-25', '1.1.1.57', 'Y', DATE '2025-11-20', 'Y', DATE '2025-12-15');

-- 12월 (가입 3명, 탈퇴 6명)
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user58', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '배윤서', 'bae58@test.com', '010-1111-0058', DATE '1992-03-03', '1.1.1.58', 'Y', DATE '2025-12-01', 'Y', DATE '2025-12-20');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user59', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '백도현', 'baek59@test.com', '010-1111-0059', DATE '1997-09-14', '1.1.1.59', 'Y', DATE '2025-12-05', 'Y', DATE '2025-12-25');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date, CLIENT_DELETE_ACCOUNT, client_last_date)
VALUES('user60', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '허지율', 'heo60@test.com', '010-1111-0060', DATE '1995-12-12', '1.1.1.60', 'Y', DATE '2025-12-10', 'Y', DATE '2025-12-31');
--신규회원
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user61', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '허지율1', 'heo60@test.com', '010-1111-0060', DATE '1995-12-12', '1.1.1.60', 'Y', DATE '2026-07-06');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user62', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '허지율2', 'heo60@test.com', '010-1111-0060', DATE '1995-12-12', '1.1.1.60', 'Y', DATE '2026-07-06');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user63', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '허지율3', 'heo60@test.com', '010-1111-0060', DATE '1995-12-12', '1.1.1.60', 'Y', DATE '2026-07-06');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user64', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '허지율4', 'heo60@test.com', '010-1111-0060', DATE '1995-12-12', '1.1.1.60', 'Y', DATE '2026-07-06');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user65', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '허지율5', 'heo60@test.com', '010-1111-0060', DATE '1995-12-12', '1.1.1.60', 'Y', DATE '2026-07-06');
INSERT INTO client (client_ID, client_hash, client_name, client_email, client_tel, client_birth, client_ip, client_check, client_start_date)
VALUES('user66', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', '허지율6', 'heo60@test.com', '010-1111-0060', DATE '1995-12-12', '1.1.1.60', 'Y', DATE '2026-07-06');


/* ===========================
   6. 카테고리 (category_ID 자동생성: CAT000001, CAT000002...)
=========================== */
-- 주의: 상품 등록 시 카테고리 ID가 필요하므로 순서를 상품보다 앞으로 당겼습니다.
INSERT INTO category (category_name) VALUES ('과일'); -- CAT000001
INSERT INTO category (category_name) VALUES ('채소'); -- CAT000002
INSERT INTO category (category_name) VALUES ('음료'); -- CAT000003


/* ===========================
   4. 상품 (product_ID 자동생성: P000001 ~ P000006)
=========================== */

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000001', '제주 감귤', '식품',  '신선식품 특성상 크기가 일정하지 않을 수 있습니다.', '새콤달콤한 제주 감귤', '겨울 필수 간식 감귤',  '제주농협', '국산', 'N', SYSDATE+20, '냉장', '1박스', 1, 5, DATE '2025-12-05', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000002', '부사 사과', '식품',  '보관 시 밀봉하여 냉장 보관하세요.', '아삭하고 당도 높은 부사 사과', '아침에 먹는 금사과', '대구농협', '국산', 'N', SYSDATE+30, '냉장', '1봉', 1, 3, DATE '2025-12-15', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000003', '겨울 시금치', '식품',  '흙이 묻어있으니 세척 후 섭취하세요.', '달고 단단한 겨울 노지 시금치', '영양 가득 시금치', '남해농가', '국산', 'N',  SYSDATE+7, '냉장', '1단', 1, 10, DATE '2025-12-10', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000004', '핫초코 미트', '음료',  '유통기한을 확인 유의하세요.', '진하고 부드러운 핫초코', '겨울철 따뜻한 코코아',  '미트식품', '수입산', 'N',  SYSDATE+180, '상온', '1개', 1, 20, DATE '2025-12-22', 'CAT000003');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000005', '레드향', '식품',  '선물용으로 좋은 고급 만감류입니다.', '진한 향과 높은 당도의 레드향', '명절 선물 추천',  '서귀포농협', '국산', 'N', SYSDATE+15, '냉장', '1박스', 1, 2, DATE '2026-01-10', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000006', '세척당근', '식품',  '세척되어 있어 편리하게 조리 가능합니다.', '흙 없이 깔끔한 세척당근', '요리 필수 채소',  '제주구좌농가', '국산', 'N',  SYSDATE+14, '냉장', '1봉', 1, 5, DATE '2026-01-05', 'CAT000002');

INSERT INTO product(PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000007', '대파', '식품',  '수령 후 다듬어서 냉동보관하시면 오래 드십니다.', '알싸하고 시원한 국산 대파', '모든 요리의 기본',  '진도농가', '국산', 'N', SYSDATE+10, '냉장', '1단', 1, 5, DATE '2026-01-18', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000008', '유자차 베이스', '음료', '개봉 후에는 반드시 냉장 보관하세요.', '겨울에 따뜻하게 즐기는 유자차', '국산 유자로 만든 유자청', '고흥유자영농', '국산', 'N',  SYSDATE+120, '상온', '1병', 1, 5, DATE '2026-01-25', 'CAT000003');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000009', '설향 딸기', '식품',  '딸기는 쉽게 무를 수 있으니 빠르게 드세요.', '새콤달콤 과즙 가득 설향 딸기', '겨울 왕공 딸기',  '논산딸기농가', '국산', 'N',  SYSDATE+5, '냉장', '1팩', 1, 4, DATE '2026-02-02', 'CAT000001');

INSERT INTO product(PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000010', '한라봉', '식품',  '후숙 시 당도가 더욱 올라갑니다.', '새콤달콤한 제주 한라봉', '상큼한 비타민 충전',  '제주농협', '국산', 'N',  SYSDATE+20, '상온', '1박스', 1, 5, DATE '2026-02-14', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000011', '브로콜리', '식품',  '살짝 데쳐서 초고추장에 찍어 드세요.', '영양소가 풍부한 국산 브로콜리', '건강한 그린 푸드',  '제주농가', '국산', 'N',  SYSDATE+7, '냉장', '1송이', 1, 10, DATE '2026-02-11', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000012', '도라지 배즙', '음료',  '침전물이 생길 수 있으나 흔들어 드시면 됩니다.', '기관지에 좋은 도라지 배즙', '환절기 건강 관리',  '건강조은', '국산', 'N',  SYSDATE+90, '상온', '30포', 1, 2, DATE '2026-02-20', 'CAT000003');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000013', '짭짤이 토마토', '식품',  '초록빛이 돌 때 먹어야 가장 맛있습니다.', '대저 짭짤이 토마토', '단맛과 짠맛의 조화',  '대저농협', '국산', 'N',  SYSDATE+10, '상온', '1박스', 1, 3, DATE '2026-03-05', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000014', '봄동 봄나물', '식품',  '겉절이로 무쳐 드시면 맛있습니다.', '봄을 알리는 아삭한 봄동', '입맛 돋우는 봄나물',  '해남농가', '국산', 'N', SYSDATE+5, '냉장', '1봉', 1, 5, DATE '2026-03-12', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000015', '유기농 녹차티백', '음료',  '뜨거운 물에 1~2분 우려내세요.', '은은한 향의 보성 유기농 녹차', '차 한잔의 여유',  '보성다원', '국산', 'N',  SYSDATE+365, '상온', '20티백', 1, 10, DATE '2026-03-19', 'CAT000003');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000016', '성주 참외', '식품',  '찬물에 씻어 껍질째 혹은 깎아 드세요.', '아삭하고 달콤한 성주 참외', '봄철 대표 과일', '성주농협', '국산', 'N',  SYSDATE+14, '냉장', '1봉', 1, 5, DATE '2026-04-02', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000017', '오렌지', '식품',  '강제 왁싱 처리를 하지 않은 안전한 오렌지입니다.', '고당도 네이블 오렌지', '상큼함 가득 고당도 오렌지',  '선키스트', '수입산', 'N',  SYSDATE+20, '상온', '1봉', 1, 5, DATE '2026-04-18', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000018', '청도 미나리', '식품',  '삼겹살과 곁들이면 최고의 궁합입니다.', '향이 짙은 청도 한재 미나리', '향긋한 봄 미나리',  '청도농가', '국산', 'N',  SYSDATE+5, '냉장', '1봉', 1, 10, DATE '2026-04-05', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000019', '양배추', '식품',  '겉잎을 제거하고 세척 후 사용하세요.', '위 건강에 좋은 싱싱한 양배추', '아삭한 식감 통양배추',  '강원농가', '국산', 'N',  SYSDATE+10, '냉장', '1통', 1, 3, DATE '2026-04-15', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000020', '콜드브루 원액', '음료',  '반드시 냉장 보관하시고 물이나 우유에 타서 드세요.', '깔끔한 맛의 콜드브루 커피원액', '홈카페 에센셜 콜드브루',  '커피팩토리', '수입산', 'N',  SYSDATE+60, '냉장', '1병', 1, 5, DATE '2026-04-26', 'CAT000003');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000021', '방울토마토', '식품',  '꼭지를 떼고 보관하시면 더 오래 신선합니다.', '탱글탱글한 대추방울토마토', '한 입에 쏙 건강 간식',  '부여농가', '국산', 'N',  SYSDATE+10, '냉장', '1팩', 1, 5, DATE '2026-05-10', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000022', '망고', '식품',  '슈가스팟이 생기면 당도가 가장 높습니다.', '달콤하고 부드러운 수입 생망고', '달콤한 열대과일 망고',  '글로벌푸드', '수입산', 'N',  SYSDATE+10, '상온', '1팩', 1, 4, DATE '2026-05-20', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000023', '다다기오이', '식품',  '표면의 가시에 찔리지 않게 주의하세요.', '수분이 가득하고 아삭한 다다기오이', '오이소박이, 피클용 오이',  '진천농가', '국산', 'N',  SYSDATE+7, '냉장', '5개입', 1, 5, DATE '2026-05-04', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000024', '파프리카 혼합', '식품',  '색상 비율은 랜덤으로 발송됩니다.', '아삭하고 달콤한 삼색 파프리카', '샐러드 필수 다이어트 채소',  '김제농가', '국산', 'N',  SYSDATE+7, '냉장', '1봉', 1, 10, DATE '2026-05-18', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000025', '아이스티 복숭아', '음료',  '찬물에도 잘 녹는 분말 스틱입니다.', '시원하고 달콤한 복숭아 아이스티', '여름 맞이 시원한 음료',  '티타임', '국산', 'N',  SYSDATE+365, '상온', '40스틱', 1, 10, DATE '2026-05-28', 'CAT000003');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000026', '고창 수박', '식품',  '수박 특성상 크기 및 당도가 약간 다를 수 있습니다.', '당도 선별 완료된 시원한 고창 수박', '여름 대표 과일 당도보장',  '고창농협', '국산', 'N',  SYSDATE+10, '냉장', '1통', 1, 2, DATE '2026-06-15', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000027', '신비복숭아', '식품',  '겉은 천도 속은 백도인 신비 복숭아입니다.', '짧은 제철에만 맛보는 신비복숭아', '지금 아니면 못 먹는 복숭아',  '경산농가', '국산', 'N',  SYSDATE+7, '냉장', '1팩', 1, 3, DATE '2026-06-22', 'CAT000001');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000028', '초당옥수수', '식품',  '초당옥수수 특성상 끝달림이 좋지 않을 수 있지만 정상상품입니다.', '생으로 먹어도 달콤한 초당옥수수', '아삭하고 달콤한 마약 옥수수',  '해남농가', '국산', 'N',  SYSDATE+7, '냉장', '10개', 1, 5, DATE '2026-06-10', 'CAT000002');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000029', '탄산수 플레인', '음료',  '강한 탄산이 매력적인 플레인 탄산수입니다.', '칼로리 걱정 없는 깔끔한 탄산수', '톡 쏘는 청량감',  '스파클링', '국산', 'N', SYSDATE+180, '상온', '24캔', 1, 5, DATE '2026-06-05', 'CAT000003');

INSERT INTO product (PRODUCT_ID, product_name, product_type, notice, description, shortinfo,  manufacturer, origin, underage_purchase,  expiration_date, storage_type, UNIT, min_purchase, max_purchase, PRODUCT_INPUT_DATE, category_ID)
VALUES ('P000030', '유기농 콤부차', '음료',  '냉장 보관 후 차갑게 드시면 더욱 맛있습니다.', '새콤달콤한 유기농 레몬 콤부차', '가볍게 즐기는 발효 음료',  '네이처푸드', '국산', 'N',  SYSDATE+90, '상온', '1박스', 1, 10, DATE '2026-06-25', 'CAT000003');

/* ===========================
   8.추가정보
=========================== */
-- 1. P000002 (2개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('본 상품은 냉장 보관 상품이므로 수령 후 즉시 냉장고에 넣어주세요.', 'P000002');
INSERT INTO additional_info (info_content, product_id)
VALUES ('원물 고유의 특성상 모양이 균일하지 않을 수 있으나 품질에는 문제가 없습니다.', 'P000002');

-- 2. P000005 (1개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('껍질째 드실 수 있는 상품이나, 섭취 전 흐르는 물에 깨끗이 세척해 주세요.', 'P000005');

-- 3. P000008 (3개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('개봉 후에는 변질의 우려가 있으니 가급적 빨리 섭취하시기 바랍니다.', 'P000008');
INSERT INTO additional_info (info_content, product_id)
VALUES ('유통기한은 미개봉 상태 기준이며, 보관 조건에 따라 달라질 수 있습니다.', 'P000008');
INSERT INTO additional_info (info_content, product_id)
VALUES ('제품 하단에 침전물이 생길 수 있으나 원료 성분이므로 흔들어 드십시오.', 'P000008');

-- 4. P000010 (2개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('신선식품의 특성상 상품의 중량에 3%내외의 차이가 발생할 수 있습니다.', 'P000010');
INSERT INTO additional_info (info_content, product_id)
VALUES ('기온 변화에 따라 배송 중 약간의 후숙이 진행될 수 있습니다.', 'P000010');

-- 5. P000012 (1개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('이 제품은 알레르기 유발 가능성이 있는 대두, 우유를 사용한 제품과 같은 제조시설에서 생산되었습니다.', 'P000012');

-- 6. P000023 (2개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('장기 보관 시에는 소분하여 냉동 보관하시는 것을 권장합니다.', 'P000023');
INSERT INTO additional_info (info_content, product_id)
VALUES ('조리 전 충분히 해동한 후 사용하셔야 본연의 맛을 느끼실 수 있습니다.', 'P000023');

-- 7. P000027 (1개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('충격에 약한 상품이므로 배송 중 미세한 눌림 현상이 발생할 수 있습니다.', 'P000027');

-- 8. P000028 (3개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('초당옥수수 특성상 끝달림이 좋지 않을 수 있지만 정상범주내의 정상상품입니다.', 'P000029');
INSERT INTO additional_info (info_content, product_id)
VALUES ('수령 후 바로 드시지 않을 경우 껍질을 벗겨 냉동 보관해 주세요.', 'P000028');
INSERT INTO additional_info (info_content, product_id)
VALUES ('전자레인지에 3분간 돌려 드시면 가장 아삭하고 달콤하게 즐기실 수 있습니다.', 'P000028');

-- 9. P000029 (1개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('탄산이 포함된 제품으로 흔들 경우 내용물이 넘칠 수 있으니 주의하세요.', 'P000029');

-- 10. P000030 (2개 작성)
INSERT INTO additional_info (info_content, product_id)
VALUES ('포장 용기의 모서리가 날카로우니 개봉 시 손이 베이지 않도록 주의하십시오.', 'P000030');
INSERT INTO additional_info (info_content, product_id)
VALUES ('직사광선을 피해 서늘하고 건조한 곳에 실온 보관하세요.', 'P000030');

/* ===========================
   5. 상품이미지 (product_img_id 자동생성)
=========================== */

-- P000001
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000001', 'THUMB', 'P000001_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000001', 'DETAIL', 'P000001_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000001', 'CONTENT', 'P000001_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000001', 'CONTENT', 'P000001_c2.png');

-- P000002
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000002', 'THUMB', 'P000002_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000002', 'DETAIL', 'P000002_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000002', 'CONTENT', 'P000002_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000002', 'CONTENT', 'P000003_c2.png');

-- P000003
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000003', 'THUMB', 'P000003_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000003', 'DETAIL', 'P000003_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000003', 'CONTENT', 'P000003_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000003', 'CONTENT', 'P000003_c2.png');

-- P000004
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000004', 'THUMB', 'P000004_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000004', 'DETAIL', 'P000004_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000004', 'CONTENT', 'P000004_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000004', 'CONTENT', 'P000004_c2.png');

-- P000005
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000005', 'THUMB', 'P000005_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000005', 'DETAIL', 'P000005_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000005', 'CONTENT', 'P000005_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000005', 'CONTENT', 'P000005_c2.png');
-- P000006
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000006', 'THUMB', 'P000006_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000006', 'DETAIL', 'P000006_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000006', 'CONTENT', 'P000006_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000006', 'CONTENT', 'P000006_c2.png');
-- P000007
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000007', 'THUMB', 'P000007_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000007', 'DETAIL', 'P000007_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000007', 'CONTENT', 'P000007_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000007', 'CONTENT', 'P000007_c2.png');
-- P000008
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000008', 'THUMB', 'P000008_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000008', 'DETAIL', 'P000008_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000008', 'CONTENT', 'P000008_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000008', 'CONTENT', 'P000008_c2.png');
-- P000009
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000009', 'THUMB', 'P000009_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000009', 'DETAIL', 'P000009_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000009', 'CONTENT', 'P000009_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000009', 'CONTENT', 'P000009_c2.png');
-- P000010
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000010', 'THUMB', 'P000010_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000010', 'DETAIL', 'P000010_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000010', 'CONTENT', 'P000010_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000010', 'CONTENT', 'P000010_c2.png');
-- P000011
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000011', 'THUMB', 'P000011_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000011', 'DETAIL', 'P000011_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000011', 'CONTENT', 'P000011_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000011', 'CONTENT', 'P000011_c2.png');
-- P000012
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000012', 'THUMB', 'P000012_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000012', 'DETAIL', 'P000012_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000012', 'CONTENT', 'P000012_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000012', 'CONTENT', 'P000012_c2.png');
-- P000013
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000013', 'THUMB', 'P000013_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000013', 'DETAIL', 'P000013_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000013', 'CONTENT', 'P000013_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000013', 'CONTENT', 'P000013_c2.png');
-- P000014
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000014', 'THUMB', 'P000014_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000014', 'DETAIL', 'P000014_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000014', 'CONTENT', 'P000014_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000014', 'CONTENT', 'P000014_c2.png');
-- P000015
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000015', 'THUMB', 'P000015_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000015', 'DETAIL', 'P000015_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000015', 'CONTENT', 'P000015_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000015', 'CONTENT', 'P000015_c2.png');
-- P000016
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000016', 'THUMB', 'P000016_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000016', 'DETAIL', 'P000016_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000016', 'CONTENT', 'P000016_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000016', 'CONTENT', 'P000016_c2.png');
-- P000017
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000017', 'THUMB', 'P000017_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000017', 'DETAIL', 'P000017_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000017', 'CONTENT', 'P000017_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000017', 'CONTENT', 'P000017_c2.png');
-- P000018
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000018', 'THUMB', 'P000018_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000018', 'DETAIL', 'P000018_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000018', 'CONTENT', 'P000018_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000018', 'CONTENT', 'P000018_c2.png');
-- P000019
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000019', 'THUMB', 'P000019_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000019', 'DETAIL', 'P000019_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000019', 'CONTENT', 'P000019_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000019', 'CONTENT', 'P000019_c2.png');
-- P000020
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000020', 'THUMB', 'P000020_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000020', 'DETAIL', 'P000020_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000020', 'CONTENT', 'P000020_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000020', 'CONTENT', 'P000020_c2.png');
-- P000021
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000021', 'THUMB', 'P000021_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000021', 'DETAIL', 'P000021_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000021', 'CONTENT', 'P000021_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000021', 'CONTENT', 'P000021_c2.png');
-- P000022
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000022', 'THUMB', 'P000022_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000022', 'DETAIL', 'P000022_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000022', 'CONTENT', 'P000022_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000022', 'CONTENT', 'P000022_c2.png');
-- P000023
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000023', 'THUMB', 'P000023_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000023', 'DETAIL', 'P000023_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000023', 'CONTENT', 'P000023_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000023', 'CONTENT', 'P000023_c2.png');
-- P000024
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000024', 'THUMB', 'P000024_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000024', 'DETAIL', 'P000024_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000024', 'CONTENT', 'P000024_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000024', 'CONTENT', 'P000024_c2.png');
-- P000025
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000025', 'THUMB', 'P000025_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000025', 'DETAIL', 'P000025_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000025', 'CONTENT', 'P000025_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000025', 'CONTENT', 'P000025_c2.png');
-- P000026
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000026', 'THUMB', 'P000026_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000026', 'DETAIL', 'P000026_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000026', 'CONTENT', 'P000026_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000026', 'CONTENT', 'P000026_c2.png');
-- P000027
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000027', 'THUMB', 'P000027_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000027', 'DETAIL', 'P000027_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000027', 'CONTENT', 'P000027_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000027', 'CONTENT', 'P000027_c2.png');
-- P000028
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000028', 'THUMB', 'P000028_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000028', 'DETAIL', 'P000028_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000028', 'CONTENT', 'P000028_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000028', 'CONTENT', 'P000028_c2.png');
-- P000029
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000029', 'THUMB', 'P000029_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000029', 'DETAIL', 'P000029_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000029', 'CONTENT', 'P000029_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000029', 'CONTENT', 'P000029_c2.png');
-- P000030
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000030', 'THUMB', 'P000030_t.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000030', 'DETAIL', 'P000030_d.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000030', 'CONTENT', 'P000030_c.png');
INSERT INTO product_image (product_ID, image_type, URL) VALUES ('P000030', 'CONTENT', 'P000030_c2.png');



/* ===========================
   7. 상품 옵션 (option_id 자동생성: OPT000001...)
=========================== */
-- 장바구니 및 주문상세에서 활용하기 위해 기본 옵션을 추가했습니다.
-- 1. 제주 감귤 (P000001)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('제주 타이벡 감귤 3kg 로얄과', 12000, 0, 110, 'P000001');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('제주 타이벡 감귤 5kg 로얄과', 19000, 10, 85, 'P000001');

-- 2. 부사 사과 (P000002)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('실속형 부사사과 5kg', 15000, 0, 130, 'P000002');

-- 3. 겨울 시금치 (P000003)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('달달한 노지 시금치 1단', 3500, 0, 250, 'P000003');

-- 4. 핫초코 미트 (P000004)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('오리지널 핫초코 30스틱', 6500, 0, 95, 'P000004');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('대용량 오리지널 60스틱', 10500, 5, 50, 'P000004');

-- 5. 레드향 (P000005)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('제주 레드향 2kg 가정용', 28000, 0, 80, 'P000005');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('제주 레드향 3kg 선물용', 40000, 0, 40, 'P000005');

-- 6. 세척당근 (P000006)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('간편 세척당근 1kg', 4000, 0, 180, 'P000006');

-- 7. 대파 (P000007)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('흙대파 1단', 2900, 0, 400, 'P000007');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('깔끔 손질대파 500g', 3900, 10, 150, 'P000007');

-- 8. 유자차 베이스 (P000008)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('달콤 유자청 1kg 병', 8000, 0, 120, 'P000008');

-- 9. 설향 딸기 (P000009)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('논산 설향 딸기 500g 1팩', 9900, 15, 70, 'P000009');

-- 10. 한라봉 (P000010)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('제주 한라봉 2kg 실속형', 22000, 0, 95, 'P000010');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('제주 한라봉 3kg 정품과', 31000, 0, 60, 'P000010');

-- 11. 브로콜리 (P000011)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('국산 싱싱 브로콜리 2송이', 2500, 0, 160, 'P000011');

-- 12. 도라지 배즙 (P000012)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('순수 도라지배즙 30포', 19000, 0, 110, 'P000012');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('순수 도라지배즙 60포', 35000, 5, 60, 'P000012');

-- 13. 짭짤이 토마토 (P000013)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('대저 짭짤이 토마토 1kg 랜덤과', 18000, 0, 140, 'P000013');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('대저 짭짤이 토마토 2.5kg 로얄과', 36000, 0, 80, 'P000013');

-- 14. 봄동 봄나물 (P000014)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('봄동 배추 500g', 3000, 0, 200, 'P000014');

-- 15. 유기농 녹차티백 (P000015)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('보성 현미녹차 50티백', 4500, 10, 130, 'P000015');

-- 16. 성주 참외 (P000016)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('성주 참외 1.5kg (5-7과)', 14000, 0, 100, 'P000016');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('성주 참외 3kg 가정용 못난이', 20000, 10, 90, 'P000016');

-- 17. 오렌지 (P000017)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('고당도 네이블 오렌지 10과', 9900, 5, 180, 'P000017');

-- 18. 청도 미나리 (P000018)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('청도 한재 한재미나리 300g', 5000, 0, 150, 'P000018');

-- 19. 양배추 (P000019)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('통양배추 1통 (1.5kg 내외)', 3500, 0, 170, 'P000019');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('편리한 채썬 양배추 500g', 5000, 0, 100, 'P000019');

-- 20. 콜드브루 원액 (P000020)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('예가체프 블렌드 원액 500ml', 12000, 10, 90, 'P000020');

-- 21. 방울토마토 (P000021)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('국산 대추방울토마토 1kg', 7900, 0, 140, 'P000021');

-- 22. 망고 (P000022)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('태국 골드망고 4과 팩', 15000, 0, 75, 'P000022');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('태국 골드망고 8과 박스', 29000, 5, 40, 'P000022');

-- 23. 다다기오이 (P000023)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('백다다기오이 5개 묶음', 3900, 0, 220, 'P000023');

-- 24. 파프리카 혼합 (P000024)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('삼색 파프리카 3개입 1봉', 4900, 0, 190, 'P000024');

-- 25. 아이스티 복숭아 (P000025)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('복숭아 아이스티 스틱 40T', 5500, 0, 140, 'P000025');

-- 26. 고창 수박 (P000026)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('당도선별 고창수박 6-7kg', 23000, 0, 50, 'P000026');
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('특대 고창수박 8-9kg', 30000, 10, 30, 'P000026');

-- 27. 신비복숭아 (P000027)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('경산 신비복숭아 1kg 팩', 16000, 0, 85, 'P000027');

-- 28. 초당옥수수 (P000028)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('생먹는 초당옥수수 10개입', 19900, 0, 0, 'P000028');

-- 29. 탄산수 플레인 (P000029)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('플레인 탄산수 500ml x 20개', 11000, 0, 0, 'P000029');

-- 30. 유기농 콤부차 (P000030)
INSERT INTO product_option (option_name, price, discount, stockQuantity, product_id) VALUES ('레몬 콤부차 분말형 30스틱', 15000, 0, 110, 'P000030');


/* ===========================
   3. 장바구니 (cart_ID 자동생성, client_No 매핑)
=========================== */

INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (2, 'C000001', 'OPT000001', DATE '2026-01-07');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (1, 'C000001', 'OPT000008', DATE '2026-01-07');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (4, 'C000001', 'OPT000025', DATE '2026-01-07');

INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (1, 'C000002', 'OPT000012', DATE '2026-01-09');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (3, 'C000002', 'OPT000038', DATE '2026-01-09');

INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (5, 'C000003', 'OPT000003', DATE '2026-01-10');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (2, 'C000003', 'OPT000015', DATE '2026-01-10');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (1, 'C000003', 'OPT000022', DATE '2026-01-10');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (2, 'C000003', 'OPT000041', DATE '2026-01-10');

INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (1, 'C000004', 'OPT000019', DATE '2026-01-12');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (2, 'C000004', 'OPT000030', DATE '2026-01-12');

INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (3, 'C000005', 'OPT000005', DATE '2026-01-28');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (1, 'C000005', 'OPT000011', DATE '2026-01-28');
INSERT INTO shopping_cart (quantity, client_No, option_ID, INPUT_DATE) VALUES (6, 'C000005', 'OPT000034', DATE '2026-01-28');


/* ===========================
   9. 주문 (order_ID 자동생성: O000001, O000002...)
=========================== */
INSERT INTO orders (order_id, ORDER_DATE, total_amount, ORDER_STATUS, DELIVERY_STATUS, DELIVERY_REQUEST, DELIVERY_START_DATE, DELIVERY_COMPLETION_DATE, CLIENT_NO)
VALUES ('O000001', DATE '2026-01-07', 103600, '일반배송', '배송대기', '배송요청사항없음',null,null, 'C000001');

INSERT INTO orders (order_id, ORDER_DATE, total_amount, ORDER_STATUS, DELIVERY_STATUS, DELIVERY_REQUEST, DELIVERY_START_DATE, DELIVERY_COMPLETION_DATE, CLIENT_NO)
VALUES ('O000002', DATE '2026-01-09', 56000, '일반배송', '배송대기', '배송요청사항없음', null, null, 'C000002');

INSERT INTO orders (order_id, ORDER_DATE, total_amount, ORDER_STATUS, DELIVERY_STATUS, DELIVERY_REQUEST, DELIVERY_START_DATE, DELIVERY_COMPLETION_DATE, CLIENT_NO)
VALUES ('O000003', DATE '2026-01-10', 171500, '일반배송', '배송중', '배송요청사항없음', DATE '2026-01-10', null, 'C000003');

INSERT INTO orders (TRACKING_NUMBER, order_id, ORDER_DATE, total_amount, ORDER_STATUS, DELIVERY_STATUS, DELIVERY_REQUEST, DELIVERY_START_DATE, DELIVERY_COMPLETION_DATE, CLIENT_NO)
VALUES ('TN000001', 'O000004', DATE '2026-01-12', 33800, '일반배송', '배송완료', '배송요청사항없음', DATE '2026-01-13', DATE '2026-06-14', 'C000004');

INSERT INTO orders (TRACKING_NUMBER, order_id, ORDER_DATE, total_amount, ORDER_STATUS, DELIVERY_STATUS, DELIVERY_REQUEST, DELIVERY_START_DATE, DELIVERY_COMPLETION_DATE, CLIENT_NO)
VALUES ('TN000002', 'O000005', DATE '2026-01-28', 52800, '일반배송', '배송완료', '배송요청사항없음', DATE '2026-01-29', DATE '2026-02-01', 'C000005');

/* ===========================
   10. 주문상세 (order_details_ID 자동생성: OD000001...)
=========================== */
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (2, 12000,'OPT000001','O000001');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (1, 40000,'OPT000008','O000001');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (4, 9900,'OPT000025','O000001');

INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (1, 8000,'OPT000012','O000002');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (3, 16000,'OPT000038','O000002');

INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (5, 15000,'OPT000003','O000003');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (2, 31000,'OPT000015','O000003');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (1, 4500,'OPT000022','O000003');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (2, 15000,'OPT000041','O000003');

INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (1, 18000,'OPT000019','O000004');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (2, 7900,'OPT000030','O000004');

INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (3, 6500,'OPT000005','O000005');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (1, 3900,'OPT000011','O000005');
INSERT INTO ORDER_DETAILS (QUANTITY, PRICE, OPTION_ID, ORDER_ID) VALUES (6, 4900,'OPT000034','O000005');



/* ===========================
   11. 결제 (paymentID 자동생성)
=========================== */
INSERT INTO payment (order_ID, payment_type, payment_date) VALUES ('O000001', '일반결제', DATE '2026-01-07');
INSERT INTO payment (order_ID, payment_type, payment_date) VALUES ('O000002', '자동결제', DATE '2026-01-09');
INSERT INTO payment (order_ID, payment_type, payment_date) VALUES ('O000003', '브랜드페이', DATE '2026-01-10');
INSERT INTO payment (order_ID, payment_type, payment_date) VALUES ('O000004', '브랜드페이', DATE '2026-01-12');
INSERT INTO payment (order_ID, payment_type, payment_date) VALUES ('O000005', '브랜드페이', DATE '2026-01-28');

/* ===========================
   13. 배송지 (delivery_ID 자동생성: DLV000001...)
=========================== */
-- 주의: select_delivery가 참조할 ID가 먼저 생성되어야 하므로 순서를 바꿨습니다.
INSERT INTO delivery_destination (recipient , recipient_phone, delivery_postcode, delivery_addr, first_destination, client_No, DELIVERY_INPUT_DATE)
VALUES ('홍길동', '010-1111-1111', '05800', '서울시 송파구 문정동', 'T', 'C000001', DATE '2026-01-07');

INSERT INTO delivery_destination (recipient , recipient_phone, delivery_postcode, delivery_addr, first_destination, client_No, DELIVERY_INPUT_DATE)
VALUES ('홍길동', '010-1111-1111', '05820', '서울시 송파구 장지동', 'F', 'C000001', DATE '2026-01-07');

INSERT INTO delivery_destination (recipient , recipient_phone, delivery_postcode, delivery_addr, first_destination, client_No, DELIVERY_INPUT_DATE)
VALUES ('김철수', '010-2222-2222', '06134', '서울특별시 강남구 테헤란로 152', 'T', 'C000002', DATE '2026-01-09');

INSERT INTO delivery_destination (recipient , recipient_phone, delivery_postcode, delivery_addr, first_destination, client_No, DELIVERY_INPUT_DATE)
VALUES ('김철수', '010-2222-2222', '48058', '부산광역시 해운대구 센텀중앙로 97', 'F', 'C000002', DATE '2026-01-09');

INSERT INTO delivery_destination (recipient , recipient_phone, delivery_postcode, delivery_addr, first_destination, client_No, DELIVERY_INPUT_DATE)
VALUES ('이영희', '010-3333-3333', '35209', '대전광역시 서구 둔산로 100', 'T', 'C000003', DATE '2026-01-10');

INSERT INTO delivery_destination (recipient , recipient_phone, delivery_postcode, delivery_addr, first_destination, client_No, DELIVERY_INPUT_DATE)
VALUES ('박민수', '010-1111-0004', '21984', '인천광역시 연수구 송도과학로 32', 'T', 'C000004', DATE '2026-01-12');

INSERT INTO delivery_destination (recipient , recipient_phone, delivery_postcode, delivery_addr, first_destination, client_No, DELIVERY_INPUT_DATE)
VALUES ('박민수', '010-1111-0004', '61947', '광주광역시 서구 상무중앙로 58', 'F', 'C000004', DATE '2026-01-12');

INSERT INTO delivery_destination (recipient , recipient_phone, delivery_postcode, delivery_addr, first_destination, client_No, DELIVERY_INPUT_DATE)
VALUES ('최유리', '010-1111-0005', '05820', '서울시 송파구 장지동', 'T', 'C000005', DATE '2026-01-28');


/* ===========================
   12. 선택배송지 (매핑 테이블)
=========================== */
INSERT INTO select_delivery (delivery_ID, order_ID) VALUES ('DLV000001', 'O000001');
INSERT INTO select_delivery (delivery_ID, order_ID) VALUES ('DLV000003', 'O000002');
INSERT INTO select_delivery (delivery_ID, order_ID) VALUES ('DLV000005', 'O000003');
INSERT INTO select_delivery (delivery_ID, order_ID) VALUES ('DLV000006', 'O000004');
INSERT INTO select_delivery (delivery_ID, order_ID) VALUES ('DLV000008', 'O000005');


/* ===========================
   15. 문의유형 (inquiry_code 자동생성: TYP000001...)
=========================== */
-- 문의내역 테이블보다 먼저 들어가야 에러가 안 납니다.
INSERT INTO inquiry_type (inquiry_name, inquiry_type) VALUES ('주문/결제', '1대1 문의'); -- TYP000001
INSERT INTO inquiry_type (inquiry_name, inquiry_type) VALUES ('서비스/오류/기타', '1대1 문의'); -- TYP000001
INSERT INTO inquiry_type (inquiry_name, inquiry_type) VALUES ('상품상세문의', '상품 문의');   -- TYP000002


/* ===========================
   14. 문의 (inquiry_ID 자동생성)
=========================== */
--상품
INSERT INTO inquiry (  inquiry_title,INQUIRY_DATE, inquiry_secret, inquiry_content, answer_status, answer, answer_date, inquiry_code, order_details_ID, CLIENT_NO)
VALUES ( '배송이 안 와요', '2026-06-02', 'T', '언제 오나요?', '답변완료', '조금만 기다려주세요.', SYSDATE, 'TYP000002', 'OD000001', 'C000001');

INSERT INTO inquiry ( inquiry_title,INQUIRY_DATE, inquiry_secret, inquiry_content, answer_status, inquiry_code, order_details_ID, CLIENT_NO)
VALUES ( '유통기한 문의',date '2026-07-02', 'F', '언제까지인가요?', '대기중', 'TYP000002', 'OD000004', 'C000002');

INSERT INTO inquiry (  inquiry_title,INQUIRY_DATE, inquiry_secret, inquiry_content, answer_status, inquiry_code, order_details_ID, CLIENT_NO)
VALUES ( '재입고 일정',date '2026-05-02', 'T', '재입고 언제 되죠?', '대기중', 'TYP000002', 'OD000008', 'C000003');
--1대1
INSERT INTO inquiry (  inquiry_title,INQUIRY_DATE, inquiry_secret, inquiry_content, answer_status, inquiry_code,  CLIENT_NO)
VALUES ( '환불 문의',date '2026-04-02', 'T', '환불 문의', '답변완료', 'TYP000001', 'C000004');

INSERT INTO inquiry (  inquiry_title,INQUIRY_DATE, inquiry_secret, inquiry_content, answer_status, inquiry_code,  CLIENT_NO)
VALUES ( '결제 오류',date '2026-06-05', 'T', '카드 결제는 완료되었는데 주문이 생성되지 않았습니다', '대기중', 'TYP000001', 'C000005');


/* ===========================
   16. 클레임 (claim_ID 자동생성: CLM000001...)
=========================== */
INSERT INTO claim (claim_type, requestdate, reason, reason_detail, status, processingdate, order_details_ID)
VALUES ('취소', DATE '2026-01-08', '구매취소','단순 변심으로 취소 신청', '처리완료', DATE '2026-01-08', 'OD000001');

INSERT INTO claim (claim_type, requestdate, reason, reason_detail, status, processingdate, order_details_ID)
VALUES ('교환', DATE '2026-01-09', '오배송', '주문한 상품과 다른 상품이 배송됨', '처리중', NULL, 'OD000003');

INSERT INTO claim (claim_type, requestdate, reason, reason_detail, status, processingdate, order_details_ID)
VALUES ('반품', DATE '2026-01-10', '단순변심', '생각했던 상품과 달라 반품 요청', '접수완료', NULL, 'OD000005');


/* ===========================
   17. 클레임이미지 (claim_img_ID 자동생성)
=========================== */
INSERT INTO claim_image (claim_ID, file_name) VALUES ('CLM000001', 'damage1.jpg');
INSERT INTO claim_image (claim_ID, file_name) VALUES ('CLM000001', 'damage2.jpg');
INSERT INTO claim_image (claim_ID, file_name) VALUES ('CLM000001', 'damage3.jpg');
INSERT INTO claim_image (claim_ID, file_name) VALUES ('CLM000001', 'damage4.jpg');
INSERT INTO claim_image (claim_ID, file_name) VALUES ('CLM000002', 'wrong_item.jpg');
INSERT INTO claim_image (claim_ID, file_name) VALUES ('CLM000003', 'return_request.jpg');

COMMIT;
