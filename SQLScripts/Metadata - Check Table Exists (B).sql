/*
Get All tables which current login has permission to access
*/
BEGIN try 
DECLARE @table_name VARCHAR(500) ; 
DECLARE @db_name VARCHAR(500) ; 
DECLARE @sql NVARCHAR(max) ; 
IF OBJECT_ID('tempdb..#temp_table','U') IS NOT NULL
	DROP TABLE tempdb..#temp_table
CREATE TABLE #temp_table (    
        fulltablename varchar(2000)
); 

DECLARE c1 CURSOR FOR 
SELECT name FROM sys.databases

OPEN c1; 
FETCH NEXT FROM c1 INTO @db_name;
WHILE @@FETCH_STATUS = 0 
BEGIN  
        SET @db_name = REPLACE(@db_name, '[',''); 
        SET @db_name = REPLACE(@db_name, ']',''); 
		 
		SET @sql = REPLACE('select ''@db_name''+''.''+schema_name(schema_id)+''.''+ name FROM @db_name.sys.tables','@db_name',@db_name)
		
        
		IF has_dbaccess(@db_name) =1
		BEGIN
        INSERT INTO #temp_table EXEC SP_EXECUTESQL @sql
		END
        FETCH NEXT FROM c1 INTO @db_name; 
		
		 
END;  
CLOSE c1; 
DEALLOCATE c1; 

SELECT * FROM #temp_table;

END try 
BEGIN catch 
SELECT -100 AS l1
,       ERROR_NUMBER() AS tablename
,       ERROR_SEVERITY() AS row_count
,       ERROR_STATE() AS reserved
,       ERROR_MESSAGE() AS data
,       1 AS index_size, 1 AS unused, 1 AS schemaname 
END catch

--Check Table Exists
begin 
 ;WITH base (TableFullName)
 AS
 (
 select * from #temp_table
 )
 select data.tablename
	,CASE WHEN base.TableFullName IS NULL THEN 'No' Else 'YES' END AS IsExist
 from 
(
VALUES
('Speed.dbo.LP_COLLAT')
,('Speed.dbo.LP_CS')
,('Speed.dbo.LP_COLLAT_HISTORY_LAST')
,('Speed.dbo.LP_Aggregate_Mapped_Originator_Category_State')
,('Speed.dbo.LP_Aggregate_MSA_REO')
,('Speed.dbo.LP_Aggregate_OrigLoans_Mapped_Originator')
,('Speed.dbo.LP_Aggregate_Raw_Originator_Category_State')
,('Speed.dbo.LP_Aggregate_ZipCode')
,('Speed.dbo.LP_Aggregate_Raw_Servicer_Category_State')
,('Speed.dbo.LP_CusipAggregates_ForLoanGroups')
,('Speed.dbo.LP_CusipGroups')
,('Speed.dbo.LP_DEALAGGREGATES_FORLOANGROUPS')
,('Speed.dbo.LP_CusipAggregates')
,('Speed.dbo.LP_CusipDealIdMapping')
,('Speed.dbo.LP_CusipDealIdMappingwGroupID')
,('Speed.dbo.LP_CQSVCODE')
,('Speed.dbo.LP_IntexTrancheToLPDealMapping')
,('Speed.dbo.LP_Aggregate_LiveLoans_Raw_Originator')
,('Speed.dbo.LP_Aggregate_OrigLoans_Raw_Originator')
,('Speed.dbo.LP_Aggregate_LiveLoans_Raw_Servicer')
,('Speed.dbo.LP_Collat_HPI')
,('Speed.dbo.LP_DEALAGGREGATES')
,('Speed.dbo.Dictionary_StringMappingValues')
,('Speed.dbo.LP_Aggregate_County_REO')
,('Speed.dbo.LP_Aggregate_Deal_MSA_REO')
,('Speed.dbo.LP_Aggregate_LiveLoans_Mapped_Originator')
,('Speed.dbo.LP_Aggregate_LiveLoans_Mapped_Servicer')
,('Speed.dbo.LP_GroupAggregates')
,('Speed.dbo.LP_GROUPAGGREGATES_FORLOANGROUPS')
,('Speed_MResearch.dbo.LP_LOANMOD_ALGO_OUTPUT')
,('Speed_MResearch.dbo.MOD_TABLE_ALGO')
,('Speed_MResearch.dbo.MOD_TABLE_COMBINED')
,('Speed_MResearch.dbo.MR_LOANMOD_DATA_TEMP2')
,('Speed_MResearch.dbo.MOD_TABLE_COMBINED_UNIQUE')
,('Speed_MResearch.dbo.MOD_TABLE_COMBINED_UNIQUE_OLD')
,('Speed_MResearch.dbo.MR_SERVADV_DATA')
,('ABSDB.dbo.Ranks_DealRisk')
,('Speed.dbo.LP_Collat_HISTORY')
,('Speed.dbo.LP_Collat_History_Postpayoff')
 ) data (tablename)
 LEFT JOIN base 
   ON data.tablename = base.TableFullName
end