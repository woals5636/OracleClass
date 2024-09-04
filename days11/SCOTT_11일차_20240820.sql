-- SCOTT
-- 확인용
SELECT *
FROM ANSWERS;
SELECT *
FROM HANGMOK;
SELECT *
FROM SUL;
SELECT *
FROM USERS;
    
-------------------테이블 생성----------------------------------------------------
-- 설문 질문 테이블
CREATE TABLE SUL (
   SUL_NO NUMBER NOT NULL, /* 설문번호 */
   title VARCHAR2(50 CHAR), /* 설문 제목 */
   startd DATE, /* 시작일 */
   endd DATE, /* 종료일 */
   writed DATE, /* 작성일 */
   author VARCHAR2(10 CHAR), /* 작성자 */
   
   CONSTRAINT PK_SUL PRIMARY KEY (SUL_NO)
);

-- 회원 테이블
CREATE TABLE USERS (
   memid VARCHAR2(15 CHAR) NOT NULL, /* 회원 ID */
   pw VARCHAR2(20 CHAR), /* 비밀번호 */
   nick VARCHAR2(15 CHAR), /* 닉네임 */
   
   CONSTRAINT PK_USERS PRIMARY KEY (memid)
);

-- 설문 답변 테이블
CREATE TABLE ANSWERS (
   SUL_NO NUMBER NOT NULL, /* 설문번호 */
   memid VARCHAR2(15 CHAR) NOT NULL, /* 회원 ID */
   ans NUMBER, /* 답변 */
   
   CONSTRAINT FK_SUL_TO_ANSWERS FOREIGN KEY (SUL_NO) REFERENCES SUL(SUL_NO),
   CONSTRAINT FK_USERS_TO_ANSWERS FOREIGN KEY (memid) REFERENCES USERS(memid),
   CONSTRAINT PK_ANSWERS PRIMARY KEY (SUL_NO, memid)
);

-- 설문 항목 테이블
CREATE TABLE HANGMOK (
   list VARCHAR2(100 CHAR) NOT NULL, /* 질문 항목 */
   listnum NUMBER NOT NULL, /* 질문 항목 번호 */
   SUL_NO NUMBER NOT NULL, /* 설문번호 */
   
   CONSTRAINT FK_SUL_TO_HANGMOK FOREIGN KEY (SUL_NO) REFERENCES SUL(SUL_NO)
);
--초기화
DROP TABLE HANGMOK CASCADE CONSTRAINTS;
DROP TABLE ANSWERS CASCADE CONSTRAINTS;
DROP TABLE SUL CASCADE CONSTRAINTS;
DROP TABLE USERS CASCADE CONSTRAINTS;
-- 시퀀스
CREATE SEQUENCE SEQ_NUM;
-- 임의의 회원
INSERT INTO USERS VALUES('송','1234','NICK');
INSERT INTO USERS VALUES('김재민','1234','NICK');
INSERT INTO USERS VALUES('김김김','1234','NICK');
INSERT INTO USERS VALUES('백백백','1234','NICK');
INSERT INTO USERS VALUES('최유진','1234','NICK');
INSERT INTO USERS VALUES('전','1234','NICK');
INSERT INTO USERS VALUES('최','1234','NICK');
-- 임의값 INSERT ----------------------------------------------------------------
-- 질문1 ------------------------------------------------------------------------
INSERT INTO SUL(SUL_NO,TITLE,STARTD,ENDD,WRITED,AUTHOR)
    VALUES(SEQ_NUM.NEXTVAL,'질문1','2006-03-01','2006-04-01','2006-03-15','관리자');
-- 질문1의 항목  -----------------------------------------------------------------
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('QWER',1,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ASDF',2,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ZXCV',3,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('TYUI',4,SEQ_NUM.CURRVAL);
-- 질문1의 항목에 대한 답변 --------------------------------------------------------
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'송',5);

-- 질문2 ------------------------------------------------------------------------
INSERT INTO SUL
    VALUES(SEQ_NUM.NEXTVAL,'질문2','2006-03-01','2006-04-01','2006-03-15','관리자');
