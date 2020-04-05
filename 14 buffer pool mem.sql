
--See the allocation of memory per database in the buffer pool
SELECT DB_NAME(database_id) AS [Database Name],
	COUNT(file_id) * 8/1024 AS [Buffer Size(MB)]
FROM sys.dm_os_buffer_descriptors
WHERE database_id <> 32767 -- ResourceDB
GROUP BY DB_NAME(database_id),database_id
ORDER BY [Buffer Size(MB)] DESC
GO

--In SQL 2019 it returns also information about pages in the BPE
