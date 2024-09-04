-- SCOTT
-- [����1]
SELECT TMP, (SELECT AVG(TMP) FROM DUAL) AVG_TMP
    , CEIL((TMP-(SELECT AVG(TMP) FROM DUAL)*100))/100
FROM(
SELECT '12345.67' TMP FROM DUAL
);

SELECT ENAME, PAY, AVG_PAY
    , CEIL(PAY - AVG_PAY) "�� �ø�"
    , ROUND(PAY - AVG_PAY,3) "�� �ݿø�"
    , TRUNC(PAY - AVG_PAY,3) "�� ����"
FROM(
SELECT ename, sal+NVL(COMM,0) PAY
    ,(SELECT AVG(sal+NVL(COMM,0)) FROM emp) AVG_PAY
FROM emp
);

--  [����2] EMP ���̺���
--      PAY, AVG_PAY    ��,��,����
SELECT ename, PAY, AVG_PAY
    , CASE WHEN PAY > AVG_PAY THEN '����'
           WHEN PAY < AVG_PAY THEN '����'
           ELSE '����'
    END "��,��,����"
FROM(
SELECT ename, sal+NVL(COMM,0) PAY
    ,(SELECT AVG(sal+NVL(COMM,0)) FROM emp) AVG_PAY
FROM emp
);

-- [����3] insa ���̺��� ssn �ֹε�Ϲ�ȣ, ������ ���� �������� ���� ���
SELECT A.NAME, A.SSN, A.TODAY, CASE  WHEN A.TODAY > A.birth THEN '������'
                      WHEN A.TODAY < A.birth THEN '����'
                      ELSE '���û���'
                      END AS "������������"
FROM(
SELECT I.*, SUBSTR(I.SSN,3,4) BIRTH,(SELECT TO_CHAR(SYSDATE, 'MMDD') FROM DUAL) TODAY
FROM insa I ,DUAL D
)A ;

SELECT *
FROM INSA
WHERE NUM = 1002;

UPDATE INSA
SET SSN = SUBSTR(SSN,0,2)||TO_CHAR(SYSDATE,'MMDD')||SUBSTR(SSN,7)
WHERE NUM = 1002;
COMMIT;

-- [����] INSA ���̺��� �ֹε�Ϲ�ȣ(SSN) �����̸� ����ؼ� ���
-- ����(1,2) 1900 (3,4) 2000  (0,9) 1800
-- ������ = ���ϳ⵵ 2024-1998 -1(������������)
-- NAME, SSN, ����⵵, ���س⵵, ������
SELECT t.name, t.ssn, ����⵵, ���س⵵
    , ���س⵵ - ����⵵  + CASE bs
                               WHEN -1 THEN  -1                               
                               ELSE 0
                          END  ������
FROM (
        SELECT name, ssn
         , TO_CHAR( SYSDATE , 'YYYY' ) ���س⵵
         , SUBSTR( ssn, -7, 1) ����
         , SUBSTR( ssn, 0, 2) ���2�ڸ��⵵
         , CASE 
             WHEN SUBSTR( ssn, -7, 1) IN ( 1,2,5,6) THEN 1900
             WHEN SUBSTR( ssn, -7, 1) IN ( 3,4,7,8) THEN 2000
             ELSE 1800
           END +  SUBSTR( ssn, 0, 2) ����⵵
           -- 0, -1 ����������..
           -- 1      ���� ��꿡��    -1
         , SIGN( TO_DATE( SUBSTR( ssn, 3, 4 ) , 'MMDD' )  - TRUNC( SYSDATE ) )  bs 
        FROM insa
) t;

SELECT NAME, SSN, ����⵵,�������, ���س⵵,���ÿ���
    , ���س⵵ - ����⵵ + CASE WHEN ���ÿ��� - ������� > 0 THEN +0
                            ELSE +1
                         END AS ������
