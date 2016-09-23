
SELECT * FROM sys.indexes
SELECT * FROM sys.partitions
SELECT * FROM sys.allocation_units
--row-overflow varchar when >8060 
--IN_Row_data 
--LOB_data

--check fragment status
DBCC SHOWCONTIG ('Dim.URL','UX_URL_URLHashKey')
--
DBCC INDEXDEFRAG('DataWarehouse','Dim.URL','UX_URL_URLHashKey')
DBCC DBREINDEX ('Dim.URL','UX_URL_URLHashKey',0)

SELECT * FROM sys.dm_db_index_physical_stats(DB_ID('DataWarehouse'),Object_Id('Dim.URL'),NULL,NULL,'DETAILED')
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID('DataWarehouse'),Object_Id('Dim.URL'),NULL,NULL,'SAMPLE')
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID('DataWarehouse'),Object_Id('Dim.URL'),NULL,NULL,'LIMITED')

--DBCC IND ( { 'dbname' ~ dbid }, { 'objname' ~ objid },
--{ nonclustered indid ~ 1 ~ 0 ~ -1 ~ -2 } [, partition_number] )
DBCC IND (DataWarehouse,[Dim.URL],0)

--DBCC PAGE
DBCC TRACEON(3604);
DBCC TRACEOFF(3604);
GO
DBCC PAGE(8,1,1,1)



ALTER INDEX REORGANIZE
AUTO_SHRINK option with ALTER DATABASE
BACKUP DATABASE
CREATE INDEX
DBCC CHECKDB
DBCC CHECKFILEGROUP
DBCC CHECKTABLE
DBCC INDEXDEFRAG
DBCC SHRINKDATABASE
DBCC SHRINKFILE
KILL (Transact-SQL)
RESTORE DATABASE, 
UPDATE STATISTICS.
