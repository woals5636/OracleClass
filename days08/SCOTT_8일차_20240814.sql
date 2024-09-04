-- SCOTT
-- 1) 게시판 테이블 생성 : tbl_board
-- 2) 컬럼 : 글번호, 작성자, 비밀번호, 제목, 내용, 작성일, 조회수
CREATE TABLE tbl_board
(
    SEQ NUMBER(38) NOT NULL PRIMARY KEY
    , WRITER VARCHAR2(20) NOT NULL
    , PASSWORD VARCHAR2(15) NOT NULL
    , TITLE VARCHAR2(100) NOT NULL
    , CONTENT CLOB
    , REGDATE DATE DEFAULT SYSDATE
);
-- TABLE SCOTT.TBL_BOARD 생성
-- EQ 글번호에 사용할 시퀀스 생성
CREATE SEQUENCE seq_tblboard
--    INCREMENT BY 1
--    START WITH 1
--    MAXVALUE 
--    MINVALUE -- MAXVALUE 값에 도달하고 초기화시 MINVALUE 값부터 시작
--    CYCLE
    NOCACHE;
-- Sequence SEQ_TBLBOARD이(가) 생성되었습니다.
SELECT *
FROM USER_SEQUENCES;
-- 시퀀스 확인하는 구문
--
SELECT *
FROM TABS
WHERE TABLE_NAME LIKE 'TBL_B%';
--
DROP TABLE tbl_board CASCADE;

SELECT * FROM TBL_BOARD;
SELECT SEQ_TBLBOARD.CURRVAL FROM DUAL;
-- 게시글 쓰기(작성) 퀴리 작성
INSERT INTO TBL_BOARD(SEQ,WRITER,PASSWORD, TITLE,CONTENT) VALUES(SEQ_TBLBOARD.NEXTVAL,'홍길동',1234,'TEST-1','TEST-1');
INSERT INTO TBL_BOARD(SEQ,WRITER,PASSWORD, TITLE,CONTENT) VALUES(SEQ_TBLBOARD.NEXTVAL,'이시훈',1234,'TEST-2','TEST-2');
INSERT INTO TBL_BOARD VALUES(SEQ_TBLBOARD.NEXTVAL,'송세호',1234,'TEST-3','TEST-3',SYSDATE);
INSERT INTO TBL_BOARD(SEQ,WRITER,PASSWORD, TITLE) VALUES(SEQ_TBLBOARD.NEXTVAL,'원충희',1234,'TEST-4');

SELECT SEQ, TITLE, WRITER, TO_CHAR(REGDATE,'YYYY-MM-DD') REGDATE,READED
FROM TBL_BOARD
ORDER BY SEQ DESC;
-- 제약 조건 확인
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = upper('tbl_board');
-- 제약조건명을 설정하지 않으면 SYS_XXXXXXX 자동 부여

-- 조회수 컬럼 추가~
ALTER TABLE tbl_board ADD READED NUMBER DEFAULT 0;
-- 2	TEST-2	이시훈	2024-08-14	0   게시글의 제목을 클릭하면
-- 1) 조회수 1증가
    UPDATE tbl_board
    SET READED = READED + 1
    WHERE SEQ = 2;
-- 2) 게시글(SEQ)의 정보를 조회
    SELECT *
    FROM TBL_BOARD
    WHERE SEQ = 2;

-- 게시판의 작성자( WRITER 컬럼  20->40  SIZE 확장 )
-- 컬럼의 자료형의 크기를 수정...

-- 제약조건은 수정이 불가하다. 수정을 원하면 삭제후 새로 생성
ALTER TABLE tbl_board MODIFY WRITER VARCHAR2(40);

-- 칼럼명을 수정 ( TITLE-> SUBJECT )
SELECT SEQ, TITLE SUBJECT, WRITER, TO_CHAR(REGDATE,'YYYY-MM-DD') REGDATE,READED
FROM TBL_BOARD
ORDER BY SEQ DESC;

ALTER TABLE tbl_board RENAME COLUMN TITLE TO SUBJECT;

