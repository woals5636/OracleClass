-- SCOTT
-- 제약조건(Constraints) --
SELECT *
FROM user_constraints -- 뷰(View)
WHERE table_name = 'EMP';
-- 제약조건은 data integrity(데이터 무결성)을 위하여
-- 주로 테이블에 행(row)을 입력, 수정, 삭제할 때 적용되는 규칙으로 사용되며
-- 테이블에 의해 참조되고 있는 경우 테이블의 삭제 방지를 위해서도 사용된다.

-- 참고) 무결성 (integrity)
-- 데이터의 정확성과 일관성을 유지하고, 데이터에 결손과 부정합이 없음을 보증하는 것

-- 2) 제약조건 생성 방법
--  (1) 테이블을 생성과 동시에 제약조건을 생성
        -- ㄱ. IN-LINE 제약조건 설정 방법 ( 컬럼 레벨 )
--            예) seq NUMBER PRIMARY KEY
        -- ㄴ. OUT-OF_LINE 제약조건 설정 방법 ( 테이블 레벨 )
--        CREATE TABLE XX
--        (
--            컬럼1     -- 컬럼 레벨 ( NOT NULL 제약 조건 )
--            , 컬럼2
--            :
--            
--            , 제약조건 설정   -- 테이블 레벨 ( 복합키 설정 )
--            , 제약조건 설정
--            , 제약조건 설정
--            , 제약조건 설정
--        )
--        
--        예) 복합키 설정 이유?
--        [ 사원 급여 지급 테이블 ]
--        PK(급여지급날짜 + 사원번호) 복합키 -> 순번이라는 컬럼을 추가하여 기본키로 (역정규화)
--        급여지급날짜 사원번호    급여액
--        2024.7.15   1111   3,000,000
--        2024.7.15   1112   3,000,000
--        2024.7.15   1113   3,000,000
--        :
--        2024.8.15   1111   3,000,000
--        2024.8.15   1112   3,000,000
--        2024.8.15   1113   3,000,000
--        :
--  예) 컬럼 레벨 방식으로 제약조건 설정 + 테이블 생성과 동시에 제약조건 설정.
DROP TABLE tbl_constraint1;
DROP TABLE tbl_bonus;
DROP TABLE tbl_emp;
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY    SYS_CXXXXXXX
    empno NUMBER(4) NOT NULL CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) CONSTRAINT fk_tblconstraint1_deptno REFERENCES dept(deptno)
    , email VARCHAR2(150) CONSTRAINT uk_tblconstraint1_deptno UNIQUE
    , kor NUMBER(3) CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)       -- CHECK(WHERE 조건절)
    , city VARCHAR2(20) CONSTRAINT ck_tblconstraint1_city CHECK(city IN('서울','부산','대구'))       -- CHECK(WHERE 조건절)
);
-- 예) 테이블 레벨 방식으로 제약조건 설정 + 테이블 생성과 동시에 제약조건 설정.
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY    SYS_CXXXXXXX
    empno NUMBER(4) NOT NULL
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2)
    , email VARCHAR2(150)
    , kor NUMBER(3)
    , city VARCHAR2(20)
    
    , CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY(empno)     -- PRIMARY KEY(empno,ename)->복합키
    , CONSTRAINT fk_tblconstraint1_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT uk_tblconstraint1_deptno UNIQUE(email)
    , CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)       -- CHECK(WHERE 조건절)
    , CONSTRAINT ck_tblconstraint1_city CHECK(city IN('서울','부산','대구'))       -- CHECK(WHERE 조건절)
);
-- 1) PK 제약조건 제거
ALTER TABLE tbl_constraint1
--DROP CONSTRAINT PRIMARY KEY
DROP CONSTRAINT pk_tblconstraint1_empno;
-- 2) UNIQUE
ALTER TABLE tbl_constraint1
DROP UNIQUE(email);
--DROP CONSTRAINT ck_tblconstraint1_email;
-- 3) CK
ALTER TABLE tbl_constraint1
-- DROP CHECK(kor); X 형식 없음
DROP CONSTRAINT ck_tblconstraint1_kor;

