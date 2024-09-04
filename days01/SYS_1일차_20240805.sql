-- 모든 사용자 정보를 조회하는 질의(쿼리)
SELECT *
FROM all_users;
-- 실행 : F5, Ctrl + Enter
-- SCOTT/tiger 계정 생성 / 비밀번호는 대소문자를 구분한다
CREATE USER SCOTT IDENTIFIED BY tiger;
SELECT * FROM dba_users;
-- SYS CREATE SESSION 권한 부여
-- GRANT CREATE SESSION TO SCOTT;
GRANT CONNECT,RESOURCE TO SCOTT;
-- Grant을(를) 성공했습니다.

SELECT * FROM DBA_TABLES;
SELECT * FROM ALL_TABLES;
SELECT * FROM USER_TABLES; -- 뷰(View)
SELECT * FROM TABS;

-- ORA-01940: cannot drop a user that is currently connected
-- ORA-01922: CASCADE must be specified to drop 'SCOTT'
DROP USER SCOTT;

DROP USER SCOTT CASCADE;

CREATE USER SCOTT IDENTIFIED BY tiger;

-- 모든 사용자 정보 조회
-- hr 계정 정보 확인 ( 샘플 계정 )
SELECT * FROM ALL_USERS;
-- hr 계정의 비밀번호 lion 으로 수정한 후 오라클 접속(녹색)
CREATE USER
DROP USER

ALTER USER HR IDENTIFIED BY lion;

-- 계정 
ALTER USER HR ACCOUNT UNLOCK IDENTIFIED BY lion;

-- madang 계정 생성 / 비밀번호 dog
CREATE USER madang IDENTIFIED BY dog;
-- madang 계정에 권한 부여
GRANT CONNECT,RESOURCE TO MADANG;
-- 계정 언락
ALTER USER madang ACCOUNT UNLOCK IDENTIFIED BY dog;
