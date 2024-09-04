-- SCOTT
-- [오라클 연산자(OPERATOR) 정리]
-- 1) 비교 연산자 : = != > < <= >=
--            WHERE 절에서 숫자, 문자, 날짜를 비교할 때 사용
--            ANY, SOME, ALL 비교 연산자, SQL 연산자 
-- 2) 논리 연산자 : AND, OR, NOT
--            WHERE 절에서 조건을 결합할 때 사용
-- 3) SQL 연산자 : SQL언어에만 존재하는 연산자
--            [NOT] IN (list)  
--            [NOT] BETWEEN a AND b
--            [NOT] LIKE 
--            IS [NOT] NULL 
--            ANY, SOME, ALL                    WHERE 절 + (서브쿼리)
--            EXISTS   -> TRUE/FALSE 값 반환     WHERE 절 + (서브쿼리)
-- 4) NULL 연산자 
-- 5) 산술 연산자 : 덧셈, 뺄셈, 곱셈, 나눗셈    (연산자 우선 순위 존재)
-- SELECT 5-3,5-3,5*3,5/3
--    ,FLOOR(5/3) --몫
--    ,MOD(5,3)   --나머지
-- FROM DUAL;
-- 6) SET(집합) 연산자
--  1. UNION        : 합집합
--  2. UNION ALL    : 합집합
-- ORA-00937: not a single-group group function
SELECT COUNT(*)
FROM(
    SELECT name, city, buseo
    FROM insa
    WHERE buseo = '개발부'
) I;
--
SELECT COUNT(*)
FROM(
    SELECT name, city, buseo
    FROM insa
    WHERE CITY = '인천'
) I;
--
SELECT COUNT(*)
FROM(
    SELECT name, city, buseo
    FROM insa
    WHERE CITY = '인천' AND buseo = '개발부'
) I;
-- 개발부 + 인천     사원들의 합집합
SELECT name, city, buseo
FROM insa
WHERE CITY = '인천'
  -- ORA-00933: SQL command not properly ended
-- UNION    -- 중복되지 않게
UNION ALL   -- 중복 허용
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
ORDER BY BUSEO;     -- UNION 문은 두번째 SELECT 문(마지막)에만 ORDER BY 절을 사용할 수 있다.
--
SELECT ename, hiredate, TO_CHAR(deptno)deptno
FROM emp
UNION
SELECT name, ibsadate, buseo
FROM insa;
-- 조인(JOIN)
-- 사원이름, 사원명, 입사일자, 부서명 조회
-- EMP  : 사원이름, 사원명, 입사일자
-- DEPT : 부서명
SELECT ename, hiredate, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
--
SELECT * FROM EMP;
SELECT * FROM dept;
-- ORA-00918: column ambiguously defined
SELECT empno, ename, hiredate, dname, dept.deptno
FROM emp, dept                      -- 조인
WHERE emp.deptno = dept.deptno;     -- 조인 조건
-- Alias 가능
SELECT empno, ename, hiredate, dname, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;
--
SELECT empno, ename, hiredate, dname, d.deptno
FROM emp e JOIN dept d ON e.deptno = d.deptno;

-- 사원테이블(자식테이블)
-- 사원번호/사원명/입사일자/잡/기본급/수당/부서번호(FK) 
--   1    a                          10       
--   2    b                          10       
--   3    c                          10       
--    
-- 부서테이블(부모테이블)
-- PK
-- 부서번호/부서명/부서장/부서내선번호
-- 10      영업  김재민  103
-- 20      개발  이시훈  102
-- 30 
-- 40


--  3. INTERSECT    : 교집합
-- 개발부 + 인천     사원들의 교집합
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE CITY = '인천'
ORDER BY BUSEO;

--  4. MINUS        : 차집합
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
MINUS
SELECT name, city, buseo
FROM insa
WHERE CITY = '인천'
ORDER BY BUSEO;

-- 
SELECT name, NULL city, buseo
-- 칼럼수가 다를 경우네는 임의의 NULL 자료형을 추가하여 UNION 실행 가능
FROM insa
WHERE buseo = '개발부'
UNION
SELECT name, city, buseo
FROM insa
WHERE CITY = '인천'
ORDER BY BUSEO;

-- [ 계층적 질의 연산자 ] PRIOR, CONNECT_BY_ROOT 연산자

