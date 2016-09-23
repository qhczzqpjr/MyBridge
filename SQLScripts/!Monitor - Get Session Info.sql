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
		ElapsedTime = (CONVERT(VARCHAR(10),er.total_elapsed_time/3600000)+':'+
			RIGHT('00'+CONVERT(VARCHAR(2),(er.total_elapsed_time - ((er.total_elapsed_time/3600000)*3600000))/60000),2)+':'+
			RIGHT('00'+CONVERT(VARCHAR(2),(er.total_elapsed_time - (((er.total_elapsed_time)/60000)*60000)) /1000),2)),
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
WHERE   er.session_id > 50 --and er.last_wait_type='SOS_SCHEDULER_YIELD'
and ses.login_name ='speed_it' 
--and DB_Name(er.database_id) ='LP'

--group by g.name,er.last_wait_type 
ORDER BY er.blocking_session_id DESC ,
        er.session_id ,
        er.start_time 