/************************************************************************************************************
    Step1 :  Get Impacted tables by sp stp_LP_Loader_CACalc
*************************************************************************************************************/
SELECT DISTINCT
	referenced_entity_name
	--OBJECT_SCHEMA_NAME ( referencing_id ) AS referencing_schema_name,referencing_id,
 --   OBJECT_NAME(referencing_id) AS referencing_entity_name, 
 --   o.type_desc AS referencing_desciption, 
 --   COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id, 
 --   referencing_class_desc, referenced_class_desc,
 --   referenced_server_name, referenced_database_name, referenced_schema_name,
 --   referenced_entity_name, r.type_desc referenced_desciption,
 --   COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,
 --   is_caller_dependent, is_ambiguous
FROM sys.sql_expression_dependencies AS sed
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
INNER JOIN sys.objects AS r ON sed.referenced_id = r.object_id
WHERE referencing_id in (OBJECT_ID(N'dbo.stp_LP_Loader_CACalc'),OBJECT_ID('stp_LP_Loader_Advanced_Batch'),OBJECT_ID('stp_LP_Loader_UpdateCusipMappings'))
  AND r.type_desc ='USER_TABLE';

/************************************************************************************************************
    Step 2: Check table schema Info
*************************************************************************************************************/
SELECT TABLE_SCHEMA+'.'+TABLE_NAME, ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
       , IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA+'.'+TABLE_NAME IN 
(
	'dbo.LP_CACalc_Combined'
	,'dbo.LP_CACalc_Deal'
	,'dbo.LP_CACalc_Forborne'
	,'dbo.LP_CACalc_ForborneMethod1'
	,'dbo.LP_CACalc_ForborneMethod2'
	,'dbo.LP_CACalc_Reduced'
	,'dbo.LP_CACalc_V6_ForborneMethod1'
	,'dbo.LP_CACalc_V6_ForborneMethod2'
	,'dbo.LP_Collat'
	,'dbo.LP_Collat_History'
	,'dbo.LP_Collat_History'
	,'dbo.LP_CollateralAnalysis'
	,'dbo.LP_CollateralAnalysis_Adv'
	,'dbo.LP_CollateralAnalysis_calc'
	,'dbo.LP_CollateralAnalysis_tmp'
	,'dbo.LP_CollateralAnalysis_wac'
	,'dbo.LP_DealGroupMap'
	,'dbo.LP_LoanMod'
	,'dbo.LP_CS'
	,'dbo.LP_CusipMappings'
)

/************************************************************************************************************
    Step 3: Check table index Info
*************************************************************************************************************/
;WITH b AS
(SELECT 
	t.object_id
	,Schema_Name(t.schema_id) +'.'+t.name AS TableName
	,ind.index_id
	,ind.name AS IndexName
	,col.column_id
	,col.name AS ColumnName
FROM sys.indexes ind 
INNER JOIN
     sys.index_columns ic ON ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN
     sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN 
     sys.tables t ON ind.object_id = t.object_id 
--WHERE ind.name = 'PK_EDW_CMBS_DealLoanPrincipal'
)

SELECT
	TableName
	,IndexName
	,STUFF( (SELECT ', ' + col2.ColumnName
				FROM b col2 
				WHERE col2.object_id = b.object_id
				  AND col2.index_id = b.index_id
                ORDER BY col2.column_id
                FOR XML PATH('')), 1, 1, '') AS dependent_objects_list 
FROM b
where TableName IN (
'dbo.LP_CACalc_Combined'
,'dbo.LP_CACalc_Deal'
,'dbo.LP_CACalc_Forborne'
,'dbo.LP_CACalc_ForborneMethod1'
,'dbo.LP_CACalc_ForborneMethod2'
,'dbo.LP_CACalc_Reduced'
,'dbo.LP_CACalc_V6_ForborneMethod1'
,'dbo.LP_CACalc_V6_ForborneMethod2'
,'dbo.LP_Collat'
,'dbo.LP_Collat_History'
,'dbo.LP_Collat_History'
,'dbo.LP_CollateralAnalysis'
,'dbo.LP_CollateralAnalysis_Adv'
,'dbo.LP_CollateralAnalysis_calc'
,'dbo.LP_CollateralAnalysis_tmp'
,'dbo.LP_CollateralAnalysis_wac'
,'dbo.LP_DealGroupMap'
,'dbo.LP_LoanMod'
,'dbo.LP_CS'
,'dbo.LP_CusipMappings'
)
GROUP BY TableName
	,IndexName
	,b.object_id
	,index_id