--
SELECT *
FROM user_constraints -- 뷰(View)
WHERE table_name LIKE 'TBL_C%';
-- ck_constraints_city 체크제약조건 비활성화 disable(비활성화)/enable(활성화)
ALTER TABLE user_constraint1
DISABLE CONSTRAINT ck_constraints_city; --비활성화
-- DISABLE CONSTRAINT ck_constraints_city [CASCADE]; cascade옵션은 비활성화시키려는 constraint를 참조하는 다른 모든 constraint들도 비활성화시킨다
ENABLE CONSTRAINT ck_constraints_city;   --활성화
        
--  (2) ALTER TABLE 테이블을 수정할 때 제약조건을 생성(추가), 삭제
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);
    1) empno 컬럼에 PK 제약조건 추가
    ALTER TABLE tbl_constraint3
    ADD CONSTRAINT pk_tblconstraint3_empno PRIMARY KEY(empno);
    
    2) deptno 컬럼에 FK 제약조건 추가
    ALTER TABLE tbl_constraint3
    ADD CONSTRAINT fk_tblconstraint3_empno FOREIGN KEY(deptno) REFERENCES dept(deptno);
    
    DROP TABLE tbl_constraint3;
    
--  ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
    DELETE FROM dept
    WHERE deptno = 10;
    
--  [ON DELETE CASCADE | ON DELETE SET NULL]
--  ? ON DELETE CASCADE 옵션을 이용하면 부모 테이블의 행이 삭제될 때 이를 참조한 자식 테이블의 행을 동시에 삭제할 수 있다.
--  ? ON DELETE SET NULL은 자식 테이블이 참조하는 부모 테이블의 값이 삭제되면 자식 테이블의 값을 NULL 값으로 변경시킨다.
    
-- emp -> tbl_emp 생성
-- dept -> tbl_dept 생성
CREATE TABLE tbl_emp
AS
(SELECT * FROM emp);
--
CREATE TABLE tbl_dept
AS
(SELECT * FROM dept);
--
SELECT *
FROM user_constraints -- 뷰(View)
WHERE table_name LIKE 'TBL_C%';
--
DESC tbl_emp;
--
ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY (deptno);
--
ALTER TABLE tbl_emp
ADD CONSTRAINT pk_tblemp_empno PRIMARY KEY (empno);
-- FK
ALTER TABLE tbl_emp
DROP CONSTRAINT fk_tblemp_deptno;
--
ALTER TABLE tbl_emp
ADD CONSTRAINT fk_tblemp_deptno FOREIGN KEY (deptno)
                                REFERENCES tbl_dept(deptno)
                                ON DELETE SET NULL;
                                -- ON DELETE CASCADE;
--
SELECT *
FROM tbl_dept;
--
SELECT *
FROM tbl_emp;
--
DELETE FROM tbl_dept
WHERE deptno = 30;
ROLLBACK;

-------------------조인(JOIN)---------------------
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title      VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;

-- 단가테이블( 책의 가격 )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (식별관계 ***)
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA이(가) 생성되었습니다.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- 책을 지은 저자테이블
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;

-- 고객            
-- 판매            출판사 <-> 서점
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- 판매
 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   
-- 1) EQUI JOIN :  두 개 이상의 테이블에 관계되는 컬럼들의 값들이 일치하는 경우에 사용하는 일반적인 join 형태임,
--                 WHERE 절에 '='(등호)를 사용한다.
--                 흔히 primary key, foreign key 관계를 이용한다.
--                 NATURAL JOIN 과 동일하다

---- [문제] 책ID ( b_id ), 책제목 ( title ), 출판사( c_name ), 단가  컬럼 출력....
-- ㄱ. WHERE 조건문
SELECT b.b_id 책ID, title 책제목, c_name 출판사, price 단가
FROM BOOK B, DANGA D
WHERE B.b_id = D.b_id;
-- ㄴ. JOIN ~ ON
SELECT b.b_id 책ID, title 책제목, c_name 출판사, price 단가
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id;
-- ㄷ. USING 절 사용( 객체명. 과 별칭명. 사용하지 않는다 )
SELECT b_id 책ID, title 책제목, c_name 출판사, price 단가
FROM book JOIN danga USING(b_id);
-- ㄹ. NATURAL JOIN 
SELECT b_id 책ID, title 책제목, c_name 출판사, price 단가
FROM book NATURAL JOIN danga;

