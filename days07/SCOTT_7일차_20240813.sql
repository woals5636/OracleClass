-- SCOTT
-- [문제] emp, dept
-- 사원이 존재하지 않는 부서의 부서번호, 부서명을 출력
-- ㄱ. RIGHT OUTER JOIN
SELECT d.deptno 부서번호, d.dname 부서명, COUNT(E.DEPTNO) 사원수
FROM EMP E RIGHT OUTER JOIN DEPT D ON e.deptno = d.deptno
-- OUTER 생략 가능 ( RIGHT JOIN )
GROUP BY d.deptno,d.dname
HAVING COUNT(E.DEPTNO) = 0;

-- ㄴ. MINUS
WITH T AS(
SELECT DEPTNO
FROM DEPT
MINUS
SELECT DISTINCT DEPTNO
FROM EMP
)
SELECT T.DEPTNO, D.DNAME
FROM T JOIN DEPT D ON T.DEPTNO = D.DEPTNO;

-- ㄷ.
SELECT T.DEPTNO, D.DNAME
FROM (
    SELECT DEPTNO
    FROM DEPT
    MINUS
    SELECT DISTINCT DEPTNO
    FROM EMP
)T JOIN DEPT D ON T.DEPTNO = D.DEPTNO;

-- ㄹ. SQL 연산자 ALL, ANY, SOME, ( NOT EXISTS )
SELECT M.DEPTNO, M.DNAME
FROM DEPT M
WHERE NOT EXISTS ( SELECT EMPNO FROM EMP WHERE DEPTNO = M.DEPTNO );

-- ㅁ. 상관서브쿼리;
SELECT M.DEPTNO, M.DNAME
FROM DEPT M
WHERE ( SELECT COUNT(*) FROM EMP WHERE DEPTNO = M.DEPTNO ) = 0; -- EMP 테이블에 존재하지 않는 부서정보

-- [문제] insa 테이블에서 각 부서별 여자사원수를 파악해서 5명 이상인 부서 정보 출력
SELECT BUSEO, COUNT(*)여자사원수
FROM INSA
WHERE MOD(SUBSTR(SSN,-7,1),2) = 0
GROUP BY BUSEO
HAVING COUNT(*)>=5;

-- [문제] insa 테이블
--  [총사원수] [남자사원수] [여자사원수] [남사원들의  [여사원들의  [남자-      [여자-
--                                    총급여합]   총급여합]  max(급여)]  max(급여)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60        31          29   51961200   41430400    2650000    2550000

SELECT COUNT(*) "[총사원수]"
    , COUNT(DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'O')) "[남자사원수]"
    , COUNT(DECODE(MOD(SUBSTR(SSN,-7,1),2),0,'O')) "[여자사원수]"
    , SUM(DECODE(MOD(SUBSTR(SSN,-7,1),2),1,BASICPAY)) "[남사원들의총급여합]"
    , SUM(DECODE(MOD(SUBSTR(SSN,-7,1),2),0,BASICPAY)) "[여사원들의총급여합]"
    , MAX(DECODE(MOD(SUBSTR(SSN,-7,1),2),1,BASICPAY)) "[남자-max(급여)]"
    , MAX(DECODE(MOD(SUBSTR(SSN,-7,1),2),0,BASICPAY)) "[여자-max(급여)]"
FROM INSA;
-- ㄴ
SELECT
    DECODE(MOD(SUBSTR(SSN,8,1),2),1,'남자',0,'여자','전체') || '사원수' 사원
    ,COUNT(*) 사원수
    ,SUM(BASICPAY) 급여합
    ,MAX(BASICPAY) 최고급여
FROM INSA
GROUP BY ROLLUP(MOD(SUBSTR(SSN,8,1),2));

-- [문제] emp 테이블에서~
--      각 부서의 사원수, 부서 총급여합, 부서 평균급여
-- 결과)
--  DEPTNO     부서원수          총급여합           평균
---------- ----------       ----------    ----------
--      10          3             8750       2916.67
--      20          3             6775       2258.33
--      30          6            11600       1933.33 
--      40          0                0             0

SELECT D.DEPTNO
    , COUNT(E.EMPNO) 부서원수
    , NVL(SUM(E.SAL+NVL(E.COMM,0)),0) 총급여합
    , NVL(ROUND(AVG(E.SAL+NVL(E.COMM,0)),2),0) 평균
