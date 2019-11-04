-- This channel read the order files and store in the database
-- Version 1.0
function main()
   dbConnection = require("DBConnection")
   properties = require("properties")
   
   properties.directory_path()
   -- Read the XML file from the Directory
      file_directory =io.popen([[dir "]]..input_directory_path..[[" /b]])
 
    for filename in file_directory:lines() do
   -- Read the XML file from the Directory
   --local other_folder =iguana.project.root()..'other/XMLdata.xml'
    local order_file=input_directory_path..filename
  
   -- This is the default value of the column ACTIVE_FLAG in the database   
      ACTIVE_FLG="NO"
      ROW_ADD_USER_ID="SYSTEM"
      ROW_UPDATE_USER_ID="SYSTEM"
      CSOS_ORD_HDR_NUM=1
   
   
   if(GetFileExtension(order_file) == '.xml') then
   
     -- Open order file
     local open_order_file = io.open(order_file, "r")
     -- Read order file
     local read_order_file =  open_order_file:read('*a')
     -- Close the file
     open_order_file:close()
     
     local order_data = xml.parse(read_order_file)  
  
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
      "'"..CSOS_ORD_HDR_NUM.."',".. 
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
    conn_dev:execute{sql=sql_csos_order_header, live=true}
    conn_dev:execute{sql=sql_csos_order_details, live=true}
    
    -- for testing select statement 
    -- cursor = conn_dev:query([[ SELECT * FROM ; ]])
   else
      print('File is not in the XML Format')
   end -- end for if condition
   end -- end for for loop   
end -- end for main function

-- Validating the file extenstion format
function GetFileExtension(url)
     return url:match("^.+(%..+)$")
end