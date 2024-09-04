-- SCOTT
-- ��������(Constraints) --
SELECT *
FROM user_constraints -- ��(View)
WHERE table_name = 'EMP';
-- ���������� data integrity(������ ���Ἲ)�� ���Ͽ�
-- �ַ� ���̺� ��(row)�� �Է�, ����, ������ �� ����Ǵ� ��Ģ���� ���Ǹ�
-- ���̺� ���� �����ǰ� �ִ� ��� ���̺��� ���� ������ ���ؼ��� ���ȴ�.

-- ����) ���Ἲ (integrity)
-- �������� ��Ȯ���� �ϰ����� �����ϰ�, �����Ϳ� ��հ� �������� ������ �����ϴ� ��

-- 2) �������� ���� ���
--  (1) ���̺��� ������ ���ÿ� ���������� ����
        -- ��. IN-LINE �������� ���� ��� ( �÷� ���� )
--            ��) seq NUMBER PRIMARY KEY
        -- ��. OUT-OF_LINE �������� ���� ��� ( ���̺� ���� )
--        CREATE TABLE XX
--        (
--            �÷�1     -- �÷� ���� ( NOT NULL ���� ���� )
--            , �÷�2
--            :
--            
--            , �������� ����   -- ���̺� ���� ( ����Ű ���� )
--            , �������� ����
--            , �������� ����
--            , �������� ����
--        )
--        
--        ��) ����Ű ���� ����?
--        [ ��� �޿� ���� ���̺� ]
--        PK(�޿����޳�¥ + �����ȣ) ����Ű -> �����̶�� �÷��� �߰��Ͽ� �⺻Ű�� (������ȭ)
--        �޿����޳�¥ �����ȣ    �޿���
--        2024.7.15   1111   3,000,000
--        2024.7.15   1112   3,000,000
--        2024.7.15   1113   3,000,000
--        :
--        2024.8.15   1111   3,000,000
--        2024.8.15   1112   3,000,000
--        2024.8.15   1113   3,000,000
--        :
--  ��) �÷� ���� ������� �������� ���� + ���̺� ������ ���ÿ� �������� ����.
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
    , kor NUMBER(3) CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)       -- CHECK(WHERE ������)
    , city VARCHAR2(20) CONSTRAINT ck_tblconstraint1_city CHECK(city IN('����','�λ�','�뱸'))       -- CHECK(WHERE ������)
);
-- ��) ���̺� ���� ������� �������� ���� + ���̺� ������ ���ÿ� �������� ����.
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY    SYS_CXXXXXXX
    empno NUMBER(4) NOT NULL
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2)
    , email VARCHAR2(150)
    , kor NUMBER(3)
    , city VARCHAR2(20)
    
    , CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY(empno)     -- PRIMARY KEY(empno,ename)->����Ű
    , CONSTRAINT fk_tblconstraint1_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT uk_tblconstraint1_deptno UNIQUE(email)
    , CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)       -- CHECK(WHERE ������)
    , CONSTRAINT ck_tblconstraint1_city CHECK(city IN('����','�λ�','�뱸'))       -- CHECK(WHERE ������)
);
-- 1) PK �������� ����
ALTER TABLE tbl_constraint1
--DROP CONSTRAINT PRIMARY KEY
DROP CONSTRAINT pk_tblconstraint1_empno;
-- 2) UNIQUE
ALTER TABLE tbl_constraint1
DROP UNIQUE(email);
--DROP CONSTRAINT ck_tblconstraint1_email;
-- 3) CK
ALTER TABLE tbl_constraint1
-- DROP CHECK(kor); X ���� ����
DROP CONSTRAINT ck_tblconstraint1_kor;

--
SELECT *
FROM user_constraints -- ��(View)
WHERE table_name LIKE 'TBL_C%';
-- ck_constraints_city üũ�������� ��Ȱ��ȭ disable(��Ȱ��ȭ)/enable(Ȱ��ȭ)
ALTER TABLE user_constraint1
DISABLE CONSTRAINT ck_constraints_city; --��Ȱ��ȭ
-- DISABLE CONSTRAINT ck_constraints_city [CASCADE]; cascade�ɼ��� ��Ȱ��ȭ��Ű���� constraint�� �����ϴ� �ٸ� ��� constraint�鵵 ��Ȱ��ȭ��Ų��
ENABLE CONSTRAINT ck_constraints_city;   --Ȱ��ȭ
        
