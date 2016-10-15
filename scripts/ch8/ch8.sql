set serveroutput on
begin
for ind in
(select object_name
from user_objects
where object_type='INDEX')
  loop
     dbms_output.put_line(
       'Gathering Index Statistics for'||ind.object_name||'.....');
     dbms_stats.gather_index_stats(user, ind.object_name 
       ,   estimate_percent=>100);
     dbms_output.put_line('Gathering Index Statistics for '
       ||ind.object_name||' is Complete!');
  end loop;
end;
/

create index i_emp_ename ON employees_part (employee_id)
local (partition p1_i_emp_ename UNUSABLE, partition 
p2_i_emp_ename);

select index_name as "INDEX OR PARTITION NAME", status
from user_indexes
where index_name = 'I_EMP_ENAME'
union all
select partition_name as "INDEX OR PARTITION NAME", status
from user_ind_partitions
where partition_name like '%I_EMP_ENAME%';

declare
l_myHandle number;
l_transHandle number;
l_ddl clob;
begin
  l_myHandle := dbms_metadata.open('INDEX');
  dbms_metadata.set_filter(l_myHandle, 'SYSTEM_GENERATED', FALSE);
  dbms_metadata.set_filter(l_myHandle, 'BASE_OBJECT_SCHEMA',user);
  dbms_metadata.set_filter(l_myHandle, 'BASE_OBJECT_NAME', 'IOT_TAB_TST');
  l_transHandle := dbms_metadata.add_transform(l_myHandle, 'DDL');
  loop
    l_ddl := dbms_metadata.fetch_clob(l_myHandle);
    EXIT WHEN L_DDL IS NULL;
    dbms_output.put_line( l_ddl);
  end loop;
  dbms_metadata.close(l_myHandle);
end;
/
