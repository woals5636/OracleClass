-- SCOTT
-- TRIGGER
--    ��ǰ���̺�
--    PK  ��ǰ      ������
--     1  �����     10
--     2  TV        5
--     3  ������     20
--    
--    �԰����̺�
--    �԰��ȣPK  �԰�¥    �԰��ǰ��ȣ(FK)  �԰����
--    1000        ???         2               30
--    
--    �Ǹ����̺�
--    �ǸŹ�ȣ    �Ǹų�¥    �ǸŻ�ǰ��ȣ(FK)  �Ǹż���
--    1000        ???         2               15

-- ��ǰ ���̺� �ۼ�
CREATE TABLE ��ǰ (
   ��ǰ�ڵ�      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,��ǰ��        VARCHAR2(30)  NOT NULL
  ,������        VARCHAR2(30)  NOT NULL
  ,�Һ��ڰ���     NUMBER
  ,������       NUMBER DEFAULT 0
);

-- �԰� ���̺� �ۼ�
CREATE TABLE �԰� (
   �԰��ȣ      NUMBER PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�԰�����     DATE
  ,�԰����      NUMBER
  ,�԰�ܰ�      NUMBER
);

-- �Ǹ� ���̺� �ۼ�
CREATE TABLE �Ǹ� (
   �ǸŹ�ȣ      NUMBER  PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�Ǹ�����      DATE
  ,�Ǹż���      NUMBER
  ,�ǸŴܰ�      NUMBER
);
--
-- ��ǰ ���̺� �ڷ� �߰�
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('AAAAAA', '��ī', '���', 100000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('BBBBBB', '��ǻ��', '����', 1500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('CCCCCC', '�����', '���', 600000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('DDDDDD', '�ڵ���', '�ٿ�', 500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
         ('EEEEEE', '������', '���', 200000);
COMMIT;

SELECT * FROM ��ǰ;

-- ����1) �԰� ���̺� ��ǰ�� �԰� �Ǹ� �ڵ����� ��ǰ ���̺��� ��������
-- update �Ǵ� Ʈ���� ���� + Ȯ��
-- �԰� ���̺� ������ �Է�  
-- ut_insIpgo
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER
INSERT ON �԰�
FOR EACH ROW -- �� ���� Ʈ����
BEGIN
   -- :NEW.��ǰ�ڵ� :NEW.�԰����
    UPDATE ��ǰ
    SET ������ = ������ + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
-- EXCEPTION
END;
-- Trigger UT_INSIPGO��(��) �����ϵǾ����ϴ�.
--
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);
COMMIT;
--
-- ����2) �԰� ���̺��� �԰� �����Ǵ� ���    ��ǰ���̺��� ������ ����. 
CREATE OR REPLACE TRIGGER ut_updIpgo
AFTER
UPDATE ON �԰�
FOR EACH ROW -- �� ���� Ʈ����
BEGIN
   -- :NEW.��ǰ�ڵ� :NEW.�԰����
    UPDATE ��ǰ
    SET ������ = ������ + :NEW.�԰���� - :OLD.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
-- EXCEPTION
END;
--
UPDATE �԰� 
SET �԰���� = 30 
WHERE �԰��ȣ = 5;
COMMIT;

-- ���� 3) �԰� ���̺��� �԰� ��ҵǾ �԰� ����.
-- ��ǰ���̺��� ������ ����. 
CREATE OR REPLACE TRIGGER ut_delIpgo
AFTER
DELETE ON �԰�
FOR EACH ROW -- �� ���� Ʈ����
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰����
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
-- EXCEPTION
END;
--
DELETE FROM �԰� 
WHERE �԰��ȣ = 5;
COMMIT;
-- ����4) �Ǹ����̺� �ǸŰ� �Ǹ� (INSERT) 
--       ��ǰ���̺��� �������� ����
-- ut_insPan
CREATE OR REPLACE TRIGGER ut_insPan
BEFORE
INSERT ON �Ǹ�
FOR EACH ROW -- �� ���� Ʈ����
DECLARE 
  vqty ��ǰ.������%TYPE;
BEGIN  
   SELECT ������ INTO vqty
   FROM ��ǰ
   WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   
   IF vqty < :NEW.�Ǹż��� THEN
     RAISE_APPLICATION_ERROR(-20007, '������ �������� �Ǹ� ����');
   ELSE   
    UPDATE ��ǰ
    SET ������ = ������  - :NEW.�Ǹż���
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   END IF;  
   -- COMMIT;
-- EXCEPTION
END; 
--
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
               (1, 'AAAAAA', '2023-11-10', 5, 1000000);
 
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
               (2, 'AAAAAA', '2023-11-12', 50, 1000000);
COMMIT; 

