select * from emp;
select * from DEPT;
select * from student;
select * from PROFESSOR;
select * from employees;
select * from locations;
select * from department;

/* ������ ���� UPDATE */
SELECT  profno, name, position
FROM    professor
WHERE   profno = 9903;

UPDATE  professor
SET position = '�α���'
WHERE   profno = 9903;
COMMIT;
SELECT  profno, name, position
FROM    professor
WHERE   profno = 9903;

/* �л� ���̺��� �ڵ��� �л��� �����Ը� 80���� ���� */
SELECT name, weight
FROM    student
WHERE   name='�ڵ���';

UPDATE  student
SET     weight=80
WHERE   name='�ڵ���';
SELECT name, weight
FROM    student
WHERE   name='�ڵ���';

/* ���������� �̿��� ������ ���� */
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

/* �������̺��� ������ ������ ���ް� ���� ������ ���� ������ �� ���� �޿��� 350 ������ ��������
�޿��� 12% �λ��Ͻÿ� */
UPDATE  professor
SET     sal = sal*1.12 
WHERE   position = (SELECT  position
                    FROM    professor
                    WHERE   name='������')
AND     sal <= 350;

/* emp ���̹����� 'DALLAS'�� �ٹ��ϴ� ������� �޿��� 100���� �����Ͻÿ� */
UPDATE  emp
SET     sal = 100
WHERE   deptno = (SELECT    deptno
                  FROM      dept
                  WHERE     loc = 'DALLAS');
                  
/* ������ ���� DELETE */
DELETE 
FROM    student
WHERE   studno = 20103;
COMMIT;  /* ���̺� ���������� ������ �ϰڴٴ� �� */
SELECT  * FROM  student
WHERE   studno = 20103;
rollback;
/* ���������� �̿��� ������ ���� */
DELETE   FROM    student
WHERE   deptno = (SELECT    deptno
                  FROM      department
                  WHERE     dname='��ǻ�Ͱ��а�');
SELECT * FROM student
WHERE   deptno = (SELECT    deptno
                  FROM      department
                  WHERE     dname = '��ǻ�Ͱ��а�');
rollback;

/* MERGE */
/*MERGE
  - ������ ���� �ΰ��� ���̺��� ���Ͽ� �ϳ��� ���̺�� ��ġ�� ���� ������ ���۾�
  - WHEN ���� ���������� ��� ���̺� �ش� ���� �����ϸ� UPDATE ��ɹ��� ����
    ���ο� ������ ����, �׷��� ������ INSERT ��ɹ����� ���ο� ���� ����*/
/*��뿹
  - professor ���̺�� professor_temp ���̺��� ���Ͽ� professor ���̺� �ִ�
    ���� �����ʹ� professor_temp���̺��� �����Ϳ� ���� �����ϰ�, professor ���̺� ���� �����ʹ� �űԷ� �Է�*/
CREATE  TABLE   professor_temp AS
SELECT  *
FROM    professor
WHERE position = '����';

UPDATE  professor_temp
SET position = '������'
WHERE   position = '����';

INSERT  INTO    professor_temp
VALUES(9999, '�赵��', 'arom21', '���Ӱ���', 200, SYSDATE, 10, 101);
SELECT * FROM   professor_temp;

merge into professor p
using professor_temp f
on (p.profno = f.profno)
when matched then
update set p.position = f.position
when not matched then
insert values(f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);
select * from professor;

/* Ʈ����� ���� COMMIT, ROLLBACK */

/* ������ : ������ �ĺ���, �⺻ Ű ���� �ڵ����� �����ϱ� ���� �Ϸù�ȣ ���� ��ü, ���� ���̺� ���� ���� */
CREATE SEQUENCE     s_seq
INCREMENT BY        1
START WITH          1
MAXVALUE            100;

SELECT  min_value, max_value, increment_by, last_number
FROM    user_sequences
WHERE   sequence_name = 'S_SEQ';

/* CURRVAL - ���������� ������ ���� ��ȣ Ȯ��, 
   NEXTVALUE - ���������� ���� ��ȣ ���� */
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

