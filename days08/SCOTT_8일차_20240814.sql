-- SCOTT
-- 1) �Խ��� ���̺� ���� : tbl_board
-- 2) �÷� : �۹�ȣ, �ۼ���, ��й�ȣ, ����, ����, �ۼ���, ��ȸ��
CREATE TABLE tbl_board
(
    SEQ NUMBER(38) NOT NULL PRIMARY KEY
    , WRITER VARCHAR2(20) NOT NULL
    , PASSWORD VARCHAR2(15) NOT NULL
    , TITLE VARCHAR2(100) NOT NULL
    , CONTENT CLOB
    , REGDATE DATE DEFAULT SYSDATE
);
-- TABLE SCOTT.TBL_BOARD ����
-- EQ �۹�ȣ�� ����� ������ ����
CREATE SEQUENCE seq_tblboard
--    INCREMENT BY 1
--    START WITH 1
--    MAXVALUE 
--    MINVALUE -- MAXVALUE ���� �����ϰ� �ʱ�ȭ�� MINVALUE ������ ����
--    CYCLE
    NOCACHE;
-- Sequence SEQ_TBLBOARD��(��) �����Ǿ����ϴ�.
SELECT *
FROM USER_SEQUENCES;
-- ������ Ȯ���ϴ� ����
--
SELECT *
FROM TABS
WHERE TABLE_NAME LIKE 'TBL_B%';
--
DROP TABLE tbl_board CASCADE;

SELECT * FROM TBL_BOARD;
SELECT SEQ_TBLBOARD.CURRVAL FROM DUAL;
-- �Խñ� ����(�ۼ�) ���� �ۼ�
INSERT INTO TBL_BOARD(SEQ,WRITER,PASSWORD, TITLE,CONTENT) VALUES(SEQ_TBLBOARD.NEXTVAL,'ȫ�浿',1234,'TEST-1','TEST-1');
INSERT INTO TBL_BOARD(SEQ,WRITER,PASSWORD, TITLE,CONTENT) VALUES(SEQ_TBLBOARD.NEXTVAL,'�̽���',1234,'TEST-2','TEST-2');
INSERT INTO TBL_BOARD VALUES(SEQ_TBLBOARD.NEXTVAL,'�ۼ�ȣ',1234,'TEST-3','TEST-3',SYSDATE);
INSERT INTO TBL_BOARD(SEQ,WRITER,PASSWORD, TITLE) VALUES(SEQ_TBLBOARD.NEXTVAL,'������',1234,'TEST-4');

SELECT SEQ, TITLE, WRITER, TO_CHAR(REGDATE,'YYYY-MM-DD') REGDATE,READED
FROM TBL_BOARD
ORDER BY SEQ DESC;
-- ���� ���� Ȯ��
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = upper('tbl_board');
-- �������Ǹ��� �������� ������ SYS_XXXXXXX �ڵ� �ο�

-- ��ȸ�� �÷� �߰�~
ALTER TABLE tbl_board ADD READED NUMBER DEFAULT 0;
-- 2	TEST-2	�̽���	2024-08-14	0   �Խñ��� ������ Ŭ���ϸ�
-- 1) ��ȸ�� 1����
    UPDATE tbl_board
    SET READED = READED + 1
    WHERE SEQ = 2;
-- 2) �Խñ�(SEQ)�� ������ ��ȸ
    SELECT *
    FROM TBL_BOARD
    WHERE SEQ = 2;

-- �Խ����� �ۼ���( WRITER �÷�  20->40  SIZE Ȯ�� )
-- �÷��� �ڷ����� ũ�⸦ ����...

-- ���������� ������ �Ұ��ϴ�. ������ ���ϸ� ������ ���� ����
ALTER TABLE tbl_board MODIFY WRITER VARCHAR2(40);

-- Į������ ���� ( TITLE-> SUBJECT )
SELECT SEQ, TITLE SUBJECT, WRITER, TO_CHAR(REGDATE,'YYYY-MM-DD') REGDATE,READED
FROM TBL_BOARD
ORDER BY SEQ DESC;

ALTER TABLE tbl_board RENAME COLUMN TITLE TO SUBJECT;

-- ������ ���� ��¥ ������ ������ �÷��� �߰�. lastRegdate
ALTER TABLE tbl_board ADD lastRegdate DATE;
--
UPDATE tbl_board SET SUBJECT = '�������-3', CONTENT = '�������-3', LASTREGDATE = SYSDATE
WHERE SEQ = 3;
COMMIT;
--
SELECT *
FROM TBL_MYBOARD;
-- LASTREGDATE �÷� ����
ALTER TABLE TBL_BOARD
DROP COLUMN LASTREGDATE;
-- TBL_BOARD -> TBL_MYBOARD ���̺�� ����
RENAME TBL_BOARD TO TBL_MYBOARD;
-- [ ���̺� �����ϴ� ��� ]
1. CREATE TABLE ����
2. Subquery �� �̿��� ���̺� ����
    - ���� �̹� �����ϴ� ���̺��� �̿��ؼ� ���ο� ���̺� ���� (+ ���ڵ� �߰�)
    - CREATE TABLE ���̺�� [�÷���,...]
      AS (��������);
