-- SCOTT
-- [문제1]
SELECT TMP, (SELECT AVG(TMP) FROM DUAL) AVG_TMP
    , CEIL((TMP-(SELECT AVG(TMP) FROM DUAL)*100))/100
FROM(
SELECT '12345.67' TMP FROM DUAL
);

SELECT ENAME, PAY, AVG_PAY
    , CEIL(PAY - AVG_PAY) "차 올림"
    , ROUND(PAY - AVG_PAY,3) "차 반올림"
    , TRUNC(PAY - AVG_PAY,3) "차 내림"
FROM(
SELECT ename, sal+NVL(COMM,0) PAY
    ,(SELECT AVG(sal+NVL(COMM,0)) FROM emp) AVG_PAY
FROM emp
);

--  [문제2] EMP 테이블에서
--      PAY, AVG_PAY    많,적,같다
SELECT ename, PAY, AVG_PAY
    , CASE WHEN PAY > AVG_PAY THEN '많다'
           WHEN PAY < AVG_PAY THEN '적다'
           ELSE '같다'
    END "많,적,같다"
FROM(
SELECT ename, sal+NVL(COMM,0) PAY
    ,(SELECT AVG(sal+NVL(COMM,0)) FROM emp) AVG_PAY
FROM emp
);

-- [문제3] insa 테이블에서 ssn 주민등록번호, 오늘이 생일 지났는지 여부 출력
SELECT A.NAME, A.SSN, A.TODAY, CASE  WHEN A.TODAY > A.birth THEN '안지남'
                      WHEN A.TODAY < A.birth THEN '지남'
                      ELSE '오늘생일'
                      END AS "생일지남여부"
FROM(
SELECT I.*, SUBSTR(I.SSN,3,4) BIRTH,(SELECT TO_CHAR(SYSDATE, 'MMDD') FROM DUAL) TODAY
FROM insa I ,DUAL D
)A ;

SELECT *
FROM INSA
WHERE NUM = 1002;

UPDATE INSA
SET SSN = SUBSTR(SSN,0,2)||TO_CHAR(SYSDATE,'MMDD')||SUBSTR(SSN,7)
WHERE NUM = 1002;
COMMIT;

-- [문제] INSA 테이블의 주민등록번호(SSN) 만나이를 계산해서 출력
-- 성별(1,2) 1900 (3,4) 2000  (0,9) 1800
-- 만나이 = 생일년도 2024-1998 -1(생일지남여부)
-- NAME, SSN, 출생년도, 올해년도, 만나이
SELECT t.name, t.ssn, 출생년도, 올해년도
    , 올해년도 - 출생년도  + CASE bs
                               WHEN -1 THEN  -1                               
                               ELSE 0
                          END  만나이
FROM (
        SELECT name, ssn
         , TO_CHAR( SYSDATE , 'YYYY' ) 올해년도
         , SUBSTR( ssn, -7, 1) 성별
         , SUBSTR( ssn, 0, 2) 출생2자리년도
         , CASE 
             WHEN SUBSTR( ssn, -7, 1) IN ( 1,2,5,6) THEN 1900
             WHEN SUBSTR( ssn, -7, 1) IN ( 3,4,7,8) THEN 2000
             ELSE 1800
           END +  SUBSTR( ssn, 0, 2) 출생년도
           -- 0, -1 생일지난거..
           -- 1      나이 계산에서    -1
         , SIGN( TO_DATE( SUBSTR( ssn, 3, 4 ) , 'MMDD' )  - TRUNC( SYSDATE ) )  bs 
        FROM insa
) t;

SELECT NAME, SSN, 출생년도,출생월일, 올해년도,오늘월일
    , 올해년도 - 출생년도 + CASE WHEN 오늘월일 - 출생월일 > 0 THEN +0
                            ELSE +1
                         END AS 만나이
