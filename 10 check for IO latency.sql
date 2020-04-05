SELECT	GETDATE() AS [Sample Time],
    CASE WHEN num_of_reads = 0 THEN 0 
		ELSE (io_stall_read_ms / num_of_reads) END AS [Read Latency],
    CASE WHEN [num_of_writes] = 0 THEN 0 
		ELSE (io_stall_write_ms / num_of_writes) END AS [Write Latency],
    CASE WHEN (num_of_reads = 0 AND num_of_writes = 0) THEN 0 
		ELSE (io_stall / (num_of_reads + num_of_writes)) END AS [Latency],
	vfs.num_of_reads AS [Total Reads],
	vfs.num_of_writes AS [Total Writes],
    LEFT (mf.physical_name, 3) AS [Drive],
    DB_NAME (vfs.database_id) AS [Database Name],
	mf.type_desc AS [File Type],
    mf.[physical_name] AS [File Name]
FROM sys.dm_io_virtual_file_stats (NULL,NULL) AS vfs
	INNER JOIN sys.master_files AS mf ON vfs.database_id = mf.database_id
    AND vfs.file_id = mf.file_id
ORDER BY [Latency] DESC
GO