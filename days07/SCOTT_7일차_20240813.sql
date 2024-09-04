-- SCOTT
-- [����] emp, dept
-- ����� �������� �ʴ� �μ��� �μ���ȣ, �μ����� ���
-- ��. RIGHT OUTER JOIN
SELECT d.deptno �μ���ȣ, d.dname �μ���, COUNT(E.DEPTNO) �����
FROM EMP E RIGHT OUTER JOIN DEPT D ON e.deptno = d.deptno
-- OUTER ���� ���� ( RIGHT JOIN )
GROUP BY d.deptno,d.dname
HAVING COUNT(E.DEPTNO) = 0;

-- ��. MINUS
WITH T AS(
SELECT DEPTNO
FROM DEPT
MINUS
SELECT DISTINCT DEPTNO
FROM EMP
)
SELECT T.DEPTNO, D.DNAME
FROM T JOIN DEPT D ON T.DEPTNO = D.DEPTNO;

-- ��.
SELECT T.DEPTNO, D.DNAME
FROM (
    SELECT DEPTNO
    FROM DEPT
    MINUS
    SELECT DISTINCT DEPTNO
    FROM EMP
)T JOIN DEPT D ON T.DEPTNO = D.DEPTNO;

-- ��. SQL ������ ALL, ANY, SOME, ( NOT EXISTS )
SELECT M.DEPTNO, M.DNAME
FROM DEPT M
WHERE NOT EXISTS ( SELECT EMPNO FROM EMP WHERE DEPTNO = M.DEPTNO );

-- ��. �����������;
SELECT M.DEPTNO, M.DNAME
FROM DEPT M
WHERE ( SELECT COUNT(*) FROM EMP WHERE DEPTNO = M.DEPTNO ) = 0; -- EMP ���̺� �������� �ʴ� �μ�����

-- [����] insa ���̺��� �� �μ��� ���ڻ������ �ľ��ؼ� 5�� �̻��� �μ� ���� ���
SELECT BUSEO, COUNT(*)���ڻ����
FROM INSA
WHERE MOD(SUBSTR(SSN,-7,1),2) = 0
GROUP BY BUSEO
HAVING COUNT(*)>=5;

-- [����] insa ���̺�
--  [�ѻ����] [���ڻ����] [���ڻ����] [���������  [���������  [����-      [����-
--                                    �ѱ޿���]   �ѱ޿���]  max(�޿�)]  max(�޿�)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60        31          29   51961200   41430400    2650000    2550000

SELECT COUNT(*) "[�ѻ����]"
    , COUNT(DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'O')) "[���ڻ����]"
    , COUNT(DECODE(MOD(SUBSTR(SSN,-7,1),2),0,'O')) "[���ڻ����]"
    , SUM(DECODE(MOD(SUBSTR(SSN,-7,1),2),1,BASICPAY)) "[����������ѱ޿���]"
    , SUM(DECODE(MOD(SUBSTR(SSN,-7,1),2),0,BASICPAY)) "[����������ѱ޿���]"
    , MAX(DECODE(MOD(SUBSTR(SSN,-7,1),2),1,BASICPAY)) "[����-max(�޿�)]"
    , MAX(DECODE(MOD(SUBSTR(SSN,-7,1),2),0,BASICPAY)) "[����-max(�޿�)]"
FROM INSA;
-- ��
SELECT
    DECODE(MOD(SUBSTR(SSN,8,1),2),1,'����',0,'����','��ü') || '�����' ���
    ,COUNT(*) �����
    ,SUM(BASICPAY) �޿���
    ,MAX(BASICPAY) �ְ�޿�
FROM INSA
GROUP BY ROLLUP(MOD(SUBSTR(SSN,8,1),2));

-- [����] emp ���̺���~
--      �� �μ��� �����, �μ� �ѱ޿���, �μ� ��ձ޿�
-- ���)
--  DEPTNO     �μ�����          �ѱ޿���           ���
---------- ----------       ----------    ----------
--      10          3             8750       2916.67
--      20          3             6775       2258.33
--      30          6            11600       1933.33 
--      40          0                0             0

