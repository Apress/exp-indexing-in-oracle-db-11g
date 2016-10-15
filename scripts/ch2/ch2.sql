create table cust(
 cust_id number
,last_name varchar2(30)
,first_name varchar2(30));

create index cust_idx1
on cust(last_name);

insert into cust (cust_id, last_name, first_name) values(7, 'ACER','SCOTT');
insert into cust (cust_id, last_name, first_name) values(5, 'STARK','JIM');
insert into cust (cust_id, last_name, first_name) values(3, 'GREY','BOB');
insert into cust (cust_id, last_name, first_name) values(11,'KHAN','BRAD');
.....
insert into cust (cust_id, last_name, first_name) values(274, 'ACER','SID');

create tablespace reporting_data
  datafile '/ora02/DWREP/reporting_data01.dbf'
  size 1G
  extent management local
  uniform size 1M
  segment space management auto;
--
create tablespace reporting_index
  datafile '/ora02/DWREP/reporting_index01.dbf'
  size 500M
  extent management local
  uniform size 128K
  segment space management auto
  nologging;

CREATE TABLE cust(
 cust_id    NUMBER
,last_name  VARCHAR2(30)
,first_name VARCHAR2(30))
TABLESPACE reporting_data;
--
ALTER TABLE cust ADD CONSTRAINT cust_pk PRIMARY KEY (cust_id)
USING INDEX TABLESPACE reporting_index;
--
ALTER TABLE cust ADD CONSTRAINT cust_uk1 UNIQUE (last_name, first_name)
USING INDEX TABLESPACE reporting_index;
--
CREATE TABLE address(
 address_id NUMBER
,cust_id    NUMBER
,street     VARCHAR2(30)
,city       VARCHAR2(30)
,state      VARCHAR2(30))
TABLESPACE reporting_data;
--
ALTER TABLE address ADD CONSTRAINT addr_fk1
FOREIGN KEY (cust_id) REFERENCES cust(cust_id);
--
CREATE INDEX addr_fk1 ON address(cust_id)
TABLESPACE reporting_index;

select index_name, index_type, table_name, tablespace_name, status
from user_indexes
where table_name in ('CUST','ADDRESS');

select index_name, column_name, column_position
from user_ind_columns
where table_name in ('CUST','ADDRESS')
order by index_name, column_position;

select a.segment_name, a.segment_type, a.extents, a.bytes
from user_segments a, user_indexes  b
where a.segment_name = b.index_name
and   b.table_name in ('CUST','ADDRESS');

insert into cust values(1,'STARK','JIM');
insert into address values(100,1,'Vacuum Ave','Portland','OR');

create table cust(
 cust_id      number
,first_name  varchar2(200)
,last_name   varchar2(200));

alter table cust
add constraint cust_pk
primary key (cust_id)
using index tablespace users;

create table cust(
 cust_id      number         primary key
,first_name  varchar2(30)
,last_name   varchar2(30));

create table cust(
 cust_id      number         constraint cust_pk primary key
,first_name  varchar2(30)
,last_name   varchar2(30));

create table cust(
 cust_id      number constraint cust_pk primary key
                    using index tablespace users
,first_name  varchar2(30)
,last_name   varchar2(30));

create table cust(
 cust_id number
,first_name  varchar2(30)
,last_name   varchar2(30)
,constraint cust_pk primary key (cust_id)
using index tablespace users);

create table cust(
 cust_id number
,first_name  varchar2(30)
,last_name   varchar2(30));

create unique index cust_pk
on cust(cust_id);

alter table cust
add constraint cust_pk
primary key (cust_id);

create index cust_pk
on cust(cust_id, first_name, last_name);

alter table cust
add constraint cust_pk
primary key (cust_id);

select index_name, index_type, uniqueness
from user_indexes
where table_name = 'CUST';

create table cust(
 cust_id      number
,first_name  varchar2(30)
,last_name   varchar2(30));

 cust_id      number constraint cust_pk primary key
                    using index tablespace users
,first_name  varchar2(30)
,last_name   varchar2(30)
,ssn         varchar2(15) constraint cust_uk1 unique
                          using index tablespace users);

create table cust(
 cust_id      number constraint cust_pk primary key
                    using index tablespace users
,first_name  varchar2(30)
,last_name   varchar2(30)
,ssn         varchar2(15)
,constraint cust_uk1 unique (first_name, last_name)
 using index tablespace users);

SELECT DISTINCT
  a.owner                                 owner
 ,a.constraint_name                       cons_name
 ,a.table_name                            tab_name
 ,b.column_name                           cons_column
 ,NVL(c.column_name,'***Check index****') ind_column
FROM dba_constraints  a
    ,dba_cons_columns b
    ,dba_ind_columns  c
WHERE constraint_type = 'R'
AND a.owner           = UPPER('&&user_name')
AND a.owner           = b.owner
AND a.constraint_name = b.constraint_name
AND b.column_name     = c.column_name(+)
AND b.table_name      = c.table_name(+)
AND b.position        = c.column_position(+)
ORDER BY tab_name, ind_column;

SELECT
 CASE WHEN ind.index_name IS NOT NULL THEN
   CASE WHEN ind.index_type IN ('BITMAP') THEN
     '** Bitmp idx **'
   ELSE
     'indexed'
   END
 ELSE
   '** Check idx **'
 END checker
,ind.index_type
,cons.owner, cons.table_name, ind.index_name, cons.constraint_name, cons.cols
FROM (SELECT
        c.owner, c.table_name, c.constraint_name
       ,LISTAGG(cc.column_name, ',' ) WITHIN GROUP (ORDER BY cc.column_name) cols
      FROM dba_constraints  c
          ,dba_cons_columns cc
      WHERE c.owner           = cc.owner
      AND   c.owner = UPPER('&&schema')
      AND   c.constraint_name = cc.constraint_name
      AND   c.constraint_type = 'R'
      GROUP BY c.owner, c.table_name, c.constraint_name) cons
LEFT OUTER JOIN
(SELECT
  table_owner, table_name, index_name, index_type, cbr
 ,LISTAGG(column_name, ',' ) WITHIN GROUP (ORDER BY column_name) cols
 FROM (SELECT
        ic.table_owner, ic.table_name, ic.index_name
       ,ic.column_name, ic.column_position, i.index_type
       ,CONNECT_BY_ROOT(ic.column_name) cbr
       FROM dba_ind_columns ic
           ,dba_indexes     i
       WHERE ic.table_owner = UPPER('&&schema')
       AND   ic.table_owner = i.table_owner
       AND   ic.table_name  = i.table_name
       AND   ic.index_name  = i.index_name
       CONNECT BY PRIOR ic.column_position-1 = ic.column_position
       AND PRIOR ic.index_name = ic.index_name)
  GROUP BY table_owner, table_name, index_name, index_type, cbr) ind
ON  cons.cols       = ind.cols
AND cons.table_name = ind.table_name
AND cons.owner      = ind.table_owner
ORDER BY checker, cons.owner, cons.table_name;
