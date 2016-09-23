--Get ExecutionID by JobName
WITH Base
AS
(SELECT  MAX(CASE WHEN ISNUMERIC(SUBSTRING(message,
                  CHARINDEX('Execution ID:', message) + LEN('Execution ID:'),
                  CHARINDEX('.', message,
                            CHARINDEX('Execution ID:', message)
                            + LEN('Execution ID:'))
                  - ( CHARINDEX('Execution ID:', message)
                      + LEN('Execution ID:') )))=1 THEN SUBSTRING(message,
                  CHARINDEX('Execution ID:', message) + LEN('Execution ID:'),
                  CHARINDEX('.', message,
                            CHARINDEX('Execution ID:', message)
                            + LEN('Execution ID:'))
                  - ( CHARINDEX('Execution ID:', message)
                      + LEN('Execution ID:') )) ELSE 0 END ) AS ExecutionID ,
         b.name
FROM    msdb.dbo.sysjobhistory (NOLOCK) a
JOIN msdb.dbo.sysjobs (NOLOCK) b
ON a.job_id = b.job_id
GROUP BY b.name)

SELECT * 
FROM Base
WHERE ExecutionID != 0
