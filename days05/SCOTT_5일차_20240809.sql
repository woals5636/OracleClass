-- SCOTT
-- [문제1] emp 테이블에서 job의 갯수 조회?
SELECT COUNT(DISTINCT job)
FROM emp;

SELECT COUNT(*)
FROM(
    SELECT DISTINCT job
    FROM emp
)E;
-- [문제2] emp 테이블의 부서별 사원수 조회?
SELECT 10 DEPTNO, COUNT(*)
FROM EMP
WHERE DEPTNO = 10
UNION ALL
SELECT 20, COUNT(*)
FROM EMP
WHERE DEPTNO = 20
UNION ALL
SELECT 30, COUNT(*)
FROM EMP
WHERE DEPTNO = 30
UNION ALL
SELECT 40, COUNT(*)
FROM EMP
WHERE DEPTNO = 40
UNION ALL
SELECT NULL, COUNT(*)
FROM EMP;
--
SELECT(SELECT COUNT(*) count FROM emp WHERE deptno = 10) deptno_10
     ,(SELECT COUNT(*) count FROM emp WHERE deptno = 20) deptno_20
     ,(SELECT COUNT(*) count FROM emp WHERE deptno = 30) deptno_30
     ,(SELECT COUNT(*) count FROM emp WHERE deptno = 40) deptno_40
     ,(SELECT COUNT(*) count FROM emp) total
FROM dual;
-- SELECT 문 + 7절
SELECT deptno, count(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;
-- 문제 제시 ) emp 테이블에 존재하지 않는 부서도 조회. 40 0
SELECT COUNT(*)
    , COUNT(DECODE(deptno, 10, 1)) "10"
    , COUNT(DECODE(deptno, 20, 1)) "20"
    , COUNT(DECODE(deptno, 30, 1)) "30"
    , COUNT(DECODE(deptno, 40, 1)) "40"
FROM emp;
--
SELECT COUNT(CASE WHEN (DEPTNO = 10) THEN 1 END) AS "DEPTNO 10",
       COUNT(CASE WHEN (DEPTNO = 20) THEN 1 END) AS "DEPTNO 20",
       COUNT(CASE WHEN (DEPTNO = 30) THEN 1 END) AS "DEPTNO 30",  
       COUNT(CASE WHEN (DEPTNO = 40) THEN 1 END) AS "DEPTNO 40",  
       COUNT(*) AS "DEPTNO TOT"       
FROM emp;

-- [문제] insa 테이블에서 총사원수, 남자사원수, 여자사원수 조회
-- DECODE() + COUNT()
SELECT COUNT(DECODE(GENDER,'남자',1))"남자사원수"
      ,COUNT(DECODE(GENDER,'여자',1))"여자사원수"
      ,COUNT(*)"전체사원수"
FROM (
    SELECT NAME, SSN
        ,DECODE( SUBSTR(SSN, 8,1), 1, '남자',2,'여자') GENDER 
    FROM INSA
);
-- GROUP BY 절
--SELECT '전체사원수', COUNT(*)"사원수"
--FROM insa
--UNION ALL
SELECT GENDER, COUNT(*)"사원수"
FROM (
    SELECT NAME, SSN
--        ,DECODE( SUBSTR(SSN, 8,1), 1, '남자',2,'여자') GENDER   -- DECODE 문
        ,CASE  WHEN SUBSTR(SSN, 8,1) = 1 THEN '남자'      -- CASE 문
               WHEN SUBSTR(SSN, 8,1) = 2 THEN '여자'
               ELSE '전체'
         END GENDER
    FROM INSA
)
GROUP BY ROLLUP (GENDER);

-- ROLLUP
SELECT CASE MOD(SUBSTR(ssn,-7,1),2)
            WHEN 1 THEN '남수'
            WHEN 0 THEN '여수'
            ELSE '전수'
        END GENDER
        ,COUNT(*)
FROM insa
GROUP BY ROLLUP (MOD(SUBSTR(ssn,-7,1),2));

