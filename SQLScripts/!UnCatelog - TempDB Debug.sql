/****Session Info*****/
--Get DB read/write info
SELECT 
	DB_NAME(database_id) AS 'Database Name'
	,FILE_NAME(file_id) as 'File Name'
	,(f.size*8)/1024 Size_MB
	,(f.maxsize*8)/1024 MaxSize_MB
	,f.growth
	,f.filename
	,CASE f.status WHEN '2' THEN 'Data File' Else 'Log File' END AS Status
	,vfs.num_of_reads
	,vfs.num_of_bytes_read
	,vfs.io_stall_read_ms
	,vfs.num_of_writes
	,vfs.num_of_bytes_written
	,vfs.io_stall_write_ms
	,vfs.io_stall  --stall wait
	,vfs.size_on_disk_bytes
	,io_stall_read_ms / CASE WHEN num_of_reads!= 0 THEN num_of_reads END AS 'Avg Read Transfer/ms'
	,io_stall_write_ms / CASE WHEN num_of_writes!= 0 THEN num_of_writes END  AS 'Avg Write Transfer/ms'
FROM sys.dm_io_virtual_file_stats(null,null) vfs
JOIN sysfiles f
  ON vfs.file_id = f.fileid
WHERE filename like '%I:%'

 

--Get DB level cost info with different types -- only show proc info
 SELECT DB_NAME(st.dbid) DBName
      ,OBJECT_SCHEMA_NAME(objectid,st.dbid) SchemaName
      ,OBJECT_NAME(objectid,st.dbid) StoredProcedure
      ,max(cp.usecounts) execution_count
	  
	  ,sum(qs.total_worker_time) total_cpu_time
      ,sum(qs.total_worker_time) / (max(cp.usecounts) * 1.0)  avg_cpu_time

      ,sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) total_IO
      ,sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) / (max(cp.usecounts)) avg_total_IO
      ,sum(qs.total_physical_reads) total_physical_reads
      ,sum(qs.total_physical_reads) / (max(cp.usecounts) * 1.0) avg_physical_read    
      ,sum(qs.total_logical_reads) total_logical_reads
      ,sum(qs.total_logical_reads) / (max(cp.usecounts) * 1.0) avg_logical_read  
      ,sum(qs.total_logical_writes) total_logical_writes
      ,sum(qs.total_logical_writes) / (max(cp.usecounts) * 1.0) avg_logical_writes  
	  
	  ,sum(qs.total_elapsed_time) total_elapsed_time
      ,sum(qs.total_elapsed_time) / max(cp.usecounts) avg_elapsed_time
 FROM sys.dm_exec_query_stats qs CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st
   join sys.dm_exec_cached_plans cp on qs.plan_handle = cp.plan_handle
  where DB_NAME(st.dbid) is not null and cp.objtype = 'proc'
 group by DB_NAME(st.dbid),OBJECT_SCHEMA_NAME(objectid,st.dbid), OBJECT_NAME(objectid,st.dbid) 
 order by sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) desc
 --order by sum(qs.total_elapsed_time) desc
  

--Get task level info, who run the which sql with cost info
 select top 10
	t1.session_id
	,t1.request_id
	,t1.task_alloc
    ,t1.task_dealloc
    ,(SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,
          (CASE WHEN statement_end_offset = -1
              THEN LEN(CONVERT(nvarchar(max),text)) * 2
                   ELSE statement_end_offset
              END - t2.statement_start_offset)/2)
     FROM sys.dm_exec_sql_text(sql_handle)) AS query_text,
 (SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle)) as query_plan
 
from  (Select session_id, request_id,
		sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count) as task_alloc,
		sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count) as task_dealloc
       from sys.dm_db_task_space_usage
       group by session_id, request_id) as t1,
       sys.dm_exec_requests as t2
where t1.session_id = t2.session_id and
(t1.request_id = t2.request_id) and
      t1.session_id > 50
order by t1.task_alloc DESC
--57123944	47350920
--57124480	48739856

