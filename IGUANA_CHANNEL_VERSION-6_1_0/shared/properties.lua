local Properties =  {}

dbConnection = require("DBConnection")    
dbConnection.connectdb()


function Properties.directory_path()    --directory paths for Order files,archive,error,log files

    input_directory_path  = "C:\\3PL_WO\\OrderFiles\\"
    output_archived_path  = "C:\\3PL_WO\\ArchivedFiles\\"
    output_error_path = "C:\\3PL_WO\\ErrorFiles\\"
    output_log_path= "C:\\3PL_WO\\LogFiles\\"
end

function Properties.db_conn()
  conn = conn_dev
end

return Properties