SELECT D.DEPTNO
    , COUNT(E.EMPNO) �μ�����
    , NVL(SUM(E.SAL+NVL(E.COMM,0)),0) �ѱ޿���
    , NVL(ROUND(AVG(E.SAL+NVL(E.COMM,0)),2),0) ���
FROM EMP E RIGHT JOIN DEPT D ON e.deptno=d.deptno
GROUP BY D.DEPTNO
ORDER BY D.DEPTNO;

-- [ ROLLUP���� CUBE�� ]
--  �� GROUP BY ������ ���Ǿ� �׷캰 �Ұ踦 �߰��� �����ִ� ����
--  �� ��, �߰����� ���� ������ �����ش�.
SELECT
    CASE MOD(SUBSTR(SSN,-7,1),2)
        WHEN 1 THEN '����'
        ELSE '����'
    END ����
    , COUNT(*) �����
FROM INSA
GROUP BY MOD(SUBSTR(SSN,-7,1),2)
UNION ALL
SELECT '��ü', COUNT(*)
FROM INSA;

-- GROUP BY + ROLLUP/CUBE
SELECT
    CASE MOD(SUBSTR(SSN,-7,1),2)
        WHEN 1 THEN '����'
        WHEN 0 THEN '����'
        ELSE '��ü'
    END ����
    , COUNT(*) �����
FROM INSA
GROUP BY CUBE (MOD(SUBSTR(SSN,-7,1),2));
--GROUP BY ROLLUP (MOD(SUBSTR(SSN,-7,1),2));

-- ROLLUP / CUBE �� ������..
-- 1�� �μ����� �׷���, 2�� �������� �׷���
SELECT BUSEO, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY BUSEO, JIKWI
UNION ALL
SELECT BUSEO,NULL, COUNT(*) �μ�����
FROM INSA
GROUP BY BUSEO
ORDER BY BUSEO, JIKWI;
-- 1)
SELECT BUSEO, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY CUBE(BUSEO, JIKWI)
ORDER BY BUSEO, JIKWI;
-- 2)
SELECT BUSEO, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY BUSEO, JIKWI
UNION ALL
SELECT BUSEO,NULL, COUNT(*) �μ�����
FROM INSA
GROUP BY BUSEO
UNION ALL
SELECT NULL, JIKWI, COUNT(*) �μ�����
FROM INSA
GROUP BY JIKWI;

-- ���� ROLLUP
SELECT BUSEO, JIKWI, COUNT(*) �����
FROM insa
GROUP BY ROLLUP(buseo),jikwi    -- ������ ���� �κ� ���� , ��ü����x
--GROUP BY buseo, ROLLUP(jikwi) -- �μ��� ���� �κ� ���� , ��ü����x
--GROUP BY ROLLUP(buseo,jikwi)
--GROUP BY CUBE(buseo,jikwi)
ORDER BY buseo, jikwi;

-- [ GROUPING SETS �Լ� ]
SELECT buseo, '', COUNT(*)
FROM insa
GROUP BY buseo
UNION ALL
SELECT '', jikwi,COUNT(*)
FROM insa
GROUP BY jikwi;
--
SELECT BUSEO, JIKWI, COUNT(*) �����
FROM insa
GROUP BY GROUPING SETS(buseo, jikwi) -- �׷����� ���踸 ������ �Ҷ�
ORDER BY buseo, jikwi;

