-- SCOTT
-- [ 저장 프로시저 stored procedure ]
CREATE OR REPLACE PROCEDURE 프로시저명
(
    매개변수( argument, parameter ) 선언 ,  ※ 세미콜론(;) 아님 / 타입의 크기 X
    p매개변수명  [mode] 자료형
                IN      입력용 파라미터 (기본)
                OUT     출력용 파라미터
                IN OUT  입/출력용 파라미터
)
IS  -- DECLARE
    변수 상수 선언
    v
BEGIN
EXCEPTION
END;
-- 저장 프로시저를 실행하는 방법 ( 3가지 )
--    1) EXECUTE 문으로 실행
--    2) 익명 프로시저에서 호출해서 실행
--    3) 또 다른 저장 프로시저에서 호출하여 실행

-- 서브쿼리를 사용해서 테이블 생성
CREATE TABLE tbl_emp
AS
(
    SELECT *
    FROM emp
);
-- Table TBL_EMP이(가) 생성되었습니다.
SELECT *
FROM tbl_emp;
-- tbl_emp 테이블에서 사원번호를 입력받아서 사원을 삭제하는 쿼리 -> 저장 프로시저
DELETE FROM tbl_emp
WHERE empno = 7499;
-- up_ (user procedure라는 뜻으로 임의의 접두어로 규칙 정했음)
CREATE OR REPLACE PROCEDURE UP_DELTBLEMP
(
 PEMPNO TBL_EMP.EMPNO%TYPE -- 입력용 파라미터 라는 뜻
)
IS
 -- 변수, 상수 선언할게 없어서 비워둠
BEGIN
    DELETE FROM TBL_EMP
    WHERE EMPNO = PEMPNO;
    COMMIT;
-- EXCEPTION
   -- ROLLBACK;
END;
-- Procedure UP_DELTBLEMP이(가) 컴파일되었습니다.
--    1) EXECUTE 문으로 실행
-- EXECUTE UP_DELTBLEMP; -- 매개변수 수,타입 X,
EXECUTE UP_DELTBLEMP(7566);
-- EXECUTE UP_DELTBLEMP('SMITH');
EXECUTE UP_DELTBLEMP(pempno=>7369);
SELECT *
FROM tbl_emp;
--    2) 익명 프로시저에서 호출해서 실행
--DECLARE
BEGIN
    UP_DELTBLEMP(7499);
--EXCEPTION
END;
--    3) 또 다른 저장 프로시저에서 호출하여 실행
CREATE OR REPLACE PROCEDURE up_DELTBLEMP_test
(
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    UP_DELTBLEMP(7499);
--EXCEPTION
END;
-- Procedure UP_DELTBLEMP_TEST이(가) 컴파일되었습니다.
EXECUTE up_DELTBLEMP_test(7521);
-- CRUD == C(INSERT) R(SELECT) U(UPDATE) D(DELETE)
-- [문제] dept -> tbl_dept 테이블 생성
CREATE TABLE tbl_dept
AS(
    SELECT *
    FROM dept
);
-- Table TBL_DEPT이(가) 생성되었습니다.
-- [문제] TBL_DEPT 제약조건을 확인한 후 deptno 컬럼에 PK 제약 조건 설정
SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_D%';
--
ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno);
-- Table TBL_DEPT이(가) 변경되었습니다.

-- [문제] tbl_dept 테이블 SELECT 문   DBMS_OUTPUT 출력하는 저장 프로시저 생성
--      up_seltbldept
SELECT *
FROM tbl_dept;
-- 명시적 커서
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
    -- 1) 커서 선언
    CURSOR vdcursor IS (
        SELECT deptno,dname,loc
        FROM tbl_dept
    );
    --
    vdrow tbl_dept%ROWTYPE;
BEGIN
    -- 2) OPEN 커서
    OPEN vdcursor;  -- SQL 실행
    -- 3) FETCH
    LOOP
     FETCH vdcursor INTO vdrow;
     EXIT WHEN vdcursor%NOTFOUND;
     DBMS_OUTPUT.PUT( vdcursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
                                        || ', ' ||  vdrow.loc);  
   END LOOP;
    -- 4) CLOSE 커서
    CLOSE vdcursor;
