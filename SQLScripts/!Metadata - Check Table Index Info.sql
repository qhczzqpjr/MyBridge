SELECT    
    Schema_name(T.Schema_id)+'.'+T.name AS TableName,
	I.is_unique,   
    I.type_desc, 
    I.name AS IndexName,    
    KeyColumns,  
    IncludedColumns,  
    I.Filter_definition 
FROM sys.indexes I    
 JOIN sys.tables T ON T.Object_id = I.Object_id     
 JOIN sys.sysindexes SI ON I.Object_id = SI.id AND I.index_id = SI.indid    
 JOIN (SELECT * FROM (   
    SELECT IC2.object_id , IC2.index_id ,   
        STUFF((SELECT ' , ', C.name  AS [text()], CASE WHEN MAX(CONVERT(INT,IC1.is_descending_key)) = 1 THEN ' DESC' ELSE ' ASC' END 
    FROM sys.index_columns IC1   
    JOIN Sys.columns C    
       ON C.object_id = IC1.object_id    
       AND C.column_id = IC1.column_id    
       AND IC1.is_included_column = 0   
    WHERE IC1.object_id = IC2.object_id    
       AND IC1.index_id = IC2.index_id    
    GROUP BY IC1.object_id,C.name,index_id   
    ORDER BY MAX(IC1.key_ordinal)   
       FOR XML PATH('')), 1, 2, '') KeyColumns    
    FROM sys.index_columns IC2    
    --WHERE IC2.Object_id = object_id('Person.Address') --Comment for all tables   
    GROUP BY IC2.object_id ,IC2.index_id) tmp3 )tmp4    
  ON I.object_id = tmp4.object_id AND I.Index_id = tmp4.index_id   
 LEFT JOIN (SELECT * FROM (    
    SELECT IC2.object_id , IC2.index_id ,    
        STUFF((SELECT ' , ', C.name AS [text()]
    FROM sys.index_columns IC1    
    JOIN Sys.columns C     
       ON C.object_id = IC1.object_id     
       AND C.column_id = IC1.column_id     
       AND IC1.is_included_column = 1    
    WHERE IC1.object_id = IC2.object_id     
       AND IC1.index_id = IC2.index_id     
    GROUP BY IC1.object_id,C.name,index_id    
       FOR XML PATH('')), 1, 2, '') IncludedColumns     
   FROM sys.index_columns IC2     
   --WHERE IC2.Object_id = object_id('Person.Address') --Comment for all tables    
   GROUP BY IC2.object_id ,IC2.index_id) tmp1    
   WHERE IncludedColumns IS NOT NULL ) tmp2     
ON tmp2.object_id = I.object_id AND tmp2.index_id = I.index_id    
WHERE Schema_Name(t.schema_id)+'.'+t.name IN 
(
	'dbo.LP_ZipToIndexMapping'
	,'dbo.LP_ZipToIndexMapping_Tier12'
	,'dbo.OFHEO_ZipToIndexMapping'
	,'dbo.LP_HPI_State'
) --Comment for all tables  
--AND I.is_primary_key = 0 
--AND I.is_unique_constraint = 0  
AND I.is_unique = 1