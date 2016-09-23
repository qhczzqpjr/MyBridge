DECLARE @tablename nvarchar(200) = N''
DECLARE @objectype char(2) = 'U'
DECLARE @sql nvarchar(max) = N''
DECLARE @ParmDefinition nvarchar(500)= N'@result bit output';
DECLARE @IsExist bit

SELECT @sql = 'IF OBJECT_ID('''+ @tablename+''','''+@objectype+''') IS NOT NULL'
    +CHAR(10)+ 'SET @result=1' 
    +CHAR(10)+ 'ELSE'
    +CHAR(10)+'SET @result=0'
	
EXEC sp_executesql @sql, @ParmDefinition,@result = @IsExist OUTPUT;

SELECT @IsExist