-- [문제] emp 테이블에서 가장 급여(pay)를 많이 받는 사원의 정보를 조회
SELECT *
FROM emp
WHERE sal + NVL(comm,0) = (
    SELECT MAX(sal + NVL(comm,0)) MAX_PAY
    FROM EMP
);
-- SQL 연산자 : ALL, SOME, ANY, EXISTS
SELECT *
FROM emp
WHERE sal + NVL(comm,0) >= ALL(SELECT sal + NVL(comm,0) FROM EMP);
-- [문제] emp 테이블에서 가장 급여(pay)를 적게 받는 사원의 정보를 조회
SELECT *
FROM emp
WHERE sal + NVL(comm,0) <= ALL(SELECT sal + NVL(comm,0) FROM EMP);
-- [문제] emp 테이블에서 각 부서별 최고 급여를 받는 사원의 정보를 조회.
SELECT DEPTNO, MAX(sal + NVL(comm,0)) MAX_PAY, MIN(sal + NVL(comm,0)) MIN_PAY
FROM emp
GROUP BY DEPTNO
ORDER BY DEPTNO;
--
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = ANY(
                            SELECT MAX(sal+NVL(comm,0))
                            FROM emp
                            GROUP BY deptno
                            );
--
SELECT *
FROM emp m
WHERE sal+NVL(comm,0) = (-- 그 해당 부서의 가장 큰값 PAY
                            SELECT MAX(sal+NVL(comm,0))
                            FROM emp
                            WHERE deptno = m.deptno
                        );
