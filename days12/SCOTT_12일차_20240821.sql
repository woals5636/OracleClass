-- SCOTT
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;

-- t_member 테이블 기본키 확인 쿼리
SELECT *  
FROM user_constraints  
WHERE table_name LIKE 'T_M%'  AND constraint_type = 'P';

-- 회원 기입
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  1,         'admin', '1234',  '관리자', '010-1111-1111', '서울 강남구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  2,         'hong', '1234',  '홍길동', '010-1111-1112', '서울 동작구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  3,         'kim', '1234',  '김준석', '010-1111-1341', '경기 남양주시' );
COMMIT;
--
SELECT * FROM t_member;
--
  ㄹ. 회원 정보 수정
  로그인 -> (홍길동) -> [내 정보] -> 내 정보 보기 -> [수정] -> [이름][][][][][][] -> [저장]
  PL/SQL
  UPDATE T_MEMBER
  SET    MEMBERNAME = , MEMBERPHONE = 
  WHERE MEMBERSEQ = 2;
  ㅁ. 회원 탈퇴
  DELETE FROM T_MEMBER 
  WHERE MEMBERSEQ = 2;
--
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES             ( 1  ,'좋아하는 여배우?'
                      , TO_DATE( '2024-02-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                      , TO_DATE( '2024-02-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                      , 5
                      , 0
                      , TO_DATE( '2023-01-15 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                      , 1
                );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (1 ,'배슬기', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (2 ,'김옥빈', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (3 ,'아이유', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (4 ,'김선아', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (5 ,'홍길동', 0, 1 );      
   COMMIT;
--
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES             ( 2  ,'좋아하는 과목?'
                      , TO_DATE( '2024-08-12 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                      , TO_DATE( '2024-08-28 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                      , 4
                      , 0
                      , TO_DATE( '2024-02-20 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                      , 1
                );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (6 ,'자바', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (7 ,'오라클', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (8 ,'HTML5', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (9 ,'JSP', 0, 2 );
COMMIT;
--
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
VALUES             ( 3  ,'좋아하는 색?'
                      , TO_DATE( '2024-09-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                      , TO_DATE( '2024-09-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                      , 3
                      , 0
                      , TO_DATE( '2024-03-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                      , 1
                );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (10 ,'빨강', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (11 ,'녹색', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (12 ,'파랑', 0, 3 ); 

COMMIT;
-- 질문 목록을 출력하는 쿼리 ( 질문이 시작되지 않은 것은 WHERE 조건문으로 제외 )
SELECT *
FROM (
    SELECT  pollseq 번호, question 질문, membername 작성자
         , sdate 시작일, edate 종료일, itemcount 항목수, polltotal 참여자수
         , CASE 
              WHEN  SYSDATE > edate THEN  '종료'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
              ELSE '시작 전'
           END 상태 -- 추출속성   종료, 진행 중, 시작 전
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY 번호 DESC
) t 
WHERE 상태 != '시작 전';  
-- 질문 상세 출력 쿼리
SELECT question, membername
               , TO_CHAR(regdate, 'YYYY-MM-DD AM hh:mi:ss')
               , TO_CHAR(sdate, 'YYYY-MM-DD')
               , TO_CHAR(edate, 'YYYY-MM-DD')
               , CASE 
                  WHEN  SYSDATE > edate THEN  '종료'
                  WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
                  ELSE '시작 전'
               END 상태
               , itemcount
           FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq
           WHERE pollseq = 2;
-- 항목 출력 쿼리
    SELECT answer
           FROM t_pollsub
           WHERE pollseq = 2;
-- 2번 설문 투표인원 출력 쿼리
SELECT  polltotal  
    FROM t_poll
    WHERE pollseq = 2;
-- 막대 그래프 출력 쿼리
SELECT answer, acount
        , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) totalCount
        -- ,  막대그래프
        , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) * 100) || '%'
     FROM t_pollsub
    WHERE pollseq = 2;
-- 투표 삽입
 INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      1   ,  '김기수'      , SYSDATE,   2  ,     7 ,        3 );
    COMMIT;
--
  -- 1)         2/3 자동 UPDATE  [트리거]
    -- (2) t_poll   totalCount = 1증가
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 2;
    
    -- (3)t_pollsub   account = 1증가
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 7;
    
    commit;
--
 INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      2   ,  '홍길동'      , SYSDATE,   2  ,     6 ,        2 );
    COMMIT;
--
  -- 1)         2/3 자동 UPDATE  [트리거]
    -- (2) t_poll   totalCount = 1증가
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 2;
    
    -- (3)t_pollsub   account = 1증가
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 6;
    
    commit;
--
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;

-- PL/SQL ----------------------------------------------------------------------
-- 형식
--    [DECLARE] → 생략가능
--        변수, 상수 선언 블럭
--    BEGIN
--        실행 블럭
--        /*
--        
--        */
--    [EXCEPTION] → 생략가능
--        예외 처리 블럭
--    END;

-- 1) Anonymous Procedure (익명 프로시저)
DECLARE
    vename VARCHAR2(10); -- 세미콜론 기입해야함 ※ 콤마(,)아님
    vpay NUMBER;
    -- 자바 상수 선언 final double PI = 3.141592;
    -- vpi CONSTANT NUMBER = 3.141592;
    vpi CONSTANT NUMBER := 3.141592;
BEGIN
    SELECT ename, sal + NVL(comm,0) pay
            INTO vename, vpay   -- SELECT, FETCH 문에 INTO문을 사용해서 변수의 값을 할당.
    FROM emp
    -- WHERE empno = 7369;
    -- 출력   System.out.printf("%s %d",vename, vpay);
    DBMS_OUTPUT.PUT_LINE( vename || ', ' || vpay );
END;
--PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 커서( CURSOR )

-- 문제) dept 테이블에서 
-- 30번 부서의 부서명을 얻어와서 출력하는  익명프로시저를 작성,테스트
DECLARE
    -- vdname VARCHAR2(14);
    vdname dept.dname%TYPE;
BEGIN
    SELECT dname
        INTO vdname
    FROM DEPT
    WHERE DEPTNO = 30;
-- EXCEPTION
    DBMS_OUTPUT.PUT_LINE( vdname );
END;

-- 문제) 30번 부서의 지역명을 얻어와서
--  10번 부서의 지역명으로 설정하는 익명프로시저를 작성,테스트
DECLARE
    vloc dept.loc%TYPE;
BEGIN
    SELECT loc INTO vloc
    FROM dept
    WHERE deptno = 30;
    
    UPDATE dept
    SET loc = vloc
    WHERE deptno = 10;
-- EXCEPTION
-- 예외가 발생하면 ROLLBACK;
END;
ROLLBACK;

-- [문제] 10번 부서원 중에 최고급여(sal)를 받는 사원의 정보를 출력.(조회)
--1) TOP-N 
SELECT *
FROM (
    SELECT *
    FROM emp
    WHERE deptno = 10
    ORDER BY sal DESC
)
WHERE ROWNUM = 1;
--2) RANK 함수
SELECT *
FROM ( 
    SELECT 
       RANK() OVER(ORDER BY sal DESC ) sal_rank
       , emp.*
    FROM emp
    WHERE deptno = 10
) 
WHERE sal_Rank = 1;
--3) 서브쿼리
SELECT *
FROM emp
WHERE deptno = 10 AND sal = (
                        SELECT MAX(sal)
                        FROM emp
                        WHERE deptno = 10 );--1) TOP-N 
SELECT *
FROM (
    SELECT *
    FROM emp
    WHERE deptno = 10
    ORDER BY sal DESC
)
WHERE ROWNUM = 1;
--4) PL/SQL
DECLARE
 vmax_sal_10 emp.sal%TYPE;
 vempno     emp.empno%TYPE;
 vename     emp.ename%TYPE;
 vjob       emp.job%TYPE;
 vhiredate  emp.hiredate%TYPE;
 vdeptno    emp.deptno%TYPE;
 vsal       emp.sal%TYPE;