FROM EMP E RIGHT JOIN DEPT D ON e.deptno=d.deptno
GROUP BY D.DEPTNO
ORDER BY D.DEPTNO;

-- [ ROLLUP절과 CUBE절 ]
--  ㄴ GROUP BY 절에서 사용되어 그룹별 소계를 추가로 보여주는 역할
--  ㄴ 즉, 추가적인 집계 정보를 보여준다.
SELECT
    CASE MOD(SUBSTR(SSN,-7,1),2)
        WHEN 1 THEN '남자'
        ELSE '여자'
    END 성별
    , COUNT(*) 사원수
FROM INSA
GROUP BY MOD(SUBSTR(SSN,-7,1),2)
UNION ALL
SELECT '전체', COUNT(*)
FROM INSA;

-- GROUP BY + ROLLUP/CUBE
SELECT
    CASE MOD(SUBSTR(SSN,-7,1),2)
        WHEN 1 THEN '남자'
        WHEN 0 THEN '여자'
        ELSE '전체'
    END 성별
    , COUNT(*) 사원수
FROM INSA
GROUP BY CUBE (MOD(SUBSTR(SSN,-7,1),2));
--GROUP BY ROLLUP (MOD(SUBSTR(SSN,-7,1),2));

-- ROLLUP / CUBE 의 차이점..
-- 1차 부서별로 그룹핑, 2차 직위별로 그룹핑
SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO, JIKWI
UNION ALL
SELECT BUSEO,NULL, COUNT(*) 부서원수
FROM INSA
GROUP BY BUSEO
ORDER BY BUSEO, JIKWI;
-- 1)
SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY CUBE(BUSEO, JIKWI)
ORDER BY BUSEO, JIKWI;
-- 2)
SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO, JIKWI
UNION ALL
SELECT BUSEO,NULL, COUNT(*) 부서원수
FROM INSA
GROUP BY BUSEO
UNION ALL
SELECT NULL, JIKWI, COUNT(*) 부서원수
FROM INSA
GROUP BY JIKWI;

-- 분할 ROLLUP
SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM insa
GROUP BY ROLLUP(buseo),jikwi    -- 직위에 대한 부분 집계 , 전체집계x
--GROUP BY buseo, ROLLUP(jikwi) -- 부서에 대한 부분 집계 , 전체집계x
--GROUP BY ROLLUP(buseo,jikwi)
--GROUP BY CUBE(buseo,jikwi)
ORDER BY buseo, jikwi;

-- [ GROUPING SETS 함수 ]
SELECT buseo, '', COUNT(*)
FROM insa
GROUP BY buseo
UNION ALL
SELECT '', jikwi,COUNT(*)
FROM insa
GROUP BY jikwi;
--
SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM insa
GROUP BY GROUPING SETS(buseo, jikwi) -- 그룹핑한 집계만 보고자 할때
ORDER BY buseo, jikwi;

-- 피봇(PIVOT) 문제
-- 1. 테이블 설계 X (프로젝트 진행~)
-- tbl_pivot 테이블 생성
-- 번호, 이름, 국,영,수 관리 테이블
-- DDL 문 : CREATE
CREATE TABLE tbl_pivot
(
--    컬럼명 자료형(크기) 제약 조건...
    NO NUMBER PRIMARY KEY -- 고유한키(PK) 제약조건
    , NAME VARCHAR2(20 BYTE) -- NN 제약조건(==필수입력사항)
    , jumsu NUMBER(3) -- NULL 허용
);
--Table TBL_PIVOT이(가) 생성되었습니다.
SELECT *
FROM tbl_pivot;

INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '박예린', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '박예린', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '박예린', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '안시은', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '안시은', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '안시은', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '김민', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '김민', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '김민', 100 );  -- mat 

COMMIT; 

 -- 질문) 피봇
--번호 이름   국,  영,  수
--1   박예린  90 89 99
--2   안시은  56 45 12
--3   김민    99 85 100

SELECT *
FROM(
    SELECT TRUNC((NO-1)/3)+1 NO
            ,NAME
            ,DECODE(MOD(NO,3),1,'국어',2,'영어',0,'수학') 과목
            , JUMSU
    FROM tbl_pivot
    )
PIVOT(
    SUM(JUMSU)
    FOR 과목 IN ('국어','영어','수학')
)
ORDER BY NO;
--
SELECT *
FROM(
    SELECT TRUNC((NO-1)/3)+1 NO
            ,NAME
            ,ROW_NUMBER()OVER(PARTITION BY NAME ORDER BY NO) 과목
            , JUMSU
    FROM tbl_pivot
    )
