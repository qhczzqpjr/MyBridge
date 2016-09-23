sp_helptext 'MyProcedure'
GO
 
-- Use OBJECT_ID() function to get object id
SELECT    OBJECT_DEFINITION(OBJECT_ID('MyProcedure'))
GO
 
-- Use OBJECT_ID() function to get object id
SELECT    [definition]
FROM    sys.sql_modules
WHERE    object_id = OBJECT_ID('MyProcedure')
GO