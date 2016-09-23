--Version 1
DECLARE @sql NVARCHAR(MAX)
DECLARE @columnName NVARCHAR(50) = ''
DECLARE @tableName NVARCHAR(50) = ''

SELECT  @sql = 'SELECT 
	 ' + @columnName + '
	,COUNT(1) 
FROM  ' + @tableName + ' (NOLOCK)
GROUP BY  ' + @columnName + '
HAVING COUNT(1) >=2'

EXEC sp_executesql @sql



--Version 2 - key word column check 
 declare @tablename nvarchar(50)='LP_Collat'
 ,@columnname nvarchar(50)='%net%'
 ,@sql nvarchar(max)=''
 
 SELECT @sql+= ','+COLUMN_NAME+CHAR(10) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME =@tablename AND COLUMN_NAME LIKE @columnname
 select ' SELECT DISTINCT'+CHAR(10)+STUFF(@sql,1,1,'') + ' FROM  (NOLOCK)'

 --Version 3
 SELECT 
	COUNT(DISTINCT loan_id)/COUNT(1)*1.0
FROM [dbo].[LP_Collat] a (NOLOCK)