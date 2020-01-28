local ArcosSqlQueries = {}

function ArcosSqlQueries.export_schedule_item()

 exportScheduleItemsFromArcos = [[ SELECT * FROM ArcosMDB.dbo.ScheduleItems]]

end
   
return ArcosSqlQueries