FROM(
    SELECT NAME,SSN
        ,CASE WHEN SUBSTR(SSN,0,2) < 100 THEN SUBSTR(SSN,0,2)+1900
              ELSE SUBSTR(SSN,0,2)+2000
              END AS 출생년도
        ,TO_CHAR(SYSDATE, 'YYYY') 올해년도
        , SUBSTR(SSN,3,4) 출생월일
        ,TO_CHAR(SYSDATE, 'MMDD') 오늘월일
    FROM INSA
);

-- Math.random() 임의의수
-- Random 클래스 nextInt() 임의의수
-- DBMS_RANDOM 패키지
-- 자바 패키지 - 서로 관련되 클래스들의 묶음
-- 오라클 패키지 - 서로 관련된 타입, 프로그램 객체, 서브프로그램(procedure, function)
-- 0.0<= SYS.dbms_random.value < 1.0
SELECT
    SYS.dbms_random.value
--    , SYS.dbms_random.value(0,100) -- 0.0 <=실수 <100.0
--    ,SYS.dbms_random.STRING('U',5)
--    ,SYS.dbms_random.STRING('L',5)
--    ,SYS.dbms_random.STRING('X',5) -- 대문자 + 숫자
    ,SYS.dbms_random.STRING('P',5) -- 대문자 + 소문자 + 숫자 + 특수문자
    ,SYS.dbms_random.STRING('A',5) -- 알파벳
FROM DUAL;

-- [문제] 임의의 국어 점수 1개 출력
SELECT ROUND(SYS.dbms_random.value(0,100)) 국어점수
      ,CEIL(SYS.dbms_random.value(0,100)) 국어점수
      ,TRUNC(SYS.dbms_random.value(0,101)) 국어점수
FROM DUAL;
-- [문제] 임의의 로또 번호 1개 출력
SELECT CEIL(SYS.dbms_random.value(1,45)) 로또번호
FROM DUAL;
-- [문제] 임의의 숫자 6자리를 발생시켜서 출력
SELECT TRUNC(SYS.dbms_random.value(100000,1000000)) 임의의6자리번호
FROM DUAL;

-- [문제] insa테이블에서 남자사원수, 여자사원수 출력
SELECT GENDER, COUNT(*) 사원수
FROM(
SELECT i.*, DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'남자','여자') GENDER
FROM insa i
)
GROUP BY GENDER
ORDER BY GENDER;

-- [문제] insa테이블에서 부서별 남자사원수, 여자사원수 출력
-- 1) SET OPERATOR 사용
SELECT '남자사원수' "성별", COUNT(*) "사원수"
FROM insa
WHERE MOD( SUBSTR(ssn, 8, 1 ), 2 ) = 1
UNION ALL
SELECT '여자사원수' "성별", COUNT(*) "사원수"
FROM insa
WHERE MOD( SUBSTR(ssn, 8, 1 ), 2 ) = 0;
-- 2) GROUP BY 사용
SELECT BUSEO, GENDER, COUNT(*) 사원수
FROM(
SELECT i.*, DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'남자','여자') GENDER
FROM insa i
)
GROUP BY BUSEO, GENDER
ORDER BY BUSEO, GENDER;

-- [문제] emp 테이블에서 최고 급여자, 최저 급여자 사원정보 조회
SELECT *
FROM(
SELECT E.*
    ,(SELECT MAX(SAL) FROM EMP) MAX_SAL
    ,(SELECT MIN(SAL) FROM EMP) MIN_SAL
FROM EMP E
)
WHERE SAL IN (MAX_SAL , MIN_SAL);
-- [문제] emp 테이블에서 각 부서별 최고 급여자, 최저 급여자 사원정보 조회
SELECT *
FROM emp m
WHERE sal IN ( (SELECT MAX(sal)  FROM emp WHERE deptno=m.deptno)
             , (SELECT MIN(sal)  FROM emp WHERE deptno=m.deptno))
ORDER BY deptno, sal DESC;