--Get Session level info, who run the which sql with cost info
 SELECT  SPID = er.session_id ,
        Status = ses.status ,
        [Login] = ses.login_name ,
        Host = ses.host_name ,
        BlkBy = er.blocking_session_id ,
        DBName = DB_NAME(er.database_id) ,
        CommandType = er.command ,
        SQLStatement = st.text ,
        ObjectName = OBJECT_NAME(st.objectid) ,
        ElapsedMS = er.total_elapsed_time ,
        CPUTime = er.cpu_time ,
        IOReads = er.logical_reads + er.reads ,
        IOWrites = er.writes ,
        g.name ,
        LastWaitType = er.last_wait_type ,
        StartTime = er.start_time ,
        g.name ,
        Protocol = con.net_transport ,
        ConnectionWrites = con.num_writes ,
        ConnectionReads = con.num_reads ,
        ClientAddress = con.client_net_address ,
        Authentication = con.auth_scheme
FROM    sys.dm_exec_requests er
        OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) st
        LEFT JOIN sys.dm_exec_sessions ses ON ses.session_id = er.session_id
        LEFT JOIN sys.dm_exec_connections con ON con.session_id = ses.session_id
        JOIN sys.dm_resource_governor_workload_groups g ON g.group_id = ses.group_id
WHERE   er.session_id > 50 
	--AND er.status = 'running'
	--AND ses.host_name = 'GCOTDVM3728203' 
    --AND er.session_id != @@SPID
	--AND er.session_id = 59
--group by g.name,er.last_wait_type 
ORDER BY er.blocking_session_id DESC ,
        er.session_id ,
        er.start_time 
		select * from sys.dm_tran_locks where request_session_id = 58
kill 58
--Check tempdb costs by differenct sessions
SELECT 
	DB_NAME(database_id) AS 'Database Name'
	,login_time
	,last_request_start_time
	,last_request_end_time
	,login_name
	,nt_user_name
	,host_name
	,program_name
	,status
	,memory_usage
	,user_objects_alloc_page_count
	,internal_objects_alloc_page_count
	,CASE transaction_isolation_level  
		WHEN 0 THEN 'Unspecified'
		WHEN 1 THEN 'ReadUncomitted'
		WHEN 2 THEN 'ReadCommitted'
		WHEN 3 THEN 'Repeatable'
		WHEN 4 THEN 'Serializable'
		WHEN 5 THEN 'Snapshot'
	END AS transaction_isolation_level
FROM sys.dm_db_session_space_usage ssu
JOIN sys.dm_exec_sessions ds
  ON ssu.session_id = ds.session_id
WHERE ds.session_id > 50
  AND login_name = 'speed_it'
  --AND ds.session_id = @@SPID
  --AND host_name = 'GCOTDVM3728203'
ORDER BY user_objects_alloc_page_count + internal_objects_alloc_page_count DESC ;


---Get session with Latch 
	select
		session_id, wait_duration_ms,   resource_description,*
      from    sys.dm_os_waiting_tasks
      where   wait_type like 'PAGE%LATCH_%' and
              resource_description like '2:%'

			  --Temp Tables Creation Rate
			  --Temp Tables For Destruction

