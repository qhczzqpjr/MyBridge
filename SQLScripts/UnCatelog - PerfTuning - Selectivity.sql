SELECT COUNT(DISTINCT e.SessionID) AS DistinctColValues,
COUNT(e.SessionID) AS NumberOfRows,
(CAST(COUNT(DISTINCT e.SessionID) AS DECIMAL)
/ CAST(COUNT(e.SessionID) AS DECIMAL)) AS Selectivity
FROM POCOnlineWindowsPhoneStagingB AS e ;