/* 회원 */
CREATE TABLE ohora.oh_usr (
   usr_num NUMBER NOT NULL, /* 회원번호 */
   usr_id VARCHAR2(16 CHAR) NOT NULL, /* 회원ID */
   usr_tel VARCHAR2(14 CHAR), /* 일반전화 */
   usr_phone VARCHAR2(14 CHAR), /* 휴대전화 */
   usr_name VARCHAR2(20 CHAR) NOT NULL, /* 이름 */
   usr_email VARCHAR2(50) NOT NULL, /* 이메일 */
   usr_email_yn CHAR(1 CHAR), /* 이메일 수신 여부 */
   usr_sms_yn CHAR(1 CHAR), /* SMS 수신 여부 */
   usr_level VARCHAR2(6), /* 등급명 */
   usr_birth DATE, /* 생년월일 */
   usr_pw VARCHAR2(16 CHAR) NOT NULL /* 비밀번호 */
);

COMMENT ON TABLE ohora.oh_usr IS '회원';

COMMENT ON COLUMN ohora.oh_usr.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_usr.usr_id IS '회원ID';

COMMENT ON COLUMN ohora.oh_usr.usr_tel IS '일반전화';

COMMENT ON COLUMN ohora.oh_usr.usr_phone IS '휴대전화';

COMMENT ON COLUMN ohora.oh_usr.usr_name IS '이름';

COMMENT ON COLUMN ohora.oh_usr.usr_email IS '이메일';

COMMENT ON COLUMN ohora.oh_usr.usr_email_yn IS '이메일 수신 여부';

COMMENT ON COLUMN ohora.oh_usr.usr_sms_yn IS 'SMS 수신 여부';

COMMENT ON COLUMN ohora.oh_usr.usr_level IS '등급명';

COMMENT ON COLUMN ohora.oh_usr.usr_birth IS '생년월일';

COMMENT ON COLUMN ohora.oh_usr.usr_pw IS '비밀번호';

CREATE UNIQUE INDEX ohora.PK_oh_usr
   ON ohora.oh_usr (
      usr_num ASC
   );

ALTER TABLE ohora.oh_usr
   ADD
      CONSTRAINT PK_oh_usr
      PRIMARY KEY (
         usr_num
      );

/* 등급 */
CREATE TABLE ohora.oh_level (
   usr_num NUMBER NOT NULL, /* 회원번호 */
   usr_level NVARCHAR2(6) NOT NULL, /* 등급명 */
   point_rate NUMBER NOT NULL /* 적립율 */
);

COMMENT ON TABLE ohora.oh_level IS '등급';

COMMENT ON COLUMN ohora.oh_level.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_level.usr_level IS '등급명';

COMMENT ON COLUMN ohora.oh_level.point_rate IS '적립율';

CREATE UNIQUE INDEX ohora.PK_oh_level
   ON ohora.oh_level (
      usr_num ASC
   );

ALTER TABLE ohora.oh_level
   ADD
      CONSTRAINT PK_oh_level
      PRIMARY KEY (
         usr_num
      );

/* 배송주소록 */
CREATE TABLE ohora.oh_delivery_list (
   usr_num NUMBER NOT NULL, /* 회원번호 */
   dl_addr VARCHAR2(50 CHAR) NOT NULL, /* 배송주소 */
   dl_phone VARCHAR2(14 CHAR) NOT NULL, /* 휴대전화 */
   dl_tel VARCHAR2(14 CHAR), /* 일반전화 */
   dl_name VARCHAR2(20 CHAR) NOT NULL, /* 수령인 */
   dl_nick VARCHAR2(10 CHAR) NOT NULL, /* 배송지명 */
   dl_dyn CHAR(1 CHAR) /* 기본 배송지 여부 */
);

COMMENT ON TABLE ohora.oh_delivery_list IS '배송주소록';

COMMENT ON COLUMN ohora.oh_delivery_list.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_addr IS '배송주소';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_phone IS '휴대전화';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_tel IS '일반전화';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_name IS '수령인';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_nick IS '배송지명';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_dyn IS '기본 배송지 여부';

CREATE UNIQUE INDEX ohora.PK_oh_delivery_list
   ON ohora.oh_delivery_list (
      usr_num ASC
   );

ALTER TABLE ohora.oh_delivery_list
   ADD
      CONSTRAINT PK_oh_delivery_list
      PRIMARY KEY (
         usr_num
      );

