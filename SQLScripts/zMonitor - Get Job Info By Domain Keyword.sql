--Get job info by Domain Keyword
DECLARE @packageName nvarchar(500)= '%OpsMetrics%'
SELECT
    a.name as jobname,
    a.date_created,
    b.step_id,
    b.step_name,
    b.command as PackageName,
    b.last_run_date,
    b.last_run_outcome	 
FROM msdb.dbo.sysjobsteps b
JOIN msdb.dbo.sysjobs a 
  ON a.job_id=b.job_id
WHERE b.command like @packageName
