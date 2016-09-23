declare @curday char(8) = ''
		,@srctbl varchar(255) = 'CMBS.Intex_Collat_Loans'
--Get backup date
select @curday = CASE WHEN @curday='' THEN CONVERT(char(8),GETDATE(),112) ELSE @curday END 

--Copy table schema
select replace(
			replace(
				'select * into @srctbl_bak_@curday from @srctbl where 1=2'
			,'@srctbl',@srctbl)
		,'@curday',@curday)
UNION ALL
--Copy data
select replace(
			replace(
				'insert into @srctbl_bak_@curday WITH (TABLOCK) select * from @srctbl'
			,'@srctbl',@srctbl)
		,'@curday',@curday)
