
--Read the current SQL Server ERRORLOG
EXEC master.dbo.xp_readerrorlog @p1=0;

--See if LPIM is configured on the service user
EXEC master.dbo.xp_readerrorlog 0, 1, "Using Locked Pages"

--filter on description
EXEC master.dbo.xp_readerrorlog 0, 1, "backup"

--filter further down
EXEC master.dbo.xp_readerrorlog 0, 1, "backup","log"

--filter with dates
EXEC master.dbo.xp_readerrorlog 0, 1, "backup",NULL, "2020-04-04", "2020-04-05"

/*
1. Value of error log file you want to read: 0 = current, 1 = Archive #1, 2 = Archive #2, etc... 
2. Log file type: 1 or NULL = error log, 2 = SQL Agent log 
3. Search string 1: String one you want to search for 
4. Search string 2: String two you want to search for to further refine the results 
5. Search from start time
6. Search to end time 
7. Sort order for results: N'asc' = ascending, N'desc' = descending
*/
