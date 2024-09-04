-- SCOTT
-- [����1] emp ���̺��� job�� ���� ��ȸ?
SELECT COUNT(DISTINCT job)
FROM emp;

SELECT COUNT(*)
FROM(
    SELECT DISTINCT job
    FROM emp
)E;
-- [����2] emp ���̺��� �μ��� ����� ��ȸ?
SELECT 10 DEPTNO, COUNT(*)
FROM EMP
WHERE DEPTNO = 10
UNION ALL
SELECT 20, COUNT(*)
FROM EMP
WHERE DEPTNO = 20
UNION ALL
SELECT 30, COUNT(*)
FROM EMP
WHERE DEPTNO = 30
UNION ALL
SELECT 40, COUNT(*)
FROM EMP
WHERE DEPTNO = 40
UNION ALL
SELECT NULL, COUNT(*)
FROM EMP;
--
SELECT(SELECT COUNT(*) count FROM emp WHERE deptno = 10) deptno_10
     ,(SELECT COUNT(*) count FROM emp WHERE deptno = 20) deptno_20
     ,(SELECT COUNT(*) count FROM emp WHERE deptno = 30) deptno_30
     ,(SELECT COUNT(*) count FROM emp WHERE deptno = 40) deptno_40
     ,(SELECT COUNT(*) count FROM emp) total
FROM dual;
-- SELECT �� + 7��
SELECT deptno, count(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;
-- ���� ���� ) emp ���̺� �������� �ʴ� �μ��� ��ȸ. 40 0
SELECT COUNT(*)
    , COUNT(DECODE(deptno, 10, 1)) "10"
    , COUNT(DECODE(deptno, 20, 1)) "20"
    , COUNT(DECODE(deptno, 30, 1)) "30"
    , COUNT(DECODE(deptno, 40, 1)) "40"
FROM emp;
--
SELECT COUNT(CASE WHEN (DEPTNO = 10) THEN 1 END) AS "DEPTNO 10",
       COUNT(CASE WHEN (DEPTNO = 20) THEN 1 END) AS "DEPTNO 20",
       COUNT(CASE WHEN (DEPTNO = 30) THEN 1 END) AS "DEPTNO 30",  
       COUNT(CASE WHEN (DEPTNO = 40) THEN 1 END) AS "DEPTNO 40",  
       COUNT(*) AS "DEPTNO TOT"       
FROM emp;

-- [����] insa ���̺��� �ѻ����, ���ڻ����, ���ڻ���� ��ȸ
-- DECODE() + COUNT()
SELECT COUNT(DECODE(GENDER,'����',1))"���ڻ����"
      ,COUNT(DECODE(GENDER,'����',1))"���ڻ����"
      ,COUNT(*)"��ü�����"
FROM (
    SELECT NAME, SSN
        ,DECODE( SUBSTR(SSN, 8,1), 1, '����',2,'����') GENDER 
    FROM INSA
);
-- GROUP BY ��
--SELECT '��ü�����', COUNT(*)"�����"
--FROM insa
--UNION ALL
SELECT GENDER, COUNT(*)"�����"
FROM (
    SELECT NAME, SSN
--        ,DECODE( SUBSTR(SSN, 8,1), 1, '����',2,'����') GENDER   -- DECODE ��
        ,CASE  WHEN SUBSTR(SSN, 8,1) = 1 THEN '����'      -- CASE ��
               WHEN SUBSTR(SSN, 8,1) = 2 THEN '����'
               ELSE '��ü'
         END GENDER
    FROM INSA
)
GROUP BY ROLLUP (GENDER);

-- ROLLUP
SELECT CASE MOD(SUBSTR(ssn,-7,1),2)
            WHEN 1 THEN '����'
            WHEN 0 THEN '����'
            ELSE '����'
        END GENDER
        ,COUNT(*)
FROM insa
GROUP BY ROLLUP (MOD(SUBSTR(ssn,-7,1),2));