-- IS [NOT] NAN : IS [NOT] NOT A NUMBER 숫자 여부
-- IS [NOT] INFINITE : 무한대 여부

--[오라클 함수(function)]
--1) 단일행 함수
--        ㄱ. 문자 함수
--          [UPPER] [LOWER] [INITCAP]
SELECT UPPER(dname), LOWER(dname), INITCAP(dname)
FROM dept;
--          [LENGTH] 문자열 길이
SELECT dname
    ,LENGTH(dname)
FROM dept;
--          [CONCAT] 첫번째 문자열과 두번째 문자열을 연결하여 리턴
--          [SUBSTR] 문자값 중 특정 위치부터 특정 길이만큼의 문자값만을 리턴
SELECT ssn, SUBSTR(ssn,-7)
FROM insa;
--          [INSTR] 문자값 중 지정된 문자값의 위치를 숫자로 리턴
--【형식】
--     {INSTR ? INSTRB ? INSTRC ? INSTR2 ? INSTR4} 
--        ( string, substring [, 시작점 [,몇번째] ] )
--    TBL_TEL 테이블
--   SEQ        TEL
--    1 	02)123-1234
--    2	    051)3456-2342
--    3	    031)1256-2343

SELECT TEL
    ,INSTR(tel,')') ")"
    ,INSTR(tel,'-') "-"
    ,LENGTH(tel) LEN
    -- 문제 1) 지역번호만 추출하여 출력
    ,SUBSTR(TEL,0,INSTR(tel,')')-1) "지역번호"
    -- 문제 2) 전화번호의 앞자리(3,4자리)
    ,SUBSTR(TEL,INSTR(tel,')')+1,INSTR(tel,'-')-INSTR(tel,')')-1) "앞자리"
    -- 문제 3) 전화번호의 뒷자리(4자리)
    ,SUBSTR(TEL,INSTR(tel,'-')+1) "뒷자리"
FROM tbl_tel;
--
SELECT dname
    , INSTR(dname,'S',1) F
    , INSTR(dname,'S',2) S
    , INSTR(dname,'S',-1) T
FROM dept;

-- [RPAD/LPAD] 지정된 길이에서 문자값을 채우고 남은 공간을 우(좌)측부터 특정값으로 채워 리턴
--【형식】
-- RPAD (expr1, n [, expr2] )

SELECT RPAD('Corea',12,'*')
FROM dual;

SELECT ename, sal + NVL(comm,0) pay
    ,LPAD( sal + NVL(comm,0),10,'*')
FROM  emp;

-- [RTRIM/LTRIM] 문자값중에서 우(좌)측으로부터 특정문자와 일치하는 문자값을 제거하여 리턴
SELECT RTRIM('BROWINGyxXxy','xy') "RTRIM ex"
    , LTRIM('****8978','*') "LTRIM ex"
    , '[' || TRIM('            8978              ') || ']' "TRIM ex"
FROM dual;

-- [ASCII] 지정한 숫자나 문자를 ASCII 코드값으로 바꾸어 리턴
SELECT ASCII('A'), CHR(65)
FROM dual;

SELECT ename
    ,SUBSTR(ename,1,1)
    ,ASCII(SUBSTR(ename,1,1)) "ASCII"
FROM emp;

-- [GREATEST() / LEAST()] 나열한 숫자나 문자중에서 가장 큰/작은 값을 리턴
-- 숫자
SELECT GREATEST(3,5,2,4,1) max
    ,LEAST(3,5,2,4,1) min
FROM dual;
-- 문자
SELECT GREATEST('R','Z','T','H','I') max
    ,LEAST('R','Z','T','H','I') min
FROM dual;

-- VSIZE(char) 지정된 문자열의 크기를 숫자값으로 리턴
SELECT VSIZE(1)     -- 숫자는 2바이트
    , VSIZE('A')    -- 영어는 1바이트
    , VSIZE('한')    -- 숫자는 3바이트
FROM dual;

--        ㄴ. 숫자 함수
--    [ ROUND(a,[b]) - 반올림하는 함수 / b 값은 양수 음수 모두 가능 ]
SELECT 3.141592
    ,ROUND(3.141592) A -- b X 
    ,ROUND(3.141592, 0) B -- b+1 자리에서 반올림 -> 소수점 첫번째 자리
    ,ROUND(3.141592, 3) C -- 소수점 4번째 자리에서 반올림
    ,ROUND(12345.6789, -2) D --  b값이 음수이면 소수점 왼쪽 b자리에서 반올림하여 출력