-- �Ǻ�(PIVOT) ����
-- 1. ���̺� ���� X (������Ʈ ����~)
-- tbl_pivot ���̺� ����
-- ��ȣ, �̸�, ��,��,�� ���� ���̺�
-- DDL �� : CREATE
CREATE TABLE tbl_pivot
(
--    �÷��� �ڷ���(ũ��) ���� ����...
    NO NUMBER PRIMARY KEY -- ������Ű(PK) ��������
    , NAME VARCHAR2(20 BYTE) -- NN ��������(==�ʼ��Է»���)
    , jumsu NUMBER(3) -- NULL ���
);
--Table TBL_PIVOT��(��) �����Ǿ����ϴ�.
SELECT *
FROM tbl_pivot;

INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '�ڿ���', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '�ڿ���', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '�ڿ���', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '�Ƚ���', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '�Ƚ���', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '�Ƚ���', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '���', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '���', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '���', 100 );  -- mat 

COMMIT; 

 -- ����) �Ǻ�
--��ȣ �̸�   ��,  ��,  ��
--1   �ڿ���  90 89 99
--2   �Ƚ���  56 45 12
--3   ���    99 85 100

SELECT *
FROM(
    SELECT TRUNC((NO-1)/3)+1 NO
            ,NAME
            ,DECODE(MOD(NO,3),1,'����',2,'����',0,'����') ����
            , JUMSU
    FROM tbl_pivot
    )
PIVOT(
    SUM(JUMSU)
    FOR ���� IN ('����','����','����')
)
ORDER BY NO;
--
SELECT *
FROM(
    SELECT TRUNC((NO-1)/3)+1 NO
            ,NAME
            ,ROW_NUMBER()OVER(PARTITION BY NAME ORDER BY NO) ����
            , JUMSU
    FROM tbl_pivot
    )
PIVOT(
    SUM(JUMSU)
    FOR ���� IN (1 AS "����", 2 AS "����", 3 AS "����")
)
ORDER BY NO;

-- [Ǯ��] ���⵵�� ���� �Ի��� ����� �ľ�(��ȸ)
-- ORA-01788: CONNECT BY clause required in this query block
-- LEVEL �� CONNECT BY�� ���� ����ؾ��Ѵ�.
SELECT LEVEL MONTH
FROM DUAL
CONNECT BY LEVEL <= 12;
--
SELECT EMPNO
        , TO_CHAR(HIREDATE,'YYYY') YEAR
        , TO_CHAR(HIREDATE,'MM') month
FROM EMP;
--
SELECT year, m.month, NVL(COUNT(empno), 0) n
FROM  (
      SELECT empno, TO_CHAR( hiredate, 'YYYY') year
            , TO_CHAR( hiredate, 'MM' ) month
      FROM emp
     ) e
     PARTITION BY ( e.year ) RIGHT OUTER JOIN 
    (
       SELECT LEVEL month   
       FROM dual
       CONNECT BY LEVEL <= 12
     ) m 
     ON e.month = m.month
     GROUP BY year, m.month
     ORDER BY year, m.month;
--    YEAR      MONTH          N
--    ---- ---------- ----------
--    1980          1          0
--    1980          2          0
--    1980          3          0
--    :

SELECT *
FROM EMP;
SELECT TO_CHAR(HIREDATE,'YYYY') H_YEAR
       , COUNT(*)
FROM EMP
GROUP BY TO_CHAR(HIREDATE,'YYYY')
ORDER BY H_YEAR;