SELECT E.*,'최고' 최고최저급여자
FROM EMP E
WHERE (DEPTNO,SAL) IN (SELECT DEPTNO, MAX(SAL) FROM EMP GROUP BY DEPTNO)
UNION
SELECT E.*,'최저'
FROM EMP E
WHERE (DEPTNO,SAL) IN (SELECT DEPTNO, MIN(SAL) FROM EMP GROUP BY DEPTNO);

-- 순위 함수
SELECT *
FROM (
SELECT emp.*
    , RANK()OVER(PARTITION BY deptno ORDER BY sal DESC) r
    , RANK()OVER(PARTITION BY deptno ORDER BY sal ASC) r2
FROM emp
) t
WHERE t.r = 1 or t.r2 = 1
ORDER BY deptno;

-- [문제] emp 테이블에서 comm이 400이하인 사원의 정보 조회
--       (조건 comm이 NULL인 사원도 포함)

SELECT *
FROM emp
-- LNNVL() 함수 WHERE 조건이 참/UNKNOWN -> FALSE
WHERE LNNVL( comm > 400 ); -- NULL
--WHERE NVL(comm,0) <= 400;
--WHERE comm <=400 or comm = NULL;

-- [문제] 이번 달의 마지막 날짜가 몇 일 까지 있는지 확인하는 쿼리...
SELECT SYSDATE TODAY
      ,TO_CHAR(LAST_DAY(SYSDATE),'DD') "방법1"
      ,TRUNC(SYSDATE, 'MONTH') "방법2.1" -- 24/08/01 
      ,ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1) - 1 "방법2.2"
      ,TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1) - 1,'DD') "방법2.3"
FROM DUAL;

-- [문제] emp테이블에서 sal가 상위 20%에 해당되는 사원의 정보 조회
SELECT *
FROM(
    SELECT E.*,PERCENT_RANK()OVER(ORDER BY SAL DESC) "순위"
    FROM emp E
)
WHERE 순위 <=0.2;

--[문제] 다음 주 월요일은 휴강입니다. (날짜 조회)
SELECT TO_CHAR(SYSDATE,'DS TS(DY)') 오늘
    ,NEXT_DAY(SYSDATE, '월') 다음주월
FROM DUAL;

-- [문제] emp 테이블에서 각 사원들의 입사일자를 기준으로 10년 5개월 20일째 되는
-- 날짜 출력
SELECT ENAME, ADD_MONTHS(HIREDATE, 10*12+5)+ 20 HIREDATE 
FROM EMP;

--insa 테이블에서 
--[실행결과]
--                                           부서사원수/전체사원수 == 부/전 비율
--                                           부서의 해당성별사원수/전체사원수 == 부성/전%
--                                           부서의 해당성별사원수/부서사원수 == 성/부%
--                                           
--부서명     총사원수 부서사원수 성별  성별사원수  부/전%   부성/전%   성/부%
--개발부       60       14     F       8     23.3%     13.3%   57.1%
--개발부       60       14     M       6     23.3%       10%   42.9%
--기획부       60       7      F       3     11.7%        5%   42.9%
--기획부       60       7      M       4     11.7%      6.7%   57.1%
--영업부       60       16     F       8     26.7%     13.3%     50%
--영업부       60       16     M       8     26.7%     13.3%     50%
--인사부       60       4      M       4      6.7%      6.7%    100%
--자재부       60       6      F       4       10%      6.7%   66.7%
--자재부       60       6      M       2       10%      3.3%   33.3%
--총무부       60       7      F       3     11.7%        5%   42.9%
--총무부       60       7      M       4     11.7%      6.7%   57.1%
--홍보부       60       6      F       3       10%        5%     50%
--홍보부       60       6      M     

--
SELECT 부서명, 총사원수, 부서사원수, 성별,  성별사원수
  ,ROUND(   부서사원수/총사원수*100, 2) || '%' "부/전%"
  ,ROUND(   성별사원수/총사원수*100, 2) || '%' "부성/전%"
  ,ROUND(   성별사원수/부서사원수*100, 2) || '%'  "성/부%"
