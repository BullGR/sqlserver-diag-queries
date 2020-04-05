DROP TABLE IF EXISTS #T3
GO

CREATE TABLE #T3(
	[DB_Name] [nvarchar](128) NULL,
	[FilegroupName] [nvarchar](128) NULL,
	[TableName] [sysname] NOT NULL,
	[SchemaName] [sysname] NULL,
	[RowCounts] [bigint] NULL,
	[IndexName] [sysname] NULL,
	[IndexType] [tinyint] NOT NULL,
	[TotalSpaceKB] [bigint] NULL,
	[UsedSpaceKB] [bigint] NULL,
	[UnusedSpaceKB] [bigint] NULL
) ON [PRIMARY]
GO

DECLARE @SQL nvarchar(2000)
DECLARE @DBName nvarchar(200)
DECLARE @name nVARCHAR(150) -- database name  
use master
SET NOCOUNT ON

DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb') 

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  

BEGIN   
SET @DBName= @name
SET @SQL = 'USE [' + @DBName + ']' + char(13) 
+ N'INSERT INTO #T3
	SELECT 
		DB_NAME(),
		FILEGROUP_NAME(a.data_space_id) FilegroupName
		,t.NAME AS TableName
		,s.Name AS SchemaName
		,p.rows AS RowCounts
		,i.name IndexName
		,i.type IndexType
		,SUM(a.total_pages) * 8 AS TotalSpaceKB
		--,CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceMB
		,SUM(a.used_pages) * 8 AS UsedSpaceKB
		--,CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceMB
		,(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
		--,CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceMB
	FROM 
		sys.tables t
	INNER JOIN      
		sys.indexes i ON t.OBJECT_ID = i.object_id
	INNER JOIN 
		sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
	INNER JOIN 
		sys.allocation_units a ON p.partition_id = a.container_id
	LEFT OUTER JOIN 
		sys.schemas s ON t.schema_id = s.schema_id
	WHERE 
		t.NAME NOT LIKE ''dt%''
		AND t.is_ms_shipped = 0
		AND i.OBJECT_ID > 255 
	GROUP BY 
		a.data_space_id, t.Name, s.Name, p.Rows, i.name, i.type';

EXEC sp_sqlexec @SQL
--PRINT @SQL

      FETCH NEXT FROM db_cursor INTO @name   
END  

CLOSE db_cursor   
DEALLOCATE db_cursor 
GO

SELECT * FROM #T3
GO