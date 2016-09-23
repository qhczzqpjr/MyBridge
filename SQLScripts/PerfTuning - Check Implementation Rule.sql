/*Undocument commands for optimiser control, warining for using in production*/
/*query hint for disable the rules*/

--Run before and after to check rules be applied to target query
SELECT * FROM sys.dm_exec_query_transformation_stats

--enable info return to console
DBCC TRACEON (3604);

DBCC RULEOFF('JNtoSM', 'JNtoHS');

DBCC RULEON('JNtoSM', 'JNtoHS');

/*
--Clean buff
DBCC FREEPROCCACHE 

SELECT  TOP (0)
        name,
        promise_total,
        promised,
        built_substitute,
        succeeded
INTO    #Snapshot
FROM    sys.dm_exec_query_transformation_stats;

-- Clear the snapshot
TRUNCATE TABLE #Snapshot;
 
-- Save a snapshot of the DMV
INSERT  #Snapshot 
        (
        name, 
        promise_total, 
        promised, 
        built_substitute, 
        succeeded
        )
SELECT  name, 
        promise_total,
        promised, 
        built_substitute, 
        succeeded
FROM    sys.dm_exec_query_transformation_stats
OPTION  (KEEPFIXED PLAN);
 
-- Query under test
-- Must use OPTION (RECOMPILE)
SELECT  P.ProductNumber, 
        P.ProductID, 
        total_qty = SUM(I.Quantity)
FROM    Production.Product P
JOIN    Production.ProductInventory I
        ON  I.ProductID = P.ProductID
WHERE   P.ProductNumber LIKE N'T%'
GROUP   BY
        P.ProductID,
        P.ProductNumber
OPTION  (RECOMPILE);
GO
-- Results
SELECT  QTS.name,
        promise = QTS.promised - S.promised,
        promise_value_avg = 
            CASE
                WHEN QTS.promised = S.promised
                    THEN 0
                ELSE
                    (QTS.promise_total - S.promise_total) /
                    (QTS.promised - S.promised)
            END,
        built = QTS.built_substitute - S.built_substitute,
        success = QTS.succeeded - S.succeeded
FROM    #Snapshot S
JOIN    sys.dm_exec_query_transformation_stats QTS
        ON QTS.name = S.name
WHERE   QTS.succeeded != S.succeeded
OPTION  (KEEPFIXED PLAN);

*/