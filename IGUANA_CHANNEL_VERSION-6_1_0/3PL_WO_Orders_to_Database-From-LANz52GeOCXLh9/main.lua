-- This channel read the order files and store in the database
-- Version 1.0
function main()
   dbConnection = require("DBConnection")
   
   -- Read the XML file from the Directory
   local url = "C:\\3PL_WO\\OrderFiles\\XMLdata.xml"
   
   if(GetFileExtension(url) == '.xml') then
   
     -- Open order file
     local open_order_file = io.open(url, "r")
     -- Read order file
     local read_order_file =  open_order_file:read('*a')
     -- Close the file
     open_order_file:close()
     
     local order_data = xml.parse(read_order_file)  
  
     print(order_data) 
  
     dbConnection.connectdb()
      
     -- Complete two SQL insert statements for csos_order_header and csos_order_details below.
     -- Task 1 : Read the values from the 'order_data' which has data from the xml and **validate the each value based on the column type
     -- Task 2 : Add the column names which attched in the excel sheet.  
     -- Task 3 : After validation insert the data into sql
	             --Note: For the last four columns use default values and current timestamp(take from the system timestamp)
                  --Column Name         Default Values
                  --ACTIVE_FLG	       NO
                  --ROW_ADD_STP	       CURRENT_TIMESTAMP
                  --ROW_ADD_USER_ID	    SYSTEM
                  --ROW_UPDATE_STP      CURRENT_TIMESTAMP
                  --ROW_UPDATE_USER_ID	 SYSTEM
       
      
       local sql_csos_order_header =
      
      
                         [[
                           INSERT INTO csos_order_header
                           (
                              
                           )
   VALUES
   (
   ]]..
      
   "'"..Msg.breakfast_menu:child("food", i)["name"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["price"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["description"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["calories"][1].."'".. 
   '\n   )'
   
local sql_csos_order_details =
      
      
                         [[
                           INSERT INTO csos_order_details
                           (
                              
                           )
   VALUES
   (
   ]]..
   "'"..Msg.breakfast_menu:child("food", i)["name"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["price"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["description"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["calories"][1].."'".. 
   '\n   )'
   

    -- Execute the sql statements   
    conn:execute{sql=sql_csos_order_header, live=true}
    conn:execute{sql=sql_csos_order_details, live=true}
    
      -- for testing select statement 
    cursor = conn:query([[ SELECT * FROM role_ref; ]])
   
   else
      print('File is not in the XML Format')
   end
   
end


-- Validating the file extenstion format
function GetFileExtension(url)
     return url:match("^.+(%..+)$")
end