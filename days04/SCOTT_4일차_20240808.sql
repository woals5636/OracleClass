-- SCOTT
-- [����Ŭ ������(OPERATOR) ����]
-- 1) �� ������ : = != > < <= >=
--            WHERE ������ ����, ����, ��¥�� ���� �� ���
--            ANY, SOME, ALL �� ������, SQL ������ 
-- 2) �� ������ : AND, OR, NOT
--            WHERE ������ ������ ������ �� ���
-- 3) SQL ������ : SQL���� �����ϴ� ������
--            [NOT] IN (list)  
--            [NOT] BETWEEN a AND b
--            [NOT] LIKE 
--            IS [NOT] NULL 
--            ANY, SOME, ALL                    WHERE �� + (��������)
--            EXISTS   -> TRUE/FALSE �� ��ȯ     WHERE �� + (��������)
-- 4) NULL ������ 
-- 5) ��� ������ : ����, ����, ����, ������    (������ �켱 ���� ����)
-- SELECT 5-3,5-3,5*3,5/3
--    ,FLOOR(5/3) --��
--    ,MOD(5,3)   --������
-- FROM DUAL;
-- 6) SET(����) ������
--  1. UNION        : ������
--  2. UNION ALL    : ������
-- ORA-00937: not a single-group group function
SELECT COUNT(*)
FROM(
    SELECT name, city, buseo
    FROM insa
    WHERE buseo = '���ߺ�'
) I;
--
SELECT COUNT(*)
FROM(
    SELECT name, city, buseo
    FROM insa
    WHERE CITY = '��õ'
) I;
--
SELECT COUNT(*)
FROM(
    SELECT name, city, buseo
    FROM insa
    WHERE CITY = '��õ' AND buseo = '���ߺ�'
) I;
-- ���ߺ� + ��õ     ������� ������
SELECT name, city, buseo
FROM insa
WHERE CITY = '��õ'
  -- ORA-00933: SQL command not properly ended
-- UNION    -- �ߺ����� �ʰ�
UNION ALL   -- �ߺ� ���
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
ORDER BY BUSEO;     -- UNION ���� �ι�° SELECT ��(������)���� ORDER BY ���� ����� �� �ִ�.
--
SELECT ename, hiredate, TO_CHAR(deptno)deptno
FROM emp
UNION
SELECT name, ibsadate, buseo
FROM insa;
-- ����(JOIN)
-- ����̸�, �����, �Ի�����, �μ��� ��ȸ
-- EMP  : ����̸�, �����, �Ի�����
-- DEPT : �μ���
SELECT ename, hiredate, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
--
SELECT * FROM EMP;
SELECT * FROM dept;
-- ORA-00918: column ambiguously defined
SELECT empno, ename, hiredate, dname, dept.deptno
FROM emp, dept                      -- ����
WHERE emp.deptno = dept.deptno;     -- ���� ����
-- Alias ����
SELECT empno, ename, hiredate, dname, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;
--
SELECT empno, ename, hiredate, dname, d.deptno
FROM emp e JOIN dept d ON e.deptno = d.deptno;

-- ������̺�(�ڽ����̺�)
-- �����ȣ/�����/�Ի�����/��/�⺻��/����/�μ���ȣ(FK) 
--   1    a                          10       
--   2    b                          10       
--   3    c                          10       
--    
-- �μ����̺�(�θ����̺�)
-- PK
-- �μ���ȣ/�μ���/�μ���/�μ�������ȣ
-- 10      ����  �����  103
-- 20      ����  �̽���  102
-- 30 
-- 40


--  3. INTERSECT    : ������
-- ���ߺ� + ��õ     ������� ������
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE CITY = '��õ'
ORDER BY BUSEO;

--  4. MINUS        : ������
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
MINUS
SELECT name, city, buseo
FROM insa
WHERE CITY = '��õ'
ORDER BY BUSEO;

-- 
SELECT name, NULL city, buseo
-- Į������ �ٸ� ���״� ������ NULL �ڷ����� �߰��Ͽ� UNION ���� ����
FROM insa
WHERE buseo = '���ߺ�'
UNION
SELECT name, city, buseo
FROM insa
WHERE CITY = '��õ'
ORDER BY BUSEO;

-- [ ������ ���� ������ ] PRIOR, CONNECT_BY_ROOT ������

-- IS [NOT] NAN : IS [NOT] NOT A NUMBER ���� ����
-- IS [NOT] INFINITE : ���Ѵ� ����

