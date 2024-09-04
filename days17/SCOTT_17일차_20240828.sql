-- SCOTT
-- �����ͺ��̽� ���� ������ ���ν���, �Լ��鿡 ���� �����ͺ��̽� ���� �����췯��
-- ������ �ð��� �ڵ����� �۾��� ����� �� �ֵ��� �ϴ� ����̴�

-- ���� 2����
-- 1) �� DBMS_JOB ��Ű��
-- 2) DBMS_SCHEDULAR ��Ű�� ( Oracle 10g ���� )

-- 1) ���ν���, �Լ� �غ�
-- 2) ������ ����
-- 3) �� ���� / ���� / ���� ��� üũ
CREATE TABLE tbl_job
(
    seq NUMBER
    , insert_date DATE
);
-- Table TBL_JOB��(��) �����Ǿ����ϴ�.

CREATE OR REPLACE PROCEDURE up_job
-- ()
IS
    vseq NUMBER;
BEGIN
    SELECT NVL(MAX(seq),0) + 1 INTO vseq
    FROM tbl_job;
    
    INSERT INTO tbl_job VALUES(vseq, SYSDATE);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM); -- SQL ���� ���
END;
-- Procedure UP_JOB��(��) �����ϵǾ����ϴ�.

-- �� ��� ( DBMS_JOB.SUBMIT ���ν��� ��� )
SELECT *
FROM user_jobs; -- ��ϵ� ���� ��ȸ
-- �͸� ���ν���( �� ��� )
DECLARE
    vjob_no NUMBER;
BEGIN
    DBMS_JOB.SUBMIT(
        job => vjob_no -- ������ ��ϵ� �� ��Ϲ�ȣ ��ȯ�ϴ� ��¿� �Ķ����
        , what => 'UP_JOB' -- ����� ���ν���, �Լ�
        , next_date => SYSDATE -- ���� ����� ��¥(�ð�)
        -- [ ���� ���� �ֱ� ]
        -- , interval => ' SYSDATE + 1 ' �Ϸ翡 �ѹ� ���ڿ� ����
        -- , interval => ' SYSDATE + 1/24 ' �� �ð� ���� �ѹ� ���ڿ� ����
        -- , interval => 'NEXT_DAY(TRUNC(SYSDATE),'�Ͽ���') + 15/24'
        --    ���� �Ͽ��� ����3�� ����.
        -- , interval => 'LAST_DAY(TRUNC(SYSDATE)) + 18/24 + 30/60/24'
        --    �ſ� ������ ����   6�� 30�� ����..
        , interval => 'SYSDATE + 1/24/60' -- �� �и���
        -- ,  no_parse true/[false] ���ν����� �Ľ� ����
        -- ,instance ���� ����� �� �� ���� �����ų �� �ִ� Ư�� �ν��Ͻ�
        -- , force
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE( '�� ��ϵ� ��ȣ : ' || vjob_no);
END;

DECLARE
  vjob_no NUMBER;
BEGIN
    DBMS_JOB.SUBMIT(
         job => vjob_no
       , what => 'UP_JOB;'
       , next_date => SYSDATE
       -- , interval => 'SYSDATE + 1'  �Ϸ翡 �� ��  ���ڿ� ����
       -- , interval => 'SYSDATE + 1/24'
       -- , interval => 'NEXT_DAY(TRUNC(SYSDATE),'�Ͽ���') + 15/24'
       --    ���� �Ͽ��� ����3�� ����.
       -- , interval => 'LAST_DAY(TRUNC(SYSDATE)) + 18/24 + 30/60/24'
       --    �ſ� ������ ����   6�� 30�� ����..
       , interval => 'SYSDATE + 1/24/60' -- �� �� ����       
    );
    COMMIT;
     DBMS_OUTPUT.PUT_LINE( '�� ��ϵ� ��ȣ : ' || vjob_no );
END;

SELECT seq, TO_CHAR(insert_date, 'DL TS')
FROM tbl_job;
-- �� ���� : DBMS_JOB.BROKEN
BEGIN
    DBMS_JOB.BROKEN(1,true);
    COMMIT;
END;
-- �� ����� : DBMS_JOB.BROKEN
BEGIN
    DBMS_JOB.BROKEN(1,false);
    COMMIT;
END;

-- ���� ���� �ֱ�� ������� ����
BEGIN
    DBMS_JOB.RUN(1);
    COMMIT;
END;
-- �� ����
BEGIN
    DBMS_JOB.REMOVE(1);
END;
-- �� �Ӽ� ���� : DBMS_JOB.CHANGE ���ν��� ���...