-- [문제] emp 테이블의 pay 순위 등수
SELECT m.*
    , ( SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal ) RANK
    , ( SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
FROM emp m
ORDER BY deptno, dept_rank;

--
SELECT *
FROM(
    SELECT m.*
        , ( SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal ) RANK
        , ( SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
    FROM emp m
)t
WHERE t.dept_rank < 3
ORDER BY deptno, dept_rank;

-- [문제] insa 테이블에서 부서별 인원수가 10명 이상인 부서를 조회
SELECT *
FROM(
    SELECT I.buseo, COUNT(*) cnt
    FROM insa I
    GROUP BY buseo
)t
WHERE cnt >= 10;
--
SELECT I.buseo, COUNT(*) CNT
FROM insa I
GROUP BY buseo
HAVING COUNT(*) >= 10;

-- [문제] insa 테이블에서 여자사원수가 5명 이상인 부서 정보 조회
--SELECT buseo, COUNT(*)
--FROM insa
--GROUP BY buseo
--HAVING COUNT(*) >= 5;

SELECT buseo, COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자'))"여자사원수"
FROM insa
GROUP BY buseo
HAVING COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자'))>=5;
--
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0
GROUP BY buseo
HAVING COUNT(*)>=5;

-- [문제] emp 테이블에서 사원 전체 평균 급여를 계산한 후
--       각 사원들의 급여가 평균 급여보다 많을 경우 "많다" 출력
--                                  적을 경우 "적다" 출력
SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp;
--
SELECT empno, ename,pay,ROUND(avg_pay,2) avg_pay
    , CASE WHEN pay > avg_pay THEN '많다'
           WHEN pay < avg_pay THEN '적다'
           ELSE '같다'
    END ASDF
FROM(
    SELECT e.*
        ,sal+NVL(comm,0) pay
        ,(SELECT AVG(sal+NVL(comm,0)) avg_pay FROM emp) avg_pay
    FROM emp e
)ee;
-- UNION 활용
SELECT s.*,  '많다'
FROM emp s
WHERE sal + NVL(comm,0 ) > (SELECT AVG( sal + NVL(comm,0 )) avg_pay
                            FROM emp)
UNION                            
SELECT s.*,  '적다'
FROM emp s
WHERE sal + NVL(comm,0 ) < (SELECT AVG( sal + NVL(comm,0 )) avg_pay
                            FROM emp);

-- NULLIF 활용
SELECT ename, pay, avg_pay
     , NVL2( NULLIF( SIGN( pay - avg_pay ), 1 ), '적다' , '많다') 
FROM (
        SELECT ename, sal+NVL(comm,0) pay 
            , (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) avg_pay
        FROM emp
      );

-- [문제] emp 테이블에서 급여 max, min 사원 정보 조회
SELECT *
FROM(
    SELECT E.*
        , sal+NVL(comm,0) PAY
        ,(SELECT MAX(sal+NVL(comm,0)) FROM emp) MAX_PAY
        ,(SELECT MIN(sal+NVL(comm,0)) FROM emp) MIN_PAY
    FROM EMP E
)
WHERE PAY = MAX_PAY OR PAY = MIN_PAY
ORDER BY PAY DESC;
--
SELECT MAX(sal), MIN(sal)
FROM emp;
--
SELECT ename, job, hiredate, sal
    , CASE sal
        WHEN 5000 THEN 'MAX'
        WHEN 800 THEN 'MIN'
      END
FROM emp
WHERE sal IN ((SELECT MAX(sal) FROM emp),(SELECT MIN(sal) FROM emp));
-- WHERE sal IN (SELECT MAX(sal), MIN(sal) FROM emp); -- ORA-00913: too many values
-- WHERE sal IN (5000,800);

-- [문제] insa
--       서울 사람 중 부서별 남자,여자 사원수,
--                        남자 급여합계, 여자 급여합계 조회
SELECT BUSEO
    , COUNT(CASE GENDER WHEN '남자' THEN 1 END) "남자인원수"
    , COUNT(CASE GENDER WHEN '여자' THEN 1 END) "여자인원수"
    , COUNT(*) "총인원수"
    , SUM(CASE GENDER WHEN '남자' THEN TOTPAY END) "남자급여합계"
    , SUM(CASE GENDER WHEN '여자' THEN TOTPAY END) "여자급여합계"
    , SUM(TOTPAY) "총급여합계"
FROM(
    SELECT INSA.*
        , CASE TO_NUMBER(SUBSTR(SSN,-7,1)) WHEN 1 THEN '남자'
                                           WHEN 2 THEN '여자'
          END AS GENDER
        , BASICPAY+SUDANG "TOTPAY"
    FROM insa
    WHERE CITY = '서울'
)I
GROUP BY BUSEO;
--
SELECT buseo, jikwi, COUNT(*), SUM(basicpay), AVG(basicpay)
FROM insa
GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo, jikwi;
--
SELECT buseo
    , DECODE(MOD(SUBSTR(ssn, -7 , 1),2),0,'여자','남자') GENDER
    , COUNT(*) "사원수"
    , SUM(basicpay) "총급여합"
FROM insa
WHERE city = '서울'
GROUP BY buseo, MOD(SUBSTR(ssn, -7 , 1),2)
ORDER BY buseo, MOD(SUBSTR(ssn, -7 , 1),2);

-- ROWNUM , ROWID 의사칼럼(pseudo column) 오라클에서 내부적으로 사용되는 컬럼
DESC emp;
SELECT ROWNUM , ROWID, ename, hiredate, job
FROM emp;

-- 【 TOP-N 분석 】
--SELECT 컬럼명,..., ROWNUM
--FROM(
--    SELECT 컬럼명,... from 테이블명
--    ORDER BY top_n_컬럼명
--    )
--WHERE ROWNUM <= n;
--
SELECT ROWNUM, E.*
FROM (
    SELECT *
    FROM emp
    ORDER BY sal DESC
)E
WHERE ROWNUM <= 5;
-- WHERE ROWNUM >= 3 AND ROWNUM <= 5; TOP-N 방식은 BETWEEN 값은 불가능
-- 사용하기 위해서는 아래와 같이 ROWNUM에 별칭을 부여하고 인라인뷰를 작성하면 가능
SELECT *
FROM(
    SELECT ROWNUM seq, E.*
    FROM (
        SELECT *
        FROM emp
        ORDER BY sal DESC
    )E
)
WHERE seq BETWEEN 3 AND 5;

-- ORDER BY 절이 있는 곳에서는 ROWNUM 사용하지 않도록 주의
SELECT ROWNUM, emp.*
FROM emp
ORDER BY sal DESC;

-- ROLLUP/CUBE 설명
-- 1) ROLLUP : 그룹화하고 그룹에 대한 부분합
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT dname, job, COUNT(*)
FROM emp e , dept d
WHERE e.deptno = d.deptno
--GROUP BY dname, job
--ORDER BY dname ASC;
GROUP BY ROLLUP (dname, job)
ORDER BY dname ASC;

-- 2) CUBE : ROLLUP 결과에 GROUP BY 절의 조건에 따라 모든 가능한 그룹핑 조합
--           에 대한 결과 출력.    2*N=4
SELECT dname, job, COUNT(*)
FROM emp e , dept d
WHERE e.deptno = d.deptno
GROUP BY CUBE (dname, job)
ORDER BY dname ASC;