-- [Ǯ��] INSA ���� �μ���, ������ �����
SELECT BUSEO, JIKWI, COUNT(*)
FROM INSA
GROUP BY BUSEO, JIKWI
ORDER BY BUSEO, JIKWI;
-- [����] �� �μ��� ������ �ּһ����, �ִ����� ��ȸ
-- 2���� --
WITH t1 AS (
    SELECT buseo, jikwi, COUNT(num) tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
  , t2 AS (
     SELECT buseo, MIN(tot_count) buseo_min_count
                 , MAX(tot_count) buseo_max_count
     FROM t1
     GROUP BY buseo
  )
SELECT A.BUSEO
    , B.JIKWI �ּҺμ�
    , B.TOT_COUNT �ּһ����
FROM t2 A , T1 B
WHERE A.BUSEO = B.BUSEO AND A.BUSEO_MIN_COUNT = B.TOT_COUNT;

-- FIRST/MAX �м��Լ� ����ؼ� Ǯ��
WITH t AS (
    SELECT buseo, jikwi, COUNT(num) tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
SELECT T.BUSEO
    , MIN(T.jikwi) KEEP(DENSE_RANK FIRST ORDER BY T.TOT_COUNT ASC) �ּ�����
    , MIN(T.TOT_COUNT) �ּһ����
    , MAX(T.jikwi) KEEP(DENSE_RANK LAST ORDER BY T.TOT_COUNT ASC) �ִ�����
    , MAX(T.TOT_COUNT) �ִ�����
FROM T
GROUP BY T.BUSEO
ORDER BY 1;

-- 1) �м��Լ� FIRST, LAST
--           �����Լ�(COUNT,SUM,AVG,MAX,MIN)�� ���� ����Ͽ�
--           �־��� �׷쿡 ���� ���������� ������ �Ű� ����� �����ϴ� �Լ�
WITH a AS
(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
)
SELECT MIN(cnt)
    , MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt DESC) min_dname
    , MAX(cnt)
    , MAX(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt DESC) max_dname
FROM a;

-- 2) SELF JOIN
SELECT A.EMPNO,A.ENAME,A.MGR, B.ENAME
FROM EMP A JOIN EMP B ON A.MGR = B.EMPNO;

-- SELF JOIN
SELECT *
FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO; -- INNER JOIN �����Ǿ�����
-- NON EQUAL JOIN
SELECT EMPNO, ENAME, SAL, GRADE
FROM EMP E JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL;
-- ���� ���� ���
SELECT ename, sal 
   ,  CASE
        WHEN  sal BETWEEN 700 AND 1200 THEN  1
        WHEN  sal BETWEEN 1201 AND 1400 THEN  2
        WHEN  sal BETWEEN 1401 AND 2000 THEN  3
        WHEN  sal BETWEEN 2001 AND 3000 THEN  4
        WHEN  sal BETWEEN 3001 AND 9999 THEN  5
      END grade
FROM emp;
-- CROSS JOIN
SELECT EMPNO, ENAME, SAL, GRADE
FROM EMP E , SALGRADE S;

-- [����] EMP ���̺��� ���� �Ի����ڰ� ���� �����
--                    ���� �Ի����ڰ� ���� ������� �Ի� ���� �� ��?
SELECT MAX(HIREDATE) - MIN(HIREDATE)
FROM EMP;

-- �м��Լ� : CUME_DIST
--      �� �־��� �׷쿡 ���� ������� ���� ������ ���� ��ȯ
--      �� ��������(����)  0 <     <=1
SELECT DEPTNO, ENAME, SAL
--    ,CUME_DIST()OVER(ORDER BY SAL ASC) DEPT_LIST
    ,CUME_DIST()OVER(PARTITION BY DEPTNO ORDER BY SAL ASC) DEPT_LIST
FROM EMP;

-- �м��Լ� : PERCENT_RANK()
--     �� �ش� �׷� ���� ����� ����
--          0<=     ������ ��     <=1
-- ����� ���� ? �׷� �ȿ��� �ش� ���� ������ ���� ���� ����

-- NTILE()  NŸ��
--  �� ��Ƽ�� ���� ǥ���Ŀ� ��õ� ��ŭ ������ ����� ��ȯ�ϴ� �Լ�
-- �����ϴ� ���� ��Ŷ(BUCKET) �̶�� �Ѵ�.
SELECT DEPTNO, ENAME, SAL
    , NTILE(4)OVER(ORDER BY SAL ASC) NTILES
FROM EMP;
--
SELECT DEPTNO, ENAME, SAL
    , NTILE(2)OVER(PARTITION BY DEPTNO ORDER BY SAL ASC) NTILES
FROM EMP;