BEGIN
    -- 1.
    SELECT MAX(sal) INTO vmax_sal_10
    FROM emp
    WHERE deptno = 10;
    -- 2.
    SELECT empno, ename, job, sal, hiredate, deptno
        INTO vempno, vename, vjob, vsal, vhiredate, vdeptno
    FROM emp
    WHERE sal = vmax_sal_10 AND deptno = 10;
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || vempno );
    DBMS_OUTPUT.PUT_LINE('사원명 :' || vename );
    DBMS_OUTPUT.PUT_LINE('입사일자 :' || vhiredate );
--EXCEPTION
END;

--5) PL/SQL
DECLARE
 vmax_sal_10 emp.sal%TYPE;
-- vempno     emp.empno%TYPE;
-- vename     emp.ename%TYPE;
-- vjob       emp.job%TYPE;
-- vhiredate  emp.hiredate%TYPE;
-- vdeptno    emp.deptno%TYPE;
-- vsal       emp.sal%TYPE;
 vemprow    emp%ROWTYPE;
BEGIN
    -- 1.
    SELECT MAX(sal) INTO vmax_sal_10
    FROM emp
    WHERE deptno = 10;
    -- 2.
    SELECT empno, ename, job, sal, hiredate, deptno
        INTO vemprow.empno
            , vemprow.ename
            , vemprow.job
            , vemprow.sal
            , vemprow.hiredate
            , vemprow.deptno
    FROM emp
    WHERE sal = vmax_sal_10 AND deptno = 10;
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || vemprow.empno );
    DBMS_OUTPUT.PUT_LINE('사원명 :' || vemprow.ename );
    DBMS_OUTPUT.PUT_LINE('입사일자 :' || vemprow.hiredate );
