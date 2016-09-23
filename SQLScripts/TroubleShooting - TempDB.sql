/*https://technet.microsoft.com/en-us/library/ms176029(v=sql.105).aspx*/
 select top 10
	t1.session_id,
	t1.request_id,
	t1.task_alloc,
     t1.task_dealloc, 
    (SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,
          (CASE WHEN statement_end_offset = -1
              THEN LEN(CONVERT(nvarchar(max),text)) * 2
                   ELSE statement_end_offset
              END - t2.statement_start_offset)/2)
     FROM sys.dm_exec_sql_text(sql_handle)) AS query_text,
 (SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle)) as query_plan
 
from      (Select session_id, request_id,
sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count) as task_alloc,
sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count) as task_dealloc
       from sys.dm_db_task_space_usage
       group by session_id, request_id) as t1,
       sys.dm_exec_requests as t2
where t1.session_id = t2.session_id and
(t1.request_id = t2.request_id) and
      t1.session_id > 50 and t1.session_id = 306
order by t1.task_alloc DESC





SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
(SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;

SELECT transaction_id
FROM sys.dm_tran_active_snapshot_database_transactions 
ORDER BY elapsed_time_seconds DESC;

SELECT SUM(size)*1.0/128 AS [size in MB]
FROM tempdb.sys.database_files

SELECT SUM(unallocated_extent_page_count) AS [free pages], 
(SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]
FROM sys.dm_db_file_space_usage;

 SELECT SUM(internal_object_reserved_page_count) AS [internal object pages used],
(SUM(internal_object_reserved_page_count)*1.0/128) AS [internal object space in MB]
FROM sys.dm_db_file_space_usage;

SELECT SUM(user_object_reserved_page_count) AS [user object pages used],
(SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]
FROM sys.dm_db_file_space_usage;
  
   

    SELECT session_id, 
      SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
    FROM sys.dm_db_task_space_usage 
	WHERE session_id = 306
    GROUP BY session_id;

	 SELECT R1.session_id,
        R1.internal_objects_alloc_page_count 
        + R2.task_internal_objects_alloc_page_count AS session_internal_objects_alloc_page_count,
        R1.internal_objects_dealloc_page_count 
        + R2.task_internal_objects_dealloc_page_count AS session_internal_objects_dealloc_page_count
    FROM sys.dm_db_session_space_usage AS R1 
    INNER JOIN ( SELECT session_id, 
      SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
    FROM sys.dm_db_task_space_usage 
    GROUP BY session_id) AS R2 ON R1.session_id = R2.session_id
	WHERE r2.session_id = 306;
 
 with all_request_usage AS
 (
 SELECT session_id, request_id, 
      SUM(internal_objects_alloc_page_count) AS request_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count)AS request_internal_objects_dealloc_page_count 
  FROM sys.dm_db_task_space_usage 
  WHERE session_id = 306
  GROUP BY session_id, request_id
 )
,all_query_usage AS
  (
  SELECT R1.session_id, R1.request_id, 
      R1.request_internal_objects_alloc_page_count, R1.request_internal_objects_dealloc_page_count,
      R2.sql_handle, R2.statement_start_offset, R2.statement_end_offset, R2.plan_handle
  FROM (SELECT session_id, request_id, 
      SUM(internal_objects_alloc_page_count) AS request_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count)AS request_internal_objects_dealloc_page_count 
  FROM sys.dm_db_task_space_usage 
  GROUP BY session_id, request_id) R1
  INNER JOIN sys.dm_exec_requests R2 ON R1.session_id = R2.session_id and R1.request_id = R2.request_id
  )

 SELECT R1.sql_handle, R2.text 
FROM all_query_usage AS R1
OUTER APPLY sys.dm_exec_sql_text(R1.sql_handle) AS R2;

--  SELECT R1.plan_handle, R2.query_plan 
--FROM all_query_usage AS R1
--OUTER APPLY sys.dm_exec_query_plan(R1.plan_handle) AS R2;



--Identify which type of tempdb objects are consuming  space
/*
If user_obj_kb is the highest consumer, then you that objects are being created by user queries like local or global temp tables or table variables. Also don’t forget to check if there are any permanent 
tables created in TempDB. Very rare, but I’ve seen this happening.
If version_store_kb is the highest consumer, then it means that the version store is growing faster than the clean up. Most likely there are long running transactions or open transaction (Sleeping state), 
which are preventing the cleanup and hence not release tempdb space back.
*/
SELECT
SUM (user_object_reserved_page_count)*8 as user_obj_kb,
SUM (internal_object_reserved_page_count)*8 as internal_obj_kb,
SUM (version_store_reserved_page_count)*8  as version_store_kb,
SUM (unallocated_extent_page_count)*8 as freespace_kb,
SUM (mixed_extent_page_count)*8 as mixedextent_kb
FROM sys.dm_db_file_space_usage


