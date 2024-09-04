-- SCOTT
-- 1) SCOTT ������ ���̺� ��� ��ȸ.
SELECT *
FROM dba_tables;
FROM all_TABLES;
FROM USER_TABLES;
FROM TABS;
-- ������

-- INSA ���̺� ���� �ľ�
DESCRIBE INSA;
DESC INSA;
-- NOT NULL�� �ʼ� �Է� �����̴�.

-- NUMBER(5) = NUMBER(5.0) �ڴ� �Ҽ��� �ڸ���
-- VARCHAR2(20) ���ڴ� 3����Ʈ �̹Ƿ� 6���ڰ� �� �� ����

-- INSA ��� ��� ������ ��ȸ.
SELECT *
FROM INSA;
-- IBSADATE �Ի�����
-- '98/10/11' 'RR/MM/DD'    'YY/MM/DD' ������

SELECT * 
FROM v$nls_parameters;

-- SELECT �� ó�� ���� �����
1 [WITH]        
6 SELECT      
2 FROM        
3 [WHERE]      
4 [GROUP BY]    
5 [HAVING]      
7 [ORDER BY]    

-- EMP ���̺��� ��� ���� ��ȸ( �����ȣ, �����, �Ի�����) ��ȸ
SELECT EMPNO, ENAME, HIREDATE
FROM EMP;

-- ����(PAY) = �⺻��(SAL) + ����(COMM) �÷��� �߰��ؼ� ��ȸ����.
SELECT EMPNO, ENAME, HIREDATE
--    ,SAL , COMM
--    ,NVL(COMM,0)
--    ,NVL2 (COMM, COMM, 0)
--    ,SAL + COMM
--    ,SAL + NVL(COMM,0)
    ,SAL + NVL(COMM,0) AS PAY
FROM EMP;

-- 1) ����Ŭ NULL �ǹ�? ��Ȯ�� ��.
-- 2) ���� ��굵 �̻���: NULL ���� ���� ����ϸ� ����� ���δ� NULL�̴�.



-- ����) emp ���̺��� �����ȣ, �����, ���ӻ�� ��ȸ
--      ���ӻ�簡(NULL)�� ��� 'CEO'��� ���.
SELECT EMPNO, ENAME, MGR
    -- , NVL(MGR,'CEO') -- ORA-01722: invalid number
    -- , NVL(MGR,0)
    , NVL(TO_CHAR(MGR), 'CEO')
    , NVL(MGR ||'','CEO')
FROM EMP;

DESC EMP; -- MGR�� �ڷ����� �������̱� ������ ���ڷθ� ��ü�� �Ǵ� ������

