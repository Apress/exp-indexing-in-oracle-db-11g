create table cust
(cust_id    number
,last_name  varchar2(30)
,first_name varchar2(30));

select cust_id, last_name, first_name
from cust
where last_name = 'STARK';

create index cust_idx1
on cust(last_name);

select last_name
from cust
where last_name = 'STARK';

create index cust_idx2
on cust(first_name);

create table prod_sku
(prod_sku_id number
,sku         varchar2(256),
constraint prod_sku_pk primary key(prod_sku_id, sku)
) organization index;

create unique index cust_uidx1
on cust(last_name, first_name);

create index cust_ridx1
on cust(cust_id) reverse;

create index cust_cidx_1
on cust(last_name, first_name) compress 2;

create index cust_didx1
on cust(cust_id desc);

create table f_sales(
 sales_amt number
,d_date_id number
,d_product_id number
,d_customer_id number);

create bitmap index f_sales_fk1
on f_sales(d_date_id);

create table d_customers
(d_customer_id number primary key
,cust_name varchar2(30));

create bitmap index f_sales_bmj_idx1
on f_sales(d_customers.cust_name)
from f_sales, d_customers
where f_sales.d_customer_id = d_customers.d_customer_id;

create index cust_fidx1
on cust(upper(last_name));

create table inv(
 inv_id number
,inv_count number
,inv_status generated always as (
  case when inv_count <= 100 then 'GETTING LOW'
       when inv_count > 100 then 'OKAY'
  end)
);

create index inv_idx1
on inv(inv_status);

create index cust_idx1
on cust(first_name) nosegment;

create index cust_iidx1
on cust(last_name) invisible;

create index f_sales_gidx1 on f_sales(sales_amt)
global partition by range(sales_amt)
(partition pg1 values less than (25)
,partition pg2 values less than (50)
,partition pg3 values less than (maxvalue));

create table f_sales(
 sales_amt number
,d_date_id number
,d_product_id number
,d_customer_id number)
partition by range(sales_amt)(
 partition p1 values less than (100)
,partition p2 values less than (1000)
,partition p3 values less than (maxvalue));

create index f_sales_idx2
on f_sales(d_date_id, sales_amt) local;

create table cust
(cust_id    number primary key
,last_name  varchar2(30)
,first_name varchar2(30)
,ssn        varchar2(16) unique);

create table address
(address_id number primary key
,cust_id number references cust(cust_id)
,address varchar2(1000)
);

create index address_fk1 on address(cust_id);


