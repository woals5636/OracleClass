-- HR ������ �����ϰ� �ִ� ���̺� ���� ��ȸ
SELECT *
FROM TABS;
-- first_name + last_name -> name ��ȸ
-- ����Ŭ�� ''�� ����� (���ڿ�, ��¥ ���)
SELECT first_name||' '||last_name AS "N A M E"   -- ��Ī(ALIAS)�� �Է��ϴ� ��쿡�� "" ���    
    ,CONCAT(CONCAT(first_name, ' '), last_name) NAME_CON -- AS ���� ����
FROM employees;