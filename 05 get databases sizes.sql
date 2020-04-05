
--Get database files that have Percent growth type
SELECT
	DB_NAME(database_id) AS [Database Name],
	mf.name [File Name],
	growth AS [% Growth Found]
FROM sys.master_files mf
WHERE is_percent_growth = 1;

--Get database sizes and information if log is larger than data
SELECT DB_NAME(mf.database_id) AS [Database Name],
    SUM(CAST((mf.size * 8) AS FLOAT)/1024) AS [Size(MB)],
	SUM(CASE WHEN mf.type_desc='ROWS' THEN CAST((mf.size * 8) AS FLOAT)/1024 END) AS [Data Size(MB)],
	SUM(CASE WHEN mf.type_desc='LOG' THEN CAST((mf.size * 8) AS FLOAT)/1024 END) AS [Log Size(MB)],
	CASE WHEN SUM(CASE WHEN mf.type_desc='LOG' THEN CAST((mf.size * 8) AS FLOAT)/1024 END) > 
		SUM(CASE WHEN mf.type_desc='ROWS' THEN CAST((mf.size * 8) AS FLOAT)/1024 END) THEN 'Check the log file' END AS [Excessive Log]
FROM sys.master_files mf
GROUP BY DB_NAME(database_id);

--Get information on the capacity usage of the transaction log file
DBCC SQLPERF(LOGSPACE);

--Get how the database files are distributed on the volumes
SELECT DB_NAME(mf.database_id) AS [Database Name],
	type_desc AS [File Type],
    Physical_Name AS [Location]
FROM sys.master_files mf
ORDER BY DB_NAME(mf.database_id);