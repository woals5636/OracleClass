-- ��� ����� ������ ��ȸ�ϴ� ����(����)
SELECT *
FROM all_users;
-- ���� : F5, Ctrl + Enter
-- SCOTT/tiger ���� ���� / ��й�ȣ�� ��ҹ��ڸ� �����Ѵ�
CREATE USER SCOTT IDENTIFIED BY tiger;
SELECT * FROM dba_users;
-- SYS CREATE SESSION ���� �ο�
-- GRANT CREATE SESSION TO SCOTT;
GRANT CONNECT,RESOURCE TO SCOTT;
-- Grant��(��) �����߽��ϴ�.

SELECT * FROM DBA_TABLES;
SELECT * FROM ALL_TABLES;
SELECT * FROM USER_TABLES; -- ��(View)
SELECT * FROM TABS;

-- ORA-01940: cannot drop a user that is currently connected
-- ORA-01922: CASCADE must be specified to drop 'SCOTT'
DROP USER SCOTT;

DROP USER SCOTT CASCADE;

CREATE USER SCOTT IDENTIFIED BY tiger;

-- ��� ����� ���� ��ȸ
-- hr ���� ���� Ȯ�� ( ���� ���� )
SELECT * FROM ALL_USERS;
-- hr ������ ��й�ȣ lion ���� ������ �� ����Ŭ ����(���)
CREATE USER
DROP USER

ALTER USER HR IDENTIFIED BY lion;

-- ���� 
ALTER USER HR ACCOUNT UNLOCK IDENTIFIED BY lion;

-- madang ���� ���� / ��й�ȣ dog
CREATE USER madang IDENTIFIED BY dog;
-- madang ������ ���� �ο�
GRANT CONNECT,RESOURCE TO MADANG;
-- ���� ���
ALTER USER madang ACCOUNT UNLOCK IDENTIFIED BY dog;