-- ����5) �ǸŹ�ȣ 1  20     �Ǹż��� 5 -> 10 
-- updPan
CREATE OR REPLACE TRIGGER updPan
BEFORE
UPDATE ON �Ǹ�
FOR EACH ROW
DECLARE 
  vqty ��ǰ.������%TYPE;
BEGIN  
   SELECT ������ INTO vqty
   FROM ��ǰ
   WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   
   IF (vqty + :OLD.�Ǹż���) < :NEW.�Ǹż��� THEN
     RAISE_APPLICATION_ERROR(-20007, '������ �������� �Ǹ� ����');
   ELSE   
    UPDATE ��ǰ
    SET ������ = ������ + :OLD.�Ǹż��� - :NEW.�Ǹż���
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   END IF;  
   -- COMMIT;
-- EXCEPTION
END;
-- Trigger UPDPAN��(��) �����ϵǾ����ϴ�.
UPDATE �Ǹ� 
SET �Ǹż��� = 10
WHERE �ǸŹ�ȣ = 1;
COMMIT;

-- ����6)�ǸŹ�ȣ 1   (AAAAA  10)   �Ǹ� ��� (DELETE)
--      ��ǰ���̺� ������ ����
--      ut_delPan
CREATE OR REPLACE TRIGGER   ut_delPan
AFTER
DELETE ON �Ǹ�
FOR EACH ROW -- �� ���� Ʈ����
BEGIN
     UPDATE ��ǰ
     SET ������ = ������ + :OLD.�Ǹż���
     WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
  -- COMMIT/ROLLBACK X
-- EXCEPTION
END;
--
DELETE FROM �Ǹ� 
WHERE �ǸŹ�ȣ=1;
COMMIT;
--
SELECT * FROM �Ǹ�;
SELECT * FROM �԰�;
SELECT * FROM ��ǰ;

-- [ ����ó�� �� ���� ]
INSERT INTO emp(empno,ename,deptno)
VALUES(9999,'admin',90);
-- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found

CREATE OR REPLACE PROCEDURE up_exceptiontest
(
    psal emp.sal%TYPE
)
IS
    vename emp.ename%TYPE;
BEGIN
    SELECT ename INTO vename
    FROM emp
    WHERE sal = psal;
    DBMS_OUTPUT.PUT_LINE('> vename = ' || vename );
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;

EXEC up_exceptiontest(800);

-- (TOO_MANY_ROWS) ORA-01422: exact fetch returns more than requested number of rows
EXEC up_exceptiontest(2850);

-- (NO_DATA_FOUND) ORA-01403: no data found
EXEC up_exceptiontest(9000);

SELECT * FROM emp;

-- �̸� ���� ���� ���� ���� ó�� ���
INSERT INTO emp(empno,ename,deptno)
VALUES(9999,'admin',90);
-- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found

CREATE OR REPLACE PROCEDURE up_insertemp
(
    pempno emp.empno%TYPE
    , pename emp.ename%TYPE
    , pdeptno emp.deptno%TYPE
)
IS
    PARENT_KEY_NOT_FOUND EXCEPTION;
    PRAGMA EXCEPTION_INIT (PARENT_KEY_NOT_FOUND, -02291);
BEGIN
    INSERT INTO emp(empno, ename, deptno)
    VALUES (pempno, pename, pdeptno);
    COMMIT;
EXCEPTION
  WHEN PARENT_KEY_NOT_FOUND THEN
    RAISE_APPLICATION_ERROR(-20011, '> QUERY FK VIOLATED.');
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;
--
EXEC up_insertemp(9999,'admin',90);
-- [ ����ڰ� ������ ���� ó����� ]

-- sal ������ A~B  ī����
--                  0   ���� ������ ���� ������ �߻�

EXEC up_myexception(800,1200);

-- ����� ���� ���� �߻� ORA-20022: > QUERY ������� 0�̴�.
EXEC up_myexception(6000,7200);

CREATE OR REPLACE PROCEDURE up_myexception
(
     plosal NUMBER
   , phisal NUMBER
)
IS 
  vcount NUMBER;
  
  -- 1. ����� ���� ���� ��ü(����) ����
  ZERO_EMP_COUNT EXCEPTION;
BEGIN
  SELECT COUNT(*) INTO vcount
  FROM emp
  WHERE sal BETWEEN plosal AND phisal;
  IF vcount = 0 THEN
    -- ������ ����� ������ ���� �߻�
    RAISE ZERO_EMP_COUNT;
  ELSE
    DBMS_OUTPUT.PUT_LINE( '> ����� : ' || vcount );  
  END IF;
  
EXCEPTION
    WHEN ZERO_EMP_COUNT THEN
    RAISE_APPLICATION_ERROR(-20022, '> QUERY ������� 0�̴�.');
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, '> QUERY NO DATA FOUND.');
    WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;