FROM(
    SELECT NAME,SSN
        ,CASE WHEN SUBSTR(SSN,0,2) < 100 THEN SUBSTR(SSN,0,2)+1900
              ELSE SUBSTR(SSN,0,2)+2000
              END AS ����⵵
        ,TO_CHAR(SYSDATE, 'YYYY') ���س⵵
        , SUBSTR(SSN,3,4) �������
        ,TO_CHAR(SYSDATE, 'MMDD') ���ÿ���
    FROM INSA
);

-- Math.random() �����Ǽ�
-- Random Ŭ���� nextInt() �����Ǽ�
-- DBMS_RANDOM ��Ű��
-- �ڹ� ��Ű�� - ���� ���õ� Ŭ�������� ����
-- ����Ŭ ��Ű�� - ���� ���õ� Ÿ��, ���α׷� ��ü, �������α׷�(procedure, function)
-- 0.0<= SYS.dbms_random.value < 1.0
SELECT
    SYS.dbms_random.value
--    , SYS.dbms_random.value(0,100) -- 0.0 <=�Ǽ� <100.0
--    ,SYS.dbms_random.STRING('U',5)
--    ,SYS.dbms_random.STRING('L',5)
--    ,SYS.dbms_random.STRING('X',5) -- �빮�� + ����
    ,SYS.dbms_random.STRING('P',5) -- �빮�� + �ҹ��� + ���� + Ư������
    ,SYS.dbms_random.STRING('A',5) -- ���ĺ�
FROM DUAL;

-- [����] ������ ���� ���� 1�� ���
SELECT ROUND(SYS.dbms_random.value(0,100)) ��������
      ,CEIL(SYS.dbms_random.value(0,100)) ��������
      ,TRUNC(SYS.dbms_random.value(0,101)) ��������
FROM DUAL;
-- [����] ������ �ζ� ��ȣ 1�� ���
SELECT CEIL(SYS.dbms_random.value(1,45)) �ζǹ�ȣ
FROM DUAL;
-- [����] ������ ���� 6�ڸ��� �߻����Ѽ� ���
SELECT TRUNC(SYS.dbms_random.value(100000,1000000)) ������6�ڸ���ȣ
FROM DUAL;

-- [����] insa���̺��� ���ڻ����, ���ڻ���� ���
SELECT GENDER, COUNT(*) �����
FROM(
SELECT i.*, DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'����','����') GENDER
FROM insa i
)
GROUP BY GENDER
ORDER BY GENDER;

-- [����] insa���̺��� �μ��� ���ڻ����, ���ڻ���� ���
-- 1) SET OPERATOR ���
SELECT '���ڻ����' "����", COUNT(*) "�����"
FROM insa
WHERE MOD( SUBSTR(ssn, 8, 1 ), 2 ) = 1
UNION ALL
SELECT '���ڻ����' "����", COUNT(*) "�����"
FROM insa
WHERE MOD( SUBSTR(ssn, 8, 1 ), 2 ) = 0;
-- 2) GROUP BY ���
SELECT BUSEO, GENDER, COUNT(*) �����
FROM(
SELECT i.*, DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'����','����') GENDER
FROM insa i
)
GROUP BY BUSEO, GENDER
ORDER BY BUSEO, GENDER;

-- [����] emp ���̺��� �ְ� �޿���, ���� �޿��� ������� ��ȸ
SELECT *
FROM(
SELECT E.*
    ,(SELECT MAX(SAL) FROM EMP) MAX_SAL
    ,(SELECT MIN(SAL) FROM EMP) MIN_SAL
FROM EMP E
)
WHERE SAL IN (MAX_SAL , MIN_SAL);
-- [����] emp ���̺��� �� �μ��� �ְ� �޿���, ���� �޿��� ������� ��ȸ
SELECT *
FROM emp m
WHERE sal IN ( (SELECT MAX(sal)  FROM emp WHERE deptno=m.deptno)
             , (SELECT MIN(sal)  FROM emp WHERE deptno=m.deptno))
ORDER BY deptno, sal DESC;