/************************************************************************************************************
    Step 4: Check table space used and row count info
*************************************************************************************************************/
BEGIN try 
DECLARE @table_name VARCHAR(500) ; 
DECLARE @schema_name VARCHAR(500) ; 
DECLARE  @temp_table TABLE (    
        tablename sysname
,       row_count INT
,       reserved VARCHAR(50) collate database_default
,       data VARCHAR(50) collate database_default
,       index_size VARCHAR(50) collate database_default
,       unused VARCHAR(50) collate database_default 
,        row_id INT IDENTITY(1,1)
); 
DECLARE c1 CURSOR FOR 
SELECT t2.name + '.' + t1.name  
FROM sys.tables t1 
INNER JOIN sys.schemas t2 ON ( t1.schema_id = t2.schema_id );   

OPEN c1; 
FETCH NEXT FROM c1 INTO @table_name;
WHILE @@FETCH_STATUS = 0 
BEGIN  
        SET @table_name = REPLACE(@table_name, '[',''); 
        SET @table_name = REPLACE(@table_name, ']',''); 

        -- make sure the object exists before calling sp_spacedused
        IF EXISTS(SELECT OBJECT_ID FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(@table_name))
        BEGIN                
                INSERT INTO @temp_table EXEC sp_spaceused @table_name, false ;
                UPDATE @temp_table SET tablename = @table_name WHERE row_id =
                    (SELECT MAX(row_id) FROM @temp_table)
        END
        
        FETCH NEXT FROM c1 INTO @table_name; 
END; 
CLOSE c1; 
DEALLOCATE c1; 

SELECT tablename, row_count, reserved, data, index_size, unused
    FROM @temp_table 
	where TableName IN (
'dbo.LP_CACalc_Combined'
,'dbo.LP_CACalc_Deal'
,'dbo.LP_CACalc_Forborne'
,'dbo.LP_CACalc_ForborneMethod1'
,'dbo.LP_CACalc_ForborneMethod2'
,'dbo.LP_CACalc_Reduced'
,'dbo.LP_CACalc_V6_ForborneMethod1'
,'dbo.LP_CACalc_V6_ForborneMethod2'
,'dbo.LP_Collat'
,'dbo.LP_Collat_History'
,'dbo.LP_Collat_History'
,'dbo.LP_CollateralAnalysis'
,'dbo.LP_CollateralAnalysis_Adv'
,'dbo.LP_CollateralAnalysis_calc'
,'dbo.LP_CollateralAnalysis_tmp'
,'dbo.LP_CollateralAnalysis_wac'
,'dbo.LP_DealGroupMap'
,'dbo.LP_LoanMod'
,'dbo.LP_CS'
,'dbo.LP_CusipMappings'
)
	ORDER BY CONVERT(INT,REPLACE(data,'KB','')) DESC;

END try 
BEGIN catch 
SELECT -100 AS l1
,       ERROR_NUMBER() AS tablename
,       ERROR_SEVERITY() AS row_count
,       ERROR_STATE() AS reserved
,       ERROR_MESSAGE() AS data
,       1 AS index_size, 1 AS unused, 1 AS schemaname 
END catch

 
/************************************************************************************************************
    Step 5: Check acutal execution plan in sp
*************************************************************************************************************/
SET STATISTICS XML ON 
--SET STATISTICS PROFILE ON 
GO
exec speed.dbo.stp_LP_Loader_CACalc
GO
SET STATISTICS XML OFF
--SET STATISTICS PROFILE OFF 
 

