-- SCOTT
-- Ȯ�ο�
SELECT *
FROM ANSWERS;
SELECT *
FROM HANGMOK;
SELECT *
FROM SUL;
SELECT *
FROM USERS;
    
-------------------���̺� ����----------------------------------------------------
-- ���� ���� ���̺�
CREATE TABLE SUL (
   SUL_NO NUMBER NOT NULL, /* ������ȣ */
   title VARCHAR2(50 CHAR), /* ���� ���� */
   startd DATE, /* ������ */
   endd DATE, /* ������ */
   writed DATE, /* �ۼ��� */
   author VARCHAR2(10 CHAR), /* �ۼ��� */
   
   CONSTRAINT PK_SUL PRIMARY KEY (SUL_NO)
);

-- ȸ�� ���̺�
CREATE TABLE USERS (
   memid VARCHAR2(15 CHAR) NOT NULL, /* ȸ�� ID */
   pw VARCHAR2(20 CHAR), /* ��й�ȣ */
   nick VARCHAR2(15 CHAR), /* �г��� */
   
   CONSTRAINT PK_USERS PRIMARY KEY (memid)
);

-- ���� �亯 ���̺�
CREATE TABLE ANSWERS (
   SUL_NO NUMBER NOT NULL, /* ������ȣ */
   memid VARCHAR2(15 CHAR) NOT NULL, /* ȸ�� ID */
   ans NUMBER, /* �亯 */
   
   CONSTRAINT FK_SUL_TO_ANSWERS FOREIGN KEY (SUL_NO) REFERENCES SUL(SUL_NO),
   CONSTRAINT FK_USERS_TO_ANSWERS FOREIGN KEY (memid) REFERENCES USERS(memid),
   CONSTRAINT PK_ANSWERS PRIMARY KEY (SUL_NO, memid)
);

-- ���� �׸� ���̺�
CREATE TABLE HANGMOK (
   list VARCHAR2(100 CHAR) NOT NULL, /* ���� �׸� */
   listnum NUMBER NOT NULL, /* ���� �׸� ��ȣ */
   SUL_NO NUMBER NOT NULL, /* ������ȣ */
   
   CONSTRAINT FK_SUL_TO_HANGMOK FOREIGN KEY (SUL_NO) REFERENCES SUL(SUL_NO)
);
--�ʱ�ȭ
DROP TABLE HANGMOK CASCADE CONSTRAINTS;
DROP TABLE ANSWERS CASCADE CONSTRAINTS;
DROP TABLE SUL CASCADE CONSTRAINTS;
DROP TABLE USERS CASCADE CONSTRAINTS;
-- ������
CREATE SEQUENCE SEQ_NUM;
-- ������ ȸ��
INSERT INTO USERS VALUES('��','1234','NICK');
INSERT INTO USERS VALUES('�����','1234','NICK');
INSERT INTO USERS VALUES('����','1234','NICK');
INSERT INTO USERS VALUES('����','1234','NICK');
INSERT INTO USERS VALUES('������','1234','NICK');
INSERT INTO USERS VALUES('��','1234','NICK');
INSERT INTO USERS VALUES('��','1234','NICK');
-- ���ǰ� INSERT ----------------------------------------------------------------
-- ����1 ------------------------------------------------------------------------
INSERT INTO SUL(SUL_NO,TITLE,STARTD,ENDD,WRITED,AUTHOR)
    VALUES(SEQ_NUM.NEXTVAL,'����1','2006-03-01','2006-04-01','2006-03-15','������');
-- ����1�� �׸�  -----------------------------------------------------------------
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('QWER',1,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ASDF',2,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('ZXCV',3,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('TYUI',4,SEQ_NUM.CURRVAL);
-- ����1�� �׸� ���� �亯 --------------------------------------------------------
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'��',5);

-- ����2 ------------------------------------------------------------------------
INSERT INTO SUL
    VALUES(SEQ_NUM.NEXTVAL,'����2','2006-03-01','2006-04-01','2006-03-15','������');