FROM dual;

--    [절삭함수 TRUNC() , FLOOR() 차이점 ]
SELECT FLOOR(3.141592) A
    ,FLOOR(3.941592) B -- 매개변수 하나로서 해당 값을 소수점 1번째에서 내림하여 출력
    ,TRUNC(3.941592, 0) C -- a를 소수점 이하 b+1자리에서 절삭하여 b자리까지 출력
    ,TRUNC(3.941592, 3) D
FROM dual;
-- [올림(절상) 함수 CEIL()]
SELECT CEIL(3.14)
    , CEIL(3.94)
FROM dual;

--게시판: 총 페이지 수를 계산할 때 사용
SELECT CEIL(161/10) page
    ,ABS(10), ABS(-10)
FROM dual;

-- SIGN 함수 / 입력 값의 부호를 판정한다 / 1 0 -1
SELECT SIGN(100) A    --  1
    ,SIGN(0) B        --  0
    ,SIGN(-100) C     -- -1
--  ,SIGN('A') D      -- 자료형 불일치
FROM dual;
-- POWER 함수 / POWER(n2.n1)에서 n2의 n1제곱한 값을 반환
SELECT POWER(5,2) A    --  25
FROM dual;
-- SQRT 함수 / 입력된 값의 제곱근 값을 반환
SELECT SQRT(4) A    --  2
FROM dual;
--        ㄷ. 날짜 함수
-- [SYSDATE] 현재의 날짜와 시간을 리턴
SELECT SYSDATE
FROM dual;
-- [ROUND(date)] 정오를 기준으로 날짜를 반올림하여 리턴
SELECT ROUND(SYSDATE) A
    ,ROUND(SYSDATE,'DD') B -- 정오를 기준으로 날짜를 반올림
    ,ROUND(SYSDATE,'MONTH') C -- 15일을 기준으로 월을 반올림
    ,ROUND(SYSDATE,'YEAR') D -- 한해의 절반(월)을 기준으로 년도를 반올림
FROM dual;

-- [TRUNC(date)] 날짜에서 시간부분을 절삭하여 00:00으로 바꾸어주는 함수

SELECT SYSDATE A
--    ,TO_CHAR(SYSDATE,'DS TS') NOW -- 현재시간
--    ,TRUNC(SYSDATE)  -- 시간/분/초 절삭
--    ,TO_CHAR(TRUNC(SYSDATE),'DS TS')
--    ,TRUNC(SYSDATE,'DD') -- 시간/분/초 절삭
--    ,TO_CHAR(TRUNC(SYSDATE,'DD'),'DS TS')
--    ,TRUNC(SYSDATE,'MONTH') -- 시간/분/초 절삭
--    ,TO_CHAR(TRUNC(SYSDATE,'DAY'),'DS TS') -- DAY : 요일
--    ,TO_CHAR(TRUNC(SYSDATE,'MONTH'),'DS TS')
    ,TO_CHAR(TRUNC(SYSDATE,'YEAR'),'DS TS')

FROM dual;

-- 날짜에 산술 연산을 사용하는 경우
SELECT SYSDATE
    , SYSDATE + 7       -- 7일 더하기
    , SYSDATE - 7       -- 7일 빼기
    , SYSDATE + 2/24    -- 2시간 더하기
    -- 날짜 - 날짜 = 일수 [날짜에 날짜를 감하여 일수 계산]
FROM dual;
-- 회사를 입사한 후 ~ 현재 날짜 까지 몇일 ?
SELECT ename, hiredate
    , CEIL(SYSDATE - hiredate) + 1 "근무일수"
FROM emp;
-- 문제) 우리가 개강일로 부터 현재 몇일이 지났는가?
SELECT SYSDATE
    ,'2024/07/01' AS S
    , TRUNC(SYSDATE) - TRUNC(TO_DATE('2024/07/01')) + 1 LAPSE
FROM DUAL;