-- [����] emp ���̺��� ���� �޿�(pay)�� ���� �޴� ����� ������ ��ȸ
SELECT *
FROM emp
WHERE sal + NVL(comm,0) = (
    SELECT MAX(sal + NVL(comm,0)) MAX_PAY
    FROM EMP
);
-- SQL ������ : ALL, SOME, ANY, EXISTS
SELECT *
FROM emp
WHERE sal + NVL(comm,0) >= ALL(SELECT sal + NVL(comm,0) FROM EMP);
-- [����] emp ���̺��� ���� �޿�(pay)�� ���� �޴� ����� ������ ��ȸ
SELECT *
FROM emp
WHERE sal + NVL(comm,0) <= ALL(SELECT sal + NVL(comm,0) FROM EMP);
-- [����] emp ���̺��� �� �μ��� �ְ� �޿��� �޴� ����� ������ ��ȸ.
SELECT DEPTNO, MAX(sal + NVL(comm,0)) MAX_PAY, MIN(sal + NVL(comm,0)) MIN_PAY
FROM emp
GROUP BY DEPTNO
ORDER BY DEPTNO;
--
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = ANY(
                            SELECT MAX(sal+NVL(comm,0))
                            FROM emp
                            GROUP BY deptno
                            );
--
SELECT *
FROM emp m
WHERE sal+NVL(comm,0) = (-- �� �ش� �μ��� ���� ū�� PAY
                            SELECT MAX(sal+NVL(comm,0))
                            FROM emp
                            WHERE deptno = m.deptno
                        );