-- ����2�� �׸� ------------------------------------------------------------------
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
-- ����2�� �׸� ���� �亯   
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'��',5);

-- ����3 ------------------------------------------------------------------------
INSERT INTO SUL
    VALUES(SEQ_NUM.NEXTVAL,'����3','2024-08-01','2024-09-01','2024-08-24','������');
-- ����3�� �׸� ------------------------------------------------------------------
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('������������',1,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('������������',2,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('����',3,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('�����ٶ�',4,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('���ٻ��',5,SEQ_NUM.CURRVAL);
-- ����3�� �׸� ���� �亯---------------------------------------------------------
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'�����',1);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'����',1);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'����',2);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'��',5);
    
-- ����4 ------------------------------------------------------------------------
INSERT INTO SUL
    VALUES(SEQ_NUM.NEXTVAL,'���� �����ϴ� ���� ��������?','2024-08-01','2024-08-31','2024-08-10','������');
-- ����4�� �׸� ------------------------------------------------------------------
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('�载��',1,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('�����',2,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('���̺�',3,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('��ȿ��',4,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('�輱��',5,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('������',6,SEQ_NUM.CURRVAL);
INSERT INTO HANGMOK(LIST,LISTNUM,SUL_NO)
    VALUES('�Ѽ�ȭ',7,SEQ_NUM.CURRVAL);
-- ����4�� �׸� ���� �亯 --------------------------------------------------------
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'�����',1);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'����',1);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'����',2);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'������',2);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'��',2);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'��',5);
INSERT INTO ANSWERS(SUL_NO,MEMID,ANS)
    VALUES(SEQ_NUM.CURRVAL,'��',5);
--------------------------------------------------------------------------------

--1�� �ֽ� �������� ������ ���� ����ϴ� ���� �ۼ�
SELECT title ����, list �׸�
FROM SUL s JOIN HANGMOK h on s.sul_no = h.sul_no
WHERE s.sul_no = (SELECT MAX(sul_no) FROM SUL);

--2��
SELECT s.sul_no ������ȣ , s.title ����, s.author �ۼ���, s.startd ������, s.endd ������
        , (SELECT COUNT(listnum) FROM hangmok WHERE s.sul_no =sul_no) �׸��
        , (SELECT COUNT(memid) FROM answers WHERE s.sul_no =sul_no) �����ڼ�
        , CASE WHEN endd < sysdate THEN '����' WHEN startd > sysdate THEN '�����' ELSE '������' END ����
FROM hangmok h JOIN sul s ON h.sul_no = s.sul_no
GROUP BY s.sul_no , s.title, s.author, s.startd, s.endd
ORDER BY ���� DESC;
-- ���� ��� ����: ����ð�(sysdate)�� CASE������ ������ �ð��� ���� ���� ���� ���..




--4. ���� �� ����
-- 1)
SELECT s.title ��ǥ����, s.author �ۼ���, s.writed ,s.startd, s.endd, a.memid, h.list
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
SELECT CASE WHEN startd <= sysdate and endd >= sysdate THEN '��ư O'
            ELSE '��ư X'
        END as "��ư����"
FROM sul;

SELECT *
FROM answers;

    SELECT  e.ans ��ȣ, e.���� 
            ,  lpad ( ' ' , e.����+1, '*')  �׷���
            ,  ROUND( CAST(e.���� AS FLOAT) / SUM(CAST(e.���� AS FLOAT)) OVER (), 2 ) * 100 || '%' AS ����
    FROM (
    SELECT a.ans, COUNT(a.ans) "����"
    FROM answers a 
    WHERE a.sul_no = 2 --�̰͸� ������ �� ������ ? (ex. 2�� ���� �󼼺��� Ŭ���� ���Ⱑ 2�� �ǰ�)
    GROUP BY a.ans
    ORDER BY a.sul_no
    ) e
    ORDER BY ��ȣ;
    
--5�� �����ڰ� ���� ����
UPDATE hangmok
SET list = 123
WHERE list = 'QWER';

--6�� �����ڰ� ���� ����

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