-- [MONTHS_BETWEEN] 두 개의 날짜간의 달 차이를 리턴하는 함수
SELECT ename, hiredate, SYSDATE
    ,MONTHS_BETWEEN(SYSDATE, hiredate) 근무개월수
    ,MONTHS_BETWEEN(SYSDATE, hiredate)/12 근무년수
FROM emp;

-- [ADD_MONTHS] 특정 수의 달을 더한 날짜를 리턴하는 함수
SELECT SYSDATE
    ,SYSDATE + 1            -- 하루 증가
    ,ADD_MONTHS(SYSDATE,1)  -- 한달 증가
    ,ADD_MONTHS(SYSDATE,-1)  -- 한달 전
    ,ADD_MONTHS(SYSDATE,12) -- 일년 증가
FROM DUAL;
-- [LAST_DAY] 특정 날짜가 속한 달의 가장 마지막 날짜를 리턴하는 함수
SELECT SYSDATE
--    ,LAST_DAY(SYSDATE)--24/08/31
--    ,TO_CHAR(LAST_DAY(SYSDATE),'DDD')
--    ,TRUNC(SYSDATE,'MONTH')
--    ,TO_CHAR(TRUNC(SYSDATE,'MONTH'),'DAY')
    , ADD_MONTHS(TRUNC(SYSDATE,'MONTH'),1)-1
FROM dual;
-- [NEXT_DAY] 명시된 요일이 돌아오는 가장 최근의 날짜를 리턴하는 함수
SELECT SYSDATE
--    ,NEXT_DAY(SYSDATE,'일')
--    ,NEXT_DAY(SYSDATE,'금')
--    ,NEXT_DAY(SYSDATE,'월')
    ,NEXT_DAY(SYSDATE,'목') + 7 
FROM dual;

-- 문제) 10월 첫 번째 월요일 휴강...
SELECT NEXT_DAY(ADD_MONTHS(TRUNC(SYSDATE,'MONTH'),2),'월')
    , NEXT_DAY(TO_DATE('24/10/01'),'월')
FROM dual;

SELECT SYSDATE          -- 현재의 날짜와 시간을 리턴한다.
    , CURRENT_DATE      -- 현재의 날짜와 시간을 출력
    , CURRENT_TIMESTAMP -- 현재의 날짜와 밀리초 단위의 시간을 출력
FROM dual;
--        ㄹ. 변환 함수
-- [TO_NUMBER] 문자 타입을 숫자 타입으로 변환
--【형식】
--	TO_NUMBER(char [,fmt [,'nlsparam']])
SELECT '1234'
    ,TO_NUMBER('1234')
FROM DUAL;

-- TO_CHAR(NUMBER) / TO_CHAR(CHAR) / TO_CHAR(DATE) 문자로 변환함수
SELECT num, name
    , basicpay, sudang
    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang, 'L9G999G999D00') pay
    , TO_CHAR(basicpay + sudang, 'L9,999,999') pay
FROM insa;

SELECT
    TO_CHAR(100,'S9999')
    ,TO_CHAR(-100,'S9999')
    ,TO_CHAR(100,'9999MI')
    ,TO_CHAR(-100,'9999MI')
    
    ,TO_CHAR(100,'9999PR')
    ,TO_CHAR(-100,'9999PR') -- <100>
FROM dual;

--EMP 테이블 ename, sal, comm 으로 연봉 출력
SELECT ename, sal, comm
    ,sal + NVL(comm,0) pay
    ,TO_CHAR((sal + NVL(comm,0))*12, 'L9,999') 연봉
    ,TO_CHAR((sal + NVL(comm,0))*12, 'L999,999,999') 연봉
FROM emp;

--
SELECT name,ibsadate
    ,TO_CHAR(ibsadate,'YYYY.MM.DD.DAY')
    ,TO_CHAR(ibsadate,'YYYY"년" MM"월" DD"일" DAY')
    -- 기존 형식외에 추가적인 텍스트는 ""를 사용한다
FROM insa;

--        ㅁ. 일반 함수
-- [COALESCE] 나열해 놓은 값을 순차적으로 체크하여 null이 아닌 값을 리턴하는 함수
SELECT ename, sal, comm
    ,sal + NVL(comm,0)pay
    ,sal + NVL2(comm,comm,0)pay
    ,COALESCE(sal+comm, sal, 0)
FROM emp;
-- [DECODE] **중요**
-- 여러 개의 조건을 주어 조건에 맞을 경우 해당 값을 리턴하는 함수(IF...THEN...ELSE...처럼)