--[����Ŭ �Լ�(function)]
--1) ������ �Լ�
--        ��. ���� �Լ�
--          [UPPER] [LOWER] [INITCAP]
SELECT UPPER(dname), LOWER(dname), INITCAP(dname)
FROM dept;
--          [LENGTH] ���ڿ� ����
SELECT dname
    ,LENGTH(dname)
FROM dept;
--          [CONCAT] ù��° ���ڿ��� �ι�° ���ڿ��� �����Ͽ� ����
--          [SUBSTR] ���ڰ� �� Ư�� ��ġ���� Ư�� ���̸�ŭ�� ���ڰ����� ����
SELECT ssn, SUBSTR(ssn,-7)
FROM insa;
--          [INSTR] ���ڰ� �� ������ ���ڰ��� ��ġ�� ���ڷ� ����
--�����ġ�
--     {INSTR ? INSTRB ? INSTRC ? INSTR2 ? INSTR4} 
--        ( string, substring [, ������ [,���°] ] )
--    TBL_TEL ���̺�
--   SEQ        TEL
--    1 	02)123-1234
--    2	    051)3456-2342
--    3	    031)1256-2343

SELECT TEL
    ,INSTR(tel,')') ")"
    ,INSTR(tel,'-') "-"
    ,LENGTH(tel) LEN
    -- ���� 1) ������ȣ�� �����Ͽ� ���
    ,SUBSTR(TEL,0,INSTR(tel,')')-1) "������ȣ"
    -- ���� 2) ��ȭ��ȣ�� ���ڸ�(3,4�ڸ�)
    ,SUBSTR(TEL,INSTR(tel,')')+1,INSTR(tel,'-')-INSTR(tel,')')-1) "���ڸ�"
    -- ���� 3) ��ȭ��ȣ�� ���ڸ�(4�ڸ�)
    ,SUBSTR(TEL,INSTR(tel,'-')+1) "���ڸ�"
FROM tbl_tel;
--
SELECT dname
    , INSTR(dname,'S',1) F
    , INSTR(dname,'S',2) S
    , INSTR(dname,'S',-1) T
FROM dept;

-- [RPAD/LPAD] ������ ���̿��� ���ڰ��� ä��� ���� ������ ��(��)������ Ư�������� ä�� ����
--�����ġ�
-- RPAD (expr1, n [, expr2] )

SELECT RPAD('Corea',12,'*')
FROM dual;

SELECT ename, sal + NVL(comm,0) pay
    ,LPAD( sal + NVL(comm,0),10,'*')
FROM  emp;

-- [RTRIM/LTRIM] ���ڰ��߿��� ��(��)�����κ��� Ư�����ڿ� ��ġ�ϴ� ���ڰ��� �����Ͽ� ����
SELECT RTRIM('BROWINGyxXxy','xy') "RTRIM ex"
    , LTRIM('****8978','*') "LTRIM ex"
    , '[' || TRIM('            8978              ') || ']' "TRIM ex"
FROM dual;

-- [ASCII] ������ ���ڳ� ���ڸ� ASCII �ڵ尪���� �ٲپ� ����
SELECT ASCII('A'), CHR(65)
FROM dual;

SELECT ename
    ,SUBSTR(ename,1,1)
    ,ASCII(SUBSTR(ename,1,1)) "ASCII"
FROM emp;

-- [GREATEST() / LEAST()] ������ ���ڳ� �����߿��� ���� ū/���� ���� ����
-- ����
SELECT GREATEST(3,5,2,4,1) max
    ,LEAST(3,5,2,4,1) min
FROM dual;
-- ����
SELECT GREATEST('R','Z','T','H','I') max
    ,LEAST('R','Z','T','H','I') min
FROM dual;

-- VSIZE(char) ������ ���ڿ��� ũ�⸦ ���ڰ����� ����
SELECT VSIZE(1)     -- ���ڴ� 2����Ʈ
    , VSIZE('A')    -- ����� 1����Ʈ
    , VSIZE('��')    -- ���ڴ� 3����Ʈ
FROM dual;

--        ��. ���� �Լ�
--    [ ROUND(a,[b]) - �ݿø��ϴ� �Լ� / b ���� ��� ���� ��� ���� ]
SELECT 3.141592
    ,ROUND(3.141592) A -- b X 
    ,ROUND(3.141592, 0) B -- b+1 �ڸ����� �ݿø� -> �Ҽ��� ù��° �ڸ�
    ,ROUND(3.141592, 3) C -- �Ҽ��� 4��° �ڸ����� �ݿø�
    ,ROUND(12345.6789, -2) D --  b���� �����̸� �Ҽ��� ���� b�ڸ����� �ݿø��Ͽ� ���
FROM dual;

--    [�����Լ� TRUNC() , FLOOR() ������ ]
SELECT FLOOR(3.141592) A
    ,FLOOR(3.941592) B -- �Ű����� �ϳ��μ� �ش� ���� �Ҽ��� 1��°���� �����Ͽ� ���
    ,TRUNC(3.941592, 0) C -- a�� �Ҽ��� ���� b+1�ڸ����� �����Ͽ� b�ڸ����� ���
    ,TRUNC(3.941592, 3) D
FROM dual;
-- [�ø�(����) �Լ� CEIL()]
SELECT CEIL(3.14)
    , CEIL(3.94)
FROM dual;

--�Խ���: �� ������ ���� ����� �� ���
SELECT CEIL(161/10) page
    ,ABS(10), ABS(-10)
FROM dual;

-- SIGN �Լ� / �Է� ���� ��ȣ�� �����Ѵ� / 1 0 -1
SELECT SIGN(100) A    --  1
    ,SIGN(0) B        --  0
    ,SIGN(-100) C     -- -1
--  ,SIGN('A') D      -- �ڷ��� ����ġ
FROM dual;
-- POWER �Լ� / POWER(n2.n1)���� n2�� n1������ ���� ��ȯ
SELECT POWER(5,2) A    --  25
FROM dual;
-- SQRT �Լ� / �Էµ� ���� ������ ���� ��ȯ
SELECT SQRT(4) A    --  2
FROM dual;
--        ��. ��¥ �Լ�
-- [SYSDATE] ������ ��¥�� �ð��� ����
SELECT SYSDATE
FROM dual;
-- [ROUND(date)] ������ �������� ��¥�� �ݿø��Ͽ� ����
SELECT ROUND(SYSDATE) A
    ,ROUND(SYSDATE,'DD') B -- ������ �������� ��¥�� �ݿø�
    ,ROUND(SYSDATE,'MONTH') C -- 15���� �������� ���� �ݿø�
    ,ROUND(SYSDATE,'YEAR') D -- ������ ����(��)�� �������� �⵵�� �ݿø�
FROM dual;

-- [TRUNC(date)] ��¥���� �ð��κ��� �����Ͽ� 00:00���� �ٲپ��ִ� �Լ�

SELECT SYSDATE A
--    ,TO_CHAR(SYSDATE,'DS TS') NOW -- ����ð�
--    ,TRUNC(SYSDATE)  -- �ð�/��/�� ����
--    ,TO_CHAR(TRUNC(SYSDATE),'DS TS')
--    ,TRUNC(SYSDATE,'DD') -- �ð�/��/�� ����
--    ,TO_CHAR(TRUNC(SYSDATE,'DD'),'DS TS')
--    ,TRUNC(SYSDATE,'MONTH') -- �ð�/��/�� ����
--    ,TO_CHAR(TRUNC(SYSDATE,'DAY'),'DS TS') -- DAY : ����
--    ,TO_CHAR(TRUNC(SYSDATE,'MONTH'),'DS TS')
    ,TO_CHAR(TRUNC(SYSDATE,'YEAR'),'DS TS')

FROM dual;

-- ��¥�� ��� ������ ����ϴ� ���
SELECT SYSDATE
    , SYSDATE + 7       -- 7�� ���ϱ�
    , SYSDATE - 7       -- 7�� ����
    , SYSDATE + 2/24    -- 2�ð� ���ϱ�
    -- ��¥ - ��¥ = �ϼ� [��¥�� ��¥�� ���Ͽ� �ϼ� ���]
FROM dual;
-- ȸ�縦 �Ի��� �� ~ ���� ��¥ ���� ���� ?
SELECT ename, hiredate
    , CEIL(SYSDATE - hiredate) + 1 "�ٹ��ϼ�"
FROM emp;
-- ����) �츮�� �����Ϸ� ���� ���� ������ �����°�?
SELECT SYSDATE
    ,'2024/07/01' AS S
    , TRUNC(SYSDATE) - TRUNC(TO_DATE('2024/07/01')) + 1 LAPSE
FROM DUAL;

