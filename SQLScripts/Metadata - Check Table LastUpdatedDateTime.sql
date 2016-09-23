--Version 1
	 --Check Last updated datetime
	SELECT    
		DB_Name(database_id) AS DBName
		,OBJECT_NAME(ids.object_id) AS TableName
		,Schema_Name(o.schema_id) AS SchemaName
		,last_user_update
		,last_user_seek
		,last_user_scan
		,last_user_lookup
		,o.create_date
		,o.modify_date
	FROM    sys.dm_db_index_usage_stats ids
	JOIN sys.objects o
	  ON ids.object_id = o.object_id
	WHERE    database_id = DB_ID('Speed')
	--AND Schema_Name(o.schema_id) = 'DontUse'
	AND o.name = 'LP_DealAggregates_ForLoanGroups_Extended'

--Version 2

--Check Last updated datetime
SELECT    [TableName] = OBJECT_NAME(object_id),
last_user_update, last_user_seek, last_user_scan, last_user_lookup
FROM    sys.dm_db_index_usage_stats
WHERE    database_id = DB_ID('Staging')
AND        OBJECT_NAME(object_id) = 'MDM_QueueAttributes'

--Check last datetime in monitored table
SELECT MAX(ETLUpdatedDateTime) from DataWarehouse.Dim.MSGeography

--Check Schema updated datetime
SELECT    [TableName] = name,
create_date,
modify_date
FROM    sys.tables
WHERE    name = 'TransactionHistoryArchive'