FROM(
SELECT BUSEO AS 부서명
    ,(SELECT COUNT(*) FROM INSA) 총사원수
    ,(SELECT COUNT(*) FROM INSA WHERE BUSEO = T.BUSEO) 부서사원수
    ,GENDER 성별
    ,COUNT(*) 성별사원수
FROM(
    SELECT BUSEO, NAME, SSN
        ,DECODE( MOD (SUBSTR(SSN,-7,1),2),1,'M','F' )GENDER
    FROM INSA
) T
GROUP BY BUSEO,GENDER
ORDER BY BUSEO,GENDER
);

--LISTAGG() ****암기
SELECT EMPNO, ENAME, JOB,DEPTNO
FROM EMP;
--
SELECT DEPTNO, LISTAGG(ENAME , ' , ') WITHIN GROUP(ORDER BY ENAME ASC) AS ENAME 
FROM EMP;
--
SELECT DEPTNO, LISTAGG(ENAME , ' , ') WITHIN GROUP(ORDER BY ENAME ASC) AS ENAME 
FROM EMP 
GROUP BY DEPTNO;
-- [ INSA 테이블에서 TOP-N 분석방식으로
-- 급여 많이 받는 TOP-10 조회(출력)
-- 1) 급여 순으로 ORDER BY 정렬
-- 2) ROWNUM 의사컬럼 - 순번
-- 3) 순번의 1~10명 SELECT
SELECT ROWNUM 순번, A.*
FROM(
SELECT I.*, RANK()OVER(ORDER BY BASICPAY+SUDANG DESC) 급여순위
FROM INSA I
)A
WHERE 급여순위 <= 10;

-- [문제]
SELECT TRUNC(SYSDATE,'YEAR')    -- YEAR
      ,TRUNC(SYSDATE,'MONTH')   -- MONTH
      ,TRUNC(SYSDATE,'DD')      -- DAY 요일 11
      ,TRUNC(SYSDATE)           -- 시간,분,초 절삭
FROM DUAL;

-- [문제]
--    [실행결과]
--    DEPTNO        ENAME       PAY     BAR_LENGTH      
--    ---------- ---------- ---------- ----------
--    30            BLAKE       2850        29      #############################
--    30            MARTIN      2650        27      ###########################
--    30            ALLEN       1900        19      ###################
--    30            WARD        1750        18      ##################
--    30            TURNER      1500        15      ###############
--    30            JAMES       950         10      ##########

SELECT DEPTNO
    ,ENAME
    , SAL+NVL(COMM,0) PAY
    , ROUND(SAL+NVL(COMM,0),-2)/100 BAR_LENGTH
    , LPAD(' ',ROUND(SAL+NVL(COMM,0),-2)/100,'#') GRAPH
FROM EMP
WHERE DEPTNO=30
ORDER BY SAL+NVL(COMM,0) DESC;

--  WW / IW / W 차이점 파악
SELECT TO_CHAR(HIREDATE)
    ,TO_CHAR(HIREDATE,'WW')     -- 년중 몇 번째 주
    ,TO_CHAR(HIREDATE,'IW')     -- 년중 몇 번째 주
    ,TO_CHAR(HIREDATE,'W')      -- 월중 몇 번째 주
FROM EMP;

SELECT TO_CHAR(TO_DATE('2022.01.01'),'IW') A
    , TO_CHAR(TO_DATE('2022.01.02'),'IW') B
    , TO_CHAR(TO_DATE('2022.01.03'),'IW') C
    , TO_CHAR(TO_DATE('2022.01.04'),'IW') D
    , TO_CHAR(TO_DATE('2022.01.05'),'IW') E
    , TO_CHAR(TO_DATE('2022.01.06'),'IW') F
    , TO_CHAR(TO_DATE('2022.01.07'),'IW') G
    , TO_CHAR(TO_DATE('2022.01.08'),'IW') H
