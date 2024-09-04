-- SCOTT
-- [ Ʈ�����(Transaction) ]
--������ü A -> B
-- 1) UPDATE �� ( A ���¿��� �ݾ� ���� )
-- 2) UPDATE �� ( B ���¿� ������ �ݾ׸�ŭ �Ա� )
-- 1) + 2) ���� �Ϸ�(Ŀ��) OR ���� ���(�ѹ�)

CREATE TABLE tbl_dept
AS
    SELECT * FROM dept;
-- Table TBL_DEPT��(��) �����Ǿ����ϴ�.

-- 1) INSERT
INSERT INTO tbl_dept VALUES(50,'development','COREA');

SAVEPOINT a;    -- Ư������ ����.

-- 2) UPDATE
UPDATE tbl_dept 
SET loc='ROK'
WHERE deptno = 50;

-- ROLLBACK;    INSERT �������� �ѹ�.
ROLLBACK TO SAVEPOINT a;
ROLLBACK TO a;  -- UPDATE �� �ѹ�
ROLLBACK;

-- SESSION A
SELECT *
FROM tbl_dept;

--
DELETE FROM tbl_dept
WHERE deptno = 40;
COMMIT;

-- [ PACKAGE ]
-- Package EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.
-- ��Ű���� ���� �κ�
CREATE OR REPLACE PACKAGE employee_pkg
AS 
    -- �������α׷� ( ���� ���ν����� )
    PROCEDURE print_ename(p_empno NUMBER); 
    PROCEDURE print_sal(p_empno NUMBER); 
    -- ������, ����..
    FUNCTION uf_age
    (
        pssn IN VARCHAR2
        , ptype IN NUMBER
    )
    RETURN NUMBER;
END employee_pkg;

-- ��Ű�� ��ü �κ�
CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS 
   
      procedure print_ename(p_empno number) is 
         l_ename emp.ename%type; 
       begin 
         select ename 
           into l_ename 
           from emp 
           where empno = p_empno; 
       dbms_output.put_line(l_ename); 
      exception 
        when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end print_ename; 
   
   procedure print_sal(p_empno number) is 
      l_sal emp.sal%type; 
    begin 
      select sal 
       into l_sal 
        from emp 
        where empno = p_empno; 
     dbms_output.put_line(l_sal); 
    exception 
      when NO_DATA_FOUND then 
        dbms_output.put_line('Invalid employee number'); 
   end print_sal;  
   
   FUNCTION uf_age
(
   pssn IN VARCHAR2 
  ,ptype IN NUMBER --  1(���� ����)  0(������)
)
RETURN NUMBER
IS
   �� NUMBER(4);  -- ���س⵵
   �� NUMBER(4);  -- ���ϳ⵵
   �� NUMBER(1);  -- ���� ���� ����    -1 , 0 , 1
   vcounting_age NUMBER(3); -- ���� ���� 
   vamerican_age NUMBER(3); -- �� ���� 
BEGIN
   -- ������ = ���س⵵ - ���ϳ⵵    ������������X  -1 ����.
   --       =  ���³��� -1  
   -- ���³��� = ���س⵵ - ���ϳ⵵ +1 ;
   �� := TO_CHAR(SYSDATE, 'YYYY');
   �� := CASE 
          WHEN SUBSTR(pssn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(pssn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(pssn,1,2);
   �� :=  SIGN(TO_DATE(SUBSTR(pssn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (����X)

   vcounting_age := �� - �� +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ��, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ��
                                         WHEN 1 THEN -1
                                         ELSE 0
                                        END;

   IF ptype = 1 THEN
      RETURN vcounting_age;
   ELSE 
      RETURN (vamerican_age);
   END IF;
--EXCEPTION
END uf_age;
  
END employee_pkg; 
-- Package Body EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.

SELECT name, ssn, EMPLOYEE_PKG.UF_AGE(ssn,1) age
FROM insa;
