-- HR 계정이 소유하고 있는 테이블 정보 조회
SELECT *
FROM TABS;
-- first_name + last_name -> name 조회
-- 오라클은 ''을 사용함 (문자열, 날짜 등등)
SELECT first_name||' '||last_name AS "N A M E"   -- 별칭(ALIAS)을 입력하는 경우에는 "" 사용    
    ,CONCAT(CONCAT(first_name, ' '), last_name) NAME_CON -- AS 생략 가능
FROM employees;