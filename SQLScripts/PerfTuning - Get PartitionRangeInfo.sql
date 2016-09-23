DECLARE @TableName NVARCHAR(200) = N'Fact.ASDContactFormValues'
 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object]
	 ,i.name
     , p.partition_number AS [p#]
     , fg.name AS [filegroup]
     , p.rows
     , au.total_pages AS pages
     , CASE boundary_value_on_right
       WHEN 1 THEN 'less than'
       ELSE 'less than or equal to' END as comparison
     , rv.value
     , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
       SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
       CONVERT (INT, SUBSTRING (au.first_page, 4, 1) +
       SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) +
       SUBSTRING (au.first_page, 1, 1))) AS first_page
FROM sys.partitions p
INNER JOIN sys.indexes i
     ON p.object_id = i.object_id
AND p.index_id = i.index_id
INNER JOIN sys.objects o
     ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au
     ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps
     ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f
     ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds
     ON dds.partition_scheme_id = ps.data_space_id
     AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg
     ON dds.data_space_id = fg.data_space_id
LEFT OUTER JOIN sys.partition_range_values rv
     ON f.function_id = rv.function_id
     AND p.partition_number = rv.boundary_id
WHERE i.index_id < 2
     AND o.object_id = OBJECT_ID(@TableName);



--•object – The table name.
--•p# – The partition number.
--•filegroup – The filegroup the partition is located on. Note that in this result, I am using the same filegroup for all partitions, but usually you would probably not do this.
--•rows – Number of rows in the partition.
--•comparison – shows “less than” if you are using right range partitioning or “less than or equal to” if you are using left range partitioning.
--•value – The boundary point between the two partitions. This value is either in the right or left partition of the boundary point, depending on whether or not you are using right range or left range partitioning.
--•first_page – The first file:page allocated for the partition.