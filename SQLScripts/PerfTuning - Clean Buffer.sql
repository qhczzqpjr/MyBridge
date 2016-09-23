--Simple query clean cache
DBCC DROPCLEANBUFFERS
--Warning, re_configure will be clean too
DBCC FREEPROCCACHE
DBCC FREEPROCCACHE WITH NO_INFOMSGS;
DBCC FREEPROCCACHE (0x060006001ECA270EC0215D05000000000000000000000000);
--Clean cache of current db	
DBCC FLUSHAUTHCACHE
--Clean cache of given db
select database_id from sys.databases
DBCC FLUSHPROCINDB(db_id)
--Clean default cache pool/store
SELECT * FROM sys.dm_resource_governor_resource_pools;
DBCC FREEPROCCACHE ('default');  

--Warning overview clean cache, used in test a set of queries ,  only in Test Environment
/*
CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS;
*/