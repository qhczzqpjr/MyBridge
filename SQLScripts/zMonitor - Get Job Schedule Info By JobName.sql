--Get Job Schedule Info By JobName
DECLARE @JobName NVARCHAR(50) = '%Chat%'

SELECT  sysjobs.name AS JobName,
        sysschedules.name AS ScheduleName ,
        next_run_date ,
        next_run_time
FROM    msdb.dbo.sysjobs(NOLOCK)
        JOIN msdb.dbo.sysjobschedules(NOLOCK) ON sysjobschedules.job_id = sysjobs.job_id
        JOIN msdb.dbo.sysschedules(NOLOCK) ON sysschedules.schedule_id = sysjobschedules.schedule_id
WHERE   sysjobs.name LIKE @JobName