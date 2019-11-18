-- This channel read the order files and store in the database
-- Version 1.0
function main()
   
   dbConnection = require("DBConnection")
   properties = require("properties")
   Validation = require("Validation")
   constants = require("Constants")
   
   properties.directory_path()
   constants.csos_order_header_size()
   constants.csos_order_details_size()
   
   log_file = getLogFile(output_log_path)
   
   if pcall(verifyAllDirectories) then
   
   -- Read the XML file from the Directory
   file_directory =io.popen([[dir "]]..input_directory_path..[[" /b]])
   
   for filename in file_directory:lines() do
    local order_file=input_directory_path..filename  
    
    -- This is the default value of the column ACTIVE_FLAG in the database   
    ACTIVE_FLG="YES"
    ROW_ADD_USER_ID="IGUANA USER"
    ROW_UPDATE_USER_ID="IGUANA USER"
    CSOS_ORD_HDR_NUM=1
      
    if(GetFileExtension(order_file) == '.xml') then
      log_file:write("The given file is xml file tested on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking   
     -- Open order file
     local open_order_file = io.open(order_file, "r")
     
     if not open_order_file then log_file:write("No able to open file .."..order_file.."\n") else
     -- Read order file
     local read_order_file =  open_order_file:read('*a')
     -- Close the file
     open_order_file:close()
     
     local order_data = xml.parse(read_order_file)  
         Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()
     
     -- Validation
     local order_data_validation_status = validationForOrderData(order_data)
         
     if(order_data_validation_status==true) then
        table=order_data.CSOSOrderRequest.CSOSOrder.Order
        ts=os.time()
    DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)
    
    dbConnection.connectdb() 
        local sql_csos_order_header = "CALL AddCSOSOrder ("..
       conn_dev:quote(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit:nodeText())..", "..
       conn_dev:quote(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText())..", "..
       conn_dev:quote(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText())..", ".. 
       conn_dev:quote(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText())..", "..
       conn_dev:quote(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText())..", "..
       conn_dev:quote(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText())..", "..
       conn_dev:quote(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText())..", "..
       conn_dev:quote(ACTIVE_FLG)..", "..
       conn_dev:quote( DATE_VALUE)..", "..
       conn_dev:quote(ROW_ADD_USER_ID)..", "..
       conn_dev:quote( DATE_VALUE)..", "..
       conn_dev:quote(ROW_UPDATE_USER_ID)..
   ")"

            sql_csos_order_status,sql_csos_order_error = conn_dev:execute{sql=sql_csos_order_header, live=true};
           conn_dev:execute{sql=sql_csos_order_header, live=true};
   local CSOS_ORD_HDR_NUM_UPDATE=conn_dev:query{sql='select max(CSOS_ORD_HDR_NUM) from csos_order_header', live=true};
          
            duplicate =tostring(CSOS_ORD_HDR_NUM_UPDATE[1]["max(CSOS_ORD_HDR_NUM)"])

            
  for i=1,Size_Of_NoOfLines do  
               
           local sql_csos_order_details = "CALL AddCSOSOrderdetails ("..
       conn_dev:quote(duplicate)..", "..
       conn_dev:quote(table[i].BuyerItemNumber:nodeText())..", "..
       conn_dev:quote(table[i].Form:nodeText())..", ".. 
       conn_dev:quote(table[i].LineNumber:nodeText())..", "..
       conn_dev:quote(table[i].NameOfItem:nodeText())..", "..
       conn_dev:quote(table[i].NationalDrugCode:nodeText())..", "..
       conn_dev:quote(table[i].QuantityOrdered:nodeText())..", "..
       conn_dev:quote(table[i].Schedule:nodeText())..", ".. 
       conn_dev:quote(table[i].SizeOfPackages:nodeText())..", ".. 
       conn_dev:quote(table[i].Strength:nodeText())..", ".. 
       conn_dev:quote(table[i].SupplierItemNumber:nodeText())..", "..  
       conn_dev:quote(ACTIVE_FLG)..", "..
       conn_dev:quote( DATE_VALUE)..", "..
       conn_dev:quote(ROW_ADD_USER_ID)..", "..
       conn_dev:quote( DATE_VALUE)..", "..
       conn_dev:quote(ROW_UPDATE_USER_ID)..
   ")"
   sql_csos_detail_status,sql_csos_detail_error = conn_dev:execute{sql=sql_csos_order_details, live=true};  
 end      
     
     log_file:write("Insertion is done on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
        
            if(sql_csos_order_status == nil and sql_csos_detail_status == nil)
     then
         os.rename(input_directory_path..filename, output_archived_path..filename)
               log_file:write("The given file is moved to archive folder on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
     else
         os.rename(input_directory_path..filename, output_error_path..filename)     
               log_file:write("The given file is moved to error folder on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
     end
       end -- end for validation       
    end -- end for unable to open file
    else
         log_file:write("The given file is not xml file on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
         os.rename(input_directory_path..filename, output_error_path..filename)   
         log_file:write("datatype Validation failed on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
         log_file:write("Insertion is not done on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
         log_file:write("The given file is moved to error folder on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
      end -- end for if condition checking whether file is xml or not      
   end --end for for loop
   else
      log_file:write("OrderFile, ArchiveFiles and ErrorFiles folders are not exists")
   end
end -- end for main function

-- Validating the file extenstion format
function GetFileExtension(url)
     return url:match("^.+(%..+)$")
end


function verifyAllDirectories()
   result_ArchivedDirectory_Status=os.fs.access(output_archived_path)     --checking directory exist status
   result_ErrorDirectory_Status=os.fs.access(output_error_path)        --checking directory exist status
   result_OrderFileDirectory_Status=os.fs.access(input_directory_path)     --checking directory oder file status
   
   --Validating the directories of ArchivedFiles and ErrorFiles
   if(result_ArchivedDirectory_Status==false)   then   -- checking for directory exist or not   
      log_file:write("Archive directory is missing on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking
      os.fs.mkdir(output_archived_path)                    
      log_file:write("Archive directory is created on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking
   end
   
   if(result_ErrorDirectory_Status==false)   then   -- checking for directory exist or not
      log_file:write("Error directory is missing on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking      
      os.fs.mkdir(output_error_path)
      log_file:write("Error directory is created on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking
   end
   
   if(result_OrderFileDirectory_Status==false)   then   -- checking for directory exist or not   
      log_file:write("Order files directory is not existes :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking
      os.fs.mkdir(input_directory_path)                    
      log_file:write("Order files directory is created on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking
   end
end
-- Get the log file

function getLogFile(output_log_path)
   result_LogFileDirectory_Status=os.fs.access(output_log_path)
   
   if(result_LogFileDirectory_Status==false) then   -- checking for directory exist or not
      os.fs.mkdir(output_log_path)
   end
   
   log_file_with_today_date = "logs_"..os.date("%m%d%Y")..".txt" --Today Date
   local log_file_verify=io.open(output_log_path..log_file_with_today_date,'r')
   
   if log_file_verify~=nil then
      io.close(log_file_verify)
      return io.open(output_log_path..log_file_with_today_date,'a+')
   else
      return io.open(output_log_path..log_file_with_today_date,'w')
   end
end

-- Validating the order data
function validationForOrderData(order_data)
   
   table=order_data.CSOSOrderRequest.CSOSOrder.Order
            print(table[1].LineNumber:nodeText(),table[2].LineNumber:nodeText())
   -- Validation for csos_order_header
   local validateion_status = false
   
   -- Task 1 : Write all the columns of csos_order_header and csos_order_details in the if condition
   if(Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate,PO_DATE)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber,PO_NUMBER)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber,SHIPTO_NUM)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit,BUSINESS_UNIT)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel, ORDER_CHANNEL)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber,UNIQUE_TRANS_NUM)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines,NO_OF_LINES))
  then
      
   for i=1,Size_Of_NoOfLines do

   if(Validation.validate_value(table[i].LineNumber,LINE_NUM)
      and Validation.validate_value(table[i].NameOfItem,NAME_OF_ITEM)
      and Validation.validate_value(table[i].NationalDrugCode,NATIONAL_DRUG_CDE)
      and Validation.validate_value(table[i].SizeOfPackages,SIZE_OF_PACKAGE)
      and Validation.validate_value(table[i].QuantityOrdered,QUANTITY)
      and Validation.validate_value(table[i].Strength,STRENGTH)
      and Validation.validate_value(table[i].Form,FORM)
      and Validation.validate_value(table[i].Schedule,DEA_SCHEDULE)
      and Validation.validate_value(table[i].SupplierItemNumber,SUPPLIER_ITEM_NUM)
      and Validation.validate_value(table[i].BuyerItemNumber,BUYER_ITEM_NUM))     
  then
      validateion_status = true
                  log_file:write("datatype Validation success on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
          end  
     end
     else
      validateion_status = false
                  log_file:write("datatype Validation failed on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
   end -- if condition end
   return validateion_status
end