-- [MONTHS_BETWEEN] �� ���� ��¥���� �� ���̸� �����ϴ� �Լ�
SELECT ename, hiredate, SYSDATE
    ,MONTHS_BETWEEN(SYSDATE, hiredate) �ٹ�������
    ,MONTHS_BETWEEN(SYSDATE, hiredate)/12 �ٹ����
FROM emp;

-- [ADD_MONTHS] Ư�� ���� ���� ���� ��¥�� �����ϴ� �Լ�
SELECT SYSDATE
    ,SYSDATE + 1            -- �Ϸ� ����
    ,ADD_MONTHS(SYSDATE,1)  -- �Ѵ� ����
    ,ADD_MONTHS(SYSDATE,-1)  -- �Ѵ� ��
    ,ADD_MONTHS(SYSDATE,12) -- �ϳ� ����
FROM DUAL;
-- [LAST_DAY] Ư�� ��¥�� ���� ���� ���� ������ ��¥�� �����ϴ� �Լ�
SELECT SYSDATE
--    ,LAST_DAY(SYSDATE)--24/08/31
--    ,TO_CHAR(LAST_DAY(SYSDATE),'DDD')
--    ,TRUNC(SYSDATE,'MONTH')
--    ,TO_CHAR(TRUNC(SYSDATE,'MONTH'),'DAY')
    , ADD_MONTHS(TRUNC(SYSDATE,'MONTH'),1)-1
FROM dual;
-- [NEXT_DAY] ��õ� ������ ���ƿ��� ���� �ֱ��� ��¥�� �����ϴ� �Լ�
SELECT SYSDATE
--    ,NEXT_DAY(SYSDATE,'��')
--    ,NEXT_DAY(SYSDATE,'��')
--    ,NEXT_DAY(SYSDATE,'��')
    ,NEXT_DAY(SYSDATE,'��') + 7 
FROM dual;

-- ����) 10�� ù ��° ������ �ް�...
SELECT NEXT_DAY(ADD_MONTHS(TRUNC(SYSDATE,'MONTH'),2),'��')
    , NEXT_DAY(TO_DATE('24/10/01'),'��')
FROM dual;

SELECT SYSDATE          -- ������ ��¥�� �ð��� �����Ѵ�.
    , CURRENT_DATE      -- ������ ��¥�� �ð��� ���
    , CURRENT_TIMESTAMP -- ������ ��¥�� �и��� ������ �ð��� ���
FROM dual;
--        ��. ��ȯ �Լ�
-- [TO_NUMBER] ���� Ÿ���� ���� Ÿ������ ��ȯ
--�����ġ�
--	TO_NUMBER(char [,fmt [,'nlsparam']])
SELECT '1234'
    ,TO_NUMBER('1234')
FROM DUAL;

-- TO_CHAR(NUMBER) / TO_CHAR(CHAR) / TO_CHAR(DATE) ���ڷ� ��ȯ�Լ�
SELECT num, name
    , basicpay, sudang
    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang, 'L9G999G999D00') pay
    , TO_CHAR(basicpay + sudang, 'L9,999,999') pay
FROM insa;

SELECT
    TO_CHAR(100,'S9999')
    ,TO_CHAR(-100,'S9999')
    ,TO_CHAR(100,'9999MI')
    ,TO_CHAR(-100,'9999MI')
    
    ,TO_CHAR(100,'9999PR')
    ,TO_CHAR(-100,'9999PR') -- <100>
FROM dual;

--EMP ���̺� ename, sal, comm ���� ���� ���
SELECT ename, sal, comm
    ,sal + NVL(comm,0) pay
    ,TO_CHAR((sal + NVL(comm,0))*12, 'L9,999') ����
    ,TO_CHAR((sal + NVL(comm,0))*12, 'L999,999,999') ����
FROM emp;

--
SELECT name,ibsadate
    ,TO_CHAR(ibsadate,'YYYY.MM.DD.DAY')
    ,TO_CHAR(ibsadate,'YYYY"��" MM"��" DD"��" DAY')
    -- ���� ���Ŀܿ� �߰����� �ؽ�Ʈ�� ""�� ����Ѵ�
FROM insa;

--        ��. �Ϲ� �Լ�
-- [COALESCE] ������ ���� ���� ���������� üũ�Ͽ� null�� �ƴ� ���� �����ϴ� �Լ�
SELECT ename, sal, comm
    ,sal + NVL(comm,0)pay
    ,sal + NVL2(comm,comm,0)pay
    ,COALESCE(sal+comm, sal, 0)