--EXCEPTION
END;

EXEC up_seltbldept;

-- 암시적 커서 ( for문 사용 )
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
BEGIN
    FOR vdrow IN (SELECT deptno,dname,loc FROM tbl_dept)
    LOOP
     --DBMS_OUTPUT.PUT( vdcursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
                                        || ', ' ||  vdrow.loc);
    END LOOP;
--EXCEPTION
END;

EXEC up_seltbldept;

-- [문제] 새로운 부서를 추가하는 저장 프로시저 up_INStbldept
-- 시퀀스 생성 시작값 50 증가값 10
SELECT *
FROM user_sequences;
-- seq_tbldept
CREATE SEQUENCE  seq_tbldept
INCREMENT BY 10 START WITH 50 NOCACHE  NOORDER  NOCYCLE ;
-- Sequence SEQ_TBLDEPT이(가) 생성되었습니다.
DESC TBL_DEPT;
-- dname, loce NULL 값 허용
CREATE OR REPLACE PROCEDURE up_INStbldept
(
    pdname IN tbl_dept.dname%TYPE DEFAULT NULL,
    ploc IN tbl_dept.loc%TYPE := NULL
)
IS
-- vdeptno tbl_dept.deptno%TYPE;            -- 변수 선언해서
BEGIN
--   SELECT MAX(deptno)+10 INTO vdeptno     -- 위에서 선언한 변수에 DEPTNO 최대값
--   FROM tbl_dept;                            가져와서 vdeptno 에 기입

    INSERT INTO tbl_dept (deptno,dname,loc)
    VALUES (seq_tbldept.NEXTVAL,pdname,ploc );
    COMMIT;
--EXCEPTION
    -- ROLLBACK;
END;
-- Procedure UP_INSTBLDEPT이(가) 컴파일되었습니다.
SELECT * FROM tbl_dept;
EXEC UP_INSTBLDEPT;
EXEC UP_INSTBLDEPT('QC','SEOUL');
EXEC UP_INSTBLDEPT(pdname=>'QC',ploc=>'SEOUL');

-- [문제] 부서 번호를 입력받아서 삭제하는 up_deltbldept
CREATE OR REPLACE PROCEDURE up_deltbldept
(
    pdeptno IN tbl_dept.deptno%TYPE
)
IS
BEGIN
    DELETE FROM tbl_dept WHERE deptno = pdeptno;
    COMMIT;
-- EXCEPTION
    -- ROLLBACK;
END;
-- Procedure UP_DELTBLDEPT이(가) 컴파일되었습니다.
EXEC up_deltbldept(50);
EXEC up_deltbldept(70); -- 예외 처리 필요
SELECT * FROM tbl_dept;

-- [문제]
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE := NULL
    , ploc tbl_dept.loc%TYPE := NULL
)
IS
(
    vdname tbl_dept.dname%TYPE; -- 수정 전 원래 부서명
    vloc tbl_dept.loc%TYPE; -- 수정 전 원래 지역명
)
BEGIN
    -- 1) 수정 전의 원래 부서명, 지역명을 vdname, vloc 변수에 저장
    SELECT dname, loc
        INTO vdname, vloc
    FROM tbl_dept
    WHERE deptno = pdeptno;
    -- 2) UPDATE
    IF pdname IS NULL AND ploc IS NULL THEN 
        -- 수정할 것 없음
    ELSIF pdname IS NULL THEN
        UPDATE tbl_dept
        SET loc = ploc
        WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN
        UPDATE tbl_dept
        SET loc = ploc, dname = pdname
        WHERE deptno = pdeptno;
    ELSE
    END IF;
    
    UPDATE tbl_dept SET dname = pdname WHERE deptno = pdeptno;
    UPDATE tbl_dept SET loc = ploc WHERE deptno = pdeptno;
    COMMIT;