--Check Top Wait Types
 WITH [Waits] AS
    (SELECT
        [wait_type],
        [wait_time_ms] / 1000.0 AS [WaitS],
        ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS],
        [signal_wait_time_ms] / 1000.0 AS [SignalS],
        [waiting_tasks_count] AS [WaitCount],
        100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
        ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
    FROM sys.dm_os_wait_stats
    WHERE [wait_type] NOT IN (
        N'BROKER_EVENTHANDLER',             N'BROKER_RECEIVE_WAITFOR',
        N'BROKER_TASK_STOP',                N'BROKER_TO_FLUSH',
        N'BROKER_TRANSMITTER',              N'CHECKPOINT_QUEUE',
        N'CHKPT',                           N'CLR_AUTO_EVENT',
        N'CLR_MANUAL_EVENT',                N'CLR_SEMAPHORE',
        N'DBMIRROR_DBM_EVENT',              N'DBMIRROR_EVENTS_QUEUE',
        N'DBMIRROR_WORKER_QUEUE',           N'DBMIRRORING_CMD',
        N'DIRTY_PAGE_POLL',                 N'DISPATCHER_QUEUE_SEMAPHORE',
        N'EXECSYNC',                        N'FSAGENT',
        N'FT_IFTS_SCHEDULER_IDLE_WAIT',     N'FT_IFTSHC_MUTEX',
        N'HADR_CLUSAPI_CALL',               N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
        N'HADR_LOGCAPTURE_WAIT',            N'HADR_NOTIFICATION_DEQUEUE',
        N'HADR_TIMER_TASK',                 N'HADR_WORK_QUEUE',
        N'KSOURCE_WAKEUP',                  N'LAZYWRITER_SLEEP',
        N'LOGMGR_QUEUE',                    N'ONDEMAND_TASK_QUEUE',
        N'PWAIT_ALL_COMPONENTS_INITIALIZED',
        N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
        N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
        N'REQUEST_FOR_DEADLOCK_SEARCH',     N'RESOURCE_QUEUE',
        N'SERVER_IDLE_CHECK',               N'SLEEP_BPOOL_FLUSH',
        N'SLEEP_DBSTARTUP',                 N'SLEEP_DCOMSTARTUP',
        N'SLEEP_MASTERDBREADY',             N'SLEEP_MASTERMDREADY',
        N'SLEEP_MASTERUPGRADED',            N'SLEEP_MSDBSTARTUP',
        N'SLEEP_SYSTEMTASK',                N'SLEEP_TASK',
        N'SLEEP_TEMPDBSTARTUP',             N'SNI_HTTP_ACCEPT',
        N'SP_SERVER_DIAGNOSTICS_SLEEP',     N'SQLTRACE_BUFFER_FLUSH',
        N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
        N'SQLTRACE_WAIT_ENTRIES',           N'WAIT_FOR_RESULTS',
        N'WAITFOR',                         N'WAITFOR_TASKSHUTDOWN',
        N'WAIT_XTP_HOST_WAIT',              N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG',
        N'WAIT_XTP_CKPT_CLOSE',             N'XE_DISPATCHER_JOIN',
        N'XE_DISPATCHER_WAIT',              N'XE_TIMER_EVENT')
    AND [waiting_tasks_count] > 0
 )