---- [문제]  책ID ( b_id ), 책제목 ( title ), 판매수량 ( p_su ), 단가 ( price )
--          , 서점명 ( g_id ), 판매금액( = p_su * price ) 출력
SELECT  b.b_id 책ID
        , title 책제목
        , p_su 판매수량
        , price 단가
        , g.g_id 서점명
        , p_su * price 판매금액
FROM BOOK B, DANGA D, PANMAI P, GOGAEK G
WHERE B.b_id = D.b_id AND B.b_id = P.b_id AND G.g_id = P.g_id;
-- JOIN ~ ON
SELECT  b.b_id 책ID
        , title 책제목
        , p_su 판매수량
        , price 단가
        , g.g_id 서점명
        , p_su * price 판매금액
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id;
-- USING 절 사용
SELECT  b_id 책ID
        , title 책제목
        , p_su 판매수량
        , price 단가
        , g_id 서점명
        , p_su * price 판매금액
FROM book JOIN panmai USING(b_id)
          JOIN danga USING(b_id)
          JOIN gogaek USING(g_id);
-- * NON-EQUI JOIN :        조인조건절 = X
-- emp / sal    grade
SELECT empno, ename, sal, losal || '~' || hisal, grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;

-- OUTER JOIN
-- (+) 연산자
-- LEFT, RIGHT, FULL OUTER JOIN 3가지
-- KING 사원의 부서번호를 확인하고 -> NULL로 업데이트
SELECT *
FROM emp
WHERE ename = UPPER('king');

UPDATE emp
SET deptno = NULL
WHERE ename = UPPER('king');
COMMIT;

-- [모든 emp 사원정보를 출력을 하되 부서번호대신에 부서명으로 출력(조회)]
-- JOIN 모든 emp 테이블의 사원 정보를 dept 테이블과 JOIN해서
-- dname, ename, hiredate 컬럼 출력
SELECT dname, ename, hiredate
FROM dept d RIGHT OUTER JOIN emp e ON d.deptno = e.deptno;
--
SELECT dname, ename, hiredate
FROM dept d , emp e
WHERE d.deptno(+) = e.deptno;

-- 각 부서의 사원수 조회
-- 부서명, 사원수
SELECT DISTINCT dname, (SELECT COUNT(*) FROM emp WHERE deptno = d.deptno) 사원수
FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
--
SELECT dname, COUNT(empno) cnt
FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno ASC;
--
SELECT d.deptno, dname, ename, hiredate
FROM dept d FULL OUTER JOIN emp e ON d.deptno = e.deptno;

-- SELF JOIN
-- 사원번호, 사원명, 입사일자, 직속상사의이름
SELECT  a.empno 사원번호, a.ename 사원명, a.hiredate 입사일자, b.ename 직속상사의이름
FROM emp A JOIN emp B on a.mgr = b.empno;
-- CROSS JOIN : 데카르트 곱
SELECT e.*, d.*
FROM emp e , dept d;

-- 문제) 출판된 책들이 각각 총 몇권이 판매되었는지 조회     
--      (    책ID ( b_id ), 책제목 ( title ), 총판매권수( sum(p_su) ), 단가 ( price ) 컬럼 출력   )
SELECT  b.b_id 책ID
        , title 책제목
        , sum(p_su) 총판매권수
        , price 단가
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id
GROUP BY b.b_id,b.title,d.price
ORDER BY b.b_id;
--