PIVOT(
    SUM(JUMSU)
    FOR 과목 IN (1 AS "국어", 2 AS "영어", 3 AS "수학")
)
ORDER BY NO;

-- [풀이] 각년도별 월별 입사한 사원수 파악(조회)
-- ORA-01788: CONNECT BY clause required in this query block
-- LEVEL 과 CONNECT BY는 같이 사용해야한다.
SELECT LEVEL MONTH
FROM DUAL
CONNECT BY LEVEL <= 12;
--
SELECT EMPNO
        , TO_CHAR(HIREDATE,'YYYY') YEAR
        , TO_CHAR(HIREDATE,'MM') month
FROM EMP;
--
SELECT year, m.month, NVL(COUNT(empno), 0) n
FROM  (
      SELECT empno, TO_CHAR( hiredate, 'YYYY') year
            , TO_CHAR( hiredate, 'MM' ) month
      FROM emp
     ) e
     PARTITION BY ( e.year ) RIGHT OUTER JOIN 
    (
       SELECT LEVEL month   
       FROM dual
       CONNECT BY LEVEL <= 12
     ) m 
     ON e.month = m.month
     GROUP BY year, m.month
     ORDER BY year, m.month;
--    YEAR      MONTH          N
--    ---- ---------- ----------
--    1980          1          0
--    1980          2          0
--    1980          3          0
--    :

SELECT *
FROM EMP;
SELECT TO_CHAR(HIREDATE,'YYYY') H_YEAR
       , COUNT(*)
FROM EMP
GROUP BY TO_CHAR(HIREDATE,'YYYY')
ORDER BY H_YEAR;

-- [풀이] INSA 에서 부서별, 직위별 사원수
SELECT BUSEO, JIKWI, COUNT(*)
FROM INSA
GROUP BY BUSEO, JIKWI
ORDER BY BUSEO, JIKWI;
-- [문제] 각 부서별 직위별 최소사원수, 최대사원수 조회
-- 2가지 --
WITH t1 AS (
    SELECT buseo, jikwi, COUNT(num) tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
  , t2 AS (
     SELECT buseo, MIN(tot_count) buseo_min_count
                 , MAX(tot_count) buseo_max_count
     FROM t1
     GROUP BY buseo
  )
SELECT A.BUSEO
    , B.JIKWI 최소부서
    , B.TOT_COUNT 최소사원수
FROM t2 A , T1 B
WHERE A.BUSEO = B.BUSEO AND A.BUSEO_MIN_COUNT = B.TOT_COUNT;

-- FIRST/MAX 분석함수 사용해서 풀이
WITH t AS (
    SELECT buseo, jikwi, COUNT(num) tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
SELECT T.BUSEO
    , MIN(T.jikwi) KEEP(DENSE_RANK FIRST ORDER BY T.TOT_COUNT ASC) 최소직위
    , MIN(T.TOT_COUNT) 최소사원수
    , MAX(T.jikwi) KEEP(DENSE_RANK LAST ORDER BY T.TOT_COUNT ASC) 최대직위
    , MAX(T.TOT_COUNT) 최대사원수
FROM T
GROUP BY T.BUSEO
ORDER BY 1;

-- 1) 분석함수 FIRST, LAST
--           집계함수(COUNT,SUM,AVG,MAX,MIN)와 같이 사용하여
--           주어진 그룹에 대해 내부적으로 순위를 매겨 결과를 산출하는 함수
WITH a AS
(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
)
SELECT MIN(cnt)
    , MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt DESC) min_dname
    , MAX(cnt)
    , MAX(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt DESC) max_dname
FROM a;

-- 2) SELF JOIN
SELECT A.EMPNO,A.ENAME,A.MGR, B.ENAME
FROM EMP A JOIN EMP B ON A.MGR = B.EMPNO;

-- SELF JOIN
SELECT *
FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO; -- INNER JOIN 생략되어있음
-- NON EQUAL JOIN
SELECT EMPNO, ENAME, SAL, GRADE
FROM EMP E JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL;
-- 위와 같은 출력
SELECT ename, sal 
   ,  CASE
        WHEN  sal BETWEEN 700 AND 1200 THEN  1
        WHEN  sal BETWEEN 1201 AND 1400 THEN  2
        WHEN  sal BETWEEN 1401 AND 2000 THEN  3
        WHEN  sal BETWEEN 2001 AND 3000 THEN  4
        WHEN  sal BETWEEN 3001 AND 9999 THEN  5
      END grade
