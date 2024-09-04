-- SCOTT
-- 1) SCOTT 소유한 테이블 목록 조회.
SELECT *
FROM dba_tables;
FROM all_TABLES;
FROM USER_TABLES;
FROM TABS;
-- 차이점

-- INSA 테이블 구조 파악
DESCRIBE INSA;
DESC INSA;
-- NOT NULL은 필수 입력 사항이다.

-- NUMBER(5) = NUMBER(5.0) 뒤는 소숫점 자릿수
-- VARCHAR2(20) 문자는 3바이트 이므로 6문자가 올 수 있음

-- INSA 모든 사원 정보를 조회.
SELECT *
FROM INSA;
-- IBSADATE 입사일자
-- '98/10/11' 'RR/MM/DD'    'YY/MM/DD' 차이점

SELECT * 
FROM v$nls_parameters;

-- SELECT 절 처리 순서 적어보기
1 [WITH]        
6 SELECT      
2 FROM        
3 [WHERE]      
4 [GROUP BY]    
5 [HAVING]      
7 [ORDER BY]    

-- EMP 테이블에서 사원 정보 조회( 사원번호, 사원명, 입사일자) 조회
SELECT EMPNO, ENAME, HIREDATE
FROM EMP;

-- 월급(PAY) = 기본급(SAL) + 수당(COMM) 컬럼을 추가해서 조회하자.
SELECT EMPNO, ENAME, HIREDATE
--    ,SAL , COMM
--    ,NVL(COMM,0)
--    ,NVL2 (COMM, COMM, 0)
--    ,SAL + COMM
--    ,SAL + NVL(COMM,0)
    ,SAL + NVL(COMM,0) AS PAY
FROM EMP;

-- 1) 오라클 NULL 의미? 미확인 값.
-- 2) 월급 계산도 이상함: NULL 값을 갖고 계산하면 결과는 전부다 NULL이다.



-- 문제) emp 테이블에서 사원번호, 사원명, 직속상사 조회
--      직속상사가(NULL)일 경우 'CEO'라고 출력.
SELECT EMPNO, ENAME, MGR
    -- , NVL(MGR,'CEO') -- ORA-01722: invalid number
    -- , NVL(MGR,0)
    , NVL(TO_CHAR(MGR), 'CEO')
    , NVL(MGR ||'','CEO')
FROM EMP;

DESC EMP; -- MGR의 자료형이 숫자형이기 때문에 숫자로만 대체가 되는 상태임

