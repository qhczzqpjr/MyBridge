-- =============================================
-- Example to execute the stored procedure
-- =============================================
DECLARE @sql NVARCHAR(max)=''

DECLARE <cur> CURSOR
FOR SELECT <col1>,<col2>... FROM <tablename>

OPEN <cur>

FETCH <cur> INTO @var1, @var2..

WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @sql = ''
	EXEC sp_executesql @sql

    FETCH NEXT FROM <cur> INTO @var1, @var2..
    PRINT 'put user defined code here'
END

CLOSE <cur>

DEALLOCATE <cur>
GO
 