/* 게시판 */
CREATE TABLE ohora.oh_board (
   brd_num NUMBER NOT NULL, /* 글 번호 */
   brd_theme VARCHAR2(20 CHAR), /* 게시판 이름 */
   brd_title VARCHAR2(20 CHAR), /* 제목 */
   brd_content VARCHAR2(500 CHAR), /* 내용 */
   brd_date DATE, /* 작성일 */
   brd_media VARCHAR2(100 CHAR), /* 첨부파일 */
   brd_view NUMBER, /* 조회수 */
   usr_num NUMBER NOT NULL /* 회원번호 */
);

COMMENT ON TABLE ohora.oh_board IS '게시판';

COMMENT ON COLUMN ohora.oh_board.brd_num IS '글 번호';

COMMENT ON COLUMN ohora.oh_board.brd_theme IS '게시판 이름';

COMMENT ON COLUMN ohora.oh_board.brd_title IS '제목';

COMMENT ON COLUMN ohora.oh_board.brd_content IS '내용';

COMMENT ON COLUMN ohora.oh_board.brd_date IS '작성일';

COMMENT ON COLUMN ohora.oh_board.brd_media IS '첨부파일';

COMMENT ON COLUMN ohora.oh_board.brd_view IS '조회수';

COMMENT ON COLUMN ohora.oh_board.usr_num IS '회원번호';

CREATE UNIQUE INDEX ohora.PK_oh_board
   ON ohora.oh_board (
      brd_num ASC
   );

ALTER TABLE ohora.oh_board
   ADD
      CONSTRAINT PK_oh_board
      PRIMARY KEY (
         brd_num
      );

/* 댓글 */
CREATE TABLE ohora.oh_comments (
   co_num NUMBER NOT NULL, /* 댓글 번호 */
   co_content VARCHAR2(100 CHAR), /* 내용 */
   usr_num NUMBER NOT NULL /* 회원번호 */
);

COMMENT ON TABLE ohora.oh_comments IS '댓글';

COMMENT ON COLUMN ohora.oh_comments.co_num IS '댓글 번호';

COMMENT ON COLUMN ohora.oh_comments.co_content IS '내용';

COMMENT ON COLUMN ohora.oh_comments.usr_num IS '회원번호';

CREATE UNIQUE INDEX ohora.PK_oh_comments
   ON ohora.oh_comments (
      co_num ASC
   );

ALTER TABLE ohora.oh_comments
   ADD
      CONSTRAINT PK_oh_comments
      PRIMARY KEY (
         co_num
      );

/* 리뷰 */
CREATE TABLE ohora.oh_review (
   rv_num NUMBER NOT NULL, /* 리뷰 번호 */
   rv_title VARCHAR2(20 CHAR) NOT NULL, /* 제목 */
   rv_content VARCHAR2(100 CHAR) NOT NULL, /* 내용 */
   rv_media VARCHAR2(100 CHAR), /* 이미지/영상 */
   rv_date DATE, /* 작성일자 */
   rv_score NUMBER, /* 평점(별점) */
   rv_like NUMBER, /* 추천(도움돼요) */
   rv_rank NUMBER NOT NULL, /* 순위 */
   usr_num NUMBER NOT NULL, /* 회원번호 */
   od_num NUMBER, /* 주문번호 */
   pd_num NUMBER NOT NULL /* 상품번호 */
);

COMMENT ON TABLE ohora.oh_review IS '리뷰';

COMMENT ON COLUMN ohora.oh_review.rv_num IS '리뷰 번호';

COMMENT ON COLUMN ohora.oh_review.rv_title IS '제목';

COMMENT ON COLUMN ohora.oh_review.rv_content IS '내용';

COMMENT ON COLUMN ohora.oh_review.rv_media IS '이미지/영상';

COMMENT ON COLUMN ohora.oh_review.rv_date IS '작성일자';

COMMENT ON COLUMN ohora.oh_review.rv_score IS '평점(별점)';

COMMENT ON COLUMN ohora.oh_review.rv_like IS '추천(도움돼요)';

COMMENT ON COLUMN ohora.oh_review.rv_rank IS '순위';

COMMENT ON COLUMN ohora.oh_review.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_review.od_num IS '주문번호';

COMMENT ON COLUMN ohora.oh_review.pd_num IS '상품번호';

CREATE UNIQUE INDEX ohora.PK_oh_review
   ON ohora.oh_review (
      rv_num ASC
   );

ALTER TABLE ohora.oh_review
   ADD
      CONSTRAINT PK_oh_review
      PRIMARY KEY (
         rv_num
      );

