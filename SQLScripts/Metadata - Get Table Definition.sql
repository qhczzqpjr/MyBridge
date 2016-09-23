/************************************************************************************************************
    Owner: Thomas Zhu
    Date: 2015-09-11
    Description:
        Copy Table Definition of a table
    Notes:
        1. Only works for objects in current database 
        2. Not fully tested
*************************************************************************************************************/
USE SPEED
GO

DECLARE @TableName NVARCHAR(50) = 'dbo.LP_Collat'
DECLARE @NewFullTableName NVARCHAR(50) = 'fact.incident'

DECLARE @Sql NVARCHAR(MAX)
DECLARE @PreSql NVARCHAR(MAX)

SELECT @PreSql = 'CREATE TABLE '+ @NewFullTableName+' (' +CHAR(10)

SELECT  @Sql = ISNULL(@Sql,'') + COLUMN_NAME + ' ' + DATA_TYPE
        + CASE WHEN DATA_TYPE IN ( 'nvarchar', 'varchar','char','nchar' )
               THEN ( CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '(MAX)'
                           ELSE ISNULL('('
                                       + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(10))
                                       + ')', '')
                      END )
               ELSE ''
          END + CASE WHEN DATA_TYPE = 'datetime2'
                     THEN ISNULL('('
                                 + CAST(DATETIME_PRECISION AS NVARCHAR(10))
                                 + ')', '')
                     ELSE ''
                END + CASE WHEN DATA_TYPE = 'decimal'
                           THEN ISNULL('('
                                       + CAST(NUMERIC_PRECISION AS NVARCHAR(10))
                                       + ','
                                       + CAST(NUMERIC_SCALE AS NVARCHAR(10))
                                       + ')', '11')
                           ELSE ''
                      END + CASE WHEN IS_NULLABLE = 'YES' THEN ' NULL,'
                                 ELSE ' NOT NULL,'
                            END + CHAR(10)
FROM    INFORMATION_SCHEMA.COLUMNS
WHERE   TABLE_SCHEMA+'.'+TABLE_NAME = @tableName

PRINT @PreSql + STUFF(@Sql,len(@sql)-1,1,')')

 
