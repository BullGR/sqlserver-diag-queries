SELECT windows_release, 
	windows_service_pack_level, 
	windows_sku, 
	os_language_version
FROM sys.dm_os_windows_info;

/*
 Windows Release
 10.0 : Windows 10 / Windows Server 2016/2019
  6.3 : Windows 8.1 / Windows Server 2012 R2
  6.2 : Windows 8 / Windows Server 2012
  6.1 : Windows 7 / Windows Server 2008 R2
  6.0 : Windows Vista / Windows Server 2008
  5.2 : Windows XP / Windows Server 2003

 Windows SKU
  4 : Enterprise Edition
  7 : Standard Server Edition
  8 : Datacenter Server Edition
 10 : Enterprise Server Edition
 48 : Professional Edition

 OS Language 
 1033 : US-English
 
 more on the versions here https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions
*/


--Get information on the memory of the host
SELECT	system_memory_state_desc AS [System Memory State],
	total_physical_memory_kb/1024 AS [Physical Memory(MB)], 
	available_physical_memory_kb/1024 AS [Available Memory(MB)], 
	cast(((available_physical_memory_kb/1024.0)/(total_physical_memory_kb/1024.0))*100 AS decimal(5,2)) AS [Memory Free %],
    total_page_file_kb/1024 AS [Total Page File(MB)], 
	available_page_file_kb/1024 AS [Available Page File(MB)]
FROM sys.dm_os_sys_memory;


--Get information on the drives attached on the host of the current instance
SELECT DISTINCT vs.volume_mount_point AS [Mount Point], 
	vs.file_system_type AS [File System Type], 
	vs.logical_volume_name AS [Volume Name], 
	CAST(vs.total_bytes/1073741824.0 AS DECIMAL(18,2)) AS [Total Size(GB)],
	CAST(vs.available_bytes/1073741824.0 AS DECIMAL(18,2)) AS [Available Size(GB)],  
	CAST(CAST(vs.available_bytes AS FLOAT)/ CAST(vs.total_bytes AS FLOAT) AS DECIMAL(18,2)) * 100 AS [Space Free %] 
FROM sys.master_files AS mf 
	CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.[file_id]) AS vs;

--Get information on the SQL Server services running on the host of the current instance
SELECT servicename AS [Service Name],  
	process_id AS [Process ID], 
	startup_type_desc AS [Startup Type], 
	status_desc AS [Status], 
	last_startup_time AS [Last Startup],  
	service_account AS [Service Account], 
	is_clustered AS [Is Clustered], 
	cluster_nodename AS [Cluster Node Name], 
	[filename] AS [File Name],
	instant_file_initialization_enabled as [IFI enabled]
FROM sys.dm_server_services;