/* 적립금 */
CREATE TABLE ohora.oh_point (
   usr_num NUMBER NOT NULL, /* 회원번호 */
   pt_date DATE NOT NULL, /* 적립일 */
   pt_point NUMBER, /* 적립액 */
   usr_level VARCHAR2(6), /* 등급명 */
   rv_num NUMBER /* 리뷰 번호 */
);

COMMENT ON TABLE ohora.oh_point IS '적립금';

COMMENT ON COLUMN ohora.oh_point.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_point.pt_date IS '적립일';

COMMENT ON COLUMN ohora.oh_point.pt_point IS '적립액';

COMMENT ON COLUMN ohora.oh_point.usr_level IS '등급명';

COMMENT ON COLUMN ohora.oh_point.rv_num IS '리뷰 번호';

CREATE UNIQUE INDEX ohora.PK_oh_point
   ON ohora.oh_point (
      usr_num ASC
   );

ALTER TABLE ohora.oh_point
   ADD
      CONSTRAINT PK_oh_point
      PRIMARY KEY (
         usr_num
      );

/* 쿠폰 */
CREATE TABLE ohora.oh_coupon (
   cp_num NUMBER NOT NULL, /* 쿠폰번호 */
   cp_name VARCHAR2(50 CHAR) NOT NULL, /* 쿠폰 이름 */
   cp_rate NUMBER, /* 쿠폰 할인율 */
   usr_num NUMBER NOT NULL, /* 회원번호 */
   cr_num NUMBER NOT NULL /* 쿠폰조건번호 */
);

COMMENT ON TABLE ohora.oh_coupon IS '쿠폰';

COMMENT ON COLUMN ohora.oh_coupon.cp_num IS '쿠폰번호';

COMMENT ON COLUMN ohora.oh_coupon.cp_name IS '쿠폰 이름';

COMMENT ON COLUMN ohora.oh_coupon.cp_rate IS '쿠폰 할인율';

COMMENT ON COLUMN ohora.oh_coupon.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_coupon.cr_num IS '쿠폰조건번호';

CREATE UNIQUE INDEX ohora.PK_oh_coupon
   ON ohora.oh_coupon (
      cp_num ASC
   );

ALTER TABLE ohora.oh_coupon
   ADD
      CONSTRAINT PK_oh_coupon
      PRIMARY KEY (
         cp_num
      );

/* 쿠폰조건 */
CREATE TABLE ohora.oh_cpn_req (
   cr_num NUMBER NOT NULL, /* 쿠폰조건번호 */
   cr_date DATE NOT NULL, /* 유효기간 */
   cr_ratio NUMBER, /* 쿠폰 할인율 */
   cr_price NUMBER, /* 금액 조건 */
   cr_product VARCHAR2(50 CHAR), /* 적용 대상 */
   od_num NUMBER NOT NULL, /* 주문번호 */
   pd_num NUMBER NOT NULL /* 상품번호 */
);

COMMENT ON TABLE ohora.oh_cpn_req IS '쿠폰조건';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_num IS '쿠폰조건번호';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_date IS '유효기간';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_ratio IS '쿠폰 할인율';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_price IS '금액 조건';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_product IS '적용 대상';

COMMENT ON COLUMN ohora.oh_cpn_req.od_num IS '주문번호';

COMMENT ON COLUMN ohora.oh_cpn_req.pd_num IS '상품번호';

CREATE UNIQUE INDEX ohora.PK_oh_cpn_req
   ON ohora.oh_cpn_req (
      cr_num ASC
   );

ALTER TABLE ohora.oh_cpn_req
   ADD
      CONSTRAINT PK_oh_cpn_req
      PRIMARY KEY (
         cr_num
      );

/* 주문 */
CREATE TABLE ohora.oh_order (
   od_num NUMBER NOT NULL, /* 주문번호 */
   od_date DATE NOT NULL, /* 주문일자 */
   od_price NUMBER, /* 상품금액 */
   od_status CHAR(1 CHAR) NOT NULL, /* 주문 처리상태 */
   od_cancel VARCHAR2(2 CHAR), /* 취소/교환/반품 처리상태 */
   usr_num NUMBER NOT NULL, /* 회원번호 */
   pd_num NUMBER NOT NULL, /* 상품번호 */
   cart_num NUMBER /* 장바구니번호 */
);

COMMENT ON TABLE ohora.oh_order IS '주문';

