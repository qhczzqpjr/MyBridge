Declare @tableName nvarchar(500) ='dbo.LP_CS'
	,@ColName nvarchar(500) ='pool_name'
	,@sql nvarchar(max)

select @sql = 'SELECT 
	'''+@ColName+''' Col_Name
	,MIN(LEN('+@ColName+')) Min_Length
	,MAX(LEN('+@ColName+')) Max_Length
	
FROM '+@tableName+' a (NOLOCK)'

exec sp_executesql @sql


select @sql =
 'SELECT DISTINCT
	'''+@ColName+''' Col_Name
	,'+@ColName+' Col_Value
	,LEN('+@ColName+') Col_Length
 FROM '+@tableName+' a (NOLOCK)'

exec sp_executesql @sql