--EXCEPTION
END;

-- := 대입연산자
DECLARE
    va NUMBER := 1;
    vb NUMBER;
    vc NUMBER := 0;
BEGIN
    vb := 100;
    vc := va + vb;
    
    DBMS_OUTPUT.PUT_LINE( vc );
--EXCEPTION
END;

-- PL/SQL 제어문
--  자바
--    if(){
--        //
--        //
--    }
--  PL/SQL
--    IF [조건식] → 조건식 생략가능
--    THEN --> {
--    
--    END IF; --> }


IF 조건식 THEN
    ELSIF 조건식 THEN
    ELSIF 조건식 THEN
    ELSIF 조건식 THEN
    ELSE
END IF;

-- 문제) 하나의 정수를 입력받아서 홀수/짝수 라고 출력..(익명프로시저)
DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6) := '홀수';
BEGIN
    vnum := :bindNumber; -- 바인드변수
    IF MOD(vnum,2) = 0 THEN
        vresult := '짝수';
    ELSE
        vresult := '홀수';
    END IF; 
    DBMS_OUTPUT.PUT_LINE( vresult );
--EXCEPTION
END;

-- [문제] PL/SQL   IF문 연습문제...
--  국어점수 입력받아서 수우미양가 등급 출력... ( 익명프로시저 )
DECLARE
    vkor NUMBER(3) := 0;
    vgrade VARCHAR2(3);
BEGIN
    vkor := :bindNumber;
    IF vkor BETWEEN 90 AND 100   THEN vgrade := '수';
    ELSIF vkor BETWEEN 80 AND 89 THEN vgrade := '우';
    ELSIF vkor BETWEEN 70 AND 79 THEN vgrade := '미'; 
    ELSIF vkor BETWEEN 60 AND 69 THEN vgrade := '양';
    ELSIF vkor BETWEEN 00 AND 59 THEN vgrade := '양';
    --ELSE
    --grade 예외처리
    END IF;
    DBMS_OUTPUT.PUT_LINE( vgrade );
--EXCEPTION
END;
--
DECLARE
    vkor NUMBER(3) := 0;
    vgrade VARCHAR2(3);
BEGIN
    vkor := :bindNumber;
    IF vkor BETWEEN 0 AND 100 THEN
        -- 수 ~ 가
        vgrade := CASE TRUNC(vkor/10)
                    WHEN 10 THEN '수'
                    WHEN 9 THEN '수'
                    WHEN 8 THEN '우'
                    WHEN 7 THEN '미'
                    WHEN 6 THEN '양'
                    ELSE '가'
                  END;
        DBMS_OUTPUT.PUT_LINE( vgrade );
    ELSE
        DBMS_OUTPUT.PUT_LINE( '국어 0 ~ 100!!' );
    END IF;
