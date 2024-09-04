-- SCOTT
-- ��������
-- ������ ���� ������ SQL�� �� ���� ����. ( �����ϸ� ������ )

-- [ ���������� ����ϴ� 3���� ��� ]
--    ��. �����Ͻ� SQL������ Ȯ������ ���� ���( ���� ���� ���Ǵ� ��� )
--    ��) WHERE ������... X
--    ��. PL/SQL �� �ȿ��� DDL���� ����ϴ� ���
--    CREATE, ALTER, DROP ��
--    ��. PL/SQL �� �ȿ��� ALTER SYSTEM �Ǵ� ALTER SESSION ��ɾ ����ϴ� ���

-- [PL/SQL ���� ������ ����ϴ� ��� 2����]
--    ��. DBMS_SQL ��Ű��
--    ��. �� EXECUTE IMMEDIATE ��
    
--    SELECT, FETCH�� INTO -> ������ ���� �Ҵ�
--    ����)
--    EXEC[UTE] IMMEDIATE ����������
--            [ INTO ������,������, ... ]
--            [ USING [ IN / OUT / IN OUT ] �Ķ����, �Ķ����, ...];

-- �ǽ�����) �͸� ���ν���
DECLARE
    vsql VARCHAR2(1000);
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job';
    vsql := vsql || ' FROM emp';
    vsql := vsql || ' WHERE empno = 7369 ';
    DBMS_OUTPUT.PUT_LINE( vsql );
    
    EXECUTE IMMEDIATE vsql
        INTO vdeptno,vempno,vename,vjob;
    DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vempno || ', ' || 
                          vename || ', ' || vjob);
--EXCEPTION
END;

-- �ǽ����� ) ���� ���ν���
-- �Ķ���� : �����ȣ �Է�
CREATE OR REPLACE PROCEDURE up_ndsemp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000);
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job';
    vsql := vsql || ' FROM emp';
    vsql := vsql || ' WHERE empno = ' || pempno;
    DBMS_OUTPUT.PUT_LINE( vsql );
    
    EXECUTE IMMEDIATE vsql
        INTO vdeptno,vempno,vename,vjob;
    DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vempno || ', ' || 
                          vename || ', ' || vjob);
--EXCEPTION
END;

EXEC UP_NDSEMP(7369);

--
CREATE OR REPLACE PROCEDURE up_ndsemp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000);
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job';
    vsql := vsql || ' FROM emp';
    vsql := vsql || ' WHERE empno = pempno';
    DBMS_OUTPUT.PUT_LINE( vsql );
    
    EXECUTE IMMEDIATE vsql
        INTO vdeptno,vempno,vename,vjob
        USING IN pempno;
    DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vempno || ', ' || 
                          vename || ', ' || vjob);
--EXCEPTION
END;

EXEC up_ndsemp(7369);
--
-- �ǽ����� ) dept ���̺� ���ο� �μ��� �߰��ϴ� ��������
CREATE OR REPLACE PROCEDURE up_ndsInsDept
(
    pdname emp.ename%TYPE := NULL
    , ploc dept.loc%TYPE := NULL
)
IS
    vsql VARCHAR2(1000);
    vdeptno emp.deptno%TYPE;
BEGIN
    SELECT NVL(MAX(deptno),0)+10 INTO vdeptno FROM dept;
    vsql := 'INSERT INTO dept ( deptno, dname, loc )';
    vsql := vsql || ' VALUES ( :vdeptno, :pdname, :ploc ) ';
    DBMS_OUTPUT.PUT_LINE( vsql );
    
    EXECUTE IMMEDIATE vsql
        USING IN vdeptno, pdname, ploc;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE( ' INSERT ���� ' );
--EXCEPTION
END;
EXEC up_ndsInsDept('QC','COREA');

SELECT * FROM dept;

-- �ǽ�) ���� SQL - DDL �� ��� (���̺� ����)
-- ���̺��, �÷��� �Է�
DECLARE
    vsql VARCHAR2(1000);
    vtableName VARCHAR2(20);
BEGIN
    vtableName := 'tbl_test';
    vsql := ' CREATE TABLE ' || vtableName;
    vsql := vsql || ' ( ';
    vsql := vsql || ' id NUMBER PRIMARY KEY ';
    vsql := vsql || ' , name VARCHAR2(20) ';
    vsql := vsql || ' ) ';
    DBMS_OUTPUT.PUT_LINE( vsql );
    
    EXECUTE IMMEDIATE vsql;
--EXCEPTION
END;

SELECT * FROM user_tables
WHERE table_name LIKE 'TBL_T%';

-- OPEN ~ FOR �� : ���� ���� ���� + �������� ���ڵ�( Ŀ�� ó�� )
-- �μ���ȣ�� �Ķ���ͷ� �Է�..
CREATE OR REPLACE PROCEDURE up_ndsInsDept
(
    pdeptno emp.deptno%TYPE := 10
)
IS
    vsql VARCHAR2(1000);
    vcur SYS_REFCURSOR; -- Ŀ���� �ڷ��� ���� Ÿ��, 9i : REF CURSOR
    vrow emp%ROWTYPE;
BEGIN
    vsql := ' SELECT * ';
    vsql := vsql || ' FROM emp';
    vsql := vsql || ' WHERE deptno = :pdeptno';
    DBMS_OUTPUT.PUT_LINE( vsql );
    
--    EXECUTE IMMEDIATE vsql INTO USING IN vdeptno,pdname,ploc;
--    OPEN ~ FOR �� ���
--    OPEN Ŀ�� FOR ��������
    OPEN vcur FOR vsql USING pdeptno;
    LOOP
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vrow.empno || ' , ' || vrow.ename );
    END LOOP;
    CLOSE vcur;
--EXCEPTION
END;

EXEC up_ndsInsDept(30);

--
-- emp ���̺��� �˻� ��� ����
-- 1) �˻�����    : 1 �μ���ȣ, 2 �����, 3 ��
-- 2) �˻���      :
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
  psearchCondition NUMBER -- 1. �μ���ȣ, 2.�����, 3. ��
  , psearchWord VARCHAR2
)
IS
  vsql  VARCHAR2(2000);
  vcur  SYS_REFCURSOR;   -- Ŀ�� Ÿ������ ���� ����  9i  REF CURSOR
  vrow emp%ROWTYPE;
BEGIN
  vsql := 'SELECT * ';
  vsql := vsql || ' FROM emp ';
  
  IF psearchCondition = 1 THEN -- �μ���ȣ�� �˻�
    vsql := vsql || ' WHERE  deptno = :psearchWord ';
  ELSIF psearchCondition = 2 THEN -- �����
    vsql := vsql || ' WHERE  REGEXP_LIKE( ename , :psearchWord )';
  ELSIF psearchCondition = 3  THEN -- job
    vsql := vsql || ' WHERE  REGEXP_LIKE( job , :psearchWord , ''i'')';
  END IF; 
   
  OPEN vcur  FOR vsql USING psearchWord;
  LOOP  
    FETCH vcur INTO vrow;
    EXIT WHEN vcur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( vrow.empno || ' '  || vrow.ename || ' ' || vrow.job );
  END LOOP;   
  CLOSE vcur; 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, '>EMP DATA NOT FOUND...');
  WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20004, '>OTHER ERROR...');
END;

EXEC UP_NDSSEARCHEMP(1, '20'); 
EXEC UP_NDSSEARCHEMP(2, 'L'); 
EXEC UP_NDSSEARCHEMP(3, 's'); 