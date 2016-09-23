USE msdb
;With PkSource AS 
(
SELECT 
      syj.name AS JobName
      ,REPLACE(substring(command,1,CHARINDEX('.dtsx',command)+4),'/ISSERVER "\"\','') AS Command
	  ,syj.*
FROM 
       msdb.dbo.sysjobs (NOLOCK) syj
       JOIN 
       [msdb].[dbo].[sysjobsteps]   (NOLOCK)sjs  ON syj.job_id = sjs.Job_id
WHERE subsystem ='SSIS' AND Enabled = 1 AND command LIKE '%SSISDB%' --AND Command like '%SharePoint%'
),
PkSource_Path AS
( 
SELECT 
      JobName 
      ,Command
      ,REVERSE( SUBSTRING( REVERSE(COMMAND),1,CHARINDEX( '\',REVERSE(COMMAND))-1)) AS PackageName  
from PkSource
)

SELECT 
      JobName
      ,REPLACE(COMMAND,'\'+PackageName,'') AS PackagePath
      ,SUBSTRING(REPLACE(REPLACE(COMMAND,'\'+PackageName,''),'SSISDB\',''),1,CHARINDEX('\',REPLACE(REPLACE(COMMAND,'\'+PackageName,''),'SSISDB\',''))-1) AS SSISDB_Folder
      ,REVERSE( SUBSTRING( REVERSE(REPLACE(COMMAND,'\'+PackageName,'') ),1,CHARINDEX( '\',REVERSE(REPLACE(COMMAND,'\'+PackageName,'') ))-1))  AS SSISDB_Folder_Project
      ,PackageName 
FROM PkSource_Path