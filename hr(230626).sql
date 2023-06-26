select * from emp;
select * from DEPT;
select * from student;
select * from PROFESSOR;
select * from employees;
select * from locations;
select * from department;

/* 데이터 수정 UPDATE */
SELECT  profno, name, position
FROM    professor
WHERE   profno = 9903;

UPDATE  professor
SET position = '부교수'
WHERE   profno = 9903;
COMMIT;
SELECT  profno, name, position
FROM    professor
WHERE   profno = 9903;

/* 학생 테이블에서 박동진 학생의 몸무게를 80으로 변경 */
SELECT name, weight
FROM    student
WHERE   name='박동진';

UPDATE  student
SET     weight=80
WHERE   name='박동진';
SELECT name, weight
FROM    student
WHERE   name='박동진';

/* 서브쿼리를 이용한 데이터 수정 */
SELECT  studno, grade, deptno
FROM student
WHERE   studno = 10201;
SELECT  studno, grade, deptno
FROM student
WHERE   studno = 10201;

UPDATE  student
SET (grade, deptno) = (SELECT   grade, deptno
                       FROM     student
                       WHERE    studno = 10103)
WHERE   studno = 10201;
COMMit;
SELECT  studno, grade, deptno
FROM    student
WHERE   studno = 10201;

/* 교수테이블에서 성연희 교수의 직급과 동일 직급을 가진 교수들 중 현재 급여가 350 이하인 교수들의
급여를 12% 인상하시오 */
UPDATE  professor
SET     sal = sal*1.12 
WHERE   position = (SELECT  position
                    FROM    professor
                    WHERE   name='성연희')
AND     sal <= 350;

/* emp 테이벌에서 'DALLAS'에 근무하는 사원들의 급여를 100으로 변경하시오 */
UPDATE  emp
SET     sal = 100
WHERE   deptno = (SELECT    deptno
                  FROM      dept
                  WHERE     loc = 'DALLAS');
                  
/* 데이터 삭제 DELETE */
DELETE 
FROM    student
WHERE   studno = 20103;
COMMIT;  /* 테이블에 영구적으로 저장을 하겠다는 뜻 */
SELECT  * FROM  student
WHERE   studno = 20103;
rollback;
/* 서브쿼리를 이용한 데이터 삭제 */
DELETE   FROM    student
WHERE   deptno = (SELECT    deptno
                  FROM      department
                  WHERE     dname='컴퓨터공학과');
SELECT * FROM student
WHERE   deptno = (SELECT    deptno
                  FROM      department
                  WHERE     dname = '컴퓨터공학과');
rollback;

/* MERGE */
/*MERGE
  - 구조가 같은 두개의 테이블을 비교하여 하나의 테이블로 합치기 위한 데이터 조작어
  - WHEN 절의 조건절에서 결과 테이블에 해당 행이 존재하면 UPDATE 명령문에 의해
    새로운 값으로 수정, 그렇지 않으면 INSERT 명령문으로 새로운 행을 삽입*/
/*사용예
  - professor 테이블과 professor_temp 테이블을 비교하여 professor 테이블에 있는
    기존 데이터는 professor_temp테이블의 데이터에 의해 수정하고, professor 테이블에 없는 데이터는 신규로 입력*/
CREATE  TABLE   professor_temp AS
SELECT  *
FROM    professor
WHERE position = '교수';

UPDATE  professor_temp
SET position = '명예교수'
WHERE   position = '교수';

INSERT  INTO    professor_temp
VALUES(9999, '김도경', 'arom21', '전임강사', 200, SYSDATE, 10, 101);
SELECT * FROM   professor_temp;

merge into professor p
using professor_temp f
on (p.profno = f.profno)
when matched then
update set p.position = f.position
when not matched then
insert values(f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);
select * from professor;

/* 트랜잭션 관리 COMMIT, ROLLBACK */

/* 시퀀스 : 유일한 식별자, 기본 키 값을 자동으로 생성하기 위해 일련번호 생성 객체, 여러 테이블 공유 가능 */
CREATE SEQUENCE     s_seq
INCREMENT BY        1
START WITH          1
MAXVALUE            100;

