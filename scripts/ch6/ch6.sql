CREATE INDEX employees_part_1i
ON employees_part (hire_date)
TABLESPACE empindex_s
LOCAL;

CREATE INDEX employees_gi2
ON employees (manager_id)
GLOBAL
partition by range(manager_id)
(partition manager_100 values less than (100),
partition manager_200 values less than (200),
partition manager_300 values less than (300),
partition manager_400 values less than (400),
partition manager_500 values less than (500),
partition manager_600 values less than (600),
partition manager_700 values less than (700),
partition manager_800 values less than (800),
partition manager_900 values less than (900),
partition manager_max values less than (maxvalue));

create unique index employees_uk1
on employees (manager_id, employee_id)
global
partition by range(manager_id)
(partition manager_100 values less than (100),
partition manager_200 values less than (200),
partition manager_300 values less than (300),
partition manager_400 values less than (400),
partition manager_500 values less than (500),
partition manager_600 values less than (600),
partition manager_700 values less than (700),
partition manager_800 values less than (800),
partition manager_900 values less than (900),
partition manager_max values less than (maxvalue));

SELECT index_name, null partition_name, status
FROM user_indexes
WHERE table_name = 'EMPLOYEES_PARTTEST'
AND partitioned = 'NO'
UNION
SELECT index_name, partition_name, status
FROM user_ind_partitions
WHERE index_name in
(SELECT index_name from user_indexes
WHERE table_name = 'EMPLOYEES_PARTTEST')
ORDER BY 1,2,3;

CREATE TABLE employees_part
(
 EMPLOYEE_ID          NUMBER(6)         NOT NULL
 ,FIRST_NAME          VARCHAR2(20)
 ,LAST_NAME           VARCHAR2(25)      NOT NULL
 ,EMAIL               VARCHAR2(25)      NOT NULL
 ,PHONE_NUMBER        VARCHAR2(20)
 ,HIRE_DATE           DATE              NOT NULL
 ,JOB_ID              VARCHAR2(10)      NOT NULL
 ,SALARY              NUMBER(8,2)
 ,COMMISSION_PCT      NUMBER(2,2)
 ,MANAGER_ID          NUMBER(6)
 ,DEPARTMENT_ID       NUMBER(4)
 ,constraint employees_part_pk primary key (employee_id, hire_date)
)
partition by range(hire_date)
(
partition p1990 values less than ('1991-01-01'),
partition p1991 values less than ('1992-01-01'),
partition p1992 values less than ('1993-01-01'),
partition p1993 values less than ('1994-01-01'),
partition p1994 values less than ('1995-01-01'),
partition p1995 values less than ('1996-01-01'),
partition p1996 values less than ('1997-01-01'),
partition p1997 values less than ('1998-01-01'),
partition p1998 values less than ('1999-01-01'),
partition p1999 values less than ('2000-01-01'),
partition p2000 values less than ('2001-01-01'),
partition p9999 values less than ('9999-12-31'),
partition pmax values less than (MAXVALUE);

select table_name, index_name, partition_name, p.status
from user_ind_partitions p join user_indexes i using(index_name)
where table_name = 'EMPLOYEES_PARTTEST'
union
select table_name, index_name, null, status
from user_indexes
where table_name = 'EMPLOYEES_PARTTEST'
order by 2,3;

select segment_name, partition_name, round(bytes/1048576) meg
from dba_segments
where (segment_name, partition_name) in
(select index_name, subpartition_name
from user_ind_subpartitions
where index_name in
(select index_name from user_indexes
where table_name = 'BILLING_FACT'))
and bytes > 1048576*8192
order by 3 desc;