FROM emp;
-- [DECODE] **�߿�**
-- ���� ���� ������ �־� ���ǿ� ���� ��� �ش� ���� �����ϴ� �Լ�(IF...THEN...ELSE...ó��)

-- DECODE �Լ�
-- �� ���α׷��� ����� if���� sql, pl/sql ������ ������� ���ؼ� ������� ����Ŭ �Լ�
-- �� FROM �� �ܿ� ��� ��� ����
-- �� �� ������ =  �� �����ϴ�.
-- �� DECODE �Լ��� Ȯ�� �Լ� : CASE �Լ�

--  ex1)
--    if( A = B ) {
--        return C;
--    }
--    else{
--        return D;
--    }
--    ==> DECODE(A,B,C,D);
--  ex2)
--    if( A = B ) {
--        return ��;
--    }else if( A = C ){
--        return ��;
--    }else if( A = D ){
--        return ��;
--    }else if( A = E ){
--        return ��;
--    }else{
--        return ��;
--    }
--    ==> DECODE(A,B,��,C,��,D,��,E,��,��);

SELECT name
    , ssn
    , NVL2(NULLIF(SUBSTR(ssn,-7,1),TO_CHAR(2)),'����','����') GENDER
FROM insa;

SELECT name, ssn
    ,MOD(SUBSTR(ssn,-7,1),2)
    ,DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����','����') GENDER
FROM insa;
-- ����) emp ���̺��� sal�� 10%�λ��� ����.
SELECT ename, sal, comm
--  , sal * 1.1 "10% �λ�� sal"
    , sal + sal * 0.1 "10% �λ�� sal"
FROM emp;

-- ����) emp ���̺��� 10�� �μ��� pay 15%
--                   20�� �μ��� pay 15%
--                   �� �� �μ��� pay 20% �λ�
SELECT deptno, ename, sal, comm
    ,(sal+NVL(comm,0))pay
    ,(sal+NVL(comm,0)) * DECODE(deptno,10,1.15
                                      ,20,1.15
                                      ,1.2) "�λ�� PAY"
--    ,DECODE(deptno,10,(sal+NVL(comm,0))*1.15
--                  ,20,(sal+NVL(comm,0))*1.15
--                  ,(sal+NVL(comm,0))*1.2) "�λ�� PAY"
FROM emp;

-- �� ������ �ζ��κ�� ����
SELECT deptno, ename, sal, comm, pay,
       pay * DECODE(deptno, 10, 1.15,
                            20, 1.15,
                            1.2) AS "�λ�� PAY"
FROM (
    SELECT deptno, ename, sal, comm, (sal + NVL(comm, 0)) AS pay
    FROM emp
) E;

-- [CASE] **�߿�**
-- ���� ���� ������ �־� ���ǿ� ���� ��� �ش� ���� �����ϴ� �Լ�(DECODE�� Ȯ����)
SELECT name, ssn
    ,MOD(SUBSTR(ssn,-7,1),2)
    ,DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����','����') GENDER
    ,CASE MOD(SUBSTR(ssn,-7,1),2) WHEN 1 THEN '����'
                                --WHEN 0 THEN '����'
                                  ELSE '����'
    END GENDER
FROM insa;

SELECT deptno, ename, sal, comm
    ,(sal+NVL(comm,0))pay
    ,(sal+NVL(comm,0)) * DECODE(deptno,10,1.15
                                      ,20,1.15
                                      ,1.2) "�λ�� PAY"
    ,(sal+NVL(comm,0)) * CASE deptno WHEN 10 THEN 1.15
                                     WHEN 20 THEN 1.15
                                     ELSE 1.2
                         END  "�λ�� PAY"
FROM emp;

--2) ������ �Լ�( �׷��Լ� )
SELECT COUNT(*), COUNT(ename), COUNT(sal), COUNT(comm) "COUNT"
-- ORA-00937: not a single-group group function
--        , sal  �����Լ��� ���� ��� �Ұ�
    , SUM(sal) "SUM"
    , SUM(comm)/COUNT(*) "AVG_COMM"
    , AVG(comm) "AVG"
    , MAX(sal) "MAX"
    , MIN(sal) "MIN"
FROM emp;
-- �� ����� ��ȸ
-- �� �μ��� ����� ��ȸ
SELECT *
FROM INSA;
--�ѹ��� ���ߺ� ������ ��ȹ�� �λ�� ����� ȫ����




