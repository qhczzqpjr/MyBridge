--Get Latest created job and time
 SELECT name
	,date_created
FROM msdb.dbo.sysjobs (NOLOCK)
where date_created = (select max(date_created) from msdb.dbo.sysjobs)