-- WIDTH_BUCKET(expr,minvalue,maxvalue,numbuckets) == NTILE() �Լ��� ������ �м��Լ�, ������
SELECT DEPTNO, ENAME, SAL
    ,NTILE(4) OVER(ORDER BY SAL) NTILES
    ,WIDTH_BUCKET(SAL,1000,4000,4)WIDTHBUCKETS
    -- SAL ���� 1000~4000 ������ �κ��� 4�ܰ�(1 - 1000~1750, 2 - 1750~2500, 3 - 2500~3250, 4 - 3250~4000)�� ������
FROM EMP;

-- LAG( expr, offset, default_value )
--  �� �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�
--  �� ����(��) ��
-- LEAD( expr, offset, default_value )
--  �� �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�
--  �� ����(��) ��
SELECT DEPTNO, ENAME, HIREDATE, SAL
    ,LAG(SAL,1,0)OVER(ORDER BY HIREDATE)PREV_SAL
    ,LEAD(SAL,1,-1)OVER(ORDER BY HIREDATE)NEXT_SAL
FROM EMP
WHERE DEPTNO = 30;

------------------------------------------------------------------------------------------
-- [ ����Ŭ �ڷ��� (Data Type) ]  
-- 1)CHAR[(SIZE ����[BYTE|(CHAR)]   ���ڿ� �ڷ���
--   CHAR = CHAR(1 BYTE) = CHAR(1)
--   CHAR(3 BYTE) = CHAR(3)
--   CHAR(3 BYTE) = CHAR(3)   'ABC'   '��'
--   CHAR(3 CHAR  'ABC'   '�ѵμ�'
--   ���� ������ ���ڿ� �ڷ���
--   name CHAR(10 BYTE) [A][B][C][][]][][]    'ABC'
--   2000 BYTE ũ�� �Ҵ��� �� �ִ�.
--   ��) �ֹε�Ϲ�ȣ, �й� ��,,,
   
-- �׽�Ʈ
CREATE TABLE TBL_CHAR
(
    AA CHAR         -- CHAR(1) == CHAR(1 BYTE)
    ,BB CHAR(3)     -- CHAR(3 BYTE)
    ,CC CHAR(3 CHAR)

);

DESC TBL_CHAR;

INSERT INTO TBL_CHAR(AA,BB,CC) VALUES('A','AAA','AAA');
INSERT INTO TBL_CHAR(AA,BB,CC) VALUES('B','��','�ѿ츮');
INSERT INTO TBL_CHAR(AA,BB,CC) VALUES('C','�ѿ츮','�ѿ츮');-- BB���� 3BYTE�� �Ҵ�Ǿ��� ������ �����߻�

-- 2) NCHAR
--    N== UNICODE(�����ڵ�)
--    NCHAR[(SIZE)]
--    NCHAR(1) == NCHAR
--    NCHAR(10)
--    �������� ���ڿ� �ڷ���
--    2000 BYTE ���� ���尡��
   
   CREATE TABLE TBL_NCHAR
(
    AA CHAR(3)          -- CHAR(3BYTE)
    ,BB CHAR(3 CHAR)
    ,CC NCHAR(3)

);

INSERT INTO TBL_NCHAR(AA,BB,CC)VALUES('ȫ','�浿','ȫ�浿');

INSERT INTO TBL_NCHAR(AA,BB,CC)VALUES('ȫ�浿','ȫ�浿','ȫ�浿'); -- AA���� 3BYTE�� �Ҵ�Ǿ����Ƿ� �����߻�

COMMIT;