-- 수정할 때의 날짜 정보를 저장할 컬럼을 추가. lastRegdate
ALTER TABLE tbl_board ADD lastRegdate DATE;
--
UPDATE tbl_board SET SUBJECT = '제목수정-3', CONTENT = '내용수정-3', LASTREGDATE = SYSDATE
WHERE SEQ = 3;
COMMIT;
--
SELECT *
FROM TBL_MYBOARD;
-- LASTREGDATE 컬럼 삭제
ALTER TABLE TBL_BOARD
DROP COLUMN LASTREGDATE;
-- TBL_BOARD -> TBL_MYBOARD 테이블명 수정
RENAME TBL_BOARD TO TBL_MYBOARD;
-- [ 테이블 생성하는 방법 ]
1. CREATE TABLE 생성
2. Subquery 를 이용한 테이블 생성
    - 기존 이미 존재하는 테이블을 이용해서 새로운 테이블 생성 (+ 레코드 추가)
    - CREATE TABLE 테이블명 [컬럼명,...]
      AS (서브쿼리);
-- EX) emp 테이블로부터 30번 사원들만 새로운 테이블 생성
CREATE TABLE tbl_emp30  -- (eno, ename, hiredate, job,pay)
AS(
    SELECT empno, ename, hiredate, job, sal + NVL(comm,0) pay
    FROM emp
    WHERE deptno = 30
);
--Table TBL_EMP30이(가) 생성되었습니다.
DESC tbl_emp30;
-- 제약조건은 복사가 되지 않는다.
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('EMP','TBL_EMP30');
-- emp -> 새로운 테이블 생성 + 데이터 복사 X
DROP TABLE tbl_emp30;

CREATE TABLE tbl_empcopy
AS
(
SELECT *
FROM emp
WHERE 1 = 0
);
-- 테이블의 구조는 그대로 복사하지만 데이터(레코드) 복사는 하지 않는 법
SELECT *
FROM tbl_empcopy;
--
DROP TABLE tbl_empcopy;
--
DROP TABLE tbl_char;
DROP TABLE tbl_EXAMPLE;
DROP TABLE tbl_MYBOARD;
DROP TABLE tbl_NCHAR;
DROP TABLE tbl_NUMBER;
DROP TABLE tbl_PIVOT;
DROP TABLE tbl_TEL;
-- SQL 확장 => PL/SQL

-- [문제] emp, dept 테이블을 이용해서 deptno, dname, empno, ename, hiredate, pay, grade 컬럼을
-- 가진 새로운 테이블 생성 (tbl_empgrade)
CREATE TABLE tbl_empgrade
AS (
SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0) pay, grade
FROM emp e , dept d , salgrade s
WHERE d.deptno = e.deptno
    AND e.sal BETWEEN s.losal AND s.hisal
);
-- JOIN ~ ON 구문 수정
CREATE TABLE tbl_empgrade
AS (
SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0) pay
    ,s.losal || '~' || s.hisal sal_range, grade
FROM emp e JOIN dept d ON d.deptno = e.deptno
           JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
);
--
select * from tbl_empgrade;
--
DROP TABLE tbl_empgrade; -- 휴지동 이동
PURGE RECYCLEBIN;   -- 휴지통 비우기
DROP TABLE tbl_empgrade PURGE;  -- 휴지통 이동하지 않고 완전히 삭제

-- emp 테이블의 구조만 복사해서 새로운 tbl_emp 테이블 생성
CREATE TABLE tbl_emp
AS(
SELECT *
FROM emp
WHERE 1=0
);
--
SELECT *
  FROM tbl_emp;
-- emp 테이블의 10번 부서원들을 tbl_emp 테이블에 INSERT 작업
-- DIRECT LOAD INSERT에 의한 ROW 삽입 
INSERT INTO tbl_emp SELECT * FROM emp WHERE deptno = 10;
INSERT INTO tbl_emp (empno,ename) SELECT empno,ename FROM emp WHERE deptno = 20;
COMMIT;
DROP TABLE tbl_emp;

-- [ 다중 INSERT 문 4가지 ]
-- 1) unconditional insert all - 조건이 없는 INSERT ALL
CREATE TABLE tbl_emp10 AS( SELECT * FROM emp WHERE 1=0 );
CREATE TABLE tbl_emp20 AS( SELECT * FROM emp WHERE 1=0 );
CREATE TABLE tbl_emp30 AS( SELECT * FROM emp WHERE 1=0 );
CREATE TABLE tbl_emp40 AS( SELECT * FROM emp WHERE 1=0 );
--
INSERT INTO tbl_emp10 SELECT * FROM emp;
INSERT INTO tbl_emp20 SELECT * FROM emp;
INSERT INTO tbl_emp30 SELECT * FROM emp;
INSERT INTO tbl_emp40 SELECT * FROM emp;
--
ROLLBACK;
SELECT * FROM tbl_emp10;
SELECT * FROM tbl_emp20;
SELECT * FROM tbl_emp30;
SELECT * FROM tbl_emp40;
--
INSERT INTO tbl_emp10 SELECT * FROM emp;
INSERT INTO tbl_emp20 SELECT * FROM emp;
INSERT INTO tbl_emp30 SELECT * FROM emp;
INSERT INTO tbl_emp40 SELECT * FROM emp;
-- 위의 쿼리 4개를 한번에 처리
INSERT ALL
    INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT *
FROM emp;
-- 2) conditional insert all - 조건이 있는 INSERT ALL
INSERT ALL
    WHEN deptno=10 THEN 
        INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno=20 THEN 
        INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno=30 THEN 
        INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    ELSE 
        INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT *
FROM emp;
-- 3) conditional first insert - 조건이 있는 INSERT FIRST
INSERT FIRST
    WHEN deptno=10 THEN INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN sal >= 2500 THEN INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno=30 THEN INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    ELSE INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT *
FROM emp;
-- 4) pivoting insert
CREATE TABLE tbl_sales(
  employee_id       number(6),
  week_id           number(2),
  sales_mon         number(8,2),
  sales_tue         number(8,2),
  sales_wed         number(8,2),
  sales_thu         number(8,2),
  sales_fri         number(8,2)
);
-- Table created.
INSERT INTO tbl_sales VALUES(1101,4,100,150,80,60,120);
-- row created.
INSERT INTO tbl_sales VALUES(1102,5,300,300,230,120,150);
-- row created.
COMMIT;
--
SELECT *
FROM tbl_sales;
--
CREATE TABLE tbl_salesdata(
  employee_id        number(6),
  week_id            number(2),
  sales              number(8,2)
);
-- Table created.
INSERT ALL
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_mon)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_tue)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_wed)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_thu)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_fri)
  SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed,
         sales_thu, sales_fri
  FROM tbl_sales;
--rows created.
SELECT *
FROM tbl_salesdata;
--
DROP TABLE tbl_emp10;
DROP TABLE tbl_emp20;
DROP TABLE tbl_emp30;
DROP TABLE tbl_emp40;
DROP TABLE tbl_sales;
DROP TABLE tbl_salesdata;
-- DELETE      |  DROP TABLE  |  TRUNCATE문 차이점
-- 레코드 삭제   |  테이블 삭제   |  레코드 모두 삭제             
-- DML         |  DDL         |  DML

-- TRUMCATE TABLE 테이블명; 자동커밋
-- DELETE FROM 테이블명;    커밋/롤백
--   ㄴ WHERE 조건절이 없으면 모든 레코드 삭제...

-- [문제] insa 테이블에서 num, name 컬럼만을 복사해서 새로운 테이블 tbl_score 테이블 생성
--                      ㄴ num <= 1005
CREATE TABLE tbl_score AS
(
    SELECT num, name
    FROM insa
    WHERE num <= 1005
);

select * from tbl_score;
-- [문제] tbl_score 테이블에 kor,eng,mat,tot,avg,grade,rank 컬럼 추가
ALTER TABLE tbl_score
ADD(
    kor NUMBER(3) DEFAULT 0
    ,eng NUMBER(3) DEFAULT 0
    ,mat NUMBER(3) DEFAULT 0
    ,tot NUMBER(3) DEFAULT 0
    ,avg NUMBER(5,2) DEFAULT 0
    ,grade CHAR(1 CHAR) -- CHAR(3 BYTE)
    ,rank NUMBER(3)
);
-- [문제] 1001~1005 모든 학생의 국,영,수 점수를 임의의 점수를 발생시켜서 수정(update)
-- 0.0<= SYS.dbms_random.value < 1.0
SELECT * FROM tbl_score;
UPDATE tbl_score
SET KOR = ROUND(DBMS_RANDOM.VALUE(0, 100))
    ,ENG = ROUND(DBMS_RANDOM.VALUE(0, 100))
    ,MAT = ROUND(DBMS_RANDOM.VALUE(0, 100));
COMMIT;
-- [문제] 1005 학생의 국,영,수 점수를 1001 학생의 국,영,수 점수로 수정
UPDATE tbl_score
SET (kor,eng,mat) = (SELECT kor,eng,mat FROM tbl_score WHERE num = 1001)
WHERE num = 1005;

-- [문제] 모든 학생의 총점 , 평균 UPDATE
UPDATE tbl_score
SET tot = kor + eng + mat
    , avg = (kor + eng + mat)/3;
