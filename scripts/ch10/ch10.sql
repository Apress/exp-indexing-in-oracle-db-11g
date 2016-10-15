select
 owner
,task_name
,advisor_name
,created
,execution_start
,status
from dba_advisor_tasks
where advisor_name = 'SQL Access Advisor'
order by 1, 2;

select
 advisor_name
,last_exec_time
,num_db_reports
from dba_advisor_usage
order by 1, 2;