/* ALTER SEQUENCE : ������ ���� �� ����ġ, �ּ� �ִ� �� ���� ���Ǹ� ���� */
ALTER SEQUENCE  s_seq   MAXVALUE    200;
SELECT  min_value, max_value, increment_by, last_number
FROM    user_sequences
WHERE   sequence_name = 'S_SEQ';

/* ������ ���� drop sequence */
DROP SEQUENCE s_seq;

/* ---- ���̺� ���� ---- */
/* ���̺� ���� */
CREATE TABLE    address
(id NUMBER(3),
name    VARCHAR2(50),
addr    VARCHAR2(100),
phone   VARCHAR2(30),
email   VARCHAR2(100));
select * from tab;
DESC    address;

/* DEFAULT �ɼ� */
DESC    address;

/* ���������� �̿��� ���̺� ���� */
INSERT INTO     address
VALUES(1, 'HGDONG', 'SEOUL', '123-456', 'gbhong@cwunet.ac.kr');
COMMIT;
SELECT  * FROM  address;

/* �������� ���� �̿��Ͽ� �ּҷ� ���̺��� ������ �����͸� �����Ͽ� addr_second ���̺� ���� */
CREATE TABLE    addr_second(id, name, addr, phone, e_mail)
AS SELECT   *   FROM    address;
DESC    addr_second;

/* ���̺� ���� ���� */
CREATE TABLE    addr_fourth
AS SELECT   id, name   FROM   address
WHERE   1=2;
DESC    addr_fourth;

/* ���̺� ���� ���� */
/* �ּҷ� ���̺��� id, name Į���� �����Ͽ� addr_third ���̺� ���� */
CREATE TABLE    addr_third
AS SELECT   id, name    FROM    address;
DESC    addr_third;
SELECT  *   FROM    addr_third;

/* ���̺� ���� ���� - ALTER TABLE : Į�� �߰�, ����, Ÿ���̳� ������ �����ǿ� ���� �۾� */
ALTER TABLE     address
ADD(birth DTAE);

ALTER TABLE     address
ADD(comments VARCHAR2(200) DEFAULT 'NO COMMENT');
DESC    address;

/* ���̺� Į�� ���� */
/* �ּҷ� ���̺��� comment Į�� ���� */
ALTER TABLE address DROP COLUMN comments;
DESC    address;

/* ���̺� Į�� ���� */
/* ������ Į�� ���� - alter table ... modify ��ɹ� �̿� */
ALTER TABLE     address
MODIFY  phone   VARCHAR2(50);

ALTER TABLE     address
MODIFY  phone   VARCHAR2(5); /* ũ�⸦ ���� ����� ������ ũ�� ���� �۰� �ϸ� ���� �߻�*/

/* ���̺� �̸� ���� rename */
RENAME      addr_second    TO   client_address;
SELECT      *   FROM    tab;

/* ���̺� ���� */
SELECT  *   FROM    tab;
DROP    TABLE   addr_third;

SELECT  *   FROM    tab
WHERE   tname = 'ADDR_THIRD';

/* TRUNCATE : ���̺� ������ �״�� �����ϰ�, ���̺��� �����Ϳ� �Ҵ�� ������ ����*/
/* ���̺� ������ ���� ���ǰ� ������ �ε���, ��, ���Ǿ�� ���� */
/* DELETE �� ���� �����͸� �����ϴ� ����̸�, rollback ����, where���� �̿��Ͽ� Ư�� �ุ ���� ���� */
/* TRUNCATE �� ���� ������ ���� �Ӹ� �ƴ϶� �������� ���� �������� ��ȯ, rollback �Ұ��� */

SELECT  *
FROM    client_address;

TRUNCATE    TABLE   client_address;

SELECT  *
FROM    client_address;
ROLLBACK;

SELECT  *
FROM    client_address;  /* rollback �Ұ��� */

/* �ּ� �߰� - ���̺� �ּ� ���̱� */
COMMENT ON TABLE    address
IS  '�� �ּҷ��� �����ϱ� ���� ���̺�';

COMMENT ON COLUMN   address.name
IS  '�� �̸�';

/* �ּ� Ȯ���ϴ� ��� */
SELECT  COMMENTs
FROM    user_tab_comments
WHERE   table_name = 'ADDRESS';

/* �÷� �ּ� Ȯ���ϴ� ��� */
SELECT  *  
FROM    user_col_comments
WHERE   table_name = 'ADDRESS';

