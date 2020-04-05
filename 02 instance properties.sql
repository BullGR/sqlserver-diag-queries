
--get the server name and the installation date of the instance
SELECT @@SERVERNAME AS [Server Name], 
	create_date AS [SQL Server Installation Date]
FROM sys.server_principals WITH (NOLOCK)
WHERE name = N'NT AUTHORITY\SYSTEM' 
	OR name = N'NT AUTHORITY\NETWORK SERVICE';
GO


-- for a complete list of properties check 
---https://docs.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql?view=sql-server-ver15
SELECT 
	SERVERPROPERTY('MachineName') AS [Machine Name], 
	SERVERPROPERTY('ServerName') AS [Server Name],  
	SERVERPROPERTY('InstanceName') AS [Instance], 
  CASE 
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '8%' THEN 'SQL2000'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '9%' THEN 'SQL2005'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '10.0%' THEN 'SQL2008'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '10.5%' THEN 'SQL2008R2'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '11%' THEN 'SQL2012'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '12%' THEN 'SQL2014'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '13%' THEN 'SQL2016'     
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '14%' THEN 'SQL2017' 
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '15%' THEN 'SQL2019' 
     ELSE 'UNKNOWN'
  END AS [SQL Version],
	SERVERPROPERTY('Edition') AS [Edition], 
	SERVERPROPERTY('ProductLevel') AS [Product Level], 
	SERVERPROPERTY('ProductVersion') AS [Product Version], 
	SERVERPROPERTY('Collation') AS [Collation],
	SERVERPROPERTY('IsIntegratedSecurityOnly') AS [IsIntegratedSecurityOnly];
GO

--"Node" and not "Manager" is important here when NUMA enabled host is investigated
SELECT @@SERVERNAME AS [Server Name], 
	RTRIM([object_name]) AS [Object Name], 
    instance_name AS [Instance Name], 
	cntr_value AS [Page Life Expectancy]
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE N'%Buffer Node%' AND counter_name = N'Page life expectancy'
GO

EXEC sp_configure 'show advanced options',1;
GO
RECONFIGURE;

SELECT * FROM sys.configurations;
GO

EXEC sp_configure 'show advanced options',0;
GO
RECONFIGURE;
GO