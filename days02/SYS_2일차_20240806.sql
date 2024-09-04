-- SYS
SELECT*
FROM ALL_USERS;
-- 또는 FROM DBA_USERS;

-- SYS 계정이 사용할 수 있는 모든 테이블 정보를 조회. 
-- + (OWNER가 SCOTT인 테이블 정보만 조회하고 싶다.)
SELECT *
FROM ALL_TABLES
-- 또는 FROM DBA_TABLES;
WHERE OWNER = 'SCOTT';
-- 조건 OWNER가 SCOTT인;
FROM dba_tables;
--
SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = 'DATE';