COMMENT ON COLUMN ohora.oh_order.od_num IS '주문번호';

COMMENT ON COLUMN ohora.oh_order.od_date IS '주문일자';

COMMENT ON COLUMN ohora.oh_order.od_price IS '상품금액';

COMMENT ON COLUMN ohora.oh_order.od_status IS '주문 처리상태';

COMMENT ON COLUMN ohora.oh_order.od_cancel IS '취소/교환/반품 처리상태';

COMMENT ON COLUMN ohora.oh_order.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_order.pd_num IS '상품번호';

COMMENT ON COLUMN ohora.oh_order.cart_num IS '장바구니번호';

CREATE UNIQUE INDEX ohora.PK_oh_order
   ON ohora.oh_order (
      od_num ASC
   );

ALTER TABLE ohora.oh_order
   ADD
      CONSTRAINT PK_oh_order
      PRIMARY KEY (
         od_num
      );

/* 사은품 조건 */
CREATE TABLE ohora.oh_gift (
   usr_num NUMBER NOT NULL, /* 회원번호 */
   pd_num NUMBER NOT NULL, /* 상품번호 */
   od_num NUMBER NOT NULL, /* 주문번호 */
   gift_price NUMBER /* 사은품 가격 */
);

COMMENT ON TABLE ohora.oh_gift IS '사은품 조건';

COMMENT ON COLUMN ohora.oh_gift.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_gift.pd_num IS '상품번호';

COMMENT ON COLUMN ohora.oh_gift.od_num IS '주문번호';

COMMENT ON COLUMN ohora.oh_gift.gift_price IS '사은품 가격';

CREATE UNIQUE INDEX ohora.PK_oh_gift
   ON ohora.oh_gift (
      usr_num ASC
   );

ALTER TABLE ohora.oh_gift
   ADD
      CONSTRAINT PK_oh_gift
      PRIMARY KEY (
         usr_num
      );

/* 장바구니 */
CREATE TABLE ohora.oh_cart (
   cart_num NUMBER NOT NULL, /* 장바구니번호 */
   usr_num NUMBER NOT NULL, /* 회원번호 */
   pd_num NUMBER, /* 상품번호 */
   cart_pdcnt NUMBER /* 상품수량 */
);

COMMENT ON TABLE ohora.oh_cart IS '장바구니';

COMMENT ON COLUMN ohora.oh_cart.cart_num IS '장바구니번호';

COMMENT ON COLUMN ohora.oh_cart.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_cart.pd_num IS '상품번호';

COMMENT ON COLUMN ohora.oh_cart.cart_pdcnt IS '상품수량';

CREATE UNIQUE INDEX ohora.PK_oh_cart
   ON ohora.oh_cart (
      cart_num ASC
   );

ALTER TABLE ohora.oh_cart
   ADD
      CONSTRAINT PK_oh_cart
      PRIMARY KEY (
         cart_num
      );

/* 상품 */
CREATE TABLE ohora.oh_product (
   pd_num NUMBER NOT NULL, /* 상품번호 */
   pd_name VARCHAR2(50 CHAR) NOT NULL, /* 상품명 */
   pd_date DATE, /* 출시일 */
   pd_stock NUMBER, /* 재고수 */
   pd_price NUMBER, /* 정가 */
   pd_dc_price NUMBER, /* 할인가 */
   pd_view NUMBER, /* 조회수 */
   pd_media VARCHAR2(100 CHAR), /* 썸네일 */
   pd_dc_rate NUMBER, /* 자체 할인율 */
   pd_tot_buy NUMBER /* 총 구매수(상품 인기도) */
);

COMMENT ON TABLE ohora.oh_product IS '상품';

COMMENT ON COLUMN ohora.oh_product.pd_num IS '상품번호';

COMMENT ON COLUMN ohora.oh_product.pd_name IS '상품명';

COMMENT ON COLUMN ohora.oh_product.pd_date IS '출시일';

COMMENT ON COLUMN ohora.oh_product.pd_stock IS '재고수';

COMMENT ON COLUMN ohora.oh_product.pd_price IS '정가';

COMMENT ON COLUMN ohora.oh_product.pd_dc_price IS '할인가';

COMMENT ON COLUMN ohora.oh_product.pd_view IS '조회수';

COMMENT ON COLUMN ohora.oh_product.pd_media IS '썸네일';

COMMENT ON COLUMN ohora.oh_product.pd_dc_rate IS '자체 할인율';

COMMENT ON COLUMN ohora.oh_product.pd_tot_buy IS '총 구매수(상품 인기도)';