-- 3) VARCHAR2 == VARCHAR
--    ���� ���� ���ڿ� �ڷ���
--    4000BYTE �ִ�ũ��
--    VARCHAR2(size [BYTE ? CHAR])
--    VARCHAR2(1) = VARCHAR2(1 BYTE) = VARCHAR2
--    
--    NAME VARCHAR2(10)           [A][D][M][I][N][][][][][]    'ADMIN'
--                                                �� ������� �ʴ� �޸𸮴� ����

 4) NVARCHAR2
    �����ڵ� + �������� + ���ڿ� �ڷ���
    NVARCHAR2(size)
    NVARCHAR2(1) = NVARCHAR2
    4000 BYTE
 
 5) NUMBER[(p[,s])]
            �� PRECISION  SCALE
      �������ǹ� : ��Ȯ��     �Ը�
                 ��ü�ڸ���  �Ҽ��������ڸ���
                 1~38      -84~127
    NUMBER = NUMBER( 38 , 127 )
    NUMBER(P) = NUMBER(P,0)
    
    ��)
    CREATE TABLE TBL_NUMBER
    (
        NO NUMBER(2) NOT NULL PRIMARY KEY
        -- �⺻Ű�� NULL ���� ������ ���� ������ Ű���� ���´�.
        -- �⺻Ű�� �ٸ� Į������ �����ϴ� ���� �����Ͽ� NOT NULL �� ����.
        , NAME VARCHAR2(30) NOT NULL
        ,KOR NUMBER(3)
        ,ENG NUMBER(3)
        ,MAT NUMBER(3) DEFAULT 0
    );
    
    INSERT INTO TBL_NUMBER(NO,NAME,KOR,ENG,MAT) VALUES(1,'ȫ�浿',90,88,98);
    COMMIT;
    
--    SQL ����: ORA-00947: not enough values
--    INSERT INTO TBL_NUMBER(NO,NAME,KOR,ENG,MAT) VALUES(2,'�̽���',100,100);
    
    INSERT INTO TBL_NUMBER(NO,NAME,KOR,ENG) VALUES(2,'�̽���',100,100);
--    SQL ����: ORA-00947: not enough values    
--    INSERT INTO TBL_NUMBER VALUES(3,'�ۼ�ȣ',50,50);
    
    INSERT INTO TBL_NUMBER VALUES(3,'�ۼ�ȣ',50,50,100);
    COMMIT;
    --
    INSERT INTO TBL_NUMBER(NAME,NO,KOR,ENG,MAT) VALUES('�����',4,50,50,100);
    COMMIT;
    SELECT *
    FROM TBL_NUMBER;
    --
--  ORA-00001: unique constraint (SCOTT.SYS_C007027) violated
--  ���ϼ� ���࿡ ����ȴ�.
--  INSERT INTO TBL_NUMBER VALUES(4,'�輱��',110,56.234,-999);
    
    INSERT INTO TBL_NUMBER VALUES(5,'�輱��',110,56.234,-999); -- �ݿø�
    INSERT INTO TBL_NUMBER VALUES(5,'�輱��',110,56.934,-999); -- �ݿø�
    ROLLBACK;
    
 6) FLOAT[(p)]  == ���������� NUMBER ó�� ��Ÿ����.
 7) LONG    ��������(VAR) ���ڿ� �ڷ���, 2GB���� ����
 8) DATE    ��¥, �ð� ��(��������, 7byte)�� ����
    TIMESTAMP [(n)] DATE�� Ȯ�� ���·�, �ִ� 9�ڸ��� ��,��,��,��,��,��,�и��ʱ��� ������
            n�� �ʴ��� ������ �̾ ��Ÿ�� mili second�� �ڸ����� �⺻���� 6�̴�
 9) RAW(size)- 2000 BYTE ����������
    LONG RAW - 2GB       ����������
 10) LOB Ÿ���� BLOB, CLOB, NCLOB�� ���ο� ���������, BFILE�� �ܺο� �����Ѵ�.
     CLOB - �ؽ�Ʈ �����͸� ����=(4GB-1)*(data block size)
     NCLOB - �ؽ�Ʈ �����͸� ����=(4GB-1)*(data block size)
     BLOB - 2�� �����͸� (4GB-1)*(database block size)���� ����
     BFILE - 2�� �����͸� �ܺ� file���·� 4GB���� ����
    
