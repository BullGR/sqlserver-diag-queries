
--See the type of workload on your databases
--This defers from the reads/writes from the I/O subsystem

SELECT DB_NAME(ius.database_id) AS [Database Name],
	SUM(ius.user_seeks + ius.user_scans + ius.user_lookups) AS [Reads],
	CAST((CAST(SUM(ius.user_seeks + ius.user_scans + ius.user_lookups) AS FLOAT)
		/ SUM(ius.user_seeks + ius.user_scans + ius.user_lookups + ius.user_updates))*100 AS decimal(10,2)) AS [Reads %],
	SUM(ius.user_updates) AS [Writes],
	CAST((CAST(SUM(ius.user_updates) AS FLOAT)
		/ SUM(ius.user_seeks + ius.user_scans + ius.user_lookups + ius.user_updates))*100 AS decimal(10,2)) AS [Writes %],
	SUM(ius.user_seeks + ius.user_scans + ius.user_lookups + ius.user_updates) AS [Total Activity]
FROM sys.dm_db_index_usage_stats ius
GROUP BY DB_NAME(ius.database_id)
ORDER BY DB_NAME(ius.database_id);