-- EX) emp ���̺�κ��� 30�� ����鸸 ���ο� ���̺� ����
CREATE TABLE tbl_emp30  -- (eno, ename, hiredate, job,pay)
AS(
    SELECT empno, ename, hiredate, job, sal + NVL(comm,0) pay
    FROM emp
    WHERE deptno = 30
);
--Table TBL_EMP30��(��) �����Ǿ����ϴ�.
DESC tbl_emp30;
-- ���������� ���簡 ���� �ʴ´�.
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('EMP','TBL_EMP30');
-- emp -> ���ο� ���̺� ���� + ������ ���� X
DROP TABLE tbl_emp30;

CREATE TABLE tbl_empcopy
AS
(
SELECT *
FROM emp
WHERE 1 = 0
);
-- ���̺��� ������ �״�� ���������� ������(���ڵ�) ����� ���� �ʴ� ��
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
-- SQL Ȯ�� => PL/SQL

-- [����] emp, dept ���̺��� �̿��ؼ� deptno, dname, empno, ename, hiredate, pay, grade �÷���
-- ���� ���ο� ���̺� ���� (tbl_empgrade)
CREATE TABLE tbl_empgrade
AS (
SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm,0) pay, grade
FROM emp e , dept d , salgrade s
WHERE d.deptno = e.deptno
    AND e.sal BETWEEN s.losal AND s.hisal
);
-- JOIN ~ ON ���� ����
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
DROP TABLE tbl_empgrade; -- ������ �̵�
PURGE RECYCLEBIN;   -- ������ ����
DROP TABLE tbl_empgrade PURGE;  -- ������ �̵����� �ʰ� ������ ����

-- emp ���̺��� ������ �����ؼ� ���ο� tbl_emp ���̺� ����
CREATE TABLE tbl_emp
AS(
SELECT *
FROM emp
WHERE 1=0
);
--
SELECT *
  FROM tbl_emp;
-- emp ���̺��� 10�� �μ������� tbl_emp ���̺� INSERT �۾�
-- DIRECT LOAD INSERT�� ���� ROW ���� 
INSERT INTO tbl_emp SELECT * FROM emp WHERE deptno = 10;
INSERT INTO tbl_emp (empno,ename) SELECT empno,ename FROM emp WHERE deptno = 20;
COMMIT;
DROP TABLE tbl_emp;

-- [ ���� INSERT �� 4���� ]
-- 1) unconditional insert all - ������ ���� INSERT ALL
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
-- ���� ���� 4���� �ѹ��� ó��
INSERT ALL
    INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT *
FROM emp;
-- 2) conditional insert all - ������ �ִ� INSERT ALL
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
-- 3) conditional first insert - ������ �ִ� INSERT FIRST
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
-- DELETE      |  DROP TABLE  |  TRUNCATE�� ������
-- ���ڵ� ����   |  ���̺� ����   |  ���ڵ� ��� ����             
-- DML         |  DDL         |  DML

-- TRUMCATE TABLE ���̺��; �ڵ�Ŀ��
-- DELETE FROM ���̺��;    Ŀ��/�ѹ�
--   �� WHERE �������� ������ ��� ���ڵ� ����...

-- [����] insa ���̺��� num, name �÷����� �����ؼ� ���ο� ���̺� tbl_score ���̺� ����
--                      �� num <= 1005
CREATE TABLE tbl_score AS
(
    SELECT num, name
    FROM insa
    WHERE num <= 1005
);

select * from tbl_score;
-- [����] tbl_score ���̺� kor,eng,mat,tot,avg,grade,rank �÷� �߰�
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
-- [����] 1001~1005 ��� �л��� ��,��,�� ������ ������ ������ �߻����Ѽ� ����(update)
-- 0.0<= SYS.dbms_random.value < 1.0
SELECT * FROM tbl_score;
UPDATE tbl_score
SET KOR = ROUND(DBMS_RANDOM.VALUE(0, 100))
    ,ENG = ROUND(DBMS_RANDOM.VALUE(0, 100))
    ,MAT = ROUND(DBMS_RANDOM.VALUE(0, 100));
COMMIT;
-- [����] 1005 �л��� ��,��,�� ������ 1001 �л��� ��,��,�� ������ ����
UPDATE tbl_score
SET (kor,eng,mat) = (SELECT kor,eng,mat FROM tbl_score WHERE num = 1001)
WHERE num = 1005;

-- [����] ��� �л��� ���� , ��� UPDATE
UPDATE tbl_score
SET tot = kor + eng + mat
    , avg = (kor + eng + mat)/3;
-- [����] ��� �л��� ����� UPDATE
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
-- [����] ��� ����(ó��)   avg�� 90 �̻� '��' ~ '��'
UPDATE tbl_score
SET grade = CASE WHEN avg >= 90 THEN '��'
                 WHEN avg >= 80 THEN '��'
                 WHEN avg >= 70 THEN '��'
                 WHEN avg >= 60 THEN '��'
                 ELSE '��'
            END;
-- DECODE      
UPDATE tbl_score
SET grade = DECODE(FLOOR(AVG/10),10,'��',9,'��',8,'��',7,'��',6,'��','��');
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
-- [����] ���л��� ���� ������ 5�� ����
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

-- [����] result �÷� �߰�
--       �հ�, ���հ�, ����
ALTER TABLE tbl_score ADD( RESULT CHAR ( 3 CHAR ) );
UPDATE tbl_score
SET result = CASE
                WHEN (kor >= 40 AND eng>=40 AND mat>=40) AND avg>=60 THEN '�հ�'
                WHEN avg < 60 THEN '���հ�'
                ELSE '����'
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