-- [����] emp ���̺��� pay ���� ���
SELECT m.*
    , ( SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal ) RANK
    , ( SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
FROM emp m
ORDER BY deptno, dept_rank;

--
SELECT *
FROM(
    SELECT m.*
        , ( SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal ) RANK
        , ( SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
    FROM emp m
)t
WHERE t.dept_rank < 3
ORDER BY deptno, dept_rank;

-- [����] insa ���̺��� �μ��� �ο����� 10�� �̻��� �μ��� ��ȸ
SELECT *
FROM(
    SELECT I.buseo, COUNT(*) cnt
    FROM insa I
    GROUP BY buseo
)t
WHERE cnt >= 10;
--
SELECT I.buseo, COUNT(*) CNT
FROM insa I
GROUP BY buseo
HAVING COUNT(*) >= 10;

-- [����] insa ���̺��� ���ڻ������ 5�� �̻��� �μ� ���� ��ȸ
--SELECT buseo, COUNT(*)
--FROM insa
--GROUP BY buseo
--HAVING COUNT(*) >= 5;

SELECT buseo, COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����'))"���ڻ����"
FROM insa
GROUP BY buseo
HAVING COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����'))>=5;
--
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0
GROUP BY buseo
HAVING COUNT(*)>=5;

-- [����] emp ���̺��� ��� ��ü ��� �޿��� ����� ��
--       �� ������� �޿��� ��� �޿����� ���� ��� "����" ���
--                                  ���� ��� "����" ���
SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp;
--
SELECT empno, ename,pay,ROUND(avg_pay,2) avg_pay
    , CASE WHEN pay > avg_pay THEN '����'
           WHEN pay < avg_pay THEN '����'
           ELSE '����'
    END ASDF
FROM(
    SELECT e.*
        ,sal+NVL(comm,0) pay
        ,(SELECT AVG(sal+NVL(comm,0)) avg_pay FROM emp) avg_pay
    FROM emp e
)ee;
-- UNION Ȱ��
SELECT s.*,  '����'
FROM emp s
WHERE sal + NVL(comm,0 ) > (SELECT AVG( sal + NVL(comm,0 )) avg_pay
                            FROM emp)
UNION                            
SELECT s.*,  '����'
FROM emp s
WHERE sal + NVL(comm,0 ) < (SELECT AVG( sal + NVL(comm,0 )) avg_pay
                            FROM emp);

-- NULLIF Ȱ��
SELECT ename, pay, avg_pay
     , NVL2( NULLIF( SIGN( pay - avg_pay ), 1 ), '����' , '����') 
FROM (
        SELECT ename, sal+NVL(comm,0) pay 
            , (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) avg_pay
        FROM emp
      );

-- [����] emp ���̺��� �޿� max, min ��� ���� ��ȸ
SELECT *
FROM(
    SELECT E.*
        , sal+NVL(comm,0) PAY
        ,(SELECT MAX(sal+NVL(comm,0)) FROM emp) MAX_PAY
        ,(SELECT MIN(sal+NVL(comm,0)) FROM emp) MIN_PAY
    FROM EMP E
)
WHERE PAY = MAX_PAY OR PAY = MIN_PAY
ORDER BY PAY DESC;
--
SELECT MAX(sal), MIN(sal)
FROM emp;
--
SELECT ename, job, hiredate, sal
    , CASE sal
        WHEN 5000 THEN 'MAX'
        WHEN 800 THEN 'MIN'
      END
FROM emp
WHERE sal IN ((SELECT MAX(sal) FROM emp),(SELECT MIN(sal) FROM emp));
-- WHERE sal IN (SELECT MAX(sal), MIN(sal) FROM emp); -- ORA-00913: too many values
-- WHERE sal IN (5000,800);

-- [����] insa
--       ���� ��� �� �μ��� ����,���� �����,
--                        ���� �޿��հ�, ���� �޿��հ� ��ȸ
SELECT BUSEO
    , COUNT(CASE GENDER WHEN '����' THEN 1 END) "�����ο���"
    , COUNT(CASE GENDER WHEN '����' THEN 1 END) "�����ο���"
    , COUNT(*) "���ο���"
    , SUM(CASE GENDER WHEN '����' THEN TOTPAY END) "���ڱ޿��հ�"
    , SUM(CASE GENDER WHEN '����' THEN TOTPAY END) "���ڱ޿��հ�"
    , SUM(TOTPAY) "�ѱ޿��հ�"
FROM(
    SELECT INSA.*
        , CASE TO_NUMBER(SUBSTR(SSN,-7,1)) WHEN 1 THEN '����'
                                           WHEN 2 THEN '����'
          END AS GENDER
        , BASICPAY+SUDANG "TOTPAY"
    FROM insa
    WHERE CITY = '����'
)I
GROUP BY BUSEO;
--
SELECT buseo, jikwi, COUNT(*), SUM(basicpay), AVG(basicpay)
FROM insa
GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo, jikwi;
--
SELECT buseo
    , DECODE(MOD(SUBSTR(ssn, -7 , 1),2),0,'����','����') GENDER
    , COUNT(*) "�����"
    , SUM(basicpay) "�ѱ޿���"
FROM insa
WHERE city = '����'
GROUP BY buseo, MOD(SUBSTR(ssn, -7 , 1),2)
ORDER BY buseo, MOD(SUBSTR(ssn, -7 , 1),2);

-- ROWNUM , ROWID �ǻ�Į��(pseudo column) ����Ŭ���� ���������� ���Ǵ� �÷�
DESC emp;
SELECT ROWNUM , ROWID, ename, hiredate, job
FROM emp;

-- �� TOP-N �м� ��
--SELECT �÷���,..., ROWNUM
--FROM(
--    SELECT �÷���,... from ���̺��
--    ORDER BY top_n_�÷���
--    )
--WHERE ROWNUM <= n;
--
SELECT ROWNUM, E.*
FROM (
    SELECT *
    FROM emp
    ORDER BY sal DESC
)E
WHERE ROWNUM <= 5;
-- WHERE ROWNUM >= 3 AND ROWNUM <= 5; TOP-N ����� BETWEEN ���� �Ұ���
-- ����ϱ� ���ؼ��� �Ʒ��� ���� ROWNUM�� ��Ī�� �ο��ϰ� �ζ��κ並 �ۼ��ϸ� ����
SELECT *
FROM(
    SELECT ROWNUM seq, E.*
    FROM (
        SELECT *
        FROM emp
        ORDER BY sal DESC
    )E
)
WHERE seq BETWEEN 3 AND 5;

-- ORDER BY ���� �ִ� �������� ROWNUM ������� �ʵ��� ����
SELECT ROWNUM, emp.*
FROM emp
ORDER BY sal DESC;

-- ROLLUP/CUBE ����
-- 1) ROLLUP : �׷�ȭ�ϰ� �׷쿡 ���� �κ���
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT dname, job, COUNT(*)
FROM emp e , dept d
WHERE e.deptno = d.deptno
--GROUP BY dname, job
--ORDER BY dname ASC;
GROUP BY ROLLUP (dname, job)
ORDER BY dname ASC;

-- 2) CUBE : ROLLUP ����� GROUP BY ���� ���ǿ� ���� ��� ������ �׷��� ����
--           �� ���� ��� ���.    2*N=4
SELECT dname, job, COUNT(*)
FROM emp e , dept d
WHERE e.deptno = d.deptno
GROUP BY CUBE (dname, job)
ORDER BY dname ASC;

