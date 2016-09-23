DECLARE @tablename nvarchar(200)=''

SELECT  schm.name ,
        tbl.name ,
        tbl.create_date ,
        tbl.modify_date
FROM    sys.tables tbl
        JOIN sys.schemas schm ON tbl.schema_id = schm.schema_id
WHERE schm.name+'.'+tbl.name = @tablename
ORDER BY create_date DESC