-- DECODE 함수
-- ㄴ 프로그래밍 언어의 if문을 sql, pl/sql 안으로 끌어오기 위해서 만들어진 오라클 함수
-- ㄴ FROM 절 외에 모두 사용 가능
-- ㄴ 비교 연산은 =  만 가능하다.
-- ㄴ DECODE 함수의 확장 함수 : CASE 함수

--  ex1)
--    if( A = B ) {
--        return C;
--    }
--    else{
--        return D;
--    }
--    ==> DECODE(A,B,C,D);
--  ex2)
--    if( A = B ) {
--        return ㄱ;
--    }else if( A = C ){
--        return ㄴ;
--    }else if( A = D ){
--        return ㄷ;
--    }else if( A = E ){
--        return ㄹ;
--    }else{
--        return ㅁ;
--    }
--    ==> DECODE(A,B,ㄱ,C,ㄴ,D,ㄷ,E,ㄹ,ㅁ);

SELECT name
    , ssn
    , NVL2(NULLIF(SUBSTR(ssn,-7,1),TO_CHAR(2)),'남자','여자') GENDER
FROM insa;

SELECT name, ssn
    ,MOD(SUBSTR(ssn,-7,1),2)
    ,DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자','남자') GENDER
FROM insa;
-- 문제) emp 테이블에서 sal의 10%인상을 하자.
SELECT ename, sal, comm
--  , sal * 1.1 "10% 인상된 sal"
    , sal + sal * 0.1 "10% 인상된 sal"
FROM emp;

-- 문제) emp 테이블에서 10번 부서원 pay 15%
--                   20번 부서원 pay 15%
--                   그 외 부서원 pay 20% 인상
SELECT deptno, ename, sal, comm
    ,(sal+NVL(comm,0))pay
    ,(sal+NVL(comm,0)) * DECODE(deptno,10,1.15
                                      ,20,1.15
                                      ,1.2) "인상된 PAY"
--    ,DECODE(deptno,10,(sal+NVL(comm,0))*1.15
--                  ,20,(sal+NVL(comm,0))*1.15
--                  ,(sal+NVL(comm,0))*1.2) "인상된 PAY"
FROM emp;

-- 위 구문을 인라인뷰로 수정
SELECT deptno, ename, sal, comm, pay,
       pay * DECODE(deptno, 10, 1.15,
                            20, 1.15,
                            1.2) AS "인상된 PAY"
FROM (
    SELECT deptno, ename, sal, comm, (sal + NVL(comm, 0)) AS pay
    FROM emp
) E;

-- [CASE] **중요**
-- 여러 개의 조건을 주어 조건에 맞을 경우 해당 값을 리턴하는 함수(DECODE의 확장임)
SELECT name, ssn
    ,MOD(SUBSTR(ssn,-7,1),2)
    ,DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자','남자') GENDER
    ,CASE MOD(SUBSTR(ssn,-7,1),2) WHEN 1 THEN '남자'
                                --WHEN 0 THEN '여자'
                                  ELSE '여자'
    END GENDER
FROM insa;

SELECT deptno, ename, sal, comm
    ,(sal+NVL(comm,0))pay
    ,(sal+NVL(comm,0)) * DECODE(deptno,10,1.15
                                      ,20,1.15
                                      ,1.2) "인상된 PAY"
    ,(sal+NVL(comm,0)) * CASE deptno WHEN 10 THEN 1.15
                                     WHEN 20 THEN 1.15
                                     ELSE 1.2
                         END  "인상된 PAY"
FROM emp;

--2) 복수행 함수( 그룹함수 )
SELECT COUNT(*), COUNT(ename), COUNT(sal), COUNT(comm) "COUNT"
-- ORA-00937: not a single-group group function
--        , sal  집계함수와 동시 사용 불가
    , SUM(sal) "SUM"
    , SUM(comm)/COUNT(*) "AVG_COMM"
    , AVG(comm) "AVG"
    , MAX(sal) "MAX"
    , MIN(sal) "MIN"
FROM emp;
-- 총 사원수 조회
-- 각 부서별 사원수 조회
SELECT *
FROM INSA;
--총무부 개발부 영업부 기획부 인사부 자재부 홍보부




