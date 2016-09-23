SELECT
  [ps].[index_id],
  [Index] = [i].[name],
  [ps].[index_type_desc],
  [ps].[index_depth],
  [ps].[index_level],
  [ps].[page_count],
  [ps].[record_count]
FROM [sys].[dm_db_index_physical_stats](DB_ID(), 
  OBJECT_ID('AGY.[All_CusipAggregates]'), 22, NULL, 'DETAILED') AS [ps]
INNER JOIN [sys].[indexes] [i] 
  ON [ps].[index_id] = [i].[index_id] 
  AND [ps].[object_id] = [i].[object_id]; 