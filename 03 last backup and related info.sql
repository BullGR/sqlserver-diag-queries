
--Get information for the last SUCCESSFUL backup of each database 
SELECT ISNULL(d.[name], b.[database_name]) AS [Database], d.recovery_model_desc AS [Recovery Model], 
       d.log_reuse_wait_desc AS [Log Reuse Wait Desc],
    MAX(CASE WHEN [type] = 'D' THEN b.backup_finish_date ELSE NULL END) AS [Last Full Backup],
    MAX(CASE WHEN [type] = 'I' THEN b.backup_finish_date ELSE NULL END) AS [Last Differential Backup],
    MAX(CASE WHEN [type] = 'L' THEN b.backup_finish_date ELSE NULL END) AS [Last Log Backup],
	MAX(CASE WHEN [type] = 'F' THEN b.backup_finish_date ELSE NULL END) AS [Last Full-text Catalog Backup],
	MAX(CASE WHEN [type] = 'S' THEN b.backup_finish_date ELSE NULL END) AS [Last Memory Optimised File Backup]
FROM sys.databases AS d
	LEFT OUTER JOIN msdb.dbo.backupset AS b ON b.[database_name] = d.[name]
WHERE d.name <> N'tempdb' 
GROUP BY ISNULL(d.[name], b.[database_name]), d.recovery_model_desc, d.log_reuse_wait_desc, d.[name];