-- 문제) 판매권수가 가장 많은 책 정보 조회
-- 1)
SELECT ROWNUM, T.*
FROM(
SELECT  b.b_id 책ID
        , title 책제목
        , sum(p_su) 총판매권수
        , price 단가
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id
GROUP BY b.b_id,b.title,d.price
ORDER BY 총판매권수 DESC
)T
WHERE ROWNUM = 1;
-- 2)
WITH t
AS(
    SELECT  b.b_id 책ID
            , title 책제목
            , sum(p_su) 총판매권수
            , price 단가
    FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
                JOIN PANMAI P ON B.b_id = P.b_id
                JOIN GOGAEK G ON G.g_id = P.g_id
    GROUP BY b.b_id,b.title,d.price
), s AS (
    SELECT t.*
        , RANK()OVER(ORDER BY 총판매권수 DESC) 판매순위
    FROM t
)
SELECT s.*
FROM s
WHERE s.판매순위 = 1;
-- 3)
SELECT t.*
FROM(
SELECT  b.b_id 책ID
        , title 책제목
        , sum(p_su) 총판매권수
        , price 단가
        , p_date 판매일자
        , RANK()OVER(ORDER BY sum(p_su) DESC) 판매순위
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id
GROUP BY b.b_id,b.title,d.price,p_date
)t
WHERE t.판매순위 = 1;
-- 올해 판매권수가 가장 많은 책 정보 조회
SELECT t.*
FROM(
SELECT  b.b_id 책ID
        , title 책제목
        , sum(p_su) 총판매권수
        , price 단가
        , p_date 판매일자
        , RANK()OVER(ORDER BY sum(p_su) DESC) 판매순위
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id
GROUP BY b.b_id,b.title,d.price,p_date
)t
WHERE t.판매순위 = 1 AND TO_CHAR(판매일자,'YYYY') = TO_CHAR(SYSDATE,'YYYY');
--
SELECT T.*
FROM(
    SELECT b.b_id, title, SUM(p_su)판매수량
        , RANK()OVER(ORDER BY SUM(p_su)DESC) 판매순위
    FROM book b JOIN panmai p ON b.b_id = p.b_id
    WHERE TO_CHAR(p_date,'YYYY')= TO_CHAR(SYSDATE,'YYYY')
    GROUP BY b.b_id, title
)t
WHERE t.판매순위 = 1;

-- [문제] book 테이블에서 판매가 된 적이 없는 책의 정보 조회
-- 책ID, 제목, 가격
SELECT b.b_id 책ID, title 책제목, price 가격 --, p_su
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
                 JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NULL;
-- MINUS 전체 책 종류에서 판매이력 있는 책 종류 제외
-- ANTI JOIN( NOT IN 연산자 )
SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id NOT IN(
    SELECT DISTINCT b_id
    FROM panmai
);
-- 문제) book 테이블에서 판매가 된 적이 있는 책의 정보 조회
--      (b_id, title, price 컬럼 출력)
SELECT DISTINCT P.B_ID, B.TITLE, D.PRICE
FROM PANMAI P JOIN BOOK B ON P.B_ID = B.B_ID
              JOIN DANGA D ON D.B_ID = B.B_ID;
--
  SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE EXISTS ( SELECT  b_id
    FROM panmai
    WHERE b_id = b.b_id);
WHERE b.b_id IN (
    SELECT DISTINCT b_id
    FROM panmai
); 
WHERE b.b_id = ANY(
    SELECT DISTINCT b_id
    FROM panmai
);
-- 문제) 고객별 판매 금액 출력 (고객코드, 고객명, 판매금액)
SELECT g.g_id,g.g_name, SUM(p.p_su*d.price) 판매금액
FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
              JOIN danga d ON p.b_id = d.b_id
GROUP BY g.g_id,g.g_NAME;

-- [문제] 년도, 월별 판매 현황 구하기
SELECT TO_CHAR(p_date,'YYYY') YEAR, TO_CHAR(p_date,'mm') month,SUM(P_SU) 판매수량
FROM panmai p
GROUP BY TO_CHAR(p_date,'YYYY'),TO_CHAR(p_date,'mm');

-- [문제] 서점별 년도별 판매현황 구하기
SELECT A.서점명, A.YEAR,SUM(A.P_SU) 판매수량
FROM(
    SELECT P.*, g.g_name 서점명, TO_CHAR(p.p_date,'YYYY') YEAR
    FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
)A
GROUP BY A.서점명, A.YEAR
ORDER BY A.서점명, A.YEAR;

-- [문제] 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--   ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )
SELECT A.책ID, A.제목, A.단가, SUM(A.총판매권수) 총판매권수, SUM(A.총판매권수*A.단가) 총판매금액
FROM(
    SELECT p.b_id 책ID, b.title 제목, d.price 단가, p.p_su 총판매권수
    FROM panmai p JOIN book b ON p.b_id = b.b_id
                  JOIN danga d ON p.b_id = d.b_id
)A
GROUP BY A.책ID, A.제목, A.단가
HAVING SUM(A.총판매권수*A.단가) >= 15000;