-- 질문2의 항목 ------------------------------------------------------------------
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('QWER',1,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ASDF',2,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ZXCV',3,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('TYUI',4,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('TYUI',5,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('TYUI',6,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('TYUI',7,SEQ_NUM.CURRVAL);
-- 질문2의 항목에 대한 답변   
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'송',5);

-- 질문3 ------------------------------------------------------------------------
INSERT INTO SUL
    VALUES(SEQ_NUM.NEXTVAL,'질문3','2024-08-01','2024-09-01','2024-08-24','관리자');
-- 질문3의 항목 ------------------------------------------------------------------
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ㄱㄴㄷㄹㅁㅂ',1,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ㅅㅇㅈㅊㅋㅌ',2,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ㅍㅎ',3,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('가나다라',4,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('마바사아',5,SEQ_NUM.CURRVAL);
-- 질문3의 항목에 대한 답변---------------------------------------------------------
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'김재민',1);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'김김김',1);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'백백백',2);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'송',5);
    
-- 질문4 ------------------------------------------------------------------------
INSERT INTO SUL
    VALUES(SEQ_NUM.NEXTVAL,'가장 좋아하는 여자 연예인은?','2024-08-01','2024-08-31','2024-08-10','관리자');
-- 질문4의 항목 ------------------------------------------------------------------
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('배슬기',1,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('김옥빈',2,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('아이비',3,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('한효주',4,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('김선아',5,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('김태희',6,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('한선화',7,SEQ_NUM.CURRVAL);
-- 질문4의 항목에 대한 답변 --------------------------------------------------------
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'김재민',1);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'김김김',1);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'백백백',2);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'최유진',2);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'전',2);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'최',5);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'송',5);
--------------------------------------------------------------------------------

--1번 최신 설문조사 질문과 문항 출력하는 쿼리 작성
SELECT title 질문, list 항목
FROM SUL s JOIN HANGMOK h on s.sul_no = h.sul_no
WHERE s.sul_no = (SELECT MAX(sul_no) FROM SUL);

--2번
SELECT s.sul_no 설문번호 , s.title 제목, s.author 작성자, s.startd 시작일, s.endd 종료일
        , (SELECT COUNT(listnum) FROM hangmok WHERE s.sul_no =sul_no) 항목수
        , (SELECT COUNT(memid) FROM answers WHERE s.sul_no =sul_no) 응답자수
        , CASE WHEN endd < sysdate THEN '종료' WHEN startd > sysdate THEN '대기중' ELSE '진행중' END 상태
FROM hangmok h JOIN sul s ON h.sul_no = s.sul_no
GROUP BY s.sul_no , s.title, s.author, s.startd, s.endd
ORDER BY 상태 DESC;
-- 설문 목록 쿼리: 현재시간(sysdate)를 CASE문으로 나눠서 시간에 따라서 설문 상태 출력..




--4. 설문 상세 보기
-- 1)
SELECT s.title 투표제목, s.author 작성자, s.writed ,s.startd, s.endd, a.memid, h.list
FROM sul s 
LEFT JOIN answers a 
ON s.sul_no = a.sul_no
RIGHT JOIN hangmok h 
on s.sul_no = h.sul_no 
WHERE a.memid = 'love';

-- 2)
SELECT COUNT(memid)
FROM answers;

-- 3)
SELECT CASE WHEN startd <= sysdate and endd >= sysdate THEN '버튼 O'
            ELSE '버튼 X'
        END as "버튼상태"
FROM sul;

SELECT *
FROM answers;

    SELECT  e.ans 번호, e.고른수 
            ,  lpad ( ' ' , e.고른수+1, '*')  그래프
            ,  ROUND( CAST(e.고른수 AS FLOAT) / SUM(CAST(e.고른수 AS FLOAT)) OVER (), 2 ) * 100 || '%' AS 비율
    FROM (
    SELECT a.ans, COUNT(a.ans) "고른수"
    FROM answers a 
    WHERE a.sul_no = 2 --이것만 선택할 수 있으면 ? (ex. 2번 설문 상세보기 클릭시 여기가 2로 되게)
    GROUP BY a.ans
    ORDER BY a.sul_no
    ) e
    ORDER BY 번호;
    
--5번 관리자가 설문 수정
UPDATE hangmok
SET list = 123
WHERE list = 'QWER';

--6번 관리자가 설문 삭제

ALTER TABLE ANSWERS
DROP CONSTRAINT FK_SUL_TO_ANSWERS;

DELETE FROM ANSWERS
WHERE sul_no = 1;

ALTER TABLE ANSWERS
ADD CONSTRAINT FK_SUL_TO_ANSWERS
FOREIGN KEY (sul_no) REFERENCES SUL(sul_no)
ON DELETE CASCADE;
DELETE FROM SUL
WHERE sul_no = 1;




