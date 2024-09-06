-- ORACLE ���� - ���̺� ����
-- MSSQL
create table cstVSBoard (
  seq int identity (1, 1) not null primary key clustered,
  writer varchar (20) not null ,
  pwd varchar (20) not null ,
  email varchar (100) null ,
  title varchar (200) not null ,
  writedate smalldatetime not null default (getdate()),
  readed int not null default (0),
  mode tinyint not null ,
  content text null
)

-- ORACLE
CREATE SEQUENCE seq_tblcstVSBoard
NOCACHE;

CREATE TABLE tbl_cstVSBoard (
  seq NUMBER NOT NULL PRIMARY KEY,
  writer VARCHAR2 (20) NOT NULL,
  pwd VARCHAR2 (20) NOT NULL,
  email VARCHAR2 (100),
  title VARCHAR2 (200) NOT NULL,
  writedate DATE DEFAULT SYSDATE,
  readed NUMBER DEFAULT 0,
  tag NUMBER (1) NOT NULL,
  content CLOB
);

--
BEGIN
   FOR i IN 1..150 LOOP
       INSERT INTO tbl_cstVSBoard ( seq,  writer, pwd, email, title, tag,  content) 
       VALUES ( SEQ_TBLCSTVSBOARD.NEXTVAL, 'ȫ�浿' || MOD(i,10), '1234'
       , 'ȫ�浿' || MOD(i,10) || '@sist.co.kr', '����...'  || i, 0, '����...' || i );
   END LOOP;
   COMMIT;
END;
--
BEGIN
    UPDATE tbl_cstVSBoard
    SET writer = '�̽���'
    WHERE MOD(seq,15) = 2;
    COMMIT;
END;
--
BEGIN
    UPDATE tbl_cstVSBoard
    SET writer = '���ؿ�'
    WHERE MOD(seq,15) = 4;
    COMMIT;
END;
--
BEGIN
    UPDATE tbl_cstVSBoard
    SET title = '�Խ��� ����'
    WHERE MOD(seq,15) IN(3,5,8);
    COMMIT;
END;
-- ���� ������ ��ȣ : 1
-- �� �������� ����� ���ڵ� �� : 10
-- (TOP-N ���)

SELECT * 
FROM(
    SELECT ROWNUM no, t.*
    FROM(
        SELECT seq, title, writer, email, writedate, readed
        FROM tbl_cstVSBoard
        ORDER BY seq DESC
    ) t
)b
WHERE no BETWEEN 1 AND 10;
