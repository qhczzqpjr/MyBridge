exec [dbo].[usp_Util_TruncatePartition] 'QDump',201209290000,'Fact'


 SELECT * FROM sys.partitions
 WHERE OBJECT_NAME(OBJECT_ID)= 'QDump';

 SELECT t.object_id, t.name, p.partition_id, p.partition_number, p.rows FROM sys.partitions AS p
INNER JOIN sys.tables AS t  ON  p.object_id = t.object_id
WHERE p.partition_id IS NOT NULL AND t.name = 'QDump'   ORDER BY p.partition_number 
GO





SELECT psch.name as PartitionScheme,
prng.value AS ParitionValue,
prng.boundary_id AS BoundaryID
FROM sys.partition_functions AS pfun
INNER JOIN sys.partition_schemes psch ON pfun.function_id = psch.function_id
INNER JOIN sys.partition_range_values prng ON prng.function_id=pfun.function_id
WHERE pfun.name = 'Daily'


SELECT PartitionNo = $partition.Daily(FinalFateTimeID)
,min(FinalFateTimeID) , max(FinalFateTimeID)
FROM Fact.QDump 
GROUP BY $partition.Daily(FinalFateTimeID) 
ORDER BY $partition.Daily(FinalFateTimeID) 



select count(1) from fact.qdump -- 8433663







exec TRUNCATE_PARTITION 'Fact','QDump',1575


DECLARE @pkInfo table (SCHEMANAME VARCHAR(20),table_name varchar(100), pk_name varchar(100),columnName varchar(100), asckey char(1),IsUnique char(1))
 INSERT INTO @pkInfo 
 (SCHEMANAME, table_name,pk_name,columnName,asckey,IsUnique)
 SELECT 
 SCHEMANAME= 'Fact',
 B.NAME TABLE_NAME, 
 PK_NAME=
 (SELECT a.name PK_NAME FROM sys.indexes a 
 WHERE A.OBJECT_ID=B.OBJECT_ID AND A.index_id=1),
 COLUMN_NAME=
 (SELECT name FROM sys.columns E WHERE E.OBJECT_ID=B.object_id AND E.column_id=D.column_id),
 D.is_descending_key,
 C.is_unique
 FROM SYS.OBJECTS B 
 INNER JOIN sys.INDEXES C ON 
 B.object_id=C.object_id
 INNER JOIN sys.index_columns D ON
 B.object_id=D.object_id
 WHERE B.TYPE='U'
 AND (C.index_id=1)
 AND B.object_id=226151901

 select * from @pkInfo

  SELECt  OBJECT_ID('Fact.QDump') 


   SELECT 
*
 FROM SYS.OBJECTS B 
 INNER JOIN sys.INDEXES C ON 
 B.object_id=C.object_id
 INNER JOIN sys.index_columns D ON
 B.object_id=D.object_id
 WHERE B.TYPE='U'
 AND (C.index_id=1)
 AND B.object_id=226151901


 select rv.value ,*
 FROM sys.schemas s  
INNER JOIN sys.tables t  
ON t.schema_id=s.schema_id 
-- check table storage type 
INNER JOIN  sys.indexes i  
ON (i.object_id = t.object_id  
-- 0: heap 
-- 1: clusterd 
and i.index_id in (0,1)) 
INNER JOIN sys.partitions p 
ON p.object_id = i.object_id 
AND p.index_id = i.index_id 
INNER JOIN  sys.index_columns  ic  
ON (-- identify partioned column 
ic.partition_ordinal > 0  
and ic.index_id = i.index_id  
and ic.object_id = t.object_id) 
INNER JOIN  sys.columns c  
ON c.object_id = ic.object_id and c.column_id = ic.column_id 
INNER JOIN sys.system_internals_allocation_units au 
ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps 
ON ps.data_space_id = i.data_space_id 
INNER JOIN sys.partition_functions pf 
ON pf.function_id = ps.function_id and pf.name = 'Daily'
INNER JOIN sys.destination_data_spaces dds 
ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg 
ON dds.data_space_id = fg.data_space_id 
INNER JOIN sys.partition_range_values rv 
ON pf.function_id = rv.function_id AND p.partition_number = rv.boundary_id   
WHERE -- only look for heap or clustered index  
i.index_id IN (0, 1)   
AND s.name= 'Fact' 
AND t.name='QDump'
-- need exact match 
AND rv.value =201209290000 


select * from sys.partition_range_values rv 


select * from sys.partition_functions