--  (2) ALTER TABLE ���̺��� ������ �� ���������� ����(�߰�), ����
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);
    1) empno �÷��� PK �������� �߰�
    ALTER TABLE tbl_constraint3
    ADD CONSTRAINT pk_tblconstraint3_empno PRIMARY KEY(empno);
    
    2) deptno �÷��� FK �������� �߰�
    ALTER TABLE tbl_constraint3
    ADD CONSTRAINT fk_tblconstraint3_empno FOREIGN KEY(deptno) REFERENCES dept(deptno);
    
    DROP TABLE tbl_constraint3;
    
--  ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
    DELETE FROM dept
    WHERE deptno = 10;
    
--  [ON DELETE CASCADE | ON DELETE SET NULL]
--  ? ON DELETE CASCADE �ɼ��� �̿��ϸ� �θ� ���̺��� ���� ������ �� �̸� ������ �ڽ� ���̺��� ���� ���ÿ� ������ �� �ִ�.
--  ? ON DELETE SET NULL�� �ڽ� ���̺��� �����ϴ� �θ� ���̺��� ���� �����Ǹ� �ڽ� ���̺��� ���� NULL ������ �����Ų��.
    
-- emp -> tbl_emp ����
-- dept -> tbl_dept ����
CREATE TABLE tbl_emp
AS
(SELECT * FROM emp);
--
CREATE TABLE tbl_dept
AS
(SELECT * FROM dept);
--
SELECT *
FROM user_constraints -- ��(View)
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

-------------------����(JOIN)---------------------
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- åID
      ,title      VARCHAR2(100) NOT NULL  -- å ����
      ,c_name  VARCHAR2(100)    NOT NULL     -- c �̸�
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK��(��) �����Ǿ����ϴ�.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

COMMIT;

SELECT *
FROM book;

-- �ܰ����̺�( å�� ���� )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (�ĺ����� ***)
      ,price  NUMBER(7) NOT NULL    -- å ����
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA��(��) �����Ǿ����ϴ�.
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

-- å�� ���� �������̺�
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * 
FROM au_book;

-- ��            
-- �Ǹ�            ���ǻ� <-> ����
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- �Ǹ�
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
-- 1) EQUI JOIN :  �� �� �̻��� ���̺� ����Ǵ� �÷����� ������ ��ġ�ϴ� ��쿡 ����ϴ� �Ϲ����� join ������,
--                 WHERE ���� '='(��ȣ)�� ����Ѵ�.
--                 ���� primary key, foreign key ���踦 �̿��Ѵ�.
--                 NATURAL JOIN �� �����ϴ�

---- [����] åID ( b_id ), å���� ( title ), ���ǻ�( c_name ), �ܰ�  �÷� ���....
-- ��. WHERE ���ǹ�
SELECT b.b_id åID, title å����, c_name ���ǻ�, price �ܰ�
FROM BOOK B, DANGA D
WHERE B.b_id = D.b_id;
-- ��. JOIN ~ ON
SELECT b.b_id åID, title å����, c_name ���ǻ�, price �ܰ�
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id;
-- ��. USING �� ���( ��ü��. �� ��Ī��. ������� �ʴ´� )
SELECT b_id åID, title å����, c_name ���ǻ�, price �ܰ�
FROM book JOIN danga USING(b_id);
-- ��. NATURAL JOIN 
SELECT b_id åID, title å����, c_name ���ǻ�, price �ܰ�
FROM book NATURAL JOIN danga;

---- [����]  åID ( b_id ), å���� ( title ), �Ǹż��� ( p_su ), �ܰ� ( price )
--          , ������ ( g_id ), �Ǹűݾ�( = p_su * price ) ���
SELECT  b.b_id åID
        , title å����
        , p_su �Ǹż���
        , price �ܰ�
        , g.g_id ������
        , p_su * price �Ǹűݾ�
FROM BOOK B, DANGA D, PANMAI P, GOGAEK G
WHERE B.b_id = D.b_id AND B.b_id = P.b_id AND G.g_id = P.g_id;
-- JOIN ~ ON
SELECT  b.b_id åID
        , title å����
        , p_su �Ǹż���
        , price �ܰ�
        , g.g_id ������
        , p_su * price �Ǹűݾ�
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id;
-- USING �� ���
SELECT  b_id åID
        , title å����
        , p_su �Ǹż���
        , price �ܰ�
        , g_id ������
        , p_su * price �Ǹűݾ�
FROM book JOIN panmai USING(b_id)
          JOIN danga USING(b_id)
          JOIN gogaek USING(g_id);
-- * NON-EQUI JOIN :        ���������� = X
-- emp / sal    grade
SELECT empno, ename, sal, losal || '~' || hisal, grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;

-- OUTER JOIN
-- (+) ������
-- LEFT, RIGHT, FULL OUTER JOIN 3����
-- KING ����� �μ���ȣ�� Ȯ���ϰ� -> NULL�� ������Ʈ
SELECT *
FROM emp
WHERE ename = UPPER('king');

UPDATE emp
SET deptno = NULL
WHERE ename = UPPER('king');
COMMIT;

-- [��� emp ��������� ����� �ϵ� �μ���ȣ��ſ� �μ������� ���(��ȸ)]
-- JOIN ��� emp ���̺��� ��� ������ dept ���̺�� JOIN�ؼ�
-- dname, ename, hiredate �÷� ���
SELECT dname, ename, hiredate
FROM dept d RIGHT OUTER JOIN emp e ON d.deptno = e.deptno;
--
SELECT dname, ename, hiredate
FROM dept d , emp e
WHERE d.deptno(+) = e.deptno;

-- �� �μ��� ����� ��ȸ
-- �μ���, �����
SELECT DISTINCT dname, (SELECT COUNT(*) FROM emp WHERE deptno = d.deptno) �����
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
-- �����ȣ, �����, �Ի�����, ���ӻ�����̸�
SELECT  a.empno �����ȣ, a.ename �����, a.hiredate �Ի�����, b.ename ���ӻ�����̸�
FROM emp A JOIN emp B on a.mgr = b.empno;
-- CROSS JOIN : ��ī��Ʈ ��
SELECT e.*, d.*
FROM emp e , dept d;

-- ����) ���ǵ� å���� ���� �� ����� �ǸŵǾ����� ��ȸ     
--      (    åID ( b_id ), å���� ( title ), ���ǸűǼ�( sum(p_su) ), �ܰ� ( price ) �÷� ���   )
SELECT  b.b_id åID
        , title å����
        , sum(p_su) ���ǸűǼ�
        , price �ܰ�
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id
GROUP BY b.b_id,b.title,d.price
ORDER BY b.b_id;
--