SELECT  min_value, max_value, increment_by, last_number
FROM    user_sequences
WHERE   sequence_name = 'S_SEQ';

/* CURRVAL - 시퀀스에서 생성된 현재 번호 확인, 
   NEXTVALUE - 시퀀스에서 다음 번호 생성 */
INSERT INTO emp VALUES
(S_SEQ.NEXTVAL, 'test1','SALESMAN', 7698, sysdate, 800, NULL, 20);
INSERT INTO emp VALUES
(S_SEQ.NEXTVAL, 'test2','SALESMAN', 7698, sysdate, 800, NULL, 20);
INSERT INTO emp VALUES
(S_SEQ.NEXTVAL, 'test3','SALESMAN', 7698, sysdate, 800, NULL, 20);
select * from emp;

SELECT  S_SEQ.CURRVAL
FROM    DUAL;
SELECT  S_SEQ.NEXTVAL
FROM    DUAL;

/* ALTER SEQUENCE : 시퀀스 생성 후 증가치, 최소 최대 값 등의 정의를 수정 */
ALTER SEQUENCE  s_seq   MAXVALUE    200;
SELECT  min_value, max_value, increment_by, last_number
FROM    user_sequences
WHERE   sequence_name = 'S_SEQ';

/* 시퀀스 삭제 drop sequence */
DROP SEQUENCE s_seq;

/* ---- 테이블 관리 ---- */
/* 테이블 생성 */
CREATE TABLE    address
(id NUMBER(3),
name    VARCHAR2(50),
addr    VARCHAR2(100),
phone   VARCHAR2(30),
email   VARCHAR2(100));
select * from tab;
DESC    address;

/* DEFAULT 옵션 */
DESC    address;

/* 서브쿼리를 이용한 테이블 생성 */
INSERT INTO     address
VALUES(1, 'HGDONG', 'SEOUL', '123-456', 'gbhong@cwunet.ac.kr');
COMMIT;
SELECT  * FROM  address;

/* 서브쿼리 절을 이용하여 주소록 테이블의 구조와 데이터를 복사하여 addr_second 테이블 생성 */
CREATE TABLE    addr_second(id, name, addr, phone, e_mail)
AS SELECT   *   FROM    address;
DESC    addr_second;

/* 테이블 구조 복사 */
CREATE TABLE    addr_fourth
AS SELECT   id, name   FROM   address
WHERE   1=2;
DESC    addr_fourth;

/* 테이블 구조 변경 */
/* 주소록 테이블에서 id, name 칼럼만 복사하여 addr_third 테이블 생성 */
CREATE TABLE    addr_third
AS SELECT   id, name    FROM    address;
DESC    addr_third;
SELECT  *   FROM    addr_third;

/* 테이블 구조 변경 - ALTER TABLE : 칼럼 추가, 삭제, 타입이나 길이의 재정의와 같은 작업 */
ALTER TABLE     address
ADD(birth DTAE);

ALTER TABLE     address
ADD(comments VARCHAR2(200) DEFAULT 'NO COMMENT');
DESC    address;

/* 테이블 칼럼 삭제 */
/* 주소록 테이블에서 comment 칼럼 삭제 */
ALTER TABLE address DROP COLUMN comments;
DESC    address;

/* 테이블 칼럼 변경 */
/* 데이터 칼럼 변경 - alter table ... modify 명령문 이용 */
ALTER TABLE     address
MODIFY  phone   VARCHAR2(50);

ALTER TABLE     address
MODIFY  phone   VARCHAR2(5); /* 크기를 기존 저장된 데이터 크기 보다 작게 하면 오류 발생*/

/* 테이블 이름 변경 rename */
RENAME      addr_second    TO   client_address;
SELECT      *   FROM    tab;

/* 테이블 삭제 */
SELECT  *   FROM    tab;
DROP    TABLE   addr_third;

SELECT  *   FROM    tab
WHERE   tname = 'ADDR_THIRD';