FROM emp;
-- CROSS JOIN
SELECT EMPNO, ENAME, SAL, GRADE
FROM EMP E , SALGRADE S;

-- [문제] EMP 테이블에서 가장 입사일자가 빠른 사원과
--                    가장 입사일자가 늦은 사원과의 입사 차이 일 수?
SELECT MAX(HIREDATE) - MIN(HIREDATE)
FROM EMP;

-- 분석함수 : CUME_DIST
--      ㄴ 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
--      ㄴ 분포도값(비율)  0 <     <=1
SELECT DEPTNO, ENAME, SAL
--    ,CUME_DIST()OVER(ORDER BY SAL ASC) DEPT_LIST
    ,CUME_DIST()OVER(PARTITION BY DEPTNO ORDER BY SAL ASC) DEPT_LIST
FROM EMP;

-- 분석함수 : PERCENT_RANK()
--     ㄴ 해당 그룹 내의 백분위 순위
--          0<=     사이의 값     <=1
-- 백분위 순위 ? 그룹 안에서 해당 행의 값보다 작은 값의 비율

-- NTILE()  N타일
--  ㄴ 파티션 별로 표현식에 명시된 만큼 분할한 결과를 반환하는 함수
-- 분할하는 수를 버킷(BUCKET) 이라고 한다.
SELECT DEPTNO, ENAME, SAL
    , NTILE(4)OVER(ORDER BY SAL ASC) NTILES
FROM EMP;
--
SELECT DEPTNO, ENAME, SAL
    , NTILE(2)OVER(PARTITION BY DEPTNO ORDER BY SAL ASC) NTILES
FROM EMP;

-- WIDTH_BUCKET(expr,minvalue,maxvalue,numbuckets) == NTILE() 함수와 유사한 분석함수, 차이점
SELECT DEPTNO, ENAME, SAL
    ,NTILE(4) OVER(ORDER BY SAL) NTILES
    ,WIDTH_BUCKET(SAL,1000,4000,4)WIDTHBUCKETS
    -- SAL 값이 1000~4000 사이인 부분을 4단계(1 - 1000~1750, 2 - 1750~2500, 3 - 2500~3250, 4 - 3250~4000)로 나눈다
FROM EMP;

-- LAG( expr, offset, default_value )
--  ㄴ 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수
--  ㄴ 선행(앞) 행
-- LEAD( expr, offset, default_value )
--  ㄴ 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수
--  ㄴ 후행(뒤) 행
SELECT DEPTNO, ENAME, HIREDATE, SAL
    ,LAG(SAL,1,0)OVER(ORDER BY HIREDATE)PREV_SAL
    ,LEAD(SAL,1,-1)OVER(ORDER BY HIREDATE)NEXT_SAL
FROM EMP
WHERE DEPTNO = 30;

------------------------------------------------------------------------------------------
-- [ 오라클 자료형 (Data Type) ]  
-- 1)CHAR[(SIZE 단위[BYTE|(CHAR)]   문자열 자료형
--   CHAR = CHAR(1 BYTE) = CHAR(1)
--   CHAR(3 BYTE) = CHAR(3)
--   CHAR(3 BYTE) = CHAR(3)   'ABC'   '한'
--   CHAR(3 CHAR  'ABC'   '한두셋'
--   고정 길이의 문자열 자료형
--   name CHAR(10 BYTE) [A][B][C][][]][][]    'ABC'
--   2000 BYTE 크기 할당할 수 있다.
--   예) 주민등록번호, 학번 등,,,
   
-- 테스트
CREATE TABLE TBL_CHAR
(
    AA CHAR         -- CHAR(1) == CHAR(1 BYTE)
    ,BB CHAR(3)     -- CHAR(3 BYTE)
    ,CC CHAR(3 CHAR)

);

DESC TBL_CHAR;

INSERT INTO TBL_CHAR(AA,BB,CC) VALUES('A','AAA','AAA');
INSERT INTO TBL_CHAR(AA,BB,CC) VALUES('B','한','한우리');
INSERT INTO TBL_CHAR(AA,BB,CC) VALUES('C','한우리','한우리');-- BB에는 3BYTE가 할당되었기 때문에 오류발생

-- 2) NCHAR
--    N== UNICODE(유니코드)
--    NCHAR[(SIZE)]
--    NCHAR(1) == NCHAR
--    NCHAR(10)
--    고정길이 문자열 자료형
--    2000 BYTE 까지 저장가능
   
   CREATE TABLE TBL_NCHAR
