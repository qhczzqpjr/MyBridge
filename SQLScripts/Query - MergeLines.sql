SELECT
	Comments
	,STUFF((
		SELECT ','+deal_id as [data()]
		FROM LP_Disabled_Deals b
		WHERE a.Comments = b.Comments
		FOR XML PATH ('')),1,1,''
	) as deal_lists
FROM LP_Disabled_Deals a
group by Comments
