/*
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA+'.'+TABLE_NAME like '%dbo.Intex_Collat_Loans%'
*/

Declare @sql nvarchar(max) =''
SELECT @sql += ','+ QUOTENAME(COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA+'.'+TABLE_NAME = 'dbo.Intex_Collat_Loans'
select STUFF(@sql,1,1,'')