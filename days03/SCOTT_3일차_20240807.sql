-- SCOTT
-- [LIKE 연산자의 ESCAPE 옵션 설명]
-- ㄴ wildcard를 일반 문자처럼 쓰고 싶은 경우에는 ESCAPE 옵션을 사용
SELECT deptno, dname, loc
FROM dept;
-- dept 테이블에 새로운 부서정보를 추가
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated    유일성 제약조건 위배
-- deptno 는 기본키(PK) 이기 때문
-- > 기본키는 NULL 값을 가질 수 없으며 고유한 값(UNIQUE KEY)을 갖는다
INSERT INTO dept (deptno,dname,loc) VALUES (60,'한글_나라','COREA');
INSERT INTO dept VALUES (60,'한글_나라','COREA');
COMMIT;
ROLLBACK;
-- [문제 부서명에 % 문자 포함된 부서 정보를 조회]
SELECT *
FROM DEPT
WHERE DNAME LIKE '%\%%' ESCAPE '\';

--ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
DELETE FROM dept;
DELETE FROM dept
WHERE DEPTNO = 60;
DELETE FROM EMP; -- WHERE 조건절이 없으면 모든 레코드 삭제
ROLLBACK;
COMMIT;

UPDATE 테이블명
SET 컬럼명=칼럼값,컬럼명=칼럼값,컬럼명=칼럼값;

UPDATE dept
SET dname = 'QC'; -- WHERE 조건절이 없으면 모든 레코드 수정
ROLLBACK;

UPDATE dept
-- SET dname = dname||'XX';
SET dname = SUBSTR(dname,0,2), loc = 'COREA'
WHERE deptno = 50;

SELECT * FROM DEPT;

-- [문제] 40번 부서의 부서명,지역명을 얻어와서
--       50번 부서의 부서명으로, 지역명으로 수정하는 쿼리 작성
SELECT DNAME,LOC
FROM DEPT
WHERE deptno = 40;

UPDATE dept
SET dname = (SELECT dname FROM DEPT WHERE deptno = 40)
    , loc = (SELECT loc FROM DEPT WHERE deptno = 40)
WHERE deptno = 50;

ROLLBACK;

UPDATE DEPT
SET (dname,loc) = (SELECT dname,loc FROM DEPT WHERE deptno = 40)
WHERE DEPTNO = 50;

-- [문제] dept        50,60,70 deptno 삭제
DELETE dept
WHERE DEPTNO BETWEEN 50 AND 70;
--WHERE DEPTNO IN(50,60,70);

-- [문제] EMP 테이블 모든 사원의 SAL 기본급을 PAY급여의 10% 인상하는 UPDATE
SELECT * FROM EMP;

UPDATE EMP
SET SAL = SAL + (SAL + NVL(COMM,0))*0.1;

ROLLBACK;

SELECT *
FROM (
    SELECT SAL , NVL(COMM,0)COMM, SAL + NVL(COMM,0) PAY
    FROM EMP
)

-- DUAL 테이블 == 시노님
-- 스키마.객체명

-- PUBLIC 시노님 생성
-- ORA-01031: insufficient privileges
-- 권한이 없기 때문에 scott에서는 생성 불가
--CREATE PUBLIC SYNONYM arirang
--FOR scott.emp;

-- 권한 부여
-- GRANT SELECT ON sh.sales TO warehouse_user;
GRANT SELECT ON ARIRANG TO HR;

-- 권한 회수
REVOKE SELECT
	ON EMP
	FROM HR
	CASCADE CONSTRAINTS;
    
---------------------------------------------------------------------------------------------------------
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