-- [문제] 모든 학생의 등수를 UPDATE
UPDATE tbl_score M
SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > M.tot);
--SET rank = (
--               SELECT t.r
--               FROM (
--                   SELECT num, tot, RANK() OVER(ORDER BY tot DESC ) r
--                   FROM tbl_score
--               ) t
--               WHERE t.num =p.num
--           );
-- [문제] 등급 수정(처리)   avg가 90 이상 '수' ~ '가'
UPDATE tbl_score
SET grade = CASE WHEN avg >= 90 THEN '수'
                 WHEN avg >= 80 THEN '우'
                 WHEN avg >= 70 THEN '미'
                 WHEN avg >= 60 THEN '양'
                 ELSE '가'
            END;
-- DECODE      
UPDATE tbl_score
SET grade = DECODE(FLOOR(AVG/10),10,'수',9,'수',8,'우',7,'미',6,'양','가');
--
INSERT ALL
    WHEN avg >= 90 THEN
         INTO tbl_score (grade) VALUES( 'A' )
    WHEN avg >= 80 THEN
         INTO tbl_score (grade) VALUES( 'B' )
    WHEN avg >= 70 THEN
         INTO tbl_score (grade) VALUES( 'C' )
    WHEN avg >= 60 THEN
         INTO tbl_score (grade) VALUES( 'D' )
    ELSE
         INTO tbl_score (grade) VALUES( 'F' )
SELECT avg FROM tbl_score ;
--
UPDATE tbl_score
SET ENG = CASE WHEN ENG >= 60 THEN 100
               ELSE ENG + 40
          END;
-- [문제] 남학생의 국어 점수를 5점 감소
SELECT num
FROM insa
WHERE num <= 1005 AND MOD(SUBSTR(ssn,07,1),2)=1;
--
UPDATE tbl_score t
SET  kor = CASE  
              WHEN kor -5 < 0 THEN 0
              ELSE kor -5
           END
where t.num = (
                select num 
                from insa 
                where MOD(substr(ssn,8,1), 2)=1 and t.num =num
            );           
WHERE num = ANY (
                    SELECT num 
                    FROM insa
                    WHERE num <= 1005 AND MOD(SUBSTR(ssn,-7,1),2)=1
             );           
WHERE num IN (
                    SELECT num 
                    FROM insa
                    WHERE num <= 1005 AND MOD(SUBSTR(ssn,-7,1),2)=1
             );
--
SELECT *
FROM tbl_score;

-- [문제] result 컬럼 추가
--       합격, 불합격, 과락
ALTER TABLE tbl_score ADD( RESULT CHAR ( 3 CHAR ) );
UPDATE tbl_score
SET result = CASE
                WHEN (kor >= 40 AND eng>=40 AND mat>=40) AND avg>=60 THEN '합격'
                WHEN avg < 60 THEN '불합격'
                ELSE '과락'
             END;
DROP TABLE TBL_SCORE PURGE;
--------------------------------------------------------------------------------
CREATE TABLE tbl_emp(
  id         number primary key, 
  name       varchar2(10) not null,
  salary     number,
  bonus      number default 100
);

INSERT INTO tbl_emp(id,name,salary) VALUES(1001,'jijoe',150);
INSERT INTO tbl_emp(id,name,salary) VALUES(1002,'cho',130);
INSERT INTO tbl_emp(id,name,salary) VALUES(1003,'kim',140);
COMMIT;
SELECT * FROM tbl_emp;

CREATE TABLE tbl_bonus
(
    id number
    , bonus number default 100
);

INSERT INTO tbl_bonus(id)
(SELECT e.id from tbl_emp e);
INSERT INTO tbl_bonus VALUES(1004,50);
COMMIT;

SELECT * FROM tbl_emp;
--     ID     NAME    SALARY  BONUS
--    ------------------------------
--    1001	jijoe	    150	    100
--    1002	cho	        130	    100
--    1003	kim	        140	    100
SELECT * FROM tbl_bonus;
--    ID      BONUS
--    ---------------
--    1001	    100
--    1002  	100
--    1003	    100
--    1004  	50
-- MERGE
MERGE INTO tbl_bonus b
USING (SELECT id, salary FROM tbl_emp) e
ON (b.id = e.id)
WHEN MATCHED THEN
    UPDATE SET b.bonus = b.bonus + e.salary * 0.01
WHEN NOT MATCHED THEN
    INSERT ( b.id,b.bonus ) VALUES ( e.id, e.salary * 0.01 );






