-- HR ������ �����ϰ� �ִ� ���̺� ���� ��ȸ
select *
from tabs;
-- first_name last_name     name ��ȸ

-- ORA-01722: invalid number �յڿ� ���ڰ� �;� ��
-- �ڹ�: ���ڿ� ���� ������ +
-- ����Ŭ:     ", ����, ��� ?      '���ڿ�' '��¥��' 'Ȭ ����ǥ'
SELECT FIRST_NAME fname
    ,FIRST_NAME ||' '|| LAST_NAME as "NAME"            -- ���� �ֱ�
    ,concat( concat(first_name,' '), last_name) as NAME -- name �ֵ���ǥ ���� ����
    ,concat( concat(first_name,' '), last_name) NAME -- AS ���� ����
FROM EMPLOYEES;