/* TRUNCATE : 테이블 구조는 그대로 유지하고, 테이블의 데이터와 할당된 공간만 삭제*/
/* 테이블에 생성된 제약 조건과 연관된 인덱스, 뷰, 동의어는 유지 */
/* DELETE 는 기존 데이터만 삭제하는 명령이며, rollback 가능, where절을 이용하여 특정 행만 삭제 가능 */
/* TRUNCATE 는 기존 데이터 삭제 뿐만 아니라 물리적인 저장 공간까지 반환, rollback 불가능 */

SELECT  *
FROM    client_address;

TRUNCATE    TABLE   client_address;

SELECT  *
FROM    client_address;
ROLLBACK;

SELECT  *
FROM    client_address;  /* rollback 불가능 */

/* 주석 추가 - 테이블에 주석 붙이기 */
COMMENT ON TABLE    address
IS  '고객 주소록을 관리하기 위한 테이블';

COMMENT ON COLUMN   address.name
IS  '고객 이름';

/* 주석 확인하는 방법 */
SELECT  COMMENTs
FROM    user_tab_comments
WHERE   table_name = 'ADDRESS';

/* 컬럼 주석 확인하는 방법 */
SELECT  *  
FROM    user_col_comments
WHERE   table_name = 'ADDRESS';

/* 테이블 주석 삭제 */
COMMENT ON TABLE ADDRESS IS '';

/* 컬럼 주석 삭제 */
COMMENT ON COLUMN ADDRESS.NAME IS '';

/* ---- 데이터 사전 ---- */
/* USER_  */
SELECT  table_name
FROM    user_tables;

/* ALL_ */
SELECT  owner, table_name
FROM    all_tables;

/* DBA_ : 시스템 관리와 관련된 뷰, 사용자 접근 권한, 데이터베이스 자원관리 목적 */
SELECT  owner, table_name
FROM    dba_tables;

/* ---- 데이터 무결성 ---- */
/* dept 테이블에서 30번 부서를 삭제 */
desc dept;
DELETE FROM dept
WHERE   deptno = 30; /* 자식 레코드가 있어서 삭제 불가능 */

/*  1) dept 테이블에서 30번 부서를 삭제
    2) emp에서 30번 부서 소속 사원을 출력
    3) dept 테이블에서 33번 SALES 부서를 추가
    4) emp에서 30번 부서 소속 사원을 33번 부서로 변경
    5) dept 테이블에서 30번 부서 삭제
*/
SELECT  *   FROM    emp
WHERE   deptno = 30;  /* 2) */

INSERT INTO     dept
values(33, 'SALES', 'SEOUL'); /* 3) */

UPDATE  emp
SET     deptno = 33
WHERE   deptno = 30;  /* 4) */

DELETE FROM dept
WHERE   deptno = 30;  /* 5) */

/* 무결성 제약 조건 생성 예 */
CREATE TABLE    subject
    (subno  NUMBER(5)
       CONSTRAINT  subject_no_pk   PRIMARY KEY
       DEFERRABLE  INITIALLY   DEFERRED
       USING   INDEX   TABLESPACE  indx,
    SUBNAME VARCHAR2(20)
      CONSTRAINT  subject_name_nn NOT NULL,
    term    VARCHAR(8)
       CONSTRAINT  subject_term_ck CHECK   (term in ('1', '2')),
    type    VARCHAR2(8));

/* 수강 테이블 인스턴스 */
DELETE 
FROM    student
WHERE   studno = 33333;
COMMIT;  /* 테이블에 영구적으로 저장을 하겠다는 뜻 */


ALTER TABLE student
ADD CONSTRAINT  stud_no_pk  PRIMARY KEY(studno);

CREATE TABLE    sugang
    (studno  NUMBER(5)
        CONSTRAINT  sugang_studno_fk   REFERENCES    student(studno),
    SUBNO    NUMBER(5)
        CONSTRAINT  sugang_subno_fk    REFERENCES    subject(subno),
    regdate    DATE,
    result      NUMBER(3),
        CONSTRAINT  sugang_pk   PRIMARY KEY(studno, subno));