CREATE UNIQUE INDEX ohora.PK_oh_product
   ON ohora.oh_product (
      pd_num ASC
   );

ALTER TABLE ohora.oh_product
   ADD
      CONSTRAINT PK_oh_product
      PRIMARY KEY (
         pd_num
      );

/* 디자인 */
CREATE TABLE ohora.oh_mydesign (
   pmd_hashtag VARCHAR2(10 CHAR) NOT NULL, /* 해시태그 */
   pd_num NUMBER NOT NULL, /* 상품번호 */
   pmd_lineup VARCHAR2(10 CHAR), /* 라인업 */
   pmd_color VARCHAR2(10 CHAR), /* 컬러 */
   pmd_design VARCHAR2(10 CHAR) /* 디자인 */
);

COMMENT ON TABLE ohora.oh_mydesign IS '디자인';

COMMENT ON COLUMN ohora.oh_mydesign.pmd_hashtag IS '해시태그';

COMMENT ON COLUMN ohora.oh_mydesign.pd_num IS '상품번호';

COMMENT ON COLUMN ohora.oh_mydesign.pmd_lineup IS '라인업';

COMMENT ON COLUMN ohora.oh_mydesign.pmd_color IS '컬러';

COMMENT ON COLUMN ohora.oh_mydesign.pmd_design IS '디자인';

CREATE UNIQUE INDEX ohora.PK_oh_mydesign
   ON ohora.oh_mydesign (
      pmd_hashtag ASC,
      pd_num ASC
   );

ALTER TABLE ohora.oh_mydesign
   ADD
      CONSTRAINT PK_oh_mydesign
      PRIMARY KEY (
         pmd_hashtag,
         pd_num
      );

/* 카테고리 */
CREATE TABLE ohora.oh_category (
   pd_num NUMBER NOT NULL, /* 상품번호 */
   pc_fir VARCHAR2(20 CHAR) NOT NULL, /* 대분류 */
   pc_sec VARCHAR2(20 CHAR), /* 중분류 */
   pc_thd VARCHAR2(20 CHAR) /* 소분류 */
);

COMMENT ON TABLE ohora.oh_category IS '카테고리';

COMMENT ON COLUMN ohora.oh_category.pd_num IS '상품번호';

COMMENT ON COLUMN ohora.oh_category.pc_fir IS '대분류';

COMMENT ON COLUMN ohora.oh_category.pc_sec IS '중분류';

COMMENT ON COLUMN ohora.oh_category.pc_thd IS '소분류';

CREATE UNIQUE INDEX ohora.PK_oh_category
   ON ohora.oh_category (
      pd_num ASC
   );

ALTER TABLE ohora.oh_category
   ADD
      CONSTRAINT PK_oh_category
      PRIMARY KEY (
         pd_num
      );

/* 주문 상세 */
CREATE TABLE ohora.oh_order_sub (
   os_num NUMBER NOT NULL, /* 주문 상세 번호 */
   od_num NUMBER, /* 주문번호 */
   os_price NUMBER, /* 상품금액 */
   os_pay_delivery NUMBER, /* 배송비 */
   os_name VARCHAR2(50 CHAR) /* 상품 이름 */
);

COMMENT ON TABLE ohora.oh_order_sub IS '주문 상세';

COMMENT ON COLUMN ohora.oh_order_sub.os_num IS '주문 상세 번호';

COMMENT ON COLUMN ohora.oh_order_sub.od_num IS '주문번호';

COMMENT ON COLUMN ohora.oh_order_sub.os_price IS '상품금액';

COMMENT ON COLUMN ohora.oh_order_sub.os_pay_delivery IS '배송비';

COMMENT ON COLUMN ohora.oh_order_sub.os_name IS '상품 이름';

CREATE UNIQUE INDEX ohora.PK_oh_order_sub
   ON ohora.oh_order_sub (
      os_num ASC
   );

ALTER TABLE ohora.oh_order_sub
   ADD
      CONSTRAINT PK_oh_order_sub
      PRIMARY KEY (
         os_num
      );

/* 결제 */
CREATE TABLE ohora.oh_pay (
   pay_num NUMBER NOT NULL, /* 결제번호 */
   od_num NUMBER NOT NULL, /* 주문번호 */
   usr_num NUMBER NOT NULL, /* 회원번호 */
   cp_num NUMBER NOT NULL, /* 쿠폰번호 */
   pay_way VARCHAR2(20 CHAR), /* 결제수단이름 */
   pay_date DATE, /* 결제일자 */
   pay_delivery NUMBER /* 배송비 */
);