-- [ 순위(RANK) 함수 ]
SELECT ename, sal, sal+NVL(comm,0) pay
    ,RANK()OVER(ORDER BY sal+NVL(comm,0) DESC) "RANK"
    ,DENSE_RANK()OVER(ORDER BY sal+NVL(comm,0) DESC) "DENSE_RANK"
    ,ROW_NUMBER()OVER(ORDER BY sal+NVL(comm,0) DESC) "ROW_NUMBER"
FROM emp;

-- JONES 2975->2850
SELECT *
FROM emp
WHERE ename LIKE '%JONES%';

UPDATE emp
SET sal = 2850
WHERE ename = 'JONES';
-- JONES가 중복되면 값이 의도치 않게 변경될 수 있기 때문에 위와 같이 하지 말것

-- 순위 함수 사용 예제
-- emp 테이블에서 부서별로 급여 순위를 매기기.
SELECT *
FROM(
    SELECT emp.*
        ,RANK()OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) 부서별순위
        ,RANK()OVER(ORDER BY sal+NVL(comm,0) DESC) 전체순위
    FROM emp
)
WHERE 부서별순위 BETWEEN 2 AND 3;
--WHERE 순위 = 1;

-- insa 테이블 사원들을 14명씩 팀을 구성
SELECT CEIL(COUNT(*)/14) TEAM
FROM insa I;
-- [문제] insa 테이블에서 사원수가 가장 많은 부서의 부서명, 사원수를 조회
SELECT BUSEO, 사원수
FROM(
    SELECT BUSEO,COUNT(*) 사원수, RANK()OVER(ORDER BY COUNT(*) DESC) 인원순서
    FROM INSA
    GROUP BY BUSEO
)
WHERE 인원순서 = 1;

-- [문제] 여자 인원수가 가장 많은 부서 및 인원수 출력
SELECT BUSEO, 여직원인원수
FROM(
    SELECT BUSEO, COUNT(*)여직원인원수, RANK()OVER(ORDER BY COUNT(*) DESC) 여직원수순위
    FROM(
        SELECT I.*, DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'남자',0,'여자')GENDER
        FROM INSA I
    )
    WHERE GENDER = '여자'
    GROUP BY BUSEO
)
WHERE 여직원수순위 = 1;

-- [문제] insa 테이블에서 basicpay(기본급)이 상위 10%만 출력 (이름 ,기본급)
SELECT name, basicpay, 순위
FROM(
    SELECT name, basicpay, (SELECT COUNT(*) FROM insa) cnt
        , RANK()OVER(ORDER BY basicpay DESC) 순위
    FROM insa
)I
WHERE 순위 <= cnt*0.1;
--
SELECT *
FROM(
    SELECT name, basicpay
        , PERCENT_RANK()OVER(ORDER BY basicpay DESC) PR
    FROM insa
)
WHERE PR <= 0.1;