--EXCEPTION
END;
--
CREATE  OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
    vdname tbl_dept.dname%TYPE ;  -- 수정 전 원래 부서명
    vloc   tbl_dept.loc%TYPE  ;  -- 수정 전 원래 지역명
BEGIN
  UPDATE tbl_dept
  SET   dname = NVL(pdname, dname)
     , loc = CASE
                 WHEN ploc IS NULL THEN loc
                 ELSE   ploc
             END
  WHERE deptno = pdeptno;
  COMMIT;
--EXCEPTION
END;
--Procedure UP_UPDTBLDEPT이(가) 컴파일되었습니다.
--
SELECT * FROM tbl_dept;
EXEC up_updtbldept( 60, 'X', 'Y' );  -- dname, loc
EXEC up_updtbldept( pdeptno=>60,  pdname=>'QC3' );  -- loc
EXEC up_updtbldept( pdeptno=>60,  ploc=>'SEOUL' );  -- 

EXEC up_deltbldept(60);

DROP SEQUENCE SEQ_TBLDEPT;
-- Sequence SEQ_TBLDEPT이(가) 삭제되었습니다.

-- [문제] 명시적 커서를 사용해서 모든 부서원 조회
-- ( 부서번호를 파라미터로 받아서 해당 부서원만 조회 )
-- up_seltblemp
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
    CURSOR vecursor IS(
        SELECT * FROM tbl_emp WHERE deptno = NVL(pdeptno,10)
    );
    verow tbl_emp%ROWTYPE;
BEGIN
    OPEN vecursor;
    LOOP
        FETCH vecursor INTO verow;
        EXIT WHEN vecursor%NOTFOUND;
        DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
        DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
                              || ', ' ||  verow.hiredate);  

    END LOOP;
    CLOSE vecursor;
--EXCEPTION
END;
-- Procedure UP_SELTBLEMP이(가) 컴파일되었습니다.

CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
    CURSOR vecursor(cdeptno tbl_emp.deptno%TYPE ) IS(
        SELECT * FROM tbl_emp WHERE deptno = NVL(cdeptno,10)
    );
    verow tbl_emp%ROWTYPE;
BEGIN
    OPEN vecursor(pdeptno);
    LOOP
        FETCH vecursor INTO verow;
        EXIT WHEN vecursor%NOTFOUND;
        DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
        DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
                              || ', ' ||  verow.hiredate);  

    END LOOP;
    CLOSE vecursor;
--EXCEPTION
END;
--
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
BEGIN
    FOR verow IN (
        SELECT * FROM tbl_emp WHERE deptno = NVL(pdeptno,10)
        ) 
        LOOP
        DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
                              || ', ' ||  verow.hiredate);
        END LOOP;
--EXCEPTION
END;
-- Procedure UP_SELTBLEMP이(가) 컴파일되었습니다.

EXEC up_seltblemp;
EXEC up_seltblemp(20);
EXEC up_seltblemp(30);

-- [ OUT모드 ]
-- 사원번호(IN) -> 사원명, 주민번호 출력용 매개변수   저장 프로시저 생성
CREATE OR REPLACE PROCEDURE up_selinsa
(
    pnum IN insa.num%TYPE
    , pname OUT insa.name%TYPE
    , pssn OUT insa.ssn%TYPE
)
IS
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    SELECT name, ssn INTO vname,vssn
    FROM insa
    WHERE num = pnum;
    
    pname := vname;
    pssn := CONCAT (SUBSTR(vssn,0,8),'******'); --  123456-1******
    
--EXCEPTION
END;
-- Procedure UP_SELINSA이(가) 컴파일되었습니다.

-- VARIABLE vname 해당 하는 모든 곳에서 사용 가능 (전역변수라고 생각해도 될듯?)
DECLARE
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    UP_SELINSA(1001,vname,vssn);
    DBMS_OUTPUT.PUT_LINE( vname || ', ' || vssn );
END;

-- IN/OUT 입출력용 파라미터 예시)