FROM DUAL;

SELECT TO_CHAR(TO_DATE('2022.01.01'),'WW') A
    , TO_CHAR(TO_DATE('2022.01.02'),'WW') B
    , TO_CHAR(TO_DATE('2022.01.03'),'WW') C
    , TO_CHAR(TO_DATE('2022.01.04'),'WW') D
    , TO_CHAR(TO_DATE('2022.01.05'),'WW') E
    , TO_CHAR(TO_DATE('2022.01.06'),'WW') F
    , TO_CHAR(TO_DATE('2022.01.07'),'WW') G
    , TO_CHAR(TO_DATE('2022.01.08'),'WW') H
FROM DUAL;

-- [문제] EMP 테이블에서
-- 사원수가 가장 많은 부서명(DNAME), 사원수
-- 사원수가 가장 작은 부서명, 사원수
-- 출력... (JOIN)
SELECT D.DEPTNO, DNAME, COUNT(EMPNO) 사원수
-- FROM EMP E INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
--FROM EMP E RIGHT OUTER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
FROM DEPT D LEFT OUTER JOIN EMP E ON E.DEPTNO = D.DEPTNO
GROUP BY D.DEPTNO, DNAME
ORDER BY D.DEPTNO;
--
SELECT *
FROM(
    SELECT D.DEPTNO, DNAME, COUNT(EMPNO) CNT
        ,RANK()OVER(ORDER BY COUNT(EMPNO) DESC) CNT_RANK
    FROM DEPT D LEFT OUTER JOIN EMP E ON E.DEPTNO = D.DEPTNO
    GROUP BY D.DEPTNO, DNAME
    ORDER BY CNT_RANK ASC
)T
SELECT *
FROM TEMP
WHERE TEMP.CNT_RANK IN (
                (SELECT MAX(TEMP.CNT_RANK) FROM TEMP)
              , (SELECT MIN(TEMP.CNT_RANK) FROM TEMP)
      );
-- WITH( 절 이해(암기)
WITH a AS(
        SELECT D.DEPTNO, DNAME, COUNT(EMPNO) CNT
        ,RANK()OVER(ORDER BY COUNT(EMPNO) DESC) CNT_RANK
        FROM DEPT D LEFT OUTER JOIN EMP E ON E.DEPTNO = D.DEPTNO
        GROUP BY D.DEPTNO, DNAME
    )
    , B AS(
    SELECT MAX(CNT) MAXCNT, MIN(CNT) MINCNT
    FROM A
    )
SELECT A.DEPTNO, A.DNAME, A.CNT, A.CNT_RANK
FROM A,B
WHERE A.CNT IN (B.MAXCNT,B.MINCNT);

-- 피봇(PIVOT) / 언피봇(UNPIVOT) (암기)
-- https://blog.naver.com/gurrms95/222697767118

-- JOB별 사원수를 출력
SELECT
    COUNT(DECODE(JOB, 'CLERK', 'O')) CLERK
    ,COUNT(DECODE(JOB, 'SALESMAN', 'O')) SALESMAN
    ,COUNT(DECODE(JOB, 'PRESIDENT', 'O')) PRESIDENT
    ,COUNT(DECODE(JOB, 'MANAGER', 'O')) MANAGER
    ,COUNT(DECODE(JOB, 'ANALYST', 'O')) ANALYST
FROM EMP;
--
SELECT
FROM(피봇 대상 쿼리문)
PIVOT(그룹함수(집계컬럼)) FOR 피벗컬럼 IN ( 피벗컬럼 AS 별칭...);

-- 축을 중심으로 회전시키다 == PIVOT
SELECT *
FROM (
    SELECT JOB
    FROM EMP
    )
PIVOT(
    COUNT(JOB)
    FOR JOB IN ( 'CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST')
);

-- 2) EMP 테이블에서
-- 각 월별 입사한 사원 수 조회.
-- 출력 예시
-- 1월 2월 3월 4월 .... 12월
--  2  0   5   0 ....  3       
SELECT TO_CHAR(HIREDATE,'YYYY') YEAR
      ,TO_CHAR(HIREDATE,'MM') MONTH
