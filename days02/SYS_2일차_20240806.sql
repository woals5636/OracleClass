-- SYS
SELECT*
FROM ALL_USERS;
-- �Ǵ� FROM DBA_USERS;

-- SYS ������ ����� �� �ִ� ��� ���̺� ������ ��ȸ. 
-- + (OWNER�� SCOTT�� ���̺� ������ ��ȸ�ϰ� �ʹ�.)
SELECT *
FROM ALL_TABLES
-- �Ǵ� FROM DBA_TABLES;
WHERE OWNER = 'SCOTT';
-- ���� OWNER�� SCOTT��;
FROM dba_tables;
--
SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = 'DATE';












