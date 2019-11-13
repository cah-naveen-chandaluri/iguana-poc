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
   
    c=io.open(iguana.project.root()..'other/Log/Logfile_aaa.xml.txt','a+')
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
    ACTIVE_FLG="NO"
    ROW_ADD_USER_ID="SYSTEM"
    ROW_UPDATE_USER_ID="SYSTEM"
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
         
     -- Validation
     local order_data_validation_status = validationForOrderData(order_data)
         
     if(order_data_validation_status==true) then      
       
     dbConnection.connectdb()
        
     local sql_csos_order_header =
           [[
              INSERT INTO csos_order_header
                (
                   BUSINESS_UNIT,NO_OF_LINES,ORDER_CHANNEL,PO_DATE,PO_NUMBER,
                   SHIPTO_NUM,UNIQUE_TRANS_NUM,
                   ACTIVE_FLG,ROW_ADD_STP,ROW_ADD_USER_ID,ROW_UPDATE_STP,ROW_UPDATE_USER_ID
                )
   VALUES
   (
   ]]..
      
       --"'"..CSOS_ORD_HDR_NUM.."',"..
       "'"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText().."',".. 
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText().."',"..
       "\n   '"..ACTIVE_FLG.."',"..
       "\n   '"..os.date().."',"..
       "\n   '"..ROW_ADD_USER_ID.."',"..
       "\n   '"..os.date().."',"..
       "\n   '"..ROW_UPDATE_USER_ID.."'".. 
       '\n   )'
      
            sql_csos_order_status,sql_csos_order_error = conn_dev:execute{sql=sql_csos_order_header, live=true};
   local CSOS_ORD_HDR_NUM_UPDATE=conn_dev:query{sql='select max(CSOS_ORD_HDR_NUM) from csos_order_header', live=true};
            print(CSOS_ORD_HDR_NUM_UPDATE)
            
             
       local sql_csos_order_details =
                         [[
                           INSERT INTO csos_order_details
                           (
                            CSOS_ORD_HDR_NUM,
                            BUYER_ITEM_NUM,FORM,LINE_NUM,NAME_OF_ITEM,NATIONAL_DRUG_CDE,
                            QUANTITY,DEA_SCHEDULE,SIZE_OF_PACKAGE,STRENGTH,SUPPLIER_ITEM_NUM,
                            ACTIVE_FLG,ROW_ADD_STP,ROW_ADD_USER_ID,ROW_UPDATE_STP,ROW_UPDATE_USER_ID
                           )
      VALUES
      (
      ]]..
      --"'"..CSOS_ORD_DTL_NUM.."',"..
      "'"..CSOS_ORD_HDR_NUM_UPDATE[1]["max(CSOS_ORD_HDR_NUM)"].."',".. 
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.BuyerItemNumber:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Form:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.LineNumber:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NameOfItem:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NationalDrugCode:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.QuantityOrdered:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Schedule:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SizeOfPackages:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Strength:nodeText().."',"..
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SupplierItemNumber:nodeText().."',"..
      "\n   '"..ACTIVE_FLG.."',"..
      "\n   '"..os.date().."',"..
      "\n   '"..ROW_ADD_USER_ID.."',"..
      "\n   '"..os.date().."',"..  
      "\n   '"..ROW_UPDATE_USER_ID.."'".. 
      '\n   )'
   
    
        -- Execute the sql statements   
    
    sql_csos_detail_status,sql_csos_detail_error = conn_dev:execute{sql=sql_csos_order_details, live=true};     
    
            
            
                 c:write("Insertion is done on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
            
            
            
            
    -- conn_dev:execute{sql=  [[ CREATE PROCEDURE GetExecuteQueries
    -- AS 
    -- BEGIN
    -- Execute the sql statements   
    -- sql_csos_order_status,sql_csos_order_error = conn_dev:execute{sql=sql_csos_order_header, live=true};
    -- CSOS_ORD_HDR_NUM_UPDATE=conn_dev:query{sql='select max(CSOS_ORD_HDR_NUM) from csos_order_header', live=true};
            
    --sql_csos_detail_status,sql_csos_detail_error = conn_dev:execute{sql=sql_csos_order_details, live=true};
    -- END 
    -- ]],live=true           
    -- }

     --Sql = "CALL GetExecuteQueries"
    --trace(Sql)
    --conn:execute{sql=Sql, live=true}
         
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
  
   -- Validation for csos_order_header
   local validateion_status = false
   
   -- Task 1 : Write all the columns of csos_order_header and csos_order_details in the if condition
   if(Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit:nodeText(),BUSINESS_UNIT)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText(),NO_OF_LINES)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText(),ORDER_CHANNEL)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText(),PO_DATE)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText(),PO_NUMBER)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText(),SHIPTO_NUM)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText(),UNIQUE_TRANS_NUM)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.BuyerItemNumber:nodeText(),BUYER_ITEM_NUM)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Form:nodeText(),FORM)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.LineNumber:nodeText(),LINE_NUM)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NameOfItem:nodeText(),NAME_OF_ITEM)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NationalDrugCode:nodeText(),NATIONAL_DRUG_CDE)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.QuantityOrdered:nodeText(),QUANTITY)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Schedule:nodeText(),DEA_SCHEDULE)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SizeOfPackages:nodeText(),SIZE_OF_PACKAGE)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Strength:nodeText(),STRENGTH)
      and Validation.validate_value(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SupplierItemNumber:nodeText(),SUPPLIER_ITEM_NUM))
  then
      validateion_status = true
                  c:write("datatype Validation success on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
     else
      validateion_status = false
      
                  c:write("datatype Validation failed on :"..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
      
   end -- if condition end
   
   return validateion_status

end