COMMENT ON TABLE ohora.oh_pay IS '결제';

COMMENT ON COLUMN ohora.oh_pay.pay_num IS '결제번호';

COMMENT ON COLUMN ohora.oh_pay.od_num IS '주문번호';

COMMENT ON COLUMN ohora.oh_pay.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_pay.cp_num IS '쿠폰번호';

COMMENT ON COLUMN ohora.oh_pay.pay_way IS '결제수단이름';

COMMENT ON COLUMN ohora.oh_pay.pay_date IS '결제일자';

COMMENT ON COLUMN ohora.oh_pay.pay_delivery IS '배송비';

CREATE UNIQUE INDEX ohora.PK_oh_pay
   ON ohora.oh_pay (
      pay_num ASC
   );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT PK_oh_pay
      PRIMARY KEY (
         pay_num
      );

/* 배송 */
CREATE TABLE ohora.oh_delivery (
   d_num NUMBER NOT NULL, /* 운송장 번호 */
   d_finish DATE, /* 배송 완료일 */
   d_start DATE, /* 배송 시작일 */
   d_status VARCHAR2(20 CHAR), /* 배송 상태 */
   usr_num NUMBER NOT NULL /* 회원번호 */
);

COMMENT ON TABLE ohora.oh_delivery IS '배송';

COMMENT ON COLUMN ohora.oh_delivery.d_num IS '운송장 번호';

COMMENT ON COLUMN ohora.oh_delivery.d_finish IS '배송 완료일';

COMMENT ON COLUMN ohora.oh_delivery.d_start IS '배송 시작일';

COMMENT ON COLUMN ohora.oh_delivery.d_status IS '배송 상태';

COMMENT ON COLUMN ohora.oh_delivery.usr_num IS '회원번호';

CREATE UNIQUE INDEX ohora.PK_oh_delivery
   ON ohora.oh_delivery (
      d_num ASC
   );

ALTER TABLE ohora.oh_delivery
   ADD
      CONSTRAINT PK_oh_delivery
      PRIMARY KEY (
         d_num
      );

/* 취소/교환/반품 */
CREATE TABLE ohora.oh_order_cncl (
   od_num NUMBER NOT NULL, /* 주문번호 */
   pd_num NUMBER NOT NULL, /* 상품번호 */
   oc_reason VARCHAR2(20 CHAR), /* 상세 사유 */
   oc_check VARCHAR2(20 CHAR) NOT NULL, /* 사유 선택 */
   oc_status VARCHAR2(20 CHAR), /* 진행 상태 */
   oc_cnt NUMBER /* 취소 수량 */
);

COMMENT ON TABLE ohora.oh_order_cncl IS '취소/교환/반품';

COMMENT ON COLUMN ohora.oh_order_cncl.od_num IS '주문번호';

COMMENT ON COLUMN ohora.oh_order_cncl.pd_num IS '상품번호';

COMMENT ON COLUMN ohora.oh_order_cncl.oc_reason IS '상세 사유';

COMMENT ON COLUMN ohora.oh_order_cncl.oc_check IS '사유 선택';

COMMENT ON COLUMN ohora.oh_order_cncl.oc_status IS '진행 상태';

COMMENT ON COLUMN ohora.oh_order_cncl.oc_cnt IS '취소 수량';

CREATE UNIQUE INDEX ohora.PK_oh_order_cncl
   ON ohora.oh_order_cncl (
      od_num ASC,
      pd_num ASC
   );

ALTER TABLE ohora.oh_order_cncl
   ADD
      CONSTRAINT PK_oh_order_cncl
      PRIMARY KEY (
         od_num,
         pd_num
      );

/* 권한 */
CREATE TABLE ohora.oh_roles (
   usr_num NUMBER NOT NULL, /* 회원번호 */
   role_name VARCHAR2(10 CHAR) /* 권한이름 */
);

COMMENT ON TABLE ohora.oh_roles IS '권한';

COMMENT ON COLUMN ohora.oh_roles.usr_num IS '회원번호';

COMMENT ON COLUMN ohora.oh_roles.role_name IS '권한이름';

CREATE UNIQUE INDEX ohora.PK_oh_roles
   ON ohora.oh_roles (
      usr_num ASC
   );

ALTER TABLE ohora.oh_roles
   ADD
      CONSTRAINT PK_oh_roles
      PRIMARY KEY (
         usr_num
      );

