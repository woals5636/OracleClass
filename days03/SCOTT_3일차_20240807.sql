-- SCOTT
-- [LIKE �������� ESCAPE �ɼ� ����]
-- �� wildcard�� �Ϲ� ����ó�� ���� ���� ��쿡�� ESCAPE �ɼ��� ���
SELECT deptno, dname, loc
FROM dept;
-- dept ���̺� ���ο� �μ������� �߰�
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated    ���ϼ� �������� ����
-- deptno �� �⺻Ű(PK) �̱� ����
-- > �⺻Ű�� NULL ���� ���� �� ������ ������ ��(UNIQUE KEY)�� ���´�
INSERT INTO dept (deptno,dname,loc) VALUES (60,'�ѱ�_����','COREA');
INSERT INTO dept VALUES (60,'�ѱ�_����','COREA');
COMMIT;
ROLLBACK;
-- [���� �μ��� % ���� ���Ե� �μ� ������ ��ȸ]
SELECT *
FROM DEPT
WHERE DNAME LIKE '%\%%' ESCAPE '\';

--ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
DELETE FROM dept;
DELETE FROM dept
WHERE DEPTNO = 60;
DELETE FROM EMP; -- WHERE �������� ������ ��� ���ڵ� ����
ROLLBACK;
COMMIT;

UPDATE ���̺��
SET �÷���=Į����,�÷���=Į����,�÷���=Į����;

UPDATE dept
SET dname = 'QC'; -- WHERE �������� ������ ��� ���ڵ� ����
ROLLBACK;

UPDATE dept
-- SET dname = dname||'XX';
SET dname = SUBSTR(dname,0,2), loc = 'COREA'
WHERE deptno = 50;

SELECT * FROM DEPT;

-- [����] 40�� �μ��� �μ���,�������� ���ͼ�
--       50�� �μ��� �μ�������, ���������� �����ϴ� ���� �ۼ�
SELECT DNAME,LOC
FROM DEPT
WHERE deptno = 40;

UPDATE dept
SET dname = (SELECT dname FROM DEPT WHERE deptno = 40)
    , loc = (SELECT loc FROM DEPT WHERE deptno = 40)
WHERE deptno = 50;

ROLLBACK;

UPDATE DEPT
SET (dname,loc) = (SELECT dname,loc FROM DEPT WHERE deptno = 40)
WHERE DEPTNO = 50;

-- [����] dept        50,60,70 deptno ����
DELETE dept
WHERE DEPTNO BETWEEN 50 AND 70;
--WHERE DEPTNO IN(50,60,70);

-- [����] EMP ���̺� ��� ����� SAL �⺻���� PAY�޿��� 10% �λ��ϴ� UPDATE
SELECT * FROM EMP;

UPDATE EMP
SET SAL = SAL + (SAL + NVL(COMM,0))*0.1;

ROLLBACK;

SELECT *
FROM (
    SELECT SAL , NVL(COMM,0)COMM, SAL + NVL(COMM,0) PAY
    FROM EMP
)

-- DUAL ���̺� == �ó��
-- ��Ű��.��ü��

-- PUBLIC �ó�� ����
-- ORA-01031: insufficient privileges
-- ������ ���� ������ scott������ ���� �Ұ�
--CREATE PUBLIC SYNONYM arirang
--FOR scott.emp;

-- ���� �ο�
-- GRANT SELECT ON sh.sales TO warehouse_user;
GRANT SELECT ON ARIRANG TO HR;

-- ���� ȸ��
REVOKE SELECT
	ON EMP
	FROM HR
	CASCADE CONSTRAINTS;
    
---------------------------------------------------------------------------------------------------------
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