-- IN + OUT 똑같은 변수를 사용
-- 주민등록번호 14자리를 파라미터로 IN
-- 생년월일(주민번호6자리) 를 OUT 파라미터

CREATE OR REPLACE PROCEDURE up_ssn
(
    pssn IN OUT VARCHAR2
)
IS
BEGIN
    pssn := SUBSTR(pssn,0,6);
--EXCEPTION
END;
-- Procedure UP_SSN이(가) 컴파일되었습니다.

DECLARE
    vssn VARCHAR2(14) := '761230170001'
BEGIN
    UP_SSN(vssn);
    DBMS_OUTPUT.PUT_LINE(vsn)
END;

-- 저장 함수 예) 주민등록번호 -> 성별 체크
--             리턴자료형

CREATE OR REPLACE FUNCTION uf_gender
(
    pssn insa.ssn%TYPE
)
RETURN VARCHAR2
IS
    vgender VARCHAR2(6);
    
BEGIN
    IF MOD(SUBSTR(pssn,-7,1),2) = 1 THEN
        vgender := '남자';
    ELSE
        vgender := '여자';
    END IF;
    RETURN(vgender);
--EXCEPTION
END;
-- Function UF_GENDER이(가) 컴파일되었습니다.

CREATE OR REPLACE FUNCTION uf_age
(
    pssn insa.ssn%TYPE
)
RETURN VARCHAR2
IS
    vage NUMBER(3);
    vbirthyear NUMBER(4);
    
BEGIN
    IF SUBSTR(pssn,3,4) <  TO_CHAR(SYSDATE,'MMDD') THEN
        IF SUBSTR(pssn,-7,1) IN (1,2,5,6) THEN vbirthyear := 1900+SUBSTR(pssn,1,2);
        ELSIF SUBSTR(pssn,-7,1) IN (3,4,7,8) THEN vbirthyear := 2000+SUBSTR(pssn,1,2);
        END IF;
        vage := TO_CHAR(SYSDATE,'YYYY') - vbirthyear;
        RETURN(vage);
    ELSE
        IF SUBSTR(pssn,-7,1) IN (1,2,5,6) THEN vbirthyear := 1900+SUBSTR(pssn,1,2);
        ELSIF SUBSTR(pssn,-7,1) IN (3,4,7,8) THEN vbirthyear := 2000+SUBSTR(pssn,1,2);
        END IF;
        vage := TO_CHAR(SYSDATE,'YYYY') - vbirthyear + 1;
        RETURN(vage);
END IF;
--EXCEPTION
END;
--
CREATE OR REPLACE FUNCTION uf_age
(
   pssn IN VARCHAR2
   , ptype IN NUMBER -- 만나이 0, 세는 나이 1
)
RETURN NUMBER
IS
    ㄱ NUMBER(4);  -- 올해년도
    ㄴ NUMBER(4) ;  -- 생일년도
    ㄷ NUMBER(1);  -- 생일지남 여부      -1   0    1
    vcounting_age NUMBER(3); -- 세는 나이
    vamerican_age NUMBER(3);-- 만 나이
BEGIN
  -- 만나이 = 올해년도 - 생일년도      생일지났여부X -1
  --       =    세는나이 -1          생일지났여부X -1 
  -- 세는나이 = 올해년도 - 생일년도 + 1
  ㄱ := TO_CHAR(SYSDATE,'YYYY');
  ㄴ := CASE 
           WHEN SUBSTR(pssn, -7,1) IN (1,2,5,6) THEN 1900
           WHEN SUBSTR(pssn, -7,1) IN (3,4,7,8) THEN 2000
           ELSE 1800
        END + SUBSTR(pssn,0,2);
  ㄷ := SIGN( TO_DATE(SUBSTR(pssn,3,4), 'MMDD') - TRUNC(SYSDATE) ); --   -1 X     
  vcounting_age := ㄱ - ㄴ + 1;
  vamerican_age := vcounting_age -1 + CASE ㄷ
                                         WHEN 1 THEN -1
                                         ELSE 0
                                      END;
  IF ptype = 1 THEN 
     RETURN vcounting_age;
  ELSE
     RETURN vamerican_age;
  END IF; 