SELECT E.*,'�ְ�' �ְ������޿���
FROM EMP E
WHERE (DEPTNO,SAL) IN (SELECT DEPTNO, MAX(SAL) FROM EMP GROUP BY DEPTNO)
UNION
SELECT E.*,'����'
FROM EMP E
WHERE (DEPTNO,SAL) IN (SELECT DEPTNO, MIN(SAL) FROM EMP GROUP BY DEPTNO);

-- ���� �Լ�
SELECT *
FROM (
SELECT emp.*
    , RANK()OVER(PARTITION BY deptno ORDER BY sal DESC) r
    , RANK()OVER(PARTITION BY deptno ORDER BY sal ASC) r2
FROM emp
) t
WHERE t.r = 1 or t.r2 = 1
ORDER BY deptno;

-- [����] emp ���̺��� comm�� 400������ ����� ���� ��ȸ
--       (���� comm�� NULL�� ����� ����)

SELECT *
FROM emp
-- LNNVL() �Լ� WHERE ������ ��/UNKNOWN -> FALSE
WHERE LNNVL( comm > 400 ); -- NULL
--WHERE NVL(comm,0) <= 400;
--WHERE comm <=400 or comm = NULL;

-- [����] �̹� ���� ������ ��¥�� �� �� ���� �ִ��� Ȯ���ϴ� ����...
SELECT SYSDATE TODAY
      ,TO_CHAR(LAST_DAY(SYSDATE),'DD') "���1"
      ,TRUNC(SYSDATE, 'MONTH') "���2.1" -- 24/08/01 
      ,ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1) - 1 "���2.2"
      ,TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1) - 1,'DD') "���2.3"
FROM DUAL;

-- [����] emp���̺��� sal�� ���� 20%�� �ش�Ǵ� ����� ���� ��ȸ
SELECT *
FROM(
    SELECT E.*,PERCENT_RANK()OVER(ORDER BY SAL DESC) "����"
    FROM emp E
)
WHERE ���� <=0.2;

--[����] ���� �� �������� �ް��Դϴ�. (��¥ ��ȸ)
SELECT TO_CHAR(SYSDATE,'DS TS(DY)') ����
    ,NEXT_DAY(SYSDATE, '��') �����ֿ�
FROM DUAL;

-- [����] emp ���̺��� �� ������� �Ի����ڸ� �������� 10�� 5���� 20��° �Ǵ�
-- ��¥ ���
SELECT ENAME, ADD_MONTHS(HIREDATE, 10*12+5)+ 20 HIREDATE 
FROM EMP;

--insa ���̺��� 
--[������]
--                                           �μ������/��ü����� == ��/�� ����
--                                           �μ��� �ش缺�������/��ü����� == �μ�/��%
--                                           �μ��� �ش缺�������/�μ������ == ��/��%
--                                           
--�μ���     �ѻ���� �μ������ ����  ���������  ��/��%   �μ�/��%   ��/��%
--���ߺ�       60       14     F       8     23.3%     13.3%   57.1%
--���ߺ�       60       14     M       6     23.3%       10%   42.9%
--��ȹ��       60       7      F       3     11.7%        5%   42.9%
--��ȹ��       60       7      M       4     11.7%      6.7%   57.1%
--������       60       16     F       8     26.7%     13.3%     50%
--������       60       16     M       8     26.7%     13.3%     50%
--�λ��       60       4      M       4      6.7%      6.7%    100%
--�����       60       6      F       4       10%      6.7%   66.7%
--�����       60       6      M       2       10%      3.3%   33.3%
--�ѹ���       60       7      F       3     11.7%        5%   42.9%
--�ѹ���       60       7      M       4     11.7%      6.7%   57.1%
--ȫ����       60       6      F       3       10%        5%     50%
--ȫ����       60       6      M     

--
SELECT �μ���, �ѻ����, �μ������, ����,  ���������
  ,ROUND(   �μ������/�ѻ����*100, 2) || '%' "��/��%"
  ,ROUND(   ���������/�ѻ����*100, 2) || '%' "�μ�/��%"
  ,ROUND(   ���������/�μ������*100, 2) || '%'  "��/��%"
