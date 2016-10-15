select
d.object_name,
d.operation,
d.options,
count(1)
from
dba_hist_sql_plan d,
dba_hist_sqlstat h
where
d.object_owner <> 'SYS'
and
d.operation like '%INDEX%'
and
d.sql_id = h.sql_id
group by
d.object_name,
d.operation,
d.options
order by
1,2,3;

select /*+ INDEX_JOIN(e emp_manager_ix emp_department_ix) */ department_id
     from employees e
     where manager_id < 110
     and department_id < 50;

select /*+ leading(e2 e1) use_nl(e1) index(e1 emp_emp_id_pk) 
      use_merge(j) full(j) */
      e1.first_name, e1.last_name, j.job_id, sum(e2.salary) total_sal
      from employees e1, employees e2, job_history j
      where e1.employee_id = e2.manager_id
      and e1.employee_id = j.employee_id
      and e1.hire_date = j.start_date
      group by e1.first_name, e1.last_name, j.job_id
      order by total_sal;