-- [ ����(RANK) �Լ� ]
SELECT ename, sal, sal+NVL(comm,0) pay
    ,RANK()OVER(ORDER BY sal+NVL(comm,0) DESC) "RANK"
    ,DENSE_RANK()OVER(ORDER BY sal+NVL(comm,0) DESC) "DENSE_RANK"
    ,ROW_NUMBER()OVER(ORDER BY sal+NVL(comm,0) DESC) "ROW_NUMBER"
FROM emp;

-- JONES 2975->2850
SELECT *
FROM emp
WHERE ename LIKE '%JONES%';

UPDATE emp
SET sal = 2850
WHERE ename = 'JONES';
-- JONES�� �ߺ��Ǹ� ���� �ǵ�ġ �ʰ� ����� �� �ֱ� ������ ���� ���� ���� ����

-- ���� �Լ� ��� ����
-- emp ���̺��� �μ����� �޿� ������ �ű��.
SELECT *
FROM(
    SELECT emp.*
        ,RANK()OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) �μ�������
        ,RANK()OVER(ORDER BY sal+NVL(comm,0) DESC) ��ü����
    FROM emp
)
WHERE �μ������� BETWEEN 2 AND 3;
--WHERE ���� = 1;

-- insa ���̺� ������� 14�� ���� ����
SELECT CEIL(COUNT(*)/14) TEAM
FROM insa I;
-- [����] insa ���̺��� ������� ���� ���� �μ��� �μ���, ������� ��ȸ
SELECT BUSEO, �����
FROM(
    SELECT BUSEO,COUNT(*) �����, RANK()OVER(ORDER BY COUNT(*) DESC) �ο�����
    FROM INSA
    GROUP BY BUSEO
)
WHERE �ο����� = 1;

-- [����] ���� �ο����� ���� ���� �μ� �� �ο��� ���
SELECT BUSEO, �������ο���
FROM(
    SELECT BUSEO, COUNT(*)�������ο���, RANK()OVER(ORDER BY COUNT(*) DESC) ������������
    FROM(
        SELECT I.*, DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'����',0,'����')GENDER
        FROM INSA I
    )
    WHERE GENDER = '����'
    GROUP BY BUSEO
)
WHERE ������������ = 1;

-- [����] insa ���̺��� basicpay(�⺻��)�� ���� 10%�� ��� (�̸� ,�⺻��)
SELECT name, basicpay, ����
FROM(
    SELECT name, basicpay, (SELECT COUNT(*) FROM insa) cnt
        , RANK()OVER(ORDER BY basicpay DESC) ����
    FROM insa
)I
WHERE ���� <= cnt*0.1;
--
SELECT *
FROM(
    SELECT name, basicpay
        , PERCENT_RANK()OVER(ORDER BY basicpay DESC) PR
    FROM insa
)
WHERE PR <= 0.1;





