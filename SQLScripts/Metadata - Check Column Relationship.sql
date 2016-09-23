Declare @tableName nvarchar(500) ='dbo.LP_CS'
	,@baseColName nvarchar(500) ='pool_name'
	,@refColName nvarchar(500) ='deal_name'
	,@sql nvarchar(max)

select @sql = 'SELECT COUNT('+@refColName+') '+@refColName+'_ct,'+@baseColName+'
FROM '+@tableName+' (NOLOCK)
GROUP BY '+@baseColName

exec sp_executesql @sql