FROM(
SELECT BUSEO AS �μ���
    ,(SELECT COUNT(*) FROM INSA) �ѻ����
    ,(SELECT COUNT(*) FROM INSA WHERE BUSEO = T.BUSEO) �μ������
    ,GENDER ����
    ,COUNT(*) ���������
FROM(
    SELECT BUSEO, NAME, SSN
        ,DECODE( MOD (SUBSTR(SSN,-7,1),2),1,'M','F' )GENDER
    FROM INSA
) T
GROUP BY BUSEO,GENDER
ORDER BY BUSEO,GENDER
);

--LISTAGG() ****�ϱ�
SELECT EMPNO, ENAME, JOB,DEPTNO
FROM EMP;
--
SELECT DEPTNO, LISTAGG(ENAME , ' , ') WITHIN GROUP(ORDER BY ENAME ASC) AS ENAME 
FROM EMP;
--
SELECT DEPTNO, LISTAGG(ENAME , ' , ') WITHIN GROUP(ORDER BY ENAME ASC) AS ENAME 
FROM EMP 
GROUP BY DEPTNO;
-- [ INSA ���̺��� TOP-N �м��������
-- �޿� ���� �޴� TOP-10 ��ȸ(���)
-- 1) �޿� ������ ORDER BY ����
-- 2) ROWNUM �ǻ��÷� - ����
-- 3) ������ 1~10�� SELECT
SELECT ROWNUM ����, A.*
FROM(
SELECT I.*, RANK()OVER(ORDER BY BASICPAY+SUDANG DESC) �޿�����
FROM INSA I
)A
WHERE �޿����� <= 10;

-- [����]
SELECT TRUNC(SYSDATE,'YEAR')    -- YEAR
      ,TRUNC(SYSDATE,'MONTH')   -- MONTH
      ,TRUNC(SYSDATE,'DD')      -- DAY ���� 11
      ,TRUNC(SYSDATE)           -- �ð�,��,�� ����
FROM DUAL;

-- [����]
--    [������]
--    DEPTNO        ENAME       PAY     BAR_LENGTH      
--    ---------- ---------- ---------- ----------
--    30            BLAKE       2850        29      #############################
--    30            MARTIN      2650        27      ###########################
--    30            ALLEN       1900        19      ###################
--    30            WARD        1750        18      ##################
--    30            TURNER      1500        15      ###############
--    30            JAMES       950         10      ##########

SELECT DEPTNO
    ,ENAME
    , SAL+NVL(COMM,0) PAY
    , ROUND(SAL+NVL(COMM,0),-2)/100 BAR_LENGTH
    , LPAD(' ',ROUND(SAL+NVL(COMM,0),-2)/100,'#') GRAPH
FROM EMP
WHERE DEPTNO=30
ORDER BY SAL+NVL(COMM,0) DESC;

--  WW / IW / W ������ �ľ�
SELECT TO_CHAR(HIREDATE)
    ,TO_CHAR(HIREDATE,'WW')     -- ���� �� ��° ��
    ,TO_CHAR(HIREDATE,'IW')     -- ���� �� ��° ��
    ,TO_CHAR(HIREDATE,'W')      -- ���� �� ��° ��
FROM EMP;

SELECT TO_CHAR(TO_DATE('2022.01.01'),'IW') A
    , TO_CHAR(TO_DATE('2022.01.02'),'IW') B
    , TO_CHAR(TO_DATE('2022.01.03'),'IW') C
    , TO_CHAR(TO_DATE('2022.01.04'),'IW') D
    , TO_CHAR(TO_DATE('2022.01.05'),'IW') E
    , TO_CHAR(TO_DATE('2022.01.06'),'IW') F
    , TO_CHAR(TO_DATE('2022.01.07'),'IW') G
    , TO_CHAR(TO_DATE('2022.01.08'),'IW') H