/* 결제수단 */
CREATE TABLE ohora.oh_pay_type (
   pay_way VARCHAR2(20 CHAR) NOT NULL, /* 결제수단이름 */
   od_num NUMBER /* 주문번호 */
);

COMMENT ON TABLE ohora.oh_pay_type IS '결제수단';

COMMENT ON COLUMN ohora.oh_pay_type.pay_way IS '결제수단이름';

COMMENT ON COLUMN ohora.oh_pay_type.od_num IS '주문번호';

CREATE UNIQUE INDEX ohora.PK_oh_pay_type
   ON ohora.oh_pay_type (
      pay_way ASC
   );

ALTER TABLE ohora.oh_pay_type
   ADD
      CONSTRAINT PK_oh_pay_type
      PRIMARY KEY (
         pay_way
      );

ALTER TABLE ohora.oh_level
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_level
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_delivery_list
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_delivery_list
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_board
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_board
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_comments
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_comments
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_review
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_review
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_review
   ADD
      CONSTRAINT FK_oh_order_TO_oh_review
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_review
   ADD
      CONSTRAINT FK_oh_product_TO_oh_review
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_point
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_point
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_point
   ADD
      CONSTRAINT FK_oh_review_TO_oh_point
      FOREIGN KEY (
         rv_num
      )
      REFERENCES ohora.oh_review (
         rv_num
      );

ALTER TABLE ohora.oh_coupon
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_coupon
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_coupon
   ADD
      CONSTRAINT FK_oh_cpn_req_TO_oh_coupon
      FOREIGN KEY (
         cr_num
      )
      REFERENCES ohora.oh_cpn_req (
         cr_num
      );

ALTER TABLE ohora.oh_cpn_req
   ADD
      CONSTRAINT FK_oh_order_TO_oh_cpn_req
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_cpn_req
   ADD
      CONSTRAINT FK_oh_product_TO_oh_cpn_req
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_order
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_order
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_order
   ADD
      CONSTRAINT FK_oh_product_TO_oh_order
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_order
   ADD
      CONSTRAINT FK_oh_cart_TO_oh_order
      FOREIGN KEY (
         cart_num
      )
      REFERENCES ohora.oh_cart (
         cart_num
      );

ALTER TABLE ohora.oh_gift
   ADD
      CONSTRAINT FK_oh_product_TO_oh_gift
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_gift
   ADD
      CONSTRAINT FK_oh_order_TO_oh_gift
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_gift
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_gift
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_cart
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_cart
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_cart
   ADD
      CONSTRAINT FK_oh_product_TO_oh_cart
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_mydesign
   ADD
      CONSTRAINT FK_oh_product_TO_oh_mydesign
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_category
   ADD
      CONSTRAINT FK_oh_product_TO_oh_category
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_order_sub
   ADD
      CONSTRAINT FK_oh_order_TO_oh_order_sub
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT FK_oh_order_TO_oh_pay
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_pay
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT FK_oh_coupon_TO_oh_pay
      FOREIGN KEY (
         cp_num
      )
      REFERENCES ohora.oh_coupon (
         cp_num
      );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT FK_oh_pay_type_TO_oh_pay
      FOREIGN KEY (
         pay_way
      )
      REFERENCES ohora.oh_pay_type (
         pay_way
      );

ALTER TABLE ohora.oh_delivery
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_delivery
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_order_cncl
   ADD
      CONSTRAINT FK_oh_order_TO_oh_order_cncl
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_order_cncl
   ADD
      CONSTRAINT FK_oh_product_TO_oh_order_cncl
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_roles
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_roles
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_pay_type
   ADD
      CONSTRAINT FK_oh_order_TO_oh_pay_type
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );
      
ALTER TABLE oh_order MODIFY od_status VARCHAR2(10);
ALTER TABLE oh_mydesign DROP PRIMARY KEY;
ALTER TABLE ohora.oh_mydesign MODIFY pmd_hashtag VARCHAR2(10 CHAR) NULL;
ALTER TABLE OH_REVIEW DROP COLUMN rv_rank;

SELECT * FROM oh_product;
SELECT * FROM oh_category;
SELECT * FROM oh_mydesign;

CREATE SEQUENCE seq_ohproduct_num;

