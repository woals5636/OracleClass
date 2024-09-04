-- SCOTT Á¢¼Ó
SELECT *
FROM tbl_dept;

-- SESSION B
SELECT *
FROM tbl_dept;
--
UPDATE tbl_dept
SET loc = 'COREA'
WHERE deptno = 40;
--
SELECT *
FROM tbl_dept;
--
COMMIT;