-- tempDB status for each session
SELECT sys.dm_exec_sessions.session_id AS [SESSION ID]
, DB_NAME(database_id) AS [DATABASE Name]
, HOST_NAME AS [System Name]
, program_name AS [Program Name]
, login_name AS [USER Name]
, STATUS
, cpu_time AS [CPU TIME (in milisec)]
, total_scheduled_time AS [Total Scheduled TIME (in milisec)]
, total_elapsed_time AS [Elapsed TIME (in milisec)]
, (memory_usage * 8 / 1024) AS [Memory USAGE (in MB)]
, (user_objects_alloc_page_count * 8 / 1024) AS [SPACE Allocated FOR USER Objects (in MB)]
, (user_objects_dealloc_page_count * 8 / 1024) AS [SPACE Deallocated FOR USER Objects (in MB)]
, (internal_objects_alloc_page_count * 8 / 1024) AS [SPACE Allocated FOR Internal Objects (in MB)]
, (internal_objects_dealloc_page_count * 8 / 1024) AS [SPACE Deallocated FOR Internal Objects (in MB)]
, CASE is_user_process
  WHEN 1
   THEN 'user session'
  WHEN 0
   THEN 'system session'
  END AS [SESSION Type]
, row_count AS [ROW COUNT]
FROM sys.dm_db_session_space_usage
INNER JOIN sys.dm_exec_sessions ON sys.dm_db_session_space_usage.session_id = sys.dm_exec_sessions.session_id
WHERE STATUS <> 'sleeping'
ORDER BY user_objects_alloc_page_count DESC


-- get query details base on session id
DECLARE @sqltext VARBINARY(128)
SELECT @sqltext = sql_handle
FROM sys.sysprocesses
WHERE spid = 314
SELECT TEXT

FROM sys.dm_exec_sql_text(@sqltext)
--Query that identifies the currently active T-SQL query, it’s text and the Application that is consuming a lot of tempdb space
SELECT es.host_name , es.login_name , es.program_name,
st.dbid as QueryExecContextDBID, DB_NAME(st.dbid) as QueryExecContextDBNAME, st.objectid as ModuleObjectId,
SUBSTRING(st.text, er.statement_start_offset/2 + 1,(CASE WHEN er.statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max),st.text)) * 2 ELSE er.statement_end_offset 
END - er.statement_start_offset)/2) as Query_Text,
tsu.session_id ,tsu.request_id, tsu.exec_context_id, 
(tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count) as OutStanding_user_objects_page_counts,
(tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) as OutStanding_internal_objects_page_counts,
er.start_time, er.command, er.open_transaction_count, er.percent_complete, er.estimated_completion_time, er.cpu_time, er.total_elapsed_time, er.reads,er.writes, 
er.logical_reads, er.granted_query_memory
FROM sys.dm_db_task_space_usage tsu inner join sys.dm_exec_requests er 
 ON ( tsu.session_id = er.session_id and tsu.request_id = er.request_id) 
inner join sys.dm_exec_sessions es ON ( tsu.session_id = es.session_id ) 
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE (tsu.internal_objects_alloc_page_count+tsu.user_objects_alloc_page_count) > 0
ORDER BY (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)+(tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) 
DESC

--If the number of logical processors on your server is greater than or equal to 8, then use 8 data files for tempdb
Declare @tempdbfilecount as int;
select @tempdbfilecount = (select count(*) from sys.master_files where database_id=2 and type=0);
WITH Processor_CTE ([cpu_count], [hyperthread_ratio])
AS
(
      SELECT  cpu_count, hyperthread_ratio
      FROM sys.dm_os_sys_info sysinfo
)
select Processor_CTE.cpu_count as [# of Logical Processors], @tempdbfilecount as [Current_Tempdb_DataFileCount], 
(case 
      when (cpu_count<8 and @tempdbfilecount=cpu_count)  then 'No' 
      when (cpu_count<8 and @tempdbfilecount<>cpu_count and @tempdbfilecount<cpu_count) then 'Yes' 
      when (cpu_count<8 and @tempdbfilecount<>cpu_count and @tempdbfilecount>cpu_count) then 'No'
      when (cpu_count>=8 and @tempdbfilecount=cpu_count)  then 'No (Depends on continued Contention)' 
      when (cpu_count>=8 and @tempdbfilecount<>cpu_count and @tempdbfilecount<cpu_count) then 'Yes'
      when (cpu_count>=8 and @tempdbfilecount<>cpu_count and @tempdbfilecount>cpu_count) then 'No (Depends on continued Contention)'
end) AS [TempDB_DataFileCount_ChangeRequired]
from Processor_CTE;

--find the oldest transactions that are active and using row versioning
SELECT top 5 a.session_id, a.transaction_id, a.transaction_sequence_num, a.elapsed_time_seconds,
b.program_name, b.open_tran, b.status
FROM sys.dm_tran_active_snapshot_database_transactions a
join sys.sysprocesses b
on a.session_id = b.spid
ORDER BY elapsed_time_seconds DESC