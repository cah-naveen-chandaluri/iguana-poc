local Properties =  {}

dbConnection = require("DBConnection")    
dbConnection.connectdb()


function Properties.directory_path()    --directory paths for Order files,archive,error,log files
    output_log_path= "C:\\3PL_WO\\LogFiles\\"
end

function Properties.db_conn()
  -- conn = conn_stg
   conn = conn_dev
  
end

return Properties
