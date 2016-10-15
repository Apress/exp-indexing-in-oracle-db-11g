#!/bin/ksh
 
typeset -Z4 YEAR=${1:-2011}
typeset -Z2 MM=${2:-08}
YY=`echo $YEAR|cut -c3-4`
 
LOGDIR=$HOME/logs
DT=`date +%Y%m%d.%H%M`
LOG="$LOGDIR/`echo \`basename $0\`|cut -d'.' -f1`_${YEAR}${MM}_${DT}"
 
IDXFILE=/tmp/bf_i.$$.out
PARTFILE=/tmp/bf_p.$$.out

# Get list of subpartitions for an index
 
sqlplus -s $CONNECT_STRING@$ORACLE_SID <<EOT > /dev/null
set echo off
set pages 0
set head off
set feedback off
spool $PARTFILE
 
select subpartition_name from user_ind_subpartitions
where index_name = 'BILLING_FACT_PK'
and subpartition_name like '%${YY}_${MM}%'
order by 1;
 
quit;
EOT

# Get list of indexes for a table
 
sqlplus -s $CONNECT_STRING@$ORACLE_SID <<EOT > /dev/null
set echo off
set pages 0
set head off
set feedback off
spool $IDXFILE
 
select index_name
from user_ind_columns
where table_name = 'BILLING_FACT'
and index_name != 'BILLING_FACT_PK'
order by 1;
 
quit;
EOT
 
DT=`date +%Y%m%d.%H%M`
echo "Starting index rebuilds at $DT" >> $LOG
 
# Loop through each subpartition of every index and rebuild the index subpartitions.
#    All indexes for table are done all at once, subpartition at a time (in the background)

for p in `cat $PARTFILE`
do
  for i in `cat $IDXFILE`
  do
    DT=`date +%Y%m%d.%H%M`
    sqlplus -s $CONNECT_STRING@$ORACLE_SID <<EOT >> $LOG &
    prompt Rebuilding index $i, subpartition $p at $DT
    $PROMPT alter index $i rebuild subpartition $p;
    quit;
    EOT
  done
  wait
done
 
DT=`date +%Y%m%d.%H%M`
echo "Completed index rebuilds at $DT" >> $LOG