(
    AA CHAR(3)          -- CHAR(3BYTE)
    ,BB CHAR(3 CHAR)
    ,CC NCHAR(3)

);

INSERT INTO TBL_NCHAR(AA,BB,CC)VALUES('홍','길동','홍길동');

INSERT INTO TBL_NCHAR(AA,BB,CC)VALUES('홍길동','홍길동','홍길동'); -- AA에는 3BYTE가 할당되었으므로 오류발생

COMMIT;

-- 3) VARCHAR2 == VARCHAR
--    가변 길이 문자열 자료형
--    4000BYTE 최대크기
--    VARCHAR2(size [BYTE ? CHAR])
--    VARCHAR2(1) = VARCHAR2(1 BYTE) = VARCHAR2
--    
--    NAME VARCHAR2(10)           [A][D][M][I][N][][][][][]    'ADMIN'
--                                                ㄴ 사용하지 않는 메모리는 버림

 4) NVARCHAR2
    유니코드 + 가변길이 + 문자열 자료형
    NVARCHAR2(size)
    NVARCHAR2(1) = NVARCHAR2
    4000 BYTE
 
 5) NUMBER[(p[,s])]
            ㄴ PRECISION  SCALE
      사전적의미 : 정확도     규모
                 전체자리수  소수점이하자릿수
                 1~38      -84~127
    NUMBER = NUMBER( 38 , 127 )
    NUMBER(P) = NUMBER(P,0)
    
    예)
    CREATE TABLE TBL_NUMBER
    (
        NO NUMBER(2) NOT NULL PRIMARY KEY
        -- 기본키는 NULL 값을 가질수 없고 고유한 키값을 갖는다.
        -- 기본키를 다른 칼럼으로 변경하는 것을 생각하여 NOT NULL 을 기입.
        , NAME VARCHAR2(30) NOT NULL
        ,KOR NUMBER(3)
        ,ENG NUMBER(3)
        ,MAT NUMBER(3) DEFAULT 0
    );
    
    INSERT INTO TBL_NUMBER(NO,NAME,KOR,ENG,MAT) VALUES(1,'홍길동',90,88,98);
    COMMIT;
    
--    SQL 오류: ORA-00947: not enough values
--    INSERT INTO TBL_NUMBER(NO,NAME,KOR,ENG,MAT) VALUES(2,'이시훈',100,100);
    
    INSERT INTO TBL_NUMBER(NO,NAME,KOR,ENG) VALUES(2,'이시훈',100,100);
--    SQL 오류: ORA-00947: not enough values    
--    INSERT INTO TBL_NUMBER VALUES(3,'송세호',50,50);
    
    INSERT INTO TBL_NUMBER VALUES(3,'송세호',50,50,100);
    COMMIT;
    --
    INSERT INTO TBL_NUMBER(NAME,NO,KOR,ENG,MAT) VALUES('김재민',4,50,50,100);
    COMMIT;
    SELECT *
    FROM TBL_NUMBER;
    --
--  ORA-00001: unique constraint (SCOTT.SYS_C007027) violated
--  유일성 제약에 위배된다.
--  INSERT INTO TBL_NUMBER VALUES(4,'김선우',110,56.234,-999);
    
    INSERT INTO TBL_NUMBER VALUES(5,'김선우',110,56.234,-999); -- 반올림
    INSERT INTO TBL_NUMBER VALUES(5,'김선우',110,56.934,-999); -- 반올림
    ROLLBACK;
    
 6) FLOAT[(p)]  == 내부적으로 NUMBER 처럼 나타낸다.
 7) LONG    가변길이(VAR) 문자열 자료형, 2GB까지 지원
 8) DATE    날짜, 시간 값(고정길이, 7byte)을 저장
    TIMESTAMP [(n)] DATE의 확장 형태로, 최대 9자리의 년,월,일,시,분,초,밀리초까지 보여줌
            n은 초단위 다음에 이어서 나타낼 mili second의 자릿수로 기본값은 6이다
 9) RAW(size)- 2000 BYTE 이진데이터
    LONG RAW - 2GB       이진데이터
 10) LOB 타입인 BLOB, CLOB, NCLOB는 내부에 저장되지만, BFILE은 외부에 저장한다.
     CLOB - 텍스트 데이터를 저장=(4GB-1)*(data block size)
     NCLOB - 텍스트 데이터를 저장=(4GB-1)*(data block size)
     BLOB - 2진 데이터를 (4GB-1)*(database block size)까지 저장
     BFILE - 2진 데이터를 외부 file형태로 4GB까지 저장
    
