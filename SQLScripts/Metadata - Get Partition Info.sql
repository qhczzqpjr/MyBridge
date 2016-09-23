SELECT 
	sc.name AS PartitionScheme
	, fn.name AS PartitionFunction
	, fn.type
	,fn.type_desc
	,rv.boundary_id
	,rv.value
FROM sys.partition_range_values rv 
join sys.partition_functions fn
  on rv.function_id = fn.function_id
join sys.partition_schemes sc
  on fn.function_id = sc.function_id


  SELECT 
		PartitionNo = $partition.LP_History_Partition_Function(reported_date)
		,min(reported_date)
		,max(reported_date)
		,count(1) row_count
	FROM dbo.LP_Collat_History 
	GROUP BY $partition.LP_History_Partition_Function(reported_date) 
	ORDER BY $partition.LP_History_Partition_Function(reported_date) 