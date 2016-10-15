CREATE TABLE locations_iot
(LOCATION_ID         NUMBER(4)         NOT NULL
,STREET_ADDRESS      VARCHAR2(40)
,POSTAL_CODE         VARCHAR2(12)
,CITY                VARCHAR2(30)      NOT NULL
,STATE_PROVINCE      VARCHAR2(25)
,COUNTRY_ID          CHAR(2)
,CONSTRAINT locations_iot_pk PRIMARY KEY (location_id)
)
ORGANIZATION INDEX;

CREATE TABLE locations_iot
(LOCATION_ID         NUMBER(4)         NOT NULL
,STREET_ADDRESS      VARCHAR2(40)
,POSTAL_CODE         VARCHAR2(12)
,CITY                VARCHAR2(30)      NOT NULL
,STATE_PROVINCE      VARCHAR2(25)      NOT NULL
,COUNTRY_ID          CHAR(2)
,constraint locations_iot_pk primary key (location_id, state_province)
)
ORGANIZATION INDEX
partition by list(STATE_PROVINCE)
(partition p_intl values
('Maharashtra','Bavaria','New South Wales', 'BE','Geneve',
'Tokyo Prefecture', 'Sao Paulo','Manchester','Utrecht',
'Ontario','Yukon','Oxford'),
partition p_domestic values ('Texas','New Jersey','Washington','California'));

CREATE TABLE employees
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
,CONSTRAINT employees_pk PRIMARY KEY (employee_id)
)
ORGANIZATION INDEX
TABLESPACE empindex_s
PCTTHRESHOLD 40
INCLUDING salary
OVERFLOW TABLESPACE overflow_s;

select i.table_name, i.index_name, i.index_type, i.pct_threshold,
nvl(column_name,'NONE') include_column
from user_indexes i left join user_tab_columns c
on (i.table_name = c.table_name)
and (i.include_column = c.column_id)
where index_type = 'IOT - TOP';