--EXCEPTION
END;
-------------------------------------------------------------------
--    자바
--        while(조건식){
--            //반복처리구문
--        }
--
--        while(true){
--            if(){break;} 
--        }
--
--    PL/SQL
--        WHILE(조건식)
--        LOOP -> {
--        END LOOP; -> }

-- 문제) 1~10 까지의 합 WHILE 사용 (익명 프로시저)
--WHILE 조건  LOOP  실행문; END LOOP; 
DECLARE
  vi NUMBER := 1;
  vsum NUMBER := 0;
BEGIN
  WHILE (vi <= 10) LOOP
    -- vsum += vi;   += 
    IF vi = 10 THEN
      DBMS_OUTPUT.PUT( vi );
    ELSE
      DBMS_OUTPUT.PUT( vi || '+');
    END IF;
    
    vsum := vsum + vi;
    vi := vi + 1;  -- ++/-- +=
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(  '=' || vsum );
--EXCEPTION  
END;
-- LOOP   EXIT WHEN 조건;  실행문; END LOOP; 
DECLARE
  vi NUMBER := 1;
  vsum NUMBER := 0;
BEGIN
  LOOP
    EXIT WHEN vi = 11;
    -- vsum += vi;   += 
    IF vi = 10 THEN
      DBMS_OUTPUT.PUT( vi );
    ELSE
      DBMS_OUTPUT.PUT( vi || '+');
    END IF;
    
    vsum := vsum + vi;
    vi := vi + 1;  -- ++/-- +=
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(  '=' || vsum );
--EXCEPTION  
END;

-- 1 ~ 10 합 출력 : FOR 문
DECLARE
    -- vi NUMBER; -- 반복되는 vi는 선언을 생략 가능
    vsum NUMBER := 0;
BEGIN
    -- FOR vi IN REVERSE 1..10 -> 10부터 1까지
    -- FOR vi IN 1..10
    FOR vi IN 1..10
    LOOP
        DBMS_OUTPUT.PUT( vi || ' + ');
        vsum := vsum+vi;
    END LOOP;
    DBMS_OUTPUT.PUT( '=' || vsum );
--EXCEPTION
END;
--
declare 
    chk number := 0; 
begin 
    <<restart>> 
--    dbms_output.enable; 
    chk := chk + 1; 
    dbms_output.put_line(to_char(chk)); 
    if chk <> 5 then 
    goto restart; 
end if; 
end; 
--
--DECLARE
BEGIN
  --
  GOTO first_proc;
  --
  <<second_proc>>
  DBMS_OUTPUT.PUT_LINE('> 2 처리 ');
  GOTO third_proc; 
  -- 
  --
  <<first_proc>>
  DBMS_OUTPUT.PUT_LINE('> 1 처리 ');
  GOTO second_proc; 
  -- 
  --
  --
  <<third_proc>>
  DBMS_OUTPUT.PUT_LINE('> 3 처리 '); 
--EXCEPTION
END;

-- 문제) WHILE 2~9단 세로/가로 출력
DECLARE
  vdan NUMBER(2) := 2 ;
  vi NUMBER := 1;
BEGIN
  WHILE vdan <= 9 LOOP
    vi := 1;
    WHILE vi <= 9 LOOP
      DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' '));
      vi := vi + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
     vdan := vdan + 1;
  END LOOP;
--EXCEPTION
END;
-- 문제) FOR 2~9단 세로/ 가로 출력
BEGIN
  FOR vdan IN 2..9 LOOP
    FOR vi IN 1..9 LOOP
      DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' '));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
--EXCEPTION
END;
--
BEGIN
  FOR vdan IN 1..9 LOOP
    FOR vi IN 2..9 LOOP
      DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' '));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
--EXCEPTION
END;

-- FOR문 사용한 SELECT (기억)
DECLARE
BEGIN
--    FOR 반복변수 i IN [REVERSE] 시작값..끝값 LOOP
    FOR verow IN (SELECT ename, hiredate, job FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE( verow.ename || '/' || verow.hiredate|| '/' || verow.job);
    END LOOP;
--EXCEPTION
END;

-- %TYPE변수 , %ROWTYPE변수, RECORD변수
SELECT d.deptno, dname, empno, ename, sal+NVL(comm,0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno
WHERE empno = 7369;
-- [%TYPE 변수]
DECLARE
    vdeptno dept.deptno%TYPE;
    vdname dept.dname%TYPE;
    vempno emp.empno%TYPE; 
    vename emp.ename%TYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm,0) pay
        INTO vdeptno, vdname, vempno, vename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE( vdeptno || ', ' || vdname
    || ', ' || vempno || ', ' || vename || ', ' || vpay);
--EXCEPTION
END;

-- [%ROWTYPE변수]
DECLARE
    verow emp%ROWTYPE;
    vdrow dept%ROWTYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm,0) pay
        INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname
    || ', ' || verow.empno || ', ' || verow.ename || ', ' || vpay);
--EXCEPTION
END;

-- d.deptno, dname, empno, ename, sal+NVL(comm,0) pay
-- 위의 컬럼값들을 저장할 레코드(행) 타입 선언.
-- (사용자 정의 구조체 타입 선언)
DECLARE
 TYPE EmpDeptType IS RECORD
(
    deptno dept.deptno%TYPE,
    dname dept.dname%TYPE,
    empno emp.empno%TYPE,
    ename emp.ename%TYPE,
    pay NUMBER
);
vedrow EmpDeptType;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal+NVL(comm,0) pay
        INTO vedrow.deptno, vedrow.dname, vedrow.empno
            , vedrow.ename, vedrow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE( vedrow.deptno || ', ' || vedrow.dname
    || ', ' || vedrow.empno || ', ' || vedrow.ename || ', ' || vedrow.pay);
--EXCEPTION
END;

-- INSA b+s pay / 0.025
DECLARE
    vname insa.name%TYPE;
    vpay NUMBER;
    vtax NUMBER;
    vsil NUMBER;
BEGIN
    SELECT name, basicpay + sudang
        INTO vname, vpay
    FROM insa
    WHERE num = 1001;
    IF vpay >= 2500000 THEN
        vtax := vpay *0.025;
    ELSIF vpay >= 2000000 THEN
        vtax := vpay *0.02;
    ELSE
        vtax := 0;   
    END IF;
    vsil := vpay - vtax;
    DBMS_OUTPUT.PUT_LINE(vname || '   ' || vpay || ' ' || vtax || '   ' || vsil);
--EXCEPTION
END;

-------------------- 커서 ( CURSOR ) --------------------------------------------
DECLARE
    TYPE EmpDeptType IS RECORD
    (
       deptno dept.deptno%TYPE,
       dname dept.dname%TYPE,
       empno emp.empno%TYPE,
       ename emp.ename%TYPE,
       pay   NUMBER
    );
    vedrow EmpDeptType;
    -- 1) 커서(CURSOR) 선언
    CURSOR vdecursor IS ( 
                  SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
                  FROM dept d JOIN emp e ON d.deptno = e.deptno
                    );
BEGIN
    -- 2) 커서 OPEN == SELECT 문 실행.
    OPEN vdecursor;
    
    -- 3) FETCH == 가져오다
    LOOP
        FETCH vdecursor INTO vedrow;
        EXIT WHEN vdecursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vedrow.deptno || ', ' || vedrow.dname || ', ' ||
                              vedrow.empno  || ', ' || vedrow.ename || ', ' || 
                              vedrow.pay );
    END LOOP;
    
    -- 4) 커서 CLOSE
    CLOSE vdecursor;
--EXCEPTION
END;

---------- FOR문 암시적 커서(CURSOR) 이해 -----------------------------------------
DECLARE
BEGIN
    FOR vedrow IN (
                SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
                FROM dept d JOIN emp e ON d.deptno = e.deptno
                ) LOOP
        DBMS_OUTPUT.PUT_LINE( vedrow.deptno || ', ' || vedrow.dname || ', ' ||
                              vedrow.empno  || ', ' || vedrow.ename || ', ' || 
                              vedrow.pay );
    END LOOP;
--EXCEPTION
END;