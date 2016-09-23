	-- Lets consult our views once again:
	select *
		from sys.column_store_dictionaries;--type=3 string
	select *
		from sys.column_store_segments;-- cols*Segments = cs_Segments
	select *
		from sys.column_store_row_groups; --state = 3 COMPRESSED