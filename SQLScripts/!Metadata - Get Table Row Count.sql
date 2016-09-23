/* 
 * This Sciprt is used to check table space used and row count info.
 * Provide the fullname (DB.Schema.Table) to the Values table part
 * Not Support Error handling in code, only throw expection
 */
BEGIN try 

DECLARE @temp_table TABLE (    
    tablename sysname
    ,row_count INT
    ,reserved VARCHAR(50) collate database_default
    ,data VARCHAR(50) collate database_default
    ,index_size VARCHAR(50) collate database_default
    ,unused VARCHAR(50) collate database_default 
    ,row_id INT IDENTITY(1,1)
); 


DECLARE c1 CURSOR FOR  
SELECT tablename
FROM (
VALUES ('Speed.dbo.LP_COLLAT' )
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
,('Speed.dbo.Ranks_DealRisk')
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
 ) data(tablename)
 
DECLARE @table_full_name VARCHAR(500) 
	,@db_name VARCHAR(500) 
	,@table_name VARCHAR(500)   


OPEN c1; 
FETCH NEXT FROM c1 INTO  @table_full_name;
WHILE @@FETCH_STATUS = 0 
BEGIN  
        SET @table_full_name = REPLACE(@table_full_name, '[',''); 
        SET @table_full_name = REPLACE(@table_full_name, ']',''); 
		set @db_name = LEFT(@table_full_name,CHARINDEX('.',@table_full_name,1)-1)
		set @table_name = SUBSTRING(@table_full_name,CHARINDEX('.',@table_full_name,1)+1,LEN(@table_full_name))
       
        IF OBJECT_ID(@table_full_name) is not null  -- make sure the object exists before calling sp_spacedused
        BEGIN                
		
                INSERT INTO @temp_table EXEC ('USE '+@db_name +' exec sp_spaceused '''+@table_name+''', false' )
                UPDATE @temp_table SET tablename = @table_full_name WHERE row_id =
                    (SELECT MAX(row_id) FROM @temp_table)
        END
        
        FETCH NEXT FROM c1 INTO @table_full_name; 
END; 
CLOSE c1; 
DEALLOCATE c1; 

SELECT tablename, row_count, reserved, data, index_size, unused
    FROM @temp_table 
	ORDER BY tablename;

END try 
BEGIN catch 
	CLOSE c1; 
	DEALLOCATE c1; 
SELECT -100 AS l1
	,ERROR_NUMBER() AS tablename
	,ERROR_SEVERITY() AS row_count
	,ERROR_STATE() AS reserved
	,ERROR_MESSAGE() AS data
	,1 AS index_size, 1 AS unused, 1 AS schemaname 
		
END catch