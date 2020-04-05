WITH CPU AS (
	SELECT DB_NAME(pa.DatabaseID) AS [Database Name],
		SUM(eqs.total_worker_time) AS [CPU Time(ms)]
	 FROM sys.dm_exec_query_stats eqs 
	 CROSS APPLY (SELECT CONVERT(INT, value) AS [DatabaseID] 
					FROM sys.dm_exec_plan_attributes(eqs.plan_handle)
						WHERE attribute = N'dbid') pa
		WHERE pa.DatabaseID <> 32767
	 GROUP BY pa.DatabaseID
)
 SELECT [Database Name], 
	[CPU Time(ms)], 
	CAST([CPU Time(ms)] * 1.0 / SUM([CPU Time(ms)]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPU Time %]
 FROM CPU
 ORDER BY [CPU Time(ms)] DESC;