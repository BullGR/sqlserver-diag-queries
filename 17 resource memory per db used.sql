
--Get the pages information from the buffer pool and the different states
WITH BP AS (
	SELECT 
		(CASE WHEN (bf.is_modified = 1) THEN 'Dirty' ELSE 'Clean' END) AS [Page State],
		DB_NAME (bf.database_id) AS [Database Name],
		COUNT (*) AS [Page Count],
		SUM(bf.row_count) AS [Total Rows]
	FROM sys.dm_os_buffer_descriptors bf
		WHERE bf.database_id <> 32767
	GROUP BY database_id, is_modified
)
SELECT [Page State],
	[Database Name],
	[Page Count],
	[Total Rows],
	CAST(CAST([Page Count] AS float) / sum([Page Count]) OVER()*100 AS DECIMAL(5,2)) AS [Pages % Overall]
FROM BP
ORDER BY [Page Count] DESC
GO
