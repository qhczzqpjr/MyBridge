/*
sp_spaceused [[ @objname = ] 'objname' ] 
[, [ @updateusage = ] 'updateusage' ] -- DBCC UPDATEUSAGE
[, [ @mode = ] 'mode' ]  --Stretch Databases; OLTP DB feature; 2014/2016
[, [ @oneresultset = ] oneresultset ] -- 2014/2016
*/
--EXEC sp_spaceused @objname='TEST.dbo.MyLog',@updateusage=N'false'



BEGIN try 
DECLARE @table_full_name VARCHAR(500) ; 
DECLARE @table_name VARCHAR(500) ; 
DECLARE @db_name VARCHAR(500) ; 
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
select 
	tablename
from 
(
VALUES ('Speed.dbo.LP_COLLAT' )  
) AS data (tablename)

OPEN c1; 
FETCH NEXT FROM c1 INTO @table_full_name;
WHILE @@FETCH_STATUS = 0 
BEGIN  
        SET @table_full_name = REPLACE(@table_full_name, '[',''); 
        SET @table_full_name = REPLACE(@table_full_name, ']',''); 
		set @db_name = LEFT(@table_full_name,CHARINDEX('.',@table_full_name,1)-1)
		set @table_name = SUBSTRING(@table_full_name,CHARINDEX('.',@table_full_name,1)+1,LEN(@table_full_name))
      
        IF OBJECT_ID(@table_full_name) is not null  -- make sure the object exists before calling sp_spacedused
        BEGIN                	
                INSERT INTO @temp_table EXEC ('USE '+@db_name +' exec sp_spaceused '''+@table_name+''', false' )
        END
        
        FETCH NEXT FROM c1 INTO @table_full_name; 

END; 
CLOSE c1; 
DEALLOCATE c1; 

SELECT tablename, row_count, reserved, data, index_size, unused
    FROM @temp_table 
	ORDER BY tablename;

END try 
BEGIN catch 
SELECT -100 AS l1
,       ERROR_NUMBER() AS tablename
,       ERROR_SEVERITY() AS row_count
,       ERROR_STATE() AS reserved
,       ERROR_MESSAGE() AS data
,       1 AS index_size, 1 AS unused, 1 AS schemaname 
END catch
 