--EXCEPTION
END;


SELECT num, name,ssn, UF_GENDER(ssn) gender
       ,UF_AGE(ssn,1) c_age
       ,UF_AGE(ssn,-1) a_age
FROM insa;
--
-- 예) 주민등록번호-> 1998.01.20(화) 형식의 문자열로 반환하는 저장함수 작성.테스트
CREATE OR REPLACE FUNCTION uf_birth
(
   pssn IN VARCHAR2
)
RETURN VARCHAR2
IS
    vcentury NUMBER(2);  -- 세기 18 19 20
    vbirth VARCHAR2(20);    --  " 1998.01.20(화) "
BEGIN
  vbirth := SUBSTR(pssn,1,6);   -- 771212
  vcentury := CASE
               WHEN SUBSTR(pssn, -7,1) IN (1,2,5,6) THEN 19
               WHEN SUBSTR(pssn, -7,1) IN (3,4,7,8) THEN 20
               ELSE 18
              END;
  vbirth := vcentury || vbirth; -- '19771212'
  vbirth := TO_CHAR(TO_DATE(vbirth), 'YYYY.MM.DD(DY)');
  RETURN (vbirth);
--EXCEPTION
END;
-- Function UF_BIRTH이(가) 컴파일되었습니다.
SELECT SSN, uf_birth(SSN) FROM INSA;
--

CREATE TABLE tbl_score
(
     num   NUMBER(4) PRIMARY KEY
   , name  VARCHAR2(20)
   , kor   NUMBER(3)  
   , eng   NUMBER(3)
   , mat   NUMBER(3)  
   , tot   NUMBER(3)
   , avg   NUMBER(5,2)
   , rank  NUMBER(4) 
   , grade CHAR(1 CHAR)
);
-- Table TBL_SCORE이(가) 생성되었습니다.
SELECT * FROM TBL_SCORE;
--
CREATE SEQUENCE seq_tblscore;
-- Sequence SEQ_TBLSCORE이(가) 생성되었습니다.
SELECT * FROM user_sequences;
--
-- 문제1) 학생 추가하는 저장 프로시저 생성/테스트
EXEC up_insertscore('홍길동', 89,44,55 );
EXEC up_insertscore('윤재민', 49,55,95 );
EXEC up_insertscore('김도균', 90,94,95 );
EXEC up_insertscore('이시훈', 89,75,15 );
EXEC up_insertscore('송세호', 67,44,75 );
SELECT * FROM tbl_score;
CREATE OR REPLACE PROCEDURE up_insertscore
(
    pname   tbl_score.name%TYPE
    , pkor  tbl_score.kor%TYPE
    , peng  NUMBER
    , pmat  NUMBER
)
IS
    vtot NUMBER(3) := 0;
    vavg NUMBER(5,2);
    vgrade tbl_score.grade%TYPE;
BEGIN
    vtot := pkor + peng + pmat;
    vavg := vtot / 3;
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B';
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;
    
    INSERT INTO tbl_score (num,name,kor,eng,mat,tot,avg,rank,grade)
    VALUES (seq_tblscore.NEXTVAL,pname,pkor,peng,pmat,vtot,vavg,1,vgrade);
    
    up_rankScore;
    COMMIT;
--EXCEPTION
END;
-- Procedure UP_INSERTSCORE이(가) 컴파일되었습니다.

-- 문제2) up_updateScore 저장프로시저
SELECT * FROM tbl_score;
EXEC up_updateScore( 1, 100, 100, 100 );
EXEC up_updateScore( 1, pkor =>34 );
EXEC up_updateScore( 1, pkor =>34, pmat => 90 );
EXEC up_updateScore( 1, peng =>45, pmat => 90 );

