USE Speed
GO

CREATE TABLE dbo.LP_Collat_History_Achieve(
	loan_id char(6) COLLATE SQL_Latin1_General_CP1_CS_AS  NOT NULL ,
	reported_date date NOT NULL,
	int_rate decimal(6, 3) NULL,
	scheduled_pi money NULL,
	balance money NULL,
	ots char(1) NULL,
	mba char(1) NULL,
	xcpt char(1) NULL,
	loss_amt money NULL,
	last_int_p date NULL,
	totpmt_due money NULL,
	delinq_hist char(12) NULL,
	fc_start_d date NULL,
	fc_end_d date NULL,
	fc_end_typ char(1) NULL,
	payoff_d date NULL,
	payoff_r char(1) NULL,
	reo_date date NULL,
	inv_bal money NULL,
	next_int_r decimal(6, 3) NULL,
	net_rate decimal(7, 4) NULL,
	sch_princ money NULL,
	prev_ots char(1) NULL,
	prev_mba char(1) NULL,
	hpi_ratio float NULL,
	next_ots char(1) NULL,
	next_mba char(1) NULL,
	next_bal money NULL,
	create_date date NULL,
	last_change_date date NULL,
	Servicer smallint NULL,
	amt_advanced money NULL,
	cum_amt_advanced money NULL,
	last_delinq_dt date NULL
)

GO

CREATE UNIQUE CLUSTERED INDEX IX_LP_Collat_History__Achieve_ClusteredPartitioned ON dbo.lp_collat_history_Achieve
(
	loan_id ASC,
	reported_date ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON LP_History_Partition_Scheme(reported_date)
GO



GO
--DISABLE INDEXES
ALTER INDEX IX_LP_Collat_History_ClusteredPartitioned ON LP_Collat_History DISABLE
ALTER INDEX IX_LP_Collat_History_Date_ID ON  LP_Collat_History DISABLE
ALTER INDEX IX_LP_Collat_History_ReportedDate ON  LP_Collat_History DISABLE


/*
ALTER TABLE FACT.ExonyTermination_Call_Detail_Achieve REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE); 
*/
GO


--Partition Switch
/* discrete model
declare @t varchar(100) = '8,22,27,33,'

;with t(a,b)
as
(select substring(@t,1,CHARINDEX(',',@t,1)-1) a, CHARINDEX(',',@t,1) b
union all
select  substring(@t,1+b,CHARINDEX(',',@t,1+b)-b-1), CHARINDEX(',',@t,1+b) b
from t
where CHARINDEX(',',@t,1+b)-b>0
)

select replace('ALTER TABLE dbo.LP_Collat_History SWITCH PARTITION @n TO dbo.lp_collat_history_Achieve PARTITION @n','@n',a) from t
*/
 

/*Continuous model*/
DECLARE @PARNO INT;
SELECT  @PARNO =1485
	
WHILE @PARNO<= 1850
BEGIN
    TRUNCATE TABLE dbo.LP_Collat_History_Achieve;
	ALTER TABLE dbo.LP_Collat_History SWITCH PARTITION @PARNO TO dbo.LP_Collat_History_Achieve ;
	print @PARNO;
	select @PARNO = @PARNO+1
END
-------------------------------
ALTER INDEX IX_LP_Collat_History_ClusteredPartitioned ON LP_Collat_History REBUILD
ALTER INDEX IX_LP_Collat_History_Date_ID ON  LP_Collat_History REBUILD
ALTER INDEX IX_LP_Collat_History_ReportedDate ON  LP_Collat_History REBUILD

DROP TABLE dbo.LP_Collat_History_Achieve

/*
DECLARE @TableName NVARCHAR(200) = N'dbo.LP_Collat_History'
 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object]
	 ,i.name
     , p.partition_number AS [p#]
     , fg.name AS [filegroup]
     , p.rows
     , au.total_pages AS pages
     , CASE boundary_value_on_right
       WHEN 1 THEN 'less than'
       ELSE 'less than or equal to' END as comparison
     , rv.value
     , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
       SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
       CONVERT (INT, SUBSTRING (au.first_page, 4, 1) +
       SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) +
       SUBSTRING (au.first_page, 1, 1))) AS first_page
FROM sys.partitions p
INNER JOIN sys.indexes i
     ON p.object_id = i.object_id
AND p.index_id = i.index_id
INNER JOIN sys.objects o
     ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au
     ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps
     ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f
     ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds
     ON dds.partition_scheme_id = ps.data_space_id
     AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg
     ON dds.data_space_id = fg.data_space_id
LEFT OUTER JOIN sys.partition_range_values rv
     ON f.function_id = rv.function_id
     AND p.partition_number = rv.boundary_id
WHERE i.index_id < 2
     AND o.object_id = OBJECT_ID(@TableName);


*/