SELECT
    MAX ([W1].[wait_type]) AS [WaitType],
    CAST (MAX ([W1].[WaitS]) AS DECIMAL (16,2)) AS [Wait_S],
    CAST (MAX ([W1].[ResourceS]) AS DECIMAL (16,2)) AS [Resource_S],
    CAST (MAX ([W1].[SignalS]) AS DECIMAL (16,2)) AS [Signal_S],
    MAX ([W1].[WaitCount]) AS [WaitCount],
    CAST (MAX ([W1].[Percentage]) AS DECIMAL (5,2)) AS [Percentage],
    CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgWait_S],
    CAST ((MAX ([W1].[ResourceS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgRes_S],
    CAST ((MAX ([W1].[SignalS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgSig_S]
FROM [Waits] AS [W1]
INNER JOIN [Waits] AS [W2]
    ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY [W1].[RowNum]
HAVING SUM ([W2].[Percentage]) - MAX ([W1].[Percentage]) < 95; -- percentage threshold
GO
 



--select * 
--from sys.dm_os_buffer_descriptors
--where database_id = db_id(N'tempdb')
/*
NULL latch (NL): Not used
KEEP latch (KP): Have two purposes: to keep a page in the buffer cache while another latch is placed upon it, and the second is to maintain reference counts.
SHARED latch (SH): Taken out when a request to read the data page is received.
UPDATE latch (UP): Milder than an EX latch, this allows reads but no writes on the page while being updated.
EXCLUSIVE latch (EX): Severe latch that allows no access to the page while being written. Only one per page can be held.
DESTROY latch (DT): Used to destroy a buffer and evict it from the cache (returning the page to the free list).

*/

/*--Memory grant
	select * from sys.dm_exec_query_resource_semaphores
	--0 Regular Resource Semaphore
		select granted_memory_kb,used_memory_kb,max_used_memory_kb,dop from sys.dm_exec_query_memory_grants
		where session_id = 116
--1 Small Resource Semaphore
--Check File Growth
--Find all queries waiting in the memory queue:

SELECT * FROM sys.dm_exec_query_memory_grants where grant_time is null

--Find who uses the most query memory grant:
SELECT mg.granted_memory_kb, mg.session_id, t.text, qp.query_plan 
FROM sys.dm_exec_query_memory_grants AS mg
CROSS APPLY sys.dm_exec_sql_text(mg.sql_handle) AS t
CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qp
ORDER BY 1 DESC OPTION (MAXDOP 1)

--Search cache for queries with memory grants:
SELECT t.text, cp.objtype,qp.query_plan
FROM sys.dm_exec_cached_plans AS cp
JOIN sys.dm_exec_query_stats AS qs ON cp.plan_handle = qs.plan_handle
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS t
WHERE qp.query_plan.exist('declare namespace n="http://schemas.microsoft.com/sqlserver/2004/07/showplan"; //n:MemoryFractions') = 1

*/
SELECT 
    name AS FileName, 
    size*1.0/128 AS FileSizeinMB,
    CASE max_size 
        WHEN 0 THEN 'Autogrowth is off.'
        WHEN -1 THEN 'Autogrowth is on.'
        ELSE 'Log file will grow to a maximum size of 2 TB.'
    END,
    growth AS 'GrowthValue',
    'GrowthIncrement' = 
        CASE
            WHEN growth = 0 THEN 'Size is fixed and will not grow.'
            WHEN growth > 0 AND is_percent_growth = 0 
                THEN 'Growth value is in 8-KB pages.'
            ELSE 'Growth value is a percentage.'
        END
FROM tempdb.sys.database_files;

--Current Memory Allocation
SELECT
(physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,
(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,
(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,
process_physical_memory_low,
process_virtual_memory_low
FROM sys.dm_os_process_memory;

--Check Index Info
-- 9GB
SELECT
    i.name                  AS IndexName,
    SUM(s.used_page_count) * 8   AS IndexSizeKB
FROM sys.dm_db_partition_stats  AS s 
JOIN sys.indexes                AS i
ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
WHERE s.[object_id] = object_id('dbo.Lp_collat')
GROUP BY i.name
ORDER BY i.name
 
 sp_spaceused 'dbo.Lp_collat'
--UnFinished
declare @spid int  = 58
--1792 1.2GB
 select top 10
	t1.session_id,
	t1.request_id,
	t1.task_alloc,
     t1.task_dealloc, 
	 t1.task_alloc - t1.task_dealloc as task_retain,
	 (t1.task_alloc - t1.task_dealloc)*8.0/1024/1024 as task_retain_space_GB,
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
      t1.session_id > 50 and t1.session_id =@spid
order by t1.task_alloc DESC

select * from sys.dm_os_tasks where task_address=0x000000001484FB88 --task_state ='RUNNING'
select * from sys.dm_os_tasks where session_id = 82 --64 processor

  

--Determining the Longest Running Transaction
SELECT transaction_id
FROM sys.dm_tran_active_snapshot_database_transactions 
ORDER BY elapsed_time_seconds DESC;



--Determining the Amount of Space Used Info
SELECT 
	(SELECT SUM(size)*1.0/128 FROM tempdb.sys.database_files) AS [total size in MB]
	,SUM(unallocated_extent_page_count) AS [free pages]
	,(SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]
	,(SUM(unallocated_extent_page_count)*1.0/128)/(SELECT SUM(size)*1.0/128 FROM tempdb.sys.database_files)*100 AS [free space in pct]
	,SUM(version_store_reserved_page_count) AS [version store pages used]
	,(SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
	,SUM(user_object_reserved_page_count) AS [user object pages used]
	,SUM(user_object_reserved_page_count)*1.0/128 AS [user object space in MB]
	,SUM(internal_object_reserved_page_count) AS [internal object pages used]
	,(SUM(internal_object_reserved_page_count)*1.0/128) AS [internal object space in MB]
	,SUM(mixed_extent_page_count) AS 'Total Mixed Extent Pages'
	,(SUM(mixed_extent_page_count)*1.0/128) AS [mixed extent page space in MB]
FROM sys.dm_db_file_space_usage;

 

--Method 1: Batch-Level Information
   -- Obtaining the space consumed by internal objects in all currently running tasks in each session
    SELECT session_id, 
      SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
    FROM sys.dm_db_task_space_usage 
	WHERE session_id = @spid
    GROUP BY session_id;
	--Obtaining the space consumed by internal objects in the current session for both running and completed tasks
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
	WHERE r2.session_id = @spid;
 declare @spid int  = 82
 --Method 2: Query-Level Information
	 ;with all_request_usage AS
	 (
	 SELECT session_id, request_id, 
		  SUM(internal_objects_alloc_page_count) AS request_internal_objects_alloc_page_count,
		  SUM(internal_objects_dealloc_page_count)AS request_internal_objects_dealloc_page_count 
	  FROM sys.dm_db_task_space_usage 
	  WHERE session_id = @spid
	  GROUP BY session_id, request_id
	 )
	,all_query_usage AS
	  (
	  SELECT R1.session_id, R1.request_id, 
		  R1.request_internal_objects_alloc_page_count, R1.request_internal_objects_dealloc_page_count,
		  R2.sql_handle, R2.statement_start_offset, R2.statement_end_offset, R2.plan_handle
		  ,r2.granted_query_memory,r2.last_wait_type,r2.total_elapsed_time
	  FROM (SELECT session_id, request_id, 
		  SUM(internal_objects_alloc_page_count) AS request_internal_objects_alloc_page_count,
		  SUM(internal_objects_dealloc_page_count)AS request_internal_objects_dealloc_page_count 
	  FROM sys.dm_db_task_space_usage 
	  GROUP BY session_id, request_id) R1
	  INNER JOIN sys.dm_exec_requests R2 ON R1.session_id = R2.session_id and R1.request_id = R2.request_id
	  )

	 SELECT  r1.request_internal_objects_alloc_page_count,r1.request_internal_objects_dealloc_page_count
		,r1.granted_query_memory,r1.last_wait_type,r1.total_elapsed_time
		, R2.text, ISNULL(NULLIF(SUBSTRING(R2.text, R1.statement_start_offset / 2,
	   CASE WHEN R1.statement_end_offset < R1.statement_start_offset
       THEN 0 ELSE( R1.statement_end_offset - R1.statement_start_offset ) / 2 END), ''), R2.text) AS [statement text]
	FROM all_query_usage AS R1
	OUTER APPLY sys.dm_exec_sql_text(R1.sql_handle) AS R2
	where session_id = @spid;

	--what resources threads need to wait for, and how long they need to wait
	select * from sys.dm_os_waiting_tasks where session_id = @spid
	select * from sys.dm_os_wait_stats ORDER BY wait_time_ms desc,max_wait_time_ms desc
	select * from sys.dm_os_latch_stats ORDER BY wait_time_ms desc,max_wait_time_ms desc
 
   --Log increse and fill the disk 
 SELECT name 
		,db.log_reuse_wait_desc 
		,ls.cntr_value  AS size_kb 
		,lu.cntr_value AS used_kb 
		,CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)  
		 AS used_percent 
		,CASE WHEN CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT) > .5 THEN 
	   CASE 
	    /* tempdb special monitoring */ 
	    WHEN db.name = 'tempdb'  
	     AND log_reuse_wait_desc NOT IN ('CHECKPOINT', 'NOTHING') THEN 'WARNING'  
	    /* all other databases, monitor foor the 50% fill case */ 
	    WHEN db.name <> 'tempdb' THEN 'WARNING' 
	    ELSE 'OK' 
	    END 
	  ELSE 'OK' END 
	  AS log_status 
FROM sys.databases db 
JOIN sys.dm_os_performance_counters lu 
 ON db.name = lu.instance_name 
JOIN sys.dm_os_performance_counters ls 
 ON db.name = ls.instance_name 
WHERE lu.counter_name LIKE  'Log File(s) Used Size (KB)%' 
AND ls.counter_name LIKE 'Log File(s) Size (KB)%' 
AND name in ('Speed','tempdb')


 /********************************************************************************************************************************************************************************************************************************************************************/

 
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
WHERE (tsu.internal_objects_alloc_page_count+tsu.user_objects_alloc_page_count) > 0 AND es.session_id = 82
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
SELECT top 5 a.session_id, a.transaction_id, a.transaction_sequence_num, --a.elapsed_time_seconds,
b.program_name, b.open_tran, b.status,*
FROM sys.dm_tran_active_snapshot_database_transactions a
join sys.sysprocesses b
on a.session_id = b.spid
ORDER BY elapsed_time_seconds DESC