-- ����) �ǸűǼ��� ���� ���� å ���� ��ȸ
-- 1)
SELECT ROWNUM, T.*
FROM(
SELECT  b.b_id åID
        , title å����
        , sum(p_su) ���ǸűǼ�
        , price �ܰ�
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id
GROUP BY b.b_id,b.title,d.price
ORDER BY ���ǸűǼ� DESC
)T
WHERE ROWNUM = 1;
-- 2)
WITH t
AS(
    SELECT  b.b_id åID
            , title å����
            , sum(p_su) ���ǸűǼ�
            , price �ܰ�
    FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
                JOIN PANMAI P ON B.b_id = P.b_id
                JOIN GOGAEK G ON G.g_id = P.g_id
    GROUP BY b.b_id,b.title,d.price
), s AS (
    SELECT t.*
        , RANK()OVER(ORDER BY ���ǸűǼ� DESC) �Ǹż���
    FROM t
)
SELECT s.*
FROM s
WHERE s.�Ǹż��� = 1;
-- 3)
SELECT t.*
FROM(
SELECT  b.b_id åID
        , title å����
        , sum(p_su) ���ǸűǼ�
        , price �ܰ�
        , p_date �Ǹ�����
        , RANK()OVER(ORDER BY sum(p_su) DESC) �Ǹż���
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id
GROUP BY b.b_id,b.title,d.price,p_date
)t
WHERE t.�Ǹż��� = 1;
-- ���� �ǸűǼ��� ���� ���� å ���� ��ȸ
SELECT t.*
FROM(
SELECT  b.b_id åID
        , title å����
        , sum(p_su) ���ǸűǼ�
        , price �ܰ�
        , p_date �Ǹ�����
        , RANK()OVER(ORDER BY sum(p_su) DESC) �Ǹż���
FROM BOOK B JOIN DANGA D ON B.b_id = D.b_id
            JOIN PANMAI P ON B.b_id = P.b_id
            JOIN GOGAEK G ON G.g_id = P.g_id
GROUP BY b.b_id,b.title,d.price,p_date
)t
WHERE t.�Ǹż��� = 1 AND TO_CHAR(�Ǹ�����,'YYYY') = TO_CHAR(SYSDATE,'YYYY');
--
SELECT T.*
FROM(
    SELECT b.b_id, title, SUM(p_su)�Ǹż���
        , RANK()OVER(ORDER BY SUM(p_su)DESC) �Ǹż���
    FROM book b JOIN panmai p ON b.b_id = p.b_id
    WHERE TO_CHAR(p_date,'YYYY')= TO_CHAR(SYSDATE,'YYYY')
    GROUP BY b.b_id, title
)t
WHERE t.�Ǹż��� = 1;

-- [����] book ���̺��� �ǸŰ� �� ���� ���� å�� ���� ��ȸ
-- åID, ����, ����
SELECT b.b_id åID, title å����, price ���� --, p_su
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
                 JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NULL;
-- MINUS ��ü å �������� �Ǹ��̷� �ִ� å ���� ����
-- ANTI JOIN( NOT IN ������ )
SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id NOT IN(
    SELECT DISTINCT b_id
    FROM panmai
);
-- ����) book ���̺��� �ǸŰ� �� ���� �ִ� å�� ���� ��ȸ
--      (b_id, title, price �÷� ���)
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
-- ����) ���� �Ǹ� �ݾ� ��� (���ڵ�, ����, �Ǹűݾ�)
SELECT g.g_id,g.g_name, SUM(p.p_su*d.price) �Ǹűݾ�
FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
              JOIN danga d ON p.b_id = d.b_id
GROUP BY g.g_id,g.g_NAME;

-- [����] �⵵, ���� �Ǹ� ��Ȳ ���ϱ�
SELECT TO_CHAR(p_date,'YYYY') YEAR, TO_CHAR(p_date,'mm') month,SUM(P_SU) �Ǹż���
FROM panmai p
GROUP BY TO_CHAR(p_date,'YYYY'),TO_CHAR(p_date,'mm');

-- [����] ������ �⵵�� �Ǹ���Ȳ ���ϱ�
SELECT A.������, A.YEAR,SUM(A.P_SU) �Ǹż���
FROM(
    SELECT P.*, g.g_name ������, TO_CHAR(p.p_date,'YYYY') YEAR
    FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
)A
GROUP BY A.������, A.YEAR
ORDER BY A.������, A.YEAR;

-- [����] å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--   ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )
SELECT A.åID, A.����, A.�ܰ�, SUM(A.���ǸűǼ�) ���ǸűǼ�, SUM(A.���ǸűǼ�*A.�ܰ�) ���Ǹűݾ�
FROM(
    SELECT p.b_id åID, b.title ����, d.price �ܰ�, p.p_su ���ǸűǼ�
    FROM panmai p JOIN book b ON p.b_id = b.b_id
                  JOIN danga d ON p.b_id = d.b_id
)A
GROUP BY A.åID, A.����, A.�ܰ�
HAVING SUM(A.���ǸűǼ�*A.�ܰ�) >= 15000;