-- FIRST_VALUE 분석함수 : 정렬된 값 중에 첫 번째 값
SELECT FIRST_VALUE(basicpay) OVER(ORDER BY basicpay DESC)
FROM insa;

SELECT FIRST_VALUE(basicpay) OVER(PARTITION BY BUSEO ORDER BY basicpay DESC)
FROM insa;
-- 가장 많은 급여(basicpay) 각사원의 basicpay의 차이
SELECT buseo, name, basicpay
    ,FIRST_VALUE(basicpay) OVER(PARTITION BY BUSEO ORDER BY basicpay DESC)
    ,FIRST_VALUE(basicpay) OVER(PARTITION BY BUSEO ORDER BY basicpay DESC) -- basicpay 차이
FROM insa; 

-- COUNT ~ OVER : 질의한 행의 누적된 결과 반환
-- SUM ~ OVER : 질의한 행의 누적된 결과(합) 반환
-- AVG ~ OVER : 질의한 행의 누적된 결과(평균) 반환
SELECT NAME, BASICPAY, BUSEO
--        ,COUNT(*)OVER(ORDER BY BASICPAY ASC)누계
--        ,SUM(BASICPAY)OVER(ORDER BY BUSEO ASC)누계합
        ,AVG(BASICPAY)OVER(ORDER BY BUSEO ASC)누계평균
FROM INSA;

SELECT NAME, BASICPAY, BUSEO
--        ,COUNT(*)OVER(PARTITION BY BUSEO ORDER BY BASICPAY ASC)누계
--        ,SUM(BASICPAY)OVER(PARTITION BY BUSEO ORDER BY BUSEO ASC)누계합
        ,)OVER(PARTITION BY BUSEO ORDER BY BUSEO ASC)누계합
FROM INSA;

-- ■ 테이블 생성, 수정, 삭제 (DDL : CREATE, ALTER, DROP)
-- 테이블(TABLE) : 데이터 저장소
-- 아이디      : 문자 10
-- 이름       : 문자 20
-- 나이       : 숫자 30
-- 전화번호    : 문자 20
-- 생일       : 날짜
-- 비고       :문자 255
CREATE TABLE TBL_SAMPLE
(
    ID VARCHAR2(10)
    , NAME VARCHAR2(20)
    , AGE NUMBER(3)
    , BIRTH DATE
);

-- Table TBL_SAMPLE이(가) 생성되었습니다.
SELECT *
FROM TABS
WHERE REGEXP_LIKE(TABLE_NAME,'^TBL_','i');
--WHERE TABLE_NAME LIKE 'TBL\_%' ESCAPE '\';
--
DESC TBL_SAMPLE;
-- 전화번호, 비고 칼럼 X -> 테이블 수정.
ALTER TABLE TBL_SAMPLE
ADD(
    TEL VARCHAR2(20) -- DEFAULT '000-0000-0000'
    ,BIGO VARCHAR2(255)
);
--
SELECT *
FROM TBL_SAMPLE;
-- 비고 컬럼의 크기 수정, 자료형 수정
--          (255->100)
ALTER TABLE TBL_SAMPLE
MODIFY (BIGO VARCHAR2(100));
DESC TBL_SAMPLE;

-- BIGO 컬럼명 -> MEMO 컬럼명 변경
-- ALTER TABLE X
SELECT bigo memo
FROM tbl_sample;
--
ALTER TABLE tbl_sample
    RENAME COLUMN bigo to memo;
    
-- memo 컬럼 제거
ALTER TABLE tbl_sample
DROP COLUMN memo;
-- 테이블 삭제
DROP TABLE 테이블명 CASCADE;

-- 테이블명을 변경 tbl_sample -> tbl_example
RENAME tbl_sample TO tbl_example;
-- 테이블이름이 변경되었습니다.
--
SELECT *
FROM tbl_example;