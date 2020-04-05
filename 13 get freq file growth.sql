DECLARE @path NVARCHAR(1000)
SELECT @path = Substring(PATH, 1, Len(PATH) - Charindex('\', Reverse(PATH))) + '\log.trc'
	FROM sys.traces t
WHERE t.id = 1
-- id =1 means the active trace file
--select @path

SELECT ftg.DatabaseName AS [Database Name],
       te.name AS [Event name],
       ftg.StartTime AS [Time occurred]
FROM ::fn_trace_gettable(@path, 0) ftg
       INNER JOIN sys.trace_events te ON ftg.eventclass = trace_event_id
       INNER JOIN sys.trace_categories AS cat ON te.category_id = cat.category_id
WHERE te.name IN( 'Data File Auto Grow', 'Log File Auto Grow' )
ORDER BY DatabaseName,StartTime DESC;