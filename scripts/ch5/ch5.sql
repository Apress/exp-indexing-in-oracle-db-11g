select index_name, visibility from dba_indexes
where visibility='INVISIBLE';

select first_name,last_name,phone_number
     from employees
     where UPPER(last_name) = UPPER('alapati');

select column_name,num_distinct, hidden_column,virtual_column 
      from dba_tab_ cols where table_name='EMPLOYEES';

create table sales
(prod_id     number(6) not null,
cust_id   number not null,
time_id date not null,
channel_id char(1) not null,
quantity_sold number(3) not null,
amount_sold number(10,2) not null,
total_amount AS (quantity_sold * amount_sold));

select a.index_name,a.index_type,
b.column_expression
from user_indexes a
inner join user_ind_expressions b
on a.index_name=b.index_name
where a.index_name='TEST_VIRTUAL_INDX1';
