-- HR 계정이 소유하고 있는 테이블 정보 조회
select *
from tabs;
-- first_name last_name     name 조회

-- ORA-01722: invalid number 앞뒤에 숫자가 와야 함
-- 자바: 문자열 연결 연산자 +
-- 오라클:     ", 힘수, 방법 ?      '문자열' '날짜형' '홑 따옴표'
SELECT FIRST_NAME fname
    ,FIRST_NAME ||' '|| LAST_NAME as "NAME"            -- 공백 주기
    ,concat( concat(first_name,' '), last_name) as NAME -- name 쌍따옴표 생략 가능
    ,concat( concat(first_name,' '), last_name) NAME -- AS 생략 가능
FROM EMPLOYEES;