-- EMP ���̺��� ��� ������ �̷������� ����ϰ��� �Ѵ�.
-- �̸��� 'SMITH'�̰�, ������ CLERK�̴�.
-- �ڹٿ��� System.out.printf(���̸��� \��%s\�� �Դϴ�.��, ��ȫ�浿��);
SELECT '�̸��� '''|| ENAME ||''' �̰�, ������ '''|| JOB ||'''�̴�.'
FROM EMP;

SELECT '�̸���' ||''''|| ENAME ||''''|| 
       '�̰�, ������' ||''''|| JOB ||''''|| '�̴�.'
FROM EMP;

-- ���ؼ� 65 -> A CHR()
SELECT '�̸��� '|| CHR(39) || ename|| CHR(39) || '�̰�, ������ '||job||'�̴�'
FROM EMP;


-- SYS���� ���� ��� ����� ���� ��ȸ.


SELECT *
FROM DEPT;

-- ����) EMP ���̺��� �μ���ȣ�� 10���� ����鸸 ��ȸ

-- EMP ���̺��� �� ����� ���� �ִ� �μ���ȣ�� ��ȸ
SELECT *
FROM EMP
WHERE DEPTNO = '10';

-- ����) EMP ���̺��� 10�� �μ����� ������ ������ ����� ���� ��ȸ.

SELECT *
FROM EMP
WHERE DEPTNO = '10'OR DEPTNO = '30' OR DEPTNO = '10';
-- ����Ŭ���� �� ������ OR�� �ش��ϴ� ���� ��������...
-- �ڹ� �������� : &&, ||, !
-- ����Ŭ �������� : AND OR NOT
SELECT *
FROM EMP
WHERE NOT (DEPTNO = '10');
WHERE DEPTNO != '10';
WHERE DEPTNO ^= '10';
WHERE DEPTNO <> '10';

-- ����) EMP ���̺��� 10�� �μ����� ������ ������ ����� ���� ��ȸ.
SELECT *
FROM EMP
WHERE DEPTNO != '10';
--
SELECT *
FROM EMP
WHERE DEPTNO IN ('20','30','40');
WHERE DEPTNO = '20' OR DEPTNO = '30' OR DEPTNO = '40';
-- NOT IN (LIST) SQL ������

-- [����] EMP ���̺��� ������� FORD�� ����� ��� ��������� ���(��ȸ)

SELECT *
FROM EMP
--WHERE ENAME = 'FORD';
WHERE ENAME ='FORD'; -- ���� ������ ���� ���� ��ҹ��ڸ� ��Ȯ�ϰ� �־�� �Ѵ�.

SELECT *
FROM emp
WHERE ename = UPPER('foRd');

SELECT LOWER(ENAME), INITCAP(JOB)
FROM EMP;

-- [����] emp ���̺��� Ŀ�̼��� NULL�� ����� ���� ���(��ȸ)
SELECT *
FROM emp
WHERE comm = IS NOT NULL;
WHERE comm = IS NULL;
WHERE comm = NULL;

-- [����] 2000 �̻� ����(pay) ���� 4000 �޴� ����� ������ ���(��ȸ)
-- emp ���̺���
-- pay = sal + comm
SELECT e.* , sal + NVL(comm, 0) as PAY
FROM emp e
WHERE pay >=2000 AND pay <=4000; --ORA-00904: "EMP"."PAY": invalid identifier
--
SELECT e.* , sal + NVL(comm, 0) as PAY
FROM emp e
WHERE (sal + NVL(comm, 0)) >=2000 AND (sal + NVL(comm, 0)) <=4000;
-- WITH �� ���
WITH temp AS(
    SELECT emp.*,(sal + NVL(comm, 0)) pay 
    FROM emp
)
SELECT *
FROM temp
WHERE pay >= 2000 AND pay <= 4000;
-- �ζ��κ� (IN-LINE view)
-- NOT BETWEEN A AND B  SQL������ ���
SELECT *
FROM(
    SELECT emp.*,(sal + NVL(comm, 0)) pay 
    FROM emp
    )e
WHERE pay BETWEEN 2000 AND 4000;
WHERE pay >= 2000 AND pay <= 4000;
WHERE e.pay >= 2000 AND e.pay <= 4000;

-- [����] insa ���̺��� 70������ ����� ������ ��ȸ(���)
--  �̸�, �ֹε�Ϲ�ȣ
SELECT name,ssn
    ,SUBSTR(SSN,1,1)
    ,SUBSTR(SSN,1,1)
    ,SUBSTR(SSN,1,2) -- '77' ����
    ,INSTR(SSN,0)
FROM INSA
WHERE INSTR(SSN,7)=1;
WHERE TO_NUMBER(SUBSTR(ssn,0,2))BETWEEN 70 AND 79;
WHERE SUBSTR(SSN,1,1) = 7;
-- SUBSTR() -- 
SELECT name,ssn
--    ,SUBSTR(ssn,0,8)||'******' RRN
--    ,CONCAT(SUBSTR(ssn,0,8),'******')RRN
--    ,RPAD( SUBSTR(ssn,0,8), 14, '*')RRN
--    ,SUBSTR(ssn,-6)
--    ,REPLACE(ssn,SUBSTR(ssn,-6),'******')RRN
    ,REGEXP_REPLACE(ssn, '(\d{6}-\d)\d{6}', '\1******')RRN
FROM insa;
--
SELECT name,ssn
    ,SUBSTR(ssn,0,6)
    ,SUBSTR(ssn,0,2)YEAR
    ,SUBSTR(ssn,3,2)MONTH
--    ,SUBSTR(ssn,5,2)DATE    --ORA-00923: FROM keyword not found where expected
    ,SUBSTR(ssn,5,2)"DATE"      --DATE�� ������̱� ������ ""�� �ٿ� ��Ī���� ��ȯ
    ,TO_DATE(SUBSTR(ssn,0,6))BIRTH-- '771212' ���ڿ� -> ��¥ �� ��ȯ
    --'77/12/12' DATE -> ��,��,��,�ð�,��,��
    ,TO_CHAR( TO_DATE(SUBSTR(ssn,0,6)),'YY') y
FROM insa
WHERE TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)),'YY') BETWEEN 70 AND 79;
WHERE TO_DATE((SUBSTR(ssn,0,6)) BETWEEN '70/01/01/' AND '79/12/31';
--
SELECT ename, hiredate
--    ,TO_CHAR(HIREDATE,'YYYY')Y -- 0000 �⵵ 4����
    ,TO_CHAR(HIREDATE,'YY')Y
    ,TO_CHAR(HIREDATE,'MM')M
    ,TO_CHAR(HIREDATE,'DD')D
    ,TO_CHAR(HIREDATE,'DY')DY -- ���� 1����
--    ,TO_CHAR(HIREDATE,'DAY')DAY -- ���� 3����
    
    -- EXTRACT() �����ϴ�.
    ,EXTRACT( YEAR FROM hiredate)
    ,EXTRACT( MONTH FROM hiredate)
    ,EXTRACT( DAY FROM hiredate)
    
    
FROM emp;

-- ���� ��¥���� �⵵/��/��/�ð�/��/�� �������� �ؿ�.
SELECT SYSDATE
    ,TO_CHAR(SYSDATE,'DS TS')
    ,CURRENT_TIMESTAMP
FROM DEPT;

-- insa ���̺��� 70��� ��� ��� ���� ��ȸ.
-- LIKE     SQL������
-- REGEXP_LIKE �Լ�
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn,'^7.12');
WHERE REGEXP_LIKE(ssn,'^7[0-9]12');
WHERE REGEXP_LIKE(ssn,'^7\d12');

WHERE REGEXP_LIKE(ssn,'^7.12');

WHERE REGEXP_LIKE(ssn,'^78');

WHERE ssn LIKE '7_12%'; -- 70�� 12�� ���� ��� ���
WHERE ssn LIKE '______-1______';
WHERE ssn LIKE '%-1%';  -- SSN���� ~-1~ ����
WHERE name LIKE '%��';   -- ~��  ����
WHERE name LIKE '%��%';  -- ~��~ ����
WHERE name LIKE '��%';   -- ��~  ����

-- [����] insa ���̺��� �达 ���� ������ ��� ���  ���
SELECT *
FROM insa
WHERE REGEXP_LIKE( name, '^[^��]');
WHERE NOT REGEXP_LIKE( name, '^��');
WHERE REGEXP_LIKE( name, '^��');
WHERE NOT name LIKE '��%';
WHERE name NOT LIKE '��%';   -- ��~  ����
-- [����]��ŵ��� ����, �λ�, �뱸 �̸鼭 ��ȭ��ȣ�� 5 �Ǵ� 7�� ���Ե� �ڷ� ����ϵ�
--      �μ����� ������ �δ� ��µ��� �ʵ�����. 
--      (�̸�, ��ŵ�, �μ���, ��ȭ��ȣ)
SELECT name,city,SUBSTR(buseo,0,LENGTH(buseo)-1) BUSEO,tel
FROM insa
WHERE
-- city IN('����','�λ�','�뱸')
REGEXP_LIKE(city,'����|�λ�|�뱸')
-- AND (tel like '%5%' or tel like '%7%');
AND REGEXP_LIKE(tel,'[57]');