-- EMP 테이블에서 사원 정보를 이런식으로 출력하고자 한다.
-- 이름은 'SMITH'이고, 직업은 CLERK이다.
-- 자바에서 System.out.printf(”이름은 \“%s\” 입니다.”, “홍길동”);
SELECT '이름은 '''|| ENAME ||''' 이고, 직업은 '''|| JOB ||'''이다.'
FROM EMP;

SELECT '이름은' ||''''|| ENAME ||''''|| 
       '이고, 직업은' ||''''|| JOB ||''''|| '이다.'
FROM EMP;

-- 김준석 65 -> A CHR()
SELECT '이름은 '|| CHR(39) || ename|| CHR(39) || '이고, 직업은 '||job||'이다'
FROM EMP;


-- SYS으로 가서 모든 사용자 정보 조회.


SELECT *
FROM DEPT;

-- 문제) EMP 테이블에서 부서번호가 10번인 사원들만 조회

-- EMP 테이블에서 각 사원이 속해 있는 부서번호만 조회
SELECT *
FROM EMP
WHERE DEPTNO = '10';

-- 문제) EMP 테이블에서 10번 부서원만 제외한 나머지 사원들 정보 조회.

SELECT *
FROM EMP
WHERE DEPTNO = '10'OR DEPTNO = '30' OR DEPTNO = '10';
-- 오라클에서 논리 연산자 OR에 해당하는 거이 무엇인지...
-- 자바 논리연산자 : &&, ||, !
-- 오라클 논리연산자 : AND OR NOT
SELECT *
FROM EMP
WHERE NOT (DEPTNO = '10');
WHERE DEPTNO != '10';
WHERE DEPTNO ^= '10';
WHERE DEPTNO <> '10';

-- 문제) EMP 테이블에서 10번 부서원만 제외한 나머지 사원들 정보 조회.
SELECT *
FROM EMP
WHERE DEPTNO != '10';
--
SELECT *
FROM EMP
WHERE DEPTNO IN ('20','30','40');
WHERE DEPTNO = '20' OR DEPTNO = '30' OR DEPTNO = '40';
-- NOT IN (LIST) SQL 연산자

-- [문제] EMP 테이블에서 사원명이 FORD인 사원의 모든 사원정보를 출력(조회)

SELECT *
FROM EMP
--WHERE ENAME = 'FORD';
WHERE ENAME ='FORD'; -- 값을 가지고 비교할 때는 대소문자를 정확하게 주어야 한다.

SELECT *
FROM emp
WHERE ename = UPPER('foRd');

SELECT LOWER(ENAME), INITCAP(JOB)
FROM EMP;

-- [문제] emp 테이블에서 커미션이 NULL인 사원의 정보 출력(조회)
SELECT *
FROM emp
WHERE comm = IS NOT NULL;
WHERE comm = IS NULL;
WHERE comm = NULL;

-- [문제] 2000 이상 월급(pay) 이하 4000 받는 사원의 정보를 출력(조회)
-- emp 테이블에서
-- pay = sal + comm
SELECT e.* , sal + NVL(comm, 0) as PAY
FROM emp e
WHERE pay >=2000 AND pay <=4000; --ORA-00904: "EMP"."PAY": invalid identifier
--
SELECT e.* , sal + NVL(comm, 0) as PAY
FROM emp e
WHERE (sal + NVL(comm, 0)) >=2000 AND (sal + NVL(comm, 0)) <=4000;
-- WITH 절 사용
WITH temp AS(
    SELECT emp.*,(sal + NVL(comm, 0)) pay 
    FROM emp
)
SELECT *
FROM temp
WHERE pay >= 2000 AND pay <= 4000;
-- 인라인뷰 (IN-LINE view)
-- NOT BETWEEN A AND B  SQL연산자 사용
SELECT *
FROM(
    SELECT emp.*,(sal + NVL(comm, 0)) pay 
    FROM emp
    )e
WHERE pay BETWEEN 2000 AND 4000;
WHERE pay >= 2000 AND pay <= 4000;
WHERE e.pay >= 2000 AND e.pay <= 4000;

-- [문제] insa 테이블에서 70년대생인 사원의 정보를 조회(출력)
--  이름, 주민등록번호
SELECT name,ssn
    ,SUBSTR(SSN,1,1)
    ,SUBSTR(SSN,1,1)
    ,SUBSTR(SSN,1,2) -- '77' 문자
    ,INSTR(SSN,0)
FROM INSA
WHERE INSTR(SSN,7)=1;
WHERE TO_NUMBER(SUBSTR(ssn,0,2))BETWEEN 70 AND 79;
WHERE SUBSTR(SSN,1,1) = 7;
-- SUBSTR() -- 
SELECT name,ssn
--    ,SUBSTR(ssn,0,8)||'******' RRN
--    ,CONCAT(SUBSTR(ssn,0,8),'******')RRN
--    ,RPAD( SUBSTR(ssn,0,8), 14, '*')RRN
--    ,SUBSTR(ssn,-6)
--    ,REPLACE(ssn,SUBSTR(ssn,-6),'******')RRN
    ,REGEXP_REPLACE(ssn, '(\d{6}-\d)\d{6}', '\1******')RRN
FROM insa;
--
SELECT name,ssn
    ,SUBSTR(ssn,0,6)
    ,SUBSTR(ssn,0,2)YEAR
    ,SUBSTR(ssn,3,2)MONTH
--    ,SUBSTR(ssn,5,2)DATE    --ORA-00923: FROM keyword not found where expected
    ,SUBSTR(ssn,5,2)"DATE"      --DATE는 예약어이기 때문에 ""를 붙여 별칭으로 변환
    ,TO_DATE(SUBSTR(ssn,0,6))BIRTH-- '771212' 문자열 -> 날짜 형 변환
    --'77/12/12' DATE -> 년,월,일,시간,분,초
    ,TO_CHAR( TO_DATE(SUBSTR(ssn,0,6)),'YY') y
FROM insa
WHERE TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)),'YY') BETWEEN 70 AND 79;
WHERE TO_DATE((SUBSTR(ssn,0,6)) BETWEEN '70/01/01/' AND '79/12/31';
--
SELECT ename, hiredate
--    ,TO_CHAR(HIREDATE,'YYYY')Y -- 0000 년도 4글자
    ,TO_CHAR(HIREDATE,'YY')Y
    ,TO_CHAR(HIREDATE,'MM')M
    ,TO_CHAR(HIREDATE,'DD')D
    ,TO_CHAR(HIREDATE,'DY')DY -- 요일 1글자
--    ,TO_CHAR(HIREDATE,'DAY')DAY -- 요일 3글자
    
    -- EXTRACT() 추출하다.
    ,EXTRACT( YEAR FROM hiredate)
    ,EXTRACT( MONTH FROM hiredate)
    ,EXTRACT( DAY FROM hiredate)
    
    
FROM emp;

-- 오늘 날짜에서 년도/월/일/시간/분/초 얻어오가자 해요.
SELECT SYSDATE
    ,TO_CHAR(SYSDATE,'DS TS')
    ,CURRENT_TIMESTAMP
FROM DEPT;

-- insa 테이블에서 70년대 출생 사원 정보 조회.
-- LIKE     SQL연산자
-- REGEXP_LIKE 함수
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn,'^7.12');
WHERE REGEXP_LIKE(ssn,'^7[0-9]12');
WHERE REGEXP_LIKE(ssn,'^7\d12');

WHERE REGEXP_LIKE(ssn,'^7.12');

WHERE REGEXP_LIKE(ssn,'^78');

WHERE ssn LIKE '7_12%'; -- 70년 12월 생의 사원 출력
WHERE ssn LIKE '______-1______';
WHERE ssn LIKE '%-1%';  -- SSN에서 ~-1~ 형태
WHERE name LIKE '%숙';   -- ~숙  형태
WHERE name LIKE '%말%';  -- ~말~ 형태
WHERE name LIKE '김%';   -- 김~  형태

-- [문제] insa 테이블에서 김씨 성을 제외한 모든 사원  출력
SELECT *
FROM insa
WHERE REGEXP_LIKE( name, '^[^김]');
WHERE NOT REGEXP_LIKE( name, '^김');
WHERE REGEXP_LIKE( name, '^김');
WHERE NOT name LIKE '김%';
WHERE name NOT LIKE '김%';   -- 김~  형태
-- [문제]출신도가 서울, 부산, 대구 이면서 전화번호에 5 또는 7이 포함된 자료 출력하되
--      부서명의 마지막 부는 출력되지 않도록함. 
--      (이름, 출신도, 부서명, 전화번호)
SELECT name,city,SUBSTR(buseo,0,LENGTH(buseo)-1) BUSEO,tel
FROM insa
WHERE
-- city IN('서울','부산','대구')
REGEXP_LIKE(city,'서울|부산|대구')
-- AND (tel like '%5%' or tel like '%7%');
AND REGEXP_LIKE(tel,'[57]');