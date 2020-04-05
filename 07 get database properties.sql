DROP TABLE IF EXISTS #T
GO

create table #T (property_name nvarchar(50), property_value sql_variant, dbname nvarchar(100));
GO

DECLARE curDBs CURSOR
READ_ONLY
FOR select name from sys.databases where name not in ('master', 'msdb', 'model','tempdb')

DECLARE @name varchar(40)
OPEN curDBs

FETCH NEXT FROM curDBs INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	begin
		set nocount on; 
		declare @database_id int, @fl1 varchar(max)='',@fl2 varchar(max)='',@q varchar(max)='';
    
		set @database_id=db_id(@name)
		SELECT 
				@fl1+='cast('+name+' as sql_variant) as '+name+','
			,   @fl2+=name+','
		FROM 
			sys.dm_exec_describe_first_result_set
			(
				N'SELECT * FROM sys.databases;', NULL, 0
			) AS f;
		set @q='insert into #T (property_name, property_value, dbname) select property_name , property_value, ''' + @name + ''' from ( select '+ left(@fl1,len(@fl1)-1) + ' from sys.databases where database_id='+cast(@database_id as varchar(20))+') as d unpivot ( property_value for property_name in ('+left(@fl2,len(@fl2)-1)+')) as u;'
		exec (@q);
end

	END
	FETCH NEXT FROM curDBs INTO @name
END

CLOSE curDBs
DEALLOCATE curDBs
GO

SELECT * from #T
GO