FROM DUAL;

SELECT TO_CHAR(TO_DATE('2022.01.01'),'WW') A
    , TO_CHAR(TO_DATE('2022.01.02'),'WW') B
    , TO_CHAR(TO_DATE('2022.01.03'),'WW') C
    , TO_CHAR(TO_DATE('2022.01.04'),'WW') D
    , TO_CHAR(TO_DATE('2022.01.05'),'WW') E
    , TO_CHAR(TO_DATE('2022.01.06'),'WW') F
    , TO_CHAR(TO_DATE('2022.01.07'),'WW') G
    , TO_CHAR(TO_DATE('2022.01.08'),'WW') H
FROM DUAL;

-- [����] EMP ���̺���
-- ������� ���� ���� �μ���(DNAME), �����
-- ������� ���� ���� �μ���, �����
-- ���... (JOIN)
SELECT D.DEPTNO, DNAME, COUNT(EMPNO) �����
-- FROM EMP E INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
--FROM EMP E RIGHT OUTER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
FROM DEPT D LEFT OUTER JOIN EMP E ON E.DEPTNO = D.DEPTNO
GROUP BY D.DEPTNO, DNAME
ORDER BY D.DEPTNO;
--
SELECT *
FROM(
    SELECT D.DEPTNO, DNAME, COUNT(EMPNO) CNT
        ,RANK()OVER(ORDER BY COUNT(EMPNO) DESC) CNT_RANK
    FROM DEPT D LEFT OUTER JOIN EMP E ON E.DEPTNO = D.DEPTNO
    GROUP BY D.DEPTNO, DNAME
    ORDER BY CNT_RANK ASC
)T
SELECT *
FROM TEMP
WHERE TEMP.CNT_RANK IN (
                (SELECT MAX(TEMP.CNT_RANK) FROM TEMP)
              , (SELECT MIN(TEMP.CNT_RANK) FROM TEMP)
      );
-- WITH( �� ����(�ϱ�)
WITH a AS(
        SELECT D.DEPTNO, DNAME, COUNT(EMPNO) CNT
        ,RANK()OVER(ORDER BY COUNT(EMPNO) DESC) CNT_RANK
        FROM DEPT D LEFT OUTER JOIN EMP E ON E.DEPTNO = D.DEPTNO
        GROUP BY D.DEPTNO, DNAME
    )
    , B AS(
    SELECT MAX(CNT) MAXCNT, MIN(CNT) MINCNT
    FROM A
    )
SELECT A.DEPTNO, A.DNAME, A.CNT, A.CNT_RANK
FROM A,B
WHERE A.CNT IN (B.MAXCNT,B.MINCNT);

-- �Ǻ�(PIVOT) / ���Ǻ�(UNPIVOT) (�ϱ�)
-- https://blog.naver.com/gurrms95/222697767118

-- JOB�� ������� ���
SELECT
    COUNT(DECODE(JOB, 'CLERK', 'O')) CLERK
    ,COUNT(DECODE(JOB, 'SALESMAN', 'O')) SALESMAN
    ,COUNT(DECODE(JOB, 'PRESIDENT', 'O')) PRESIDENT
    ,COUNT(DECODE(JOB, 'MANAGER', 'O')) MANAGER
    ,COUNT(DECODE(JOB, 'ANALYST', 'O')) ANALYST
FROM EMP;
--
SELECT
FROM(�Ǻ� ��� ������)
PIVOT(�׷��Լ�(�����÷�)) FOR �ǹ��÷� IN ( �ǹ��÷� AS ��Ī...);

-- ���� �߽����� ȸ����Ű�� == PIVOT
SELECT *
FROM (
    SELECT JOB
    FROM EMP
    )
PIVOT(
    COUNT(JOB)
    FOR JOB IN ( 'CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST')
);

-- 2) EMP ���̺���
-- �� ���� �Ի��� ��� �� ��ȸ.
-- ��� ����
-- 1�� 2�� 3�� 4�� .... 12��
--  2  0   5   0 ....  3       
SELECT TO_CHAR(HIREDATE,'YYYY') YEAR
      ,TO_CHAR(HIREDATE,'MM') MONTH
