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
   
    c=io.open(iguana.project.root()..'other/Log/Logfile_multiorders.txt','a+')
      d=c:read('*a')
   
      -- c=io.open("C:\\3PL_WO\\LogFiles\\Logfile.txt",'r+')   --log file creation
      -- d=c:read('*a')
   
   --Validating the directories of ArchivedFiles and ErrorFiles
   
   result_ArchivedDirectory_Status=os.fs.access(output_archived_path)     --checking directory exist status
   result_ErrorDirectory_Status=os.fs.access(output_error_path)        --checking directory exist status
      
   if(result_ArchivedDirectory_Status==false)   then   -- checking for directory exist or not   
      c:write("Archive directory is missing on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking
      os.fs.mkdir(output_archived_path)                    
      c:write("Archive directory is created on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking
   end
   
   if(result_ErrorDirectory_Status==false)   then   -- checking for directory exist or not
      c:write("Error directory is missing on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking      
      os.fs.mkdir(output_error_path)
      c:write("Error directory is created on :"..os.date('%x').." at :"..os.date('%X'),"\n") --checking
   end
   -- Read the XML file from the Directory
   
   file_directory =io.popen([[dir "]]..input_directory_path..[[" /b]])
   
   for filename in file_directory:lines() do
    local order_file=input_directory_path..filename  
   -- This is the default value of the column ACTIVE_FLAG in the database   
    ACTIVE_FLG="YES"
    ROW_ADD_USER_ID="IGUANA USER"
    ROW_UPDATE_USER_ID="IGUANA USER"
    CSOS_ORD_HDR_NUM=1
      
     
  --CSOS_ORD_HDR_NUM_UPDATE=''
    if(GetFileExtension(order_file) == '.xml') then
      c:write("The given file is xml file tested on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking   
     -- Open order file
     local open_order_file = io.open(order_file, "r")
     -- Read order file
     local read_order_file =  open_order_file:read('*a')
     -- Close the file
     open_order_file:close()
     
     local order_data = xml.parse(read_order_file)  
         Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()
         print(Size_Of_NoOfLines)
     -- Validation
     local order_data_validation_status = validationForOrderData(order_data)
         
     if(order_data_validation_status==true) then      
       
         
          table=order_data.CSOSOrderRequest.CSOSOrder.Order
            print(table[1].BuyerItemNumber:nodeText())
         
        ts=os.time()
DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)
    print(type(DATE_VALUE),DATE_VALUE)
            
             -- DATE_VALUE=tostring(os.date())   
        -- print(type(DATE_VALUE),DATE_VALUE)
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
     
     c:write("Insertion is done on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
        
            if(sql_csos_order_status == nil and sql_csos_detail_status == nil)
     then
         os.rename(input_directory_path..filename, output_archived_path..filename)
               c:write("The given file is moved to archive folder on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
     else
         os.rename(input_directory_path..filename, output_error_path..filename)     
               c:write("The given file is moved to error folder on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
     end      
           
   
       end -- end for validation       
    else
         c:write("The given file is not xml file on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
         os.rename(input_directory_path..filename, output_error_path..filename)   
         c:write("datatype Validation failed on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
         c:write("Insertion is not done on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
         c:write("The given file is moved to error folder on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
      end -- end for if condition checking whether file is xml or not      
    
   end --end for for loop
end -- end for main function

-- Validating the file extenstion format
function GetFileExtension(url)
     return url:match("^.+(%..+)$")
end

-- Validating the order data
function validationForOrderData(order_data)
   
   table=order_data.CSOSOrderRequest.CSOSOrder.Order
            print(table[1].LineNumber:nodeText(),table[2].LineNumber:nodeText())
   -- Validation for csos_order_header
   local validateion_status = false
   
   -- Task 1 : Write all the columns of csos_order_header and csos_order_details in the if condition
   if(Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText(),PO_DATE)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText(),PO_NUMBER)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText(),SHIPTO_NUM)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit:nodeText(),BUSINESS_UNIT)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText(), ORDER_CHANNEL)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText(),UNIQUE_TRANS_NUM)
      and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText(),NO_OF_LINES))
  then
      
      for i=1,Size_Of_NoOfLines do

   if(Validation.validate_value(table[i].LineNumber:nodeText(),LINE_NUM)
      and Validation.validate_value(table[i].NameOfItem:nodeText(),NAME_OF_ITEM)
      and Validation.validate_value(table[i].NationalDrugCode:nodeText(),NATIONAL_DRUG_CDE)
      and Validation.validate_value(table[i].SizeOfPackages:nodeText(),SIZE_OF_PACKAGE)
      and Validation.validate_value(table[i].QuantityOrdered:nodeText(),QUANTITY)
      and Validation.validate_value(table[i].Strength:nodeText(),STRENGTH)
      and Validation.validate_value(table[i].Form:nodeText(),FORM)
      and Validation.validate_value(table[i].Schedule:nodeText(),DEA_SCHEDULE)
      and Validation.validate_value(table[i].SupplierItemNumber:nodeText(),SUPPLIER_ITEM_NUM)
      and Validation.validate_value(table[i].BuyerItemNumber:nodeText(),BUYER_ITEM_NUM))
           
  then
             
      validateion_status = true
                  c:write("datatype Validation success on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
          end

          
     end
            
     else
      validateion_status = false
      
                  c:write("datatype Validation failed on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
      
   end -- if condition end
   
   return validateion_status

end