-- 상품등록 프로시저
CREATE OR REPLACE PROCEDURE up_InsertOhproduct
(
    -- OH_PRODUCT 테이블에 삽입할 매개변수
    p_pd_name oh_product.pd_name%TYPE                   -- 상품명
    , p_pd_date oh_product.pd_date%TYPE := SYSDATE      -- 출시일자
    , p_pd_stock oh_product.pd_stock%TYPE               -- 재고
    , p_pd_price oh_product.pd_price%TYPE               -- 정가 ( 판매가 )
--    , p_pd_dc_price oh_product.pd_dc_price%TYPE       -- 할인금액
--    , p_pd_view oh_product.pd_view%TYPE := 0          -- 조회수
    , p_pd_media oh_product.pd_media%TYPE := '이미지'    -- 이미지/영상(링크)
    , p_pd_dc_rate oh_product.pd_dc_rate%TYPE           -- 할인율
--    , p_pd_tot_buy oh_product.pd_tot_buy%TYPE         -- 총 구매수
    
    -- OH_CATEGORY 테이블에 삽입할 매개변수
    , p_pc_fir oh_category.pc_fir%TYPE -- 대분류
    , p_pc_sec oh_category.pc_sec%TYPE -- 중분류
    , p_pc_thd oh_category.pc_thd%TYPE -- 소분류
    
    -- OH_MYDESIGN 테이블에 삽입할 매개변수
    , p_pmd_hashtag oh_mydesign.pmd_hashtag%TYPE    -- 해시태그
    , p_pmd_lineup oh_mydesign.pmd_lineup%TYPE      -- 라인업
    , p_pmd_color oh_mydesign.pmd_color%TYPE        -- 컬러
    , p_pmd_design oh_mydesign.pmd_design%TYPE      -- 디자인

)
IS
    v_pd_dc_price oh_product.pd_dc_price%TYPE;      -- 할인가
    v_pd_view oh_product.pd_view%TYPE;              -- 조회수
    v_pd_tot_buy oh_product.pd_tot_buy%TYPE;        -- 총 구매수
BEGIN
    v_pd_dc_price := p_pd_price * p_pd_dc_rate / 100; -- 할인가 
    v_pd_view := 0; -- 조회수 0으로 초기화
    v_pd_tot_buy := 0; -- 총 구매수 0으로 초기화(상품 인기도 정렬을 위한)
    
    -- OH_PRODUCT INSERT
    INSERT INTO oh_product
    VALUES (seq_ohproduct_num.nextval
            ,p_pd_name
            ,p_pd_date
            ,p_pd_stock
            ,p_pd_price
            ,v_pd_dc_price
            ,v_pd_view
            ,p_pd_media
            ,p_pd_dc_rate
            ,v_pd_tot_buy
            );
    
    -- OH_CATEGORY INSERT        
    INSERT INTO oh_category
    VALUES (seq_ohproduct_num.currval
            ,p_pc_fir
            ,p_pc_sec
            ,p_pc_thd
            );
    
    -- OH_OHMYDESIGN INSERT          
    INSERT INTO oh_mydesign
    VALUES (p_pmd_hashtag
            ,seq_ohproduct_num.currval
            ,p_pmd_lineup
            ,p_pmd_color
            ,p_pmd_design
            );
    COMMIT;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
-- Procedure UP_INSERTOHPRODUCT이(가) 컴파일되었습니다.
-- 매개변수 ( 상품명 , 출시일자, 재고 , 가격, 이미지, 할인율
--           대분류 , 중분류 , 소분류
--           해시태그, 라인업 , 컬러 , 디자인 )

-- 데이터 삽입 예제
EXEC
    up_InsertOhproduct (
        p_pd_name      => 'Nail Polish - Midnight Blue',       -- 상품명
        p_pd_date      => TO_DATE('2024-08-29', 'YYYY-MM-DD'), -- 출시일자
        p_pd_stock     => 500,                                 -- 재고
        p_pd_price     => 15000,                               -- 정가 (숫자)
        p_pd_media     => 'midnight_blue_image.jpg',           -- 이미지/영상 링크
        p_pd_dc_rate   => 20,                                  -- 할인율 (숫자)

        p_pc_fir       => 'Beauty',                            -- 대분류
        p_pc_sec       => 'Nail Care',                         -- 중분류
        p_pc_thd       => 'Polish',                            -- 소분류

        p_pmd_hashtag  => '#MidnightBlue #NailPolish',         -- 해시태그
        p_pmd_lineup   => 'Summer',                            -- 라인업
        p_pmd_color    => 'Blue',                              -- 컬러
        p_pmd_design   => 'Glossy'                             -- 디자인
    );