FROM EMP;
--
SELECT *
FROM (
    SELECT TO_CHAR(HIREDATE,'YYYY') YEAR
          ,TO_CHAR(HIREDATE,'MM') MONTH
    FROM EMP
    )
PIVOT(
    COUNT(MONTH)
    FOR MONTH IN('01' AS "1월",'02','03','04','05','06','07','08','09','10','11','12')
)
ORDER BY YEAR;

-- [문제] EMP 테이블에서 JOB별 사원수 조회
SELECT *
FROM (
    SELECT JOB
    FROM EMP
    )
PIVOT(
    COUNT(JOB)
    FOR JOB IN ( 'CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST')
);
-- [문제] EMP 테이블에서 부서별/JOB별 사원수 조회
--    DEPTNO DNAME             'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
------------ -------------- ---------- ---------- ----------- ---------- ----------
--        10 ACCOUNTING              1          0           1          1          0
--        20 RESEARCH                1          0           0          1          1
--        30 SALES                   1          4           0          1          0
--        40 OPERATIONS              0          0           0          0          0
SELECT *
FROM( SELECT D.DEPTNO, D.DNAME, E.JOB
      FROM EMP E, DEPT D
      WHERE E.DEPTNO(+) = D.DEPTNO -- RIGHT OUTER JOIN
)
PIVOT(
    COUNT(JOB)
    FOR JOB IN('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST')
)
ORDER BY DEPTNO;
--실습문제) 각 부서별 총 급여합을 조회
SELECT DEPTNO, SAL+NVL(COMM,0) PAY
FROM EMP;

SELECT *
FROM(
    SELECT DEPTNO, SAL+NVL(COMM,0) PAY
    FROM EMP)
PIVOT(
    SUM(PAY)
    FOR DEPTNO IN('10','20','30','40')
);

-- 실습문제
SELECT *
FROM(
SELECT JOB, DEPTNO,SAL, ENAME
FROM EMP
)
PIVOT(
    SUM(SAL) AS 합계, MAX(SAL) AS 최고액, MAX(ENAME) AS 최고연승
    FOR DEPTNO IN ('10','20','30','40')
);

-- 피봇 문제
-- 생일 지난 사람  안지난사람  오늘
--      20          30      1
SELECT *
FROM INSA;
SELECT *
FROM(
    SELECT SIGN(BIRTHDAY-TODAY) S
    FROM(
    SELECT SUBSTR(SSN,3,4) BIRTHDAY, TO_CHAR(SYSDATE,'MMDD') TODAY
    FROM INSA)
)
PIVOT(
    COUNT(S)
    FOR S IN ('1' AS "생일아직",'0' AS "오늘생일",'-1' AS "생일지남")
);

-- 부서번호 4자리 출력
SELECT DEPTNO
    ,CONCAT('00',DEPTNO)
    ,TO_CHAR(DEPTNO,'0999')
    ,LPAD(DEPTNO,4,'0')
FROM DEPT;

-- (암기) insa테이블에서 각 부서별/출신지역별/사원수 몇명인지 출력(조회)
SELECT BUSEO, CITY, COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO,CITY
ORDER BY BUSEO,CITY;
--오라클 10G 새로 추가된 기능 : PARTITION BY OUTER JOIN 구문 사용

WITH C AS(
    SELECT DISTINCT CITY
    FROM INSA
)
SELECT BUSEO, C.CITY, COUNT(*) 사원수
FROM INSA I PARTITION BY(BUSEO) RIGHT OUTER JOIN C ON I.CITY = C.CITY
GROUP BY BUSEO, C.CITY
ORDER BY BUSEO, C.CITY;



