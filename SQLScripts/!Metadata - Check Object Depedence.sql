--Version 1
SELECT  DB_NAME() AS dbname, 
 o.type_desc AS referenced_object_type, 
 d1.referenced_entity_name, 
 d1.referenced_id, 
        STUFF( (SELECT ', ' + OBJECT_NAME(d2.referencing_id)
   FROM sys.sql_expression_dependencies d2
         WHERE d2.referenced_id = d1.referenced_id
                ORDER BY OBJECT_NAME(d2.referencing_id)
                FOR XML PATH('')), 1, 1, '') AS dependent_objects_list
FROM sys.sql_expression_dependencies  d1 JOIN sys.objects o 
  ON  d1.referenced_id = o.[object_id]
GROUP BY o.type_desc, d1.referenced_id, d1.referenced_entity_name
ORDER BY o.type_desc, d1.referenced_entity_name

--Version 2
SELECT OBJECT_SCHEMA_NAME ( referencing_id ) AS referencing_schema_name,referencing_id,
    OBJECT_NAME(referencing_id) AS referencing_entity_name, 
    o.type_desc AS referencing_desciption, 
    COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id, 
    referencing_class_desc, referenced_class_desc,
    referenced_server_name, referenced_database_name, referenced_schema_name,
    referenced_entity_name, r.type_desc referenced_desciption,
    COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,
    is_caller_dependent, is_ambiguous
FROM sys.sql_expression_dependencies AS sed
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
INNER JOIN sys.objects AS r ON sed.referenced_id = r.object_id
WHERE referencing_id= OBJECT_ID(N'dbo.LP_Load_XXXAggregates_ForLoanGroups_Extended');

