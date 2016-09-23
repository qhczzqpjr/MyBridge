/************************************************************************************************************
    Owner: Thomas Zhu
    Date: 2015-09-11
    Description:
        This script is used to generate the insert value to all the column the in table
        Support identity and non-identity
        Support column filter
    Notes:
        1. Only works for objects in current database 
        2. Next version can be implemented by dynamic query to support cross-db support
*************************************************************************************************************/
USE <DB>
GO

DECLARE @tableName NVARCHAR(200)= 'fact.incident' --<Schema>.<Table>
DECLARE @comma NVARCHAR(MAX) =''
DECLARE @IsIdentityColumnInculde bit =1
DECLARE @sql NVARCHAR(MAX) =''

        SELECT @sql += ',' + CHAR(10) + c.name
		    ,@comma += ',' + CHAR(10) + CASE WHEN ty.name IN ('smallint','tinyint','int','bigint') THEN CASE WHEN c.name LIKE '%ID%' THEN '-1' ELSE '0' END
			    WHEN ty.name IN ('nchar','nvarchar','ntext') THEN 'N'''''
			    WHEN ty.name IN ('char','varchar','text') THEN ''''''
			    WHEN ty.name IN ('datetime','datetime2') THEN 'GETUTCDATE()'
			    WHEN ty.name IN ('float','real','decimal','money') THEN '0.0'
			    WHEN ty.name IN ('uniqueidentifier') THEN	'00000000-0000-0000-0000-000000000000'
			    ELSE 'NULL'
		    END
        FROM  sys.tables t
                INNER JOIN sys.columns c 
                    ON t.object_id=c.object_id
                INNER JOIN sys.types ty
                    ON c.user_type_id = ty.system_type_id
        WHERE SCHEMA_NAME(t.schema_id)+'.'+t.name = @tableName
          AND ty.name!='timestamp'

IF EXISTS (SELECT is_identity FROM SYS.COLUMNS WHERE object_id = Object_id(@tableName) and is_identity = 1)
    BEGIN


            IF @IsIdentityColumnInculde = 1
                SELECT 
                    'SET IDENTITY_INSERT '+@tableName+' ON' + CHAR(10)
                    +'INSERT INTO '+ @tableName +'(' +STUFF(@sql,1,1,'')+')' + CHAR(10) 
                    +' Values'+ '('+ STUFF(@comma+')',1,1,'') + CHAR(10)
                    +'SET IDENTITY_INSERT '+@tableName+' OFF'  
            ELSE
                BEGIN
                    SELECT @sql += ',' + CHAR(10) + c.name
		                    ,@comma += ',' + CHAR(10) + CASE WHEN ty.name IN ('smallint','tinyint','int','bigint') THEN CASE WHEN c.name LIKE '%ID%' THEN '-1' ELSE '0' END
			                    WHEN ty.name IN ('nchar','nvarchar','ntext') THEN 'N'''''
			                    WHEN ty.name IN ('char','varchar','text') THEN ''''''
			                    WHEN ty.name IN ('datetime','datetime2') THEN 'GETUTCDATE()'
			                    WHEN ty.name IN ('float','real','decimal','money') THEN '0.0'
			                    WHEN ty.name IN ('uniqueidentifier') THEN	'00000000-0000-0000-0000-000000000000'
			                    ELSE 'NULL'
		                    END
                    FROM  sys.tables t
                            INNER JOIN sys.columns c 
                                ON t.object_id=c.object_id
                            INNER JOIN sys.types ty
                                ON c.user_type_id = ty.user_type_id
                    WHERE SCHEMA_NAME(t.schema_id)+'.'+t.name = @tableName
                      AND c.is_identity = 0
                      AND ty.name!='timestamp'

                    SELECT +'INSERT INTO '+ @tableName +'(' +STUFF(@sql,1,1,'')+')' + CHAR(10) 
                        +' Values'+ '('+ STUFF(@comma+')',1,1,'')
                END
    END      
ELSE
        SELECT +'INSERT INTO '+ @tableName +'(' +STUFF(@sql,1,1,'')+')' + CHAR(10) 
            +' Values'+ '('+ STUFF(@comma+')',1,1,'')
