SELECT *
FROM (
SELECT  *,
case when statusdescription='Running' then
CONVERT(VARCHAR(10),DATEDIFF(ss,ExecutionStartTime_PST , dateadd(hh,-7,getdate()))/3600) +'hrs ' 
       + RIGHT('00'+CONVERT(VARCHAR(2),(DATEDIFF(ss, ExecutionStartTime_PST , dateadd(hh,-7,getdate()))%3600)/60),2) +'mins ' 
       + RIGHT('00'+CONVERT(VARCHAR(2),DATEDIFF(ss, ExecutionStartTime_PST , dateadd(hh,-7,getdate()))%60),2) +'secs'
	   else Execution_Duration
	   end as Duration
 FROM (
SELECT 
   execs.execution_id
, execs.project_name
, execs.package_name
, CASE  WHEN opers.[status] = 1 THEN 'Created'
    WHEN opers.[status] = 2 THEN 'Running'
    WHEN opers.[status] = 3 THEN 'Canceled'
    WHEN opers.[status] = 4 THEN 'Failed'
    WHEN opers.[status] = 5 THEN 'Pending'
    WHEN opers.[status] = 6 THEN 'Ended Unexpectedly'
    WHEN opers.[status] = 7 THEN 'Succeeded'
    WHEN opers.[status] = 8 THEN 'Stopping'
    WHEN opers.[status] = 9 THEN 'Completed'
       END AS StatusDescription
, expv_start.parameter_value as SourceStartDate
, expv_end.parameter_value as SourceEndDate
, dateadd(hh,-7,opers.start_time) as ExecutionStartTime_PST
, dateadd(hh,-7,opers.end_time) as ExecutionEndTime_PST
,CONVERT(VARCHAR(10),DATEDIFF(ss, opers.start_time, opers.end_time)/3600) +'hrs ' 
       + RIGHT('00'+CONVERT(VARCHAR(2),(DATEDIFF(ss, opers.start_time, opers.end_time)%3600)/60),2) +'mins ' 
       + RIGHT('00'+CONVERT(VARCHAR(2),DATEDIFF(ss, opers.start_time, opers.end_time)%60),2) +'secs' AS Execution_Duration
FROM SSISDB.internal.executions execs
INNER JOIN SSISDB.internal.operations opers
       ON execs.execution_id=opers.operation_id
INNER JOIN SSISDB.internal.execution_parameter_values expv_start
       ON execs.execution_id=expv_start.execution_id AND expv_start.parameter_name IN ('Proj_StartDate', 'StartDate')
INNER JOIN SSISDB.internal.execution_parameter_values expv_end
       ON execs.execution_id=expv_end.execution_id AND expv_end.parameter_name IN ('Proj_EndDate', 'EndDate')
)AL
WHERE 
AL.StatusDescription in (/*'Running','Failed',*/'succeeded')
AND 
AL.package_name='IELoadMasterPackage.dtsx' and
cast(executionStartTime_PST as date) >= cast(dateadd(hh,-7,getdate()-10) as date)
)x
where LEFT(Duration,1) in(3,4,5,6)
ORDER BY Duration 

