SELECT sj.name AS [Job Name], 
	sj.[description] AS [Job Description], 
	SUSER_SNAME(sj.owner_sid) AS [Job Owner],
	sj.date_created AS [Date Created], 
	sj.[enabled] AS [Job Enabled], 
	ss.[enabled] AS [Schedule Enabled], 
	sjs.next_run_date AS [Next Run Date], 
	sjs.next_run_time AS [Next Run Time]
FROM msdb.dbo.sysjobs AS sj 
	INNER JOIN msdb.dbo.syscategories AS sc ON sj.category_id = sc.category_id
	LEFT OUTER JOIN msdb.dbo.sysjobschedules AS sjs ON sj.job_id = sjs.job_id
	LEFT OUTER JOIN msdb.dbo.sysschedules AS ss ON sjs.schedule_id = ss.schedule_id
ORDER BY sj.date_modified desc;