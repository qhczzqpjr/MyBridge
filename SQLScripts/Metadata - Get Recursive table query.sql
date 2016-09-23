--Use CTE to convert value to multiple column
declare @t varchar(100) = '8,22,27,33,'

;with t(a,b)
as
(select substring(@t,1,CHARINDEX(',',@t,1)-1) a, CHARINDEX(',',@t,1) b
union all
select  substring(@t,1+b,CHARINDEX(',',@t,1+b)-b-1), CHARINDEX(',',@t,1+b) b
from t
where CHARINDEX(',',@t,1+b)-b>0
)

select * from t


;with cte (id,dest,subjectitem,source) as
(
  select id,dest,
    cast(left(source, charindex(',',source+',')-1) as varchar(50)) subjectitem,
         stuff(source, 1, charindex(',',source+','), '') source
  from TMS_Test
  union all
  select id,dest,
    cast(left(source, charindex(',',source+',')-1) as varchar(50)) subjectitem,
    stuff(source, 1, charindex(',',source+','), '') source
  from cte
  where source > ''
) 
select * into #x
from cte
order by id


SELECT T1.id,T1.dest,T2.my_Splits AS subjects
FROM
 (
  SELECT *,
  CAST('<X>'+replace(T.source,',','</X><X>')+'</X>' as XML) as my_Xml 
  FROM TMS_Test T
 ) T1
 CROSS APPLY
 ( 
 SELECT my_Data.D.value('.','varchar(50)') as my_Splits
 FROM T1.my_Xml.nodes('X') as my_Data(D)
 ) T2


