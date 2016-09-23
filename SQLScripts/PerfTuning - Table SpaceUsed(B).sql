/************************************************************************************************************
    Owner: Thomas Zhu
    Date: 2015-09-11
    Description:
        This script is used to generate space used by the tables
    Notes:
        1. Only works for objects in current database 
*************************************************************************************************************/
BEGIN try 
DECLARE @table_name VARCHAR(500) ; 
DECLARE @schema_name VARCHAR(500) ; 
DECLARE  @temp_table TABLE (    
        tablename sysname
,       row_count INT
,       reserved VARCHAR(50) collate database_default
,       data VARCHAR(50) collate database_default
,       index_size VARCHAR(50) collate database_default
,       unused VARCHAR(50) collate database_default 
,        row_id INT IDENTITY(1,1)
); 
DECLARE c1 CURSOR FOR 
SELECT t2.name + '.' + t1.name  
FROM sys.tables t1 
INNER JOIN sys.schemas t2 ON ( t1.schema_id = t2.schema_id );   

OPEN c1; 
FETCH NEXT FROM c1 INTO @table_name;
WHILE @@FETCH_STATUS = 0 
BEGIN  
        SET @table_name = REPLACE(@table_name, '[',''); 
        SET @table_name = REPLACE(@table_name, ']',''); 

        -- make sure the object exists before calling sp_spacedused
        IF EXISTS(SELECT OBJECT_ID FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(@table_name))
        BEGIN                
                INSERT INTO @temp_table EXEC sp_spaceused @table_name, false ;
                UPDATE @temp_table SET tablename = @table_name WHERE row_id =
                    (SELECT MAX(row_id) FROM @temp_table)
        END
        
        FETCH NEXT FROM c1 INTO @table_name; 
END; 
CLOSE c1; 
DEALLOCATE c1; 

SELECT tablename, row_count, reserved, data, index_size, unused
    FROM @temp_table ORDER BY CONVERT(INT,REPLACE(data,'KB','')) DESC;

END try 
BEGIN catch 
SELECT -100 AS l1
,       ERROR_NUMBER() AS tablename
,       ERROR_SEVERITY() AS row_count
,       ERROR_STATE() AS reserved
,       ERROR_MESSAGE() AS data
,       1 AS index_size, 1 AS unused, 1 AS schemaname 
END catch