CREATE BITMAP INDEX EMPLOYEES_B1
ON EMPLOYEES (GENDER)
NOLOGGING;

SELECT sum(bytes)/1048576
FROM dba_segments
WHERE segment_name = 'EMPLOYEES_B2';

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
 ,CONSTRAINT employees_part_pk PRIMARY KEY (employee_id, hire_date)
)
ORGANIZATION INDEX
MAPPING TABLE;

CREATE BITMAP INDEX employees_part_1i
ON employees_part (department_id)
NOLOGGING
LOCAL;

SELECT pr.prod_category, c.country_id, 
t.calendar_year, sum(s.quantity_sold), SUM(s.amount_sold)
FROM sales s, times t, customers c, products pr
WHERE s.time_id = t.time_id
AND   s.cust_id = c.cust_id
AND   pr.prod_id = s.prod_id
AND   t.calendar_year = '2011'
GROUP BY pr.prod_category, c.country_id, t.calendar_year;

CREATE BITMAP INDEX BILLING_FACT_BJIX01
ON BILLING_FACT (GEO.GEO_ID)
FROM BILLING_FACT BF, GEOGRAPHY_DIMENSION GEO
WHERE BF.GEO_ID = GEO.GEO_ID
tablespace BILLING_FACT_S 
PCTFREE 5
PARALLEL 4
LOCAL
NOLOGGING;

CREATE BITMAP INDEX BILLING_FACT_BJIX02
ON BILLING_FACT (GEO.GEO_ID, TM.YYYYMMDD_DT)
FROM BILLING_FACT BF, GEOGRAPHY_DIMENSION GEO, TIME_DIMENSION TM
WHERE BF.GEO_ID = GEO.GEO_ID
AND BF.YYYYMMDD_DT = TM.YYYYMMMDD_DT
tablespace BILLING_FACT_S 
PCTFREE 5
PARALLEL 4
LOCAL
NOLOGGING;

SELECT index_name, index_type, join_index FROM dba_indexes
WHERE index_type = 'BITMAP';