FROM EMP;
--
SELECT *
FROM (
    SELECT TO_CHAR(HIREDATE,'YYYY') YEAR
          ,TO_CHAR(HIREDATE,'MM') MONTH
    FROM EMP
    )
PIVOT(
    COUNT(MONTH)
    FOR MONTH IN('01' AS "1��",'02','03','04','05','06','07','08','09','10','11','12')
)
ORDER BY YEAR;

-- [����] EMP ���̺��� JOB�� ����� ��ȸ
SELECT *
FROM (
    SELECT JOB
    FROM EMP
    )
PIVOT(
    COUNT(JOB)
    FOR JOB IN ( 'CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST')
);
-- [����] EMP ���̺��� �μ���/JOB�� ����� ��ȸ
--    DEPTNO DNAME             'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
------------ -------------- ---------- ---------- ----------- ---------- ----------
--        10 ACCOUNTING              1          0           1          1          0
--        20 RESEARCH                1          0           0          1          1
--        30 SALES                   1          4           0          1          0
--        40 OPERATIONS              0          0           0          0          0
SELECT *
FROM( SELECT D.DEPTNO, D.DNAME, E.JOB
      FROM EMP E, DEPT D
      WHERE E.DEPTNO(+) = D.DEPTNO -- RIGHT OUTER JOIN
)
PIVOT(
    COUNT(JOB)
    FOR JOB IN('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST')
)
ORDER BY DEPTNO;
--�ǽ�����) �� �μ��� �� �޿����� ��ȸ
SELECT DEPTNO, SAL+NVL(COMM,0) PAY
FROM EMP;

SELECT *
FROM(
    SELECT DEPTNO, SAL+NVL(COMM,0) PAY
    FROM EMP)
PIVOT(
    SUM(PAY)
    FOR DEPTNO IN('10','20','30','40')
);

-- �ǽ�����
SELECT *
FROM(
SELECT JOB, DEPTNO,SAL, ENAME
FROM EMP
)
PIVOT(
    SUM(SAL) AS �հ�, MAX(SAL) AS �ְ��, MAX(ENAME) AS �ְ���
    FOR DEPTNO IN ('10','20','30','40')
);

-- �Ǻ� ����
-- ���� ���� ���  ���������  ����
--      20          30      1
SELECT *
FROM INSA;
SELECT *
FROM(
    SELECT SIGN(BIRTHDAY-TODAY) S
    FROM(
    SELECT SUBSTR(SSN,3,4) BIRTHDAY, TO_CHAR(SYSDATE,'MMDD') TODAY
    FROM INSA)
)
PIVOT(
    COUNT(S)
    FOR S IN ('1' AS "���Ͼ���",'0' AS "���û���",'-1' AS "��������")
);

-- �μ���ȣ 4�ڸ� ���
SELECT DEPTNO
    ,CONCAT('00',DEPTNO)
    ,TO_CHAR(DEPTNO,'0999')
    ,LPAD(DEPTNO,4,'0')
FROM DEPT;

-- (�ϱ�) insa���̺��� �� �μ���/���������/����� ������� ���(��ȸ)
SELECT BUSEO, CITY, COUNT(*) �����
FROM INSA
GROUP BY BUSEO,CITY
ORDER BY BUSEO,CITY;
--����Ŭ 10G ���� �߰��� ��� : PARTITION BY OUTER JOIN ���� ���

WITH C AS(
    SELECT DISTINCT CITY
    FROM INSA
)
SELECT BUSEO, C.CITY, COUNT(*) �����
FROM INSA I PARTITION BY(BUSEO) RIGHT OUTER JOIN C ON I.CITY = C.CITY
GROUP BY BUSEO, C.CITY
ORDER BY BUSEO, C.CITY;