-- FIRST_VALUE �м��Լ� : ���ĵ� �� �߿� ù ��° ��
SELECT FIRST_VALUE(basicpay) OVER(ORDER BY basicpay DESC)
FROM insa;

SELECT FIRST_VALUE(basicpay) OVER(PARTITION BY BUSEO ORDER BY basicpay DESC)
FROM insa;
-- ���� ���� �޿�(basicpay) ������� basicpay�� ����
SELECT buseo, name, basicpay
    ,FIRST_VALUE(basicpay) OVER(PARTITION BY BUSEO ORDER BY basicpay DESC)
    ,FIRST_VALUE(basicpay) OVER(PARTITION BY BUSEO ORDER BY basicpay DESC) -- basicpay ����
FROM insa; 

-- COUNT ~ OVER : ������ ���� ������ ��� ��ȯ
-- SUM ~ OVER : ������ ���� ������ ���(��) ��ȯ
-- AVG ~ OVER : ������ ���� ������ ���(���) ��ȯ
SELECT NAME, BASICPAY, BUSEO
--        ,COUNT(*)OVER(ORDER BY BASICPAY ASC)����
--        ,SUM(BASICPAY)OVER(ORDER BY BUSEO ASC)������
        ,AVG(BASICPAY)OVER(ORDER BY BUSEO ASC)�������
FROM INSA;

SELECT NAME, BASICPAY, BUSEO
--        ,COUNT(*)OVER(PARTITION BY BUSEO ORDER BY BASICPAY ASC)����
--        ,SUM(BASICPAY)OVER(PARTITION BY BUSEO ORDER BY BUSEO ASC)������
        ,)OVER(PARTITION BY BUSEO ORDER BY BUSEO ASC)������
FROM INSA;

-- �� ���̺� ����, ����, ���� (DDL : CREATE, ALTER, DROP)
-- ���̺�(TABLE) : ������ �����
-- ���̵�      : ���� 10
-- �̸�       : ���� 20
-- ����       : ���� 30
-- ��ȭ��ȣ    : ���� 20
-- ����       : ��¥
-- ���       :���� 255
CREATE TABLE TBL_SAMPLE
(
    ID VARCHAR2(10)
    , NAME VARCHAR2(20)
    , AGE NUMBER(3)
    , BIRTH DATE
);

-- Table TBL_SAMPLE��(��) �����Ǿ����ϴ�.
SELECT *
FROM TABS
WHERE REGEXP_LIKE(TABLE_NAME,'^TBL_','i');
--WHERE TABLE_NAME LIKE 'TBL\_%' ESCAPE '\';
--
DESC TBL_SAMPLE;
-- ��ȭ��ȣ, ��� Į�� X -> ���̺� ����.
ALTER TABLE TBL_SAMPLE
ADD(
    TEL VARCHAR2(20) -- DEFAULT '000-0000-0000'
    ,BIGO VARCHAR2(255)
);
--
SELECT *
FROM TBL_SAMPLE;
-- ��� �÷��� ũ�� ����, �ڷ��� ����
--          (255->100)
ALTER TABLE TBL_SAMPLE
MODIFY (BIGO VARCHAR2(100));
DESC TBL_SAMPLE;

-- BIGO �÷��� -> MEMO �÷��� ����
-- ALTER TABLE X
SELECT bigo memo
FROM tbl_sample;
--
ALTER TABLE tbl_sample
    RENAME COLUMN bigo to memo;
    
-- memo �÷� ����
ALTER TABLE tbl_sample
DROP COLUMN memo;
-- ���̺� ����
DROP TABLE ���̺�� CASCADE;

-- ���̺���� ���� tbl_sample -> tbl_example
RENAME tbl_sample TO tbl_example;
-- ���̺��̸��� ����Ǿ����ϴ�.
--
SELECT *
FROM tbl_example;