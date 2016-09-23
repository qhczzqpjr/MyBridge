--Check is_auto_update_stats_async_on
SELECT is_auto_update_stats_async_on  
FROM sys.databases

--view statistics_update_date info
SELECT 
	name AS index_name 
    ,STATS_DATE(object_id, index_id) AS statistics_update_date
FROM sys.indexes 
where name like '%LP%'

--Check statistics step by step
select * from sys.sysindexes
exec sp_helpstats 'LP_Collat_History','ALL'
DBCC SHOW_STATISTICS(N'LP_Collat_History',IX_LP_Collat_History_Date_ID) WITH HISTOGRAM
DBCC SHOW_STATISTICS(N'LP_Collat_History',LP_Collat_History_idx1_hs)


--Create statistics
IF EXISTS (SELECT * FROM sys.stats
WHERE object_id = object_id('Sales.SalesOrderHeader')
AND name = 'ActNumberPONotNull')
DROP STATISTICS Sales.SalesOrderHeader.ActNumberPONotNull
GO
CREATE STATISTICS ActNumberPONotNull ON Sales.SalesOrderHeader (AccountNumber) WHERE PurchaseOrderNumber IS NOT NULL
GO
DBCC SHOW_STATISTICS(N'Sales.SalesOrderHeader', ActNumberPONotNull)


--view the statistics object permission required in PROD
SELECT sch.name + '.' + so.name AS TableName ,
	ss.name AS Statistic,
	sp.last_updated AS StatsLastUpdated ,
	sp.rows AS RowsInTable ,
	sp.rows_sampled AS RowsSampled ,
	sp.modification_counter AS RowModifications
FROM sys.stats ss
JOIN sys.objects so ON ss.object_id = so.object_id
JOIN sys.schemas sch ON so.schema_id = sch.schema_id
OUTER APPLY sys.dm_db_stats_properties(so.object_id, ss.stats_id) sp
WHERE so.type = 'U'
AND sp.modification_counter > 0

--update existing Statistics 
exec sp_updatestats

UPDATE STATISTICS SPEED_MResearch.dbo.mod_table_combined_unique

UPDATE STATISTICS dbo.mod_table_combined_unique IDX_mod_table_combined_unique_LOAN_ID;
UPDATE STATISTICS Production.Product(Products) WITH SAMPLE 50 PERCENT;
UPDATE STATISTICS Production.Product(Products) WITH FULLSCAN, NORECOMPUTE;

DBCC SHOW_STATISTICS ("SPEED_MResearch.dbo.mod_table_combined_unique", IDX_mod_table_combined_unique_LOAN_ID);



