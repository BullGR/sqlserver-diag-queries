--get index stats info
DECLARE @db_id INT;    
SET @db_id = DB_ID(N'WideWorldImporters');  

SELECT DB_NAME(database_id) AS [Database Name], 
	object_name(object_id,@db_id) AS [Object Name], 
	CAST(avg_fragmentation_in_percent AS DECIMAL(5,2)) AS [Avg Fragmentation %], 
	page_count AS [Page Count]
FROM sys.dm_db_index_physical_stats(@db_id, NULL, NULL, NULL , 'SAMPLED')
where page_count>1000 and avg_fragmentation_in_percent>30;