CREATE OR REPLACE PROCEDURE up_updateScore
( 
    pnum   NUMBER
    , pkor NUMBER := NULL
    , peng NUMBER := NULL
    , pmat NUMBER := NULL
)
IS
  vkor NUMBER(3) ;
  veng NUMBER(3) ;
  vmat NUMBER(3) ; 
  
  vtot NUMBER(3) := 0;
  vavg NUMBER(5,2);
  vgrade tbl_score.grade%TYPE;
BEGIN
   SELECT kor,eng,mat INTO vkor, veng, vmat
   FROM tbl_score
   WHERE num = pnum; 
   
   vtot := NVL(pkor, vkor) + NVL(peng, veng) + NVL(pmat, vmat);
   vavg := vtot / 3;
   
   IF vavg >= 90 THEN
     vgrade := 'A';
  ELSIF vavg >= 80 THEN
     vgrade := 'B';
  ELSIF vavg >= 70 THEN
     vgrade := 'C';
  ELSIF vavg >=  60 THEN
     vgrade := 'D';     
  ELSE 
     vgrade := 'F';
  END IF;

   UPDATE tbl_score
   SET kor=NVL(pkor, kor), eng=NVL(peng,eng), mat=NVL(pmat, mat)
   WHERE num = pnum;
   
   up_rankScore;
   COMMIT;
--EXCEPTION
END;

-- [문제] tbl_score 테이블의 모든 학생의 등수를 처리하는 프로시저 생성
-- up_rankScore
CREATE OR REPLACE PROCEDURE up_rankScore
IS
    vnum NUMBER;
    vrank NUMBER;
BEGIN

    SELECT NUM, RANK()OVER(ORDER BY TOT) INTO vnum, vrank
    FROM tbl_score;
    
    UPDATE tbl_score
    SET rank = vrank
    WHERE NUM = VNUM;
    
    COMMIT;
--EXCEPTION
END;

CREATE OR REPLACE PROCEDURE up_rankScore
IS
BEGIN
    UPDATE tbl_score p
    SET rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE p.tot < c.tot  );
    COMMIT;
--EXCEPTION
END;

EXEC up_rankScore;
SELECT * FROM tbl_score;

-- up_deleteScore   학생 1명 학번으로 삭제 + 등수 처리
CREATE OR REPLACE PROCEDURE up_deleteScore
(
    pnum NUMBER
)
IS
BEGIN
    DELETE FROM tbl_score
    WHERE num = pnum;
    up_rankScore;
    COMMIT;
--EXCEPTION
END;

EXEC up_deleteScore(2);

SELECT * FROM TBL_SCORE;

-- [문제] up_selectScore 모든 학생 정보를 조회 + 명시적 커서 / 암시적 커서
CREATE OR REPLACE PROCEDURE up_selectScore
IS
  --1) 커서 선언
  CURSOR vcursor IS (SELECT * FROM tbl_score);
  vrow tbl_score%ROWTYPE;
BEGIN
  --2) OPEN  커서 실제 실행..
  OPEN vcursor;
  --3) FETCH  커서 INTO 
  LOOP  
    FETCH vcursor INTO vrow;
    EXIT WHEN vcursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ' ' || vrow.name || ' ' || vrow.kor
           || ' ' || vrow.eng || ' ' || vrow.mat || ' ' || vrow.tot
           || ' ' || vrow.avg || ' ' || vrow.grade || ' ' || vrow.rank
        );
  END LOOP;
  --4) CLOSE
  CLOSE vcursor;
--EXCEPTION
  -- ROLLBACK;
END;

CREATE OR REPLACE PROCEDURE up_selectScore
IS
BEGIN
  FOR vrow IN (SELECT * FROM tbl_score) LOOP
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ' ' || vrow.name || ' ' || vrow.kor
           || ' ' || vrow.eng || ' ' || vrow.mat || ' ' || vrow.tot
           || ' ' || vrow.avg || ' ' || vrow.grade || ' ' || vrow.rank
        );
  END LOOP;
--EXCEPTION
  -- ROLLBACK;
END;

EXEC up_selectScore;