/* ���̺� �ּ� ���� */
COMMENT ON TABLE ADDRESS IS '';

/* �÷� �ּ� ���� */
COMMENT ON COLUMN ADDRESS.NAME IS '';

/* ---- ������ ���� ---- */
/* USER_  */
SELECT  table_name
FROM    user_tables;

/* ALL_ */
SELECT  owner, table_name
FROM    all_tables;

/* DBA_ : �ý��� ������ ���õ� ��, ����� ���� ����, �����ͺ��̽� �ڿ����� ���� */
SELECT  owner, table_name
FROM    dba_tables;

/* ---- ������ ���Ἲ ---- */
/* dept ���̺��� 30�� �μ��� ���� */
desc dept;
DELETE FROM dept
WHERE   deptno = 30; /* �ڽ� ���ڵ尡 �־ ���� �Ұ��� */

/*  1) dept ���̺��� 30�� �μ��� ����
    2) emp���� 30�� �μ� �Ҽ� ����� ���
    3) dept ���̺��� 33�� SALES �μ��� �߰�
    4) emp���� 30�� �μ� �Ҽ� ����� 33�� �μ��� ����
    5) dept ���̺��� 30�� �μ� ����
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

/* ���Ἲ ���� ���� ���� �� */
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

/* ���� ���̺� �ν��Ͻ� */
DELETE 
FROM    student
WHERE   studno = 33333;
COMMIT;  /* ���̺� ���������� ������ �ϰڴٴ� �� */


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

/* ������ �������� ���Ἲ ���� ���� ��ȸ */
SELECT  constraint_name, constraint_type
FROM    user_constraints
WHERE   table_name IN ('SUBJECT', 'SUGANG');

/* ���Ἲ �������� �߰� �� */
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

INSERT INTO subject values(1, 'SQL', '1', '�ʼ�');
INSERT INTO subject values(2, ' , ', '2', '�ʼ�');
INSERT INTO subject values(3, 'JAVA', '3', '����');
COMMIT;
select * from subject;

INSERT INTO subject values(4, '����' '1', '�ʼ�');
INSERT INTO subject values(4, '�����͸𵨸�', '2', '����');
commit;
select * from subject;

/* ���Ἲ ���� ���� ���� */
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

/* ---- ���� ---- */
-- 1��
CREATE TABLE EE
(EMPLOYEE_ID NUMBER(7),
LAST_NAME VARCHAR2(25),
FIRST_NAME VARCHAR2(25),
DEPTNO  NUMBER(2),
PHONE_NUMBER    VARCHAR(2));

-- 2�� 
ALTER TABLE EE
MODIFY PHONE_NUMBER VARCHAR(20);
INSERT INTO EE VALUES(1,'test1', 'Ben', 10, '123-4566 1100');
INSERT INTO EE VALUES(2,'test2', 'Betty', 20, '123-7890 1860');
INSERT INTO ee VALUES(3,'test3', 'Chad', 20, '123-8888 2200');
INSERT INTO ee VALUES(3,'test4', 'haha', 20, '123-8888 2200');
SELECT * FROM EE;

-- 3��
ALTER TABLE EE
ADD CONSTRAINT ee_no_pk PRIMARY KEY(EMPLOYEE_ID);
--EMPLOYEED_ID �÷� �ȿ� �ߺ��Ǵ� ���� �ֱ� ������ PK������ �Ұ���
UPDATE EE
SET EMPLOYEE_ID = 4
WHERE EMPLOYEE_ID = 3 AND LAST_NAME = 'test4';
ALTER TABLE EE
ADD CONSTRAINT ee_no_pk PRIMARY KEY(EMPLOYEE_ID);

--4.
INSERT INTO department
VALUES(20,'�׽�Ʈ',NULL,NULL);
ALTER TABLE EE ADD CONSTRAINT ee_deptno_fk
FOREIGN KEY(deptno) REFERENCES department(deptno);
SELECT * FROM EE;

--5.
INSERT INTO EE(employee_id, first_name, deptno)
values(4,'cindy',50);
--employee_id�÷��� PK�̱� ������ 4��� �ߺ����� ������ �ʴ´�.

--6.
DROP TABLE EE;