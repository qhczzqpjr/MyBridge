--Version 1
WITH DepTree 
 AS 
(
    SELECT DISTINCT o.name, 
          o.[object_id] AS referenced_id , 
      o.name AS referenced_name, 
      o.[object_id] AS referencing_id, 
      o.name AS referencing_name,  
      0 AS NestLevel,
	  CONVERT(varchar(255),OBJECT_NAME(o.[object_id])) Sort
 FROM  sys.objects o JOIN sys.columns c
   ON o.[object_id] = c.[object_id]
    WHERE o.is_ms_shipped = 0 
	--AND c.name = 'Adv_Bal_Samp' --Column
	AND c.object_id = Object_id(N'LP_Collat') --Table
    UNION ALL
    
    SELECT  r.name, 
         d1.referenced_id,  
     OBJECT_NAME(d1.referenced_id) , 
     d1.referencing_id, 
     OBJECT_NAME( d1.referencing_id) , 
     NestLevel + 1,
	 CONVERT(varchar(255),RTRIM(Sort)+'  |    '+OBJECT_NAME(d1.referencing_id)) Sort
     FROM  sys.sql_expression_dependencies d1 
  JOIN DepTree r 
   ON d1.referenced_id =  r.referencing_id
)
 SELECT  --name AS parent_object_name, 
         --referenced_id, 
         --referenced_name, 
         --referencing_id, 
         --referencing_name, 
         --NestLevel,
		 Sort
  FROM DepTree t1 
  WHERE Sort like '%stp_LP_Loader_Advanced_Batch%'
 ORDER BY Len(sort) desc

 
--Version 2
;WITH T
AS
(
SELECT 
	sed.referenced_id referenced_id
	,CONVERT(varchar(255),OBJECT_NAME(sed.referencing_id)) refering_entity_name
	,sed.referenced_entity_name
	,r.type_desc
	, 1 lvl
	,CONVERT(varchar(255),OBJECT_NAME(sed.referencing_id)) Sort
FROM sys.sql_expression_dependencies AS sed
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
INNER JOIN sys.objects AS r ON sed.referenced_id = r.object_id
WHERE referencing_id = Object_id('dbo.OSCAR_Publish_Tables')
UNION ALL
SELECT 
	sed.referenced_id referencing_id
	,CONVERT(varchar(255), REPLICATE ('  |    ' , lvl)+ OBJECT_NAME(sed.referencing_id)) refering_entity_name
	,sed.referenced_entity_name 
	,r.type_desc
	,lvl+1  lvl
	,CONVERT(varchar(255),RTRIM(Sort)+'  |    '+OBJECT_NAME(sed.referencing_id)) Sort
FROM sys.sql_expression_dependencies AS sed
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
INNER JOIN sys.objects AS r ON sed.referenced_id = r.object_id
INNER JOIN T on t.referenced_id =sed.referencing_id and object_name(t.referenced_id) like 'stp%'
 )
 
 SELECT Schema_Name(t2.schema_id),referenced_entity_name,t.type_desc,lvl,Sort
 FROM T JOIN sys.objects t2 on t.referenced_id = t2.object_id
 ORDER BY Sort
 OPTION(MAXRECURSION 10)