-- (암기.기억)
CREATE OR REPLACE PROCEDURE up_selectinsa
(
    -- 커서를 파라미터로 전달
    pinsacursor SYS_REFCURSOR -- 오라클 9i 이전 REF CURSORS
)
IS
    vname insa.name%TYPE;
    vcity insa.city%TYPE;
    vbasicpay insa.basicpay%TYPE;
BEGIN
    LOOP
        FETCH pinsacursor INTO vname,vcity,vbasicpay;
        EXIT WHEN pinsacursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vname || ', ' || vcity || ', ' || vbasicpay);
    END LOOP;
    CLOSE pinsacursor;
--EXCEPTION
END;
-- Procedure UP_SELECTINSA이(가) 컴파일되었습니다.

CREATE OR REPLACE PROCEDURE up_selectinsa_test
IS
    vinsacursor SYS_REFCURSOR;
BEGIN
    -- OPEN ~ FOR 문
    OPEN vinsacursor FOR SELECT name,city,basicpay FROM insa;
    UP_SELECTINSA(vinsacursor);
--EXCEPTION
END;

EXEC up_selectinsa_test;

-- [ 트리거 Trigger ]
CREATE TABLE tbl_exam1
(
   id NUMBER PRIMARY KEY
   , name VARCHAR2(20)
);

CREATE TABLE tbl_exam2
(
   memo VARCHAR2(100)
   , ilja DATE DEFAULT SYSDATE
);

-- tbl_exam1 테이블에 INSERT , UPDATE, DELETE 이벤트가 발생하면
-- 자동으로 tbl_exam2 테이블에 tbl_exam1 테이블에서 일어난 작업을
-- 로그로 기록하는 트리거를 작성하고 확인

CREATE OR REPLACE TRIGGER ut_log
AFTER
INSERT OR DELETE OR UPDATE ON tbl_exam1
FOR EACH ROW
--DECLARE  
BEGIN
  IF INSERTING THEN
     INSERT INTO tbl_exam2 (memo) VALUES ( :NEW.name || '추가 로그 기록...');
  ELSIF DELETING THEN
     INSERT INTO tbl_exam2 (memo) VALUES ( :OLD.name || '삭제 로그 기록...');
  ELSIF UPDATING THEN    
    INSERT INTO tbl_exam2 (memo) VALUES ( :OLD.name || ' -> ' || :NEW.name || '수정 로그 기록...');
  --ELSE
  END IF;  
--EXCEPTION
END;
-- Trigger UT_LOG이(가) 컴파일되었습니다.

UPDATE tbl_exam1
SET name = 'admin'
WHERE id = 1;
COMMIT;

SELECT * FROM tbl_exam1;
SELECT * FROM tbl_exam2;

INSERT INTO tbl_exam1 VALUES(1,'hong');

DELETE FROM tbl_exam1
WHERE id = 1;

rollback;

-- tbl_exam1 대상 테이블로 DML 문이 근무시간(9~17시) 외 또는 주말에는 처리되지 않도록 처리
CREATE OR REPLACE TRIGGER ut_log_before
BEFORE
INSERT OR UPDATE OR DELETE ON tbl_exam1
-- FOR EACH ROW
-- DECLARE
BEGIN
    IF TO_CHAR(SYSDATE,'DY') IN ('토','일')
        OR
        TO_CHAR(SYSDATE,'hh24') > 16
        OR
        TO_CHAR(SYSDATE,'hh24') < 9
    THEN 
    -- 강제로 예외를 발생   자바에서의 예시 : throw new IOException();
    RAISE_APPLICATION_ERROR(-20001,'근무시간이 아니기에 DML 작업 처리할 수 없다.');
    END IF;
--EXCEPTION
END;

INSERT INTO tbl_exam1 VALUES(3,'kim'); -- 현재시간 17:21
-- SQL 오류: ORA-20001: 근무시간이 아니기에 DML 작업 처리할 수 없다.

DROP TABLE TBL_DEPT;
DROP TABLE TBL_EMP;
DROP TABLE TBL_SCORE;
DROP TABLE TBL_EXAM1;
DROP TABLE TBL_EXAM2;