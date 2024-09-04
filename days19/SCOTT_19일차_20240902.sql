-- SCOTT
SELECT rowid, emp.*
from emp;
-- EMP 테이블에 PK(empno) / 인덱스
SELECT *
FROM emp
WHERE SUBSTR( empno, 0, 2 ) = 76; -- 0.009초 FULL SCAN
-- 위 WHERE 절 같이 

-- WHERE empno = 7369; -- 0.007초 INDEX ( UNIQUE SCAN )
-- WHERE deptno = 30 AND sal > 1300; -- 0.003초 FULL SCAN
-- CREATE INDEX DS_EMP ON emp(deptno,sal); -- 0.005초 INDEX ( RANGE SCAN )
-- DROP INDEX DS_EMP;

--WHERE deptno = 10;
--WHERE empno > 7600;
--WHERE ename = 'SMITH';
--WHERE empno = 7369;

-- 인덱스 검색
SELECT *
FROM user_indexes
WHERE table_name = 'EMP';


SELECT *
FROM USER_TABLES;

SELECT *
FROM DEPT;

SELECT * FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO;

SELECT e.grade, s.losal, s.hisal, count(*) cnt
FROM salgrade s JOIN emp e ON sal BETWEEN losal AND hisal
GROUP BY grade

SELECT d.deptno, dname, empno, ename,sal
FROM dept d RIGHT JOIN emp e ON d.deptno = e.deptno
                  JOIN salgrade s ON sal BETWEEN losal AND hisal
WHERE grade =

SELECT E.*,
       CASE WHEN 700 <= SAL AND SAL <= 1200 THEN '1등급'
            WHEN 1201 <= SAL AND SAL <= 1400 THEN '2등급'
            WHEN 1401 <= SAL AND SAL <= 2000 THEN '3등급'
            WHEN 2001 <= SAL AND SAL <= 3001 THEN '4등급'
            ELSE '5등급'
       END AS GRADE,
       D.DNAME
FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO;


select * from dept;


SELECT *
FROM EMP E FULL JOIN DEPT D ON E.DEPTNO = D.DEPTNO;

SELECT E.DEPTNO,D.DNAME,COUNT(*)CNT
FROM EMP E FULL JOIN DEPT D ON E.DEPTNO = D.DEPTNO
GROUP BY DNAME,E.DEPTNO
ORDER BY E.DEPTNO;


SELECT E.EMPNO, ENAME, HIREDATE, SAL+NVL(COMM,0) PAY,D.DEPTNO,D.DNAME
FROM EMP E FULL JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE D.DEPTNO = ;

-- ID 중복체크하는 저장 프로시저
CREATE OR REPLACE PROCEDURE up_idcheck
(
  pid IN emp.empno%TYPE
  , pcheck  OUT NUMBER -- 0/1
)
IS 
BEGIN
   SELECT COUNT(*) INTO pcheck
   FROM emp
   WHERE empno = pid;
--EXCEPTION
--  WHEN OTHERS THEN
--    RAISE AP_E)
END;
-- Procedure UP_IDCHECK이(가) 컴파일되었습니다.
DECLARE
  vcheck NUMBER(1);
BEGIN
   UP_IDCHECK(9999, vcheck);
   DBMS_OUTPUT.PUT_LINE( vcheck );
END ;


-- 로그인 체크하는 저장 프로시저
CREATE OR REPLACE PROCEDURE up_login
(
  pid IN emp.empno%TYPE
  , ppwd IN emp.ename%TYPE
  , pcheck  OUT NUMBER --   0(성공), 1(ID 존재, pwd x), -1(ID존재 X)
)
IS 
  vpwd emp.ename%TYPE;
BEGIN
   SELECT COUNT(*) INTO pcheck
   FROM emp
   WHERE empno = pid;
   
   IF pcheck = 1 THEN  -- ID 존재
      SELECT ename INTO vpwd
      FROM emp
      WHERE empno = pid;
      
      IF vpwd = ppwd THEN -- ID 존재 O, PWD 일치
         pcheck := 0;
      ELSE -- ID 존재 O, PWD X
         pcheck := 1;
      END IF;
   ELSE -- ID 존재
         pcheck := -1;
   END IF;
   
--EXCEPTION
--  WHEN OTHERS THEN
--    RAISE AP_E)
END;




-- DEPT 테이블의 모든 부서 정보를 조회하는 저장프로시저
CREATE OR REPLACE PROCEDURE up_selectdept
(
    pdeptcursor OUT SYS_REFCURSOR
)
IS 
BEGIN
    OPEN pdeptcursor FOR
        SELECT *
        From dept;
--EXCEPTION
--  WHEN OTHERS THEN
--    RAISE AP_E)
END;

-- DEPT 테이블의 모든 부서 정보를 조회하는 저장프로시저
CREATE OR REPLACE PROCEDURE up_deletedept
( 
     pdeptno IN dept.deptno%TYPE
)
IS   
BEGIN
    DELETE FROM  dept 
    WHERE deptno = pdeptno;
    COMMIT;
-- EXCEPTION    
END; 

select * from dept;

CREATE OR REPLACE PROCEDURE up_insertdept
( 
     pdeptno IN dept.deptno%TYPE,
     pdname IN dept.dname%TYPE,
     ploc IN dept.loc%TYPE
)
IS   
BEGIN
    INSERT INTO dept 
    VALUES (pdeptno,pdname,ploc);
    COMMIT;
-- EXCEPTION    
END; 