select * from sugang;
select * from subject;
desc sugang;

/* 데이터 사전에서 무결성 제약 조건 조회 */
SELECT  constraint_name, constraint_type
FROM    user_constraints
WHERE   table_name IN ('SUBJECT', 'SUGANG');

/* 무결성 제약조건 추가 예 */
ALTER TABLe student
ADD CONSTRAINT  stud_idnum_uk UNIQUE(idnum);

ALTER TABLE student
MODIFY (name CONSTRAINT stud_name_nn NOT NULL);

ALTER table department
add constraint dept_pk primary key(deptno);
ALTER TABLE student ADD CONSTRAINT stud_deptno_kf
FOREIGN KEY(deptno) REFERENCES department(deptno);

alter table professor add constraints prof_pk primary key(profno);
alter table professor modify (name not null);
alter table professeor add constraints prof_fk
foreign key(deptno) references department(deptno);

INSERT INTO subject values(1, 'SQL', '1', '필수');
INSERT INTO subject values(2, ' , ', '2', '필수');
INSERT INTO subject values(3, 'JAVA', '3', '선택');
COMMIT;
select * from subject;

INSERT INTO subject values(4, '데베' '1', '필수');
INSERT INTO subject values(4, '데이터모델링', '2', '선택');
commit;
select * from subject;

/* 무결성 제약 조건 삭제 */
SELECT  constraint_name, constraint_type
FROM    user_constraints
WHERE   table_name = 'SUBJECT';

ALTER TABLE subject
DROP constraint subject_term_ck;

SELECT  constraint_name, constraint_type
FROM    user_constraints
WHERE   table_name = 'SUBJECT';

ALTER TABLE sugang
DISABLE constraint sugang_pk;

ALTER TABLE sugang
DISABLE constraint sugang_studno_fk;

SELECT  constraint_name, status
FROM    user_constraints
WHERE   table_name IN ('SUGANG', 'SUBJECT');

ALTER TABLE sugang
DISABLE constraint sugang_pk;

ALTER TABLE sugang
DISABLE constraint sugang_studno_fk;

SELECT  constraint_name, status
FROM    user_constraints
WHERE   table_name = 'SUGANG';

/* ---- 문제 ---- */
-- 1번
CREATE TABLE EE
(EMPLOYEE_ID NUMBER(7),
LAST_NAME VARCHAR2(25),
FIRST_NAME VARCHAR2(25),
DEPTNO  NUMBER(2),
PHONE_NUMBER    VARCHAR(2));

-- 2번 
ALTER TABLE EE
MODIFY PHONE_NUMBER VARCHAR(20);
INSERT INTO EE VALUES(1,'test1', 'Ben', 10, '123-4566 1100');
INSERT INTO EE VALUES(2,'test2', 'Betty', 20, '123-7890 1860');
INSERT INTO ee VALUES(3,'test3', 'Chad', 20, '123-8888 2200');
INSERT INTO ee VALUES(3,'test4', 'haha', 20, '123-8888 2200');
SELECT * FROM EE;

-- 3번
ALTER TABLE EE
ADD CONSTRAINT ee_no_pk PRIMARY KEY(EMPLOYEE_ID);
--EMPLOYEED_ID 컬럼 안에 중복되는 값이 있기 때문에 PK설정이 불가능
UPDATE EE
SET EMPLOYEE_ID = 4
WHERE EMPLOYEE_ID = 3 AND LAST_NAME = 'test4';
ALTER TABLE EE
ADD CONSTRAINT ee_no_pk PRIMARY KEY(EMPLOYEE_ID);

--4.
INSERT INTO department
VALUES(20,'테스트',NULL,NULL);
ALTER TABLE EE ADD CONSTRAINT ee_deptno_fk
FOREIGN KEY(deptno) REFERENCES department(deptno);
SELECT * FROM EE;

--5.
INSERT INTO EE(employee_id, first_name, deptno)
values(4,'cindy',50);
--employee_id컬럼이 PK이기 때문에 4라는 중복값이 허용되지 않는다.

--6.
DROP TABLE EE;