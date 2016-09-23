--Alter Table
  SELECT
	'ALTER TABLE '+
		quotename(Schema_Name(t.schema_id)) +'.'+quotename(OBJECT_NAME(c.object_id, DB_ID('AdventureWorksDW2014'))) -- DB_Id
		+' ALTER COLUMN '+quotename(c.name)+' '+ CASE WHEN type_name(system_type_id) = 'nvarchar' THEN CASE WHEN max_length=-1 THEN 'nvarchar(max)' ELSE concat(' nvarchar(',max_length/2,')') END 
												 WHEN type_name(system_type_id) = 'varchar' THEN CASE WHEN max_length=-1 THEN 'varchar(max)' ELSE concat(' nvarchar(',max_length,')') END  
												 WHEN type_name(system_type_id) = 'ntext' THEN 'ntext' 
												 WHEN type_name(system_type_id) = 'text' THEN 'text'
												 WHEN type_name(system_type_id) = 'nchar' THEN concat('nchar(',max_length/2,')')  
												 WHEN type_name(system_type_id) = 'char' THEN concat('char(',max_length,')')  
											ELSE NULL END+' COLLATE Latin1_General_CI_AS '
							 + CASE WHEN is_nullable =1 THEN 'NULL' ELSE 'NOT NULL' END
FROM [AdventureWorksDW2014].sys.columns AS c  -- DB_Id
  INNER JOIN [AdventureWorksDW2014].sys.tables AS t ON t.object_id = c.object_id  -- DB_Id
WHERE t.type = 'U'
  AND c.collation_name IS NOT NULL
 --AND c.collation_name !='SQL_Latin1_General_CP1_CI_AS'


 /*  2008
 --Alter Table
  SELECT
	'ALTER TABLE '+
		quotename(Schema_Name(t.schema_id)) +'.'+quotename(OBJECT_NAME(c.object_id, DB_ID('SPEED_MResearch'))) -- DB_Id
		+' ALTER COLUMN '+quotename(c.name)+' '+ CASE WHEN type_name(system_type_id) = 'nvarchar' THEN CASE WHEN max_length=-1 THEN 'nvarchar(max)' ELSE ' nvarchar('+CAST(max_length/2 AS varchar(50))+')' END 
												 WHEN type_name(system_type_id) = 'varchar' THEN CASE WHEN max_length=-1 THEN 'varchar(max)' ELSE ' nvarchar('+CAST(max_length AS varchar(50))+')' END  
												 WHEN type_name(system_type_id) = 'ntext' THEN 'ntext' 
												 WHEN type_name(system_type_id) = 'text' THEN 'text'
												 WHEN type_name(system_type_id) = 'nchar' THEN 'nchar('+CAST(max_length/2 AS varchar(50))+')' 
												 WHEN type_name(system_type_id) = 'char' THEN 'char('+CAST(max_length AS varchar(50))+')'
											ELSE NULL END+' COLLATE Latin1_General_CI_AS '
							 + CASE WHEN is_nullable =1 THEN 'NULL' ELSE 'NOT NULL' END
FROM SPEED_MResearch.sys.columns AS c  -- DB_Id
  INNER JOIN SPEED_MResearch.sys.tables AS t ON t.object_id = c.object_id  -- DB_Id
WHERE t.type = 'U'
  AND c.collation_name IS NOT NULL
  AND quotename(Schema_Name(t.schema_id)) +'.'+quotename(OBJECT_NAME(c.object_id, DB_ID('SPEED_MResearch'))) ='[dbo].[LP_LoanMod_Algo_Output]'
 --AND c.collation_name !='SQL_Latin1_General_CP1_CI_AS'

 */