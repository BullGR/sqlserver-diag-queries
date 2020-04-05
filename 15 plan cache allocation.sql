
--Check for Adhoc queries and cache plan bloating
SELECT objtype AS [Cache Type],
    COUNT(*) AS [Total Plans],
    SUM(CAST(size_in_bytes AS float)) / 1024 / 1024 AS [Total MBs],
    AVG(usecounts) AS [Avg Use Count],
    SUM(CAST((CASE WHEN usecounts = 1 THEN size_in_bytes ELSE 0 END) AS float)) / 1024 / 1024 AS [Total MBs – USE Count 1],
    SUM(CASE WHEN usecounts = 1 THEN 1 ELSE 0 END) AS [Total Plans – USE Count 1]
FROM sys.dm_exec_cached_plans
GROUP BY objtype
ORDER BY [Total MBs – USE Count 1] DESC
GO
