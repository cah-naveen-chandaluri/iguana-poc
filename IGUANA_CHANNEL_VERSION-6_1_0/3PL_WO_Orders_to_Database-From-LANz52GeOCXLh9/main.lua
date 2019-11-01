-- This channel read the order files and store in the database
-- Version 1.0
function main()
   dbConnection = require("DBConnection")
   
   -- Read the XML file from the Directory
   local url =iguana.project.root()..'other/XMLdata.xml'
   --local url="C:\\3PL\\XMLdata.xml"
   c="NO"
   
   if(GetFileExtension(url) == '.xml') then
   
     -- Open order file
     local open_order_file = io.open(url, "r")
     -- Read order file
     local read_order_file =  open_order_file:read('*a')
     -- Close the file
     open_order_file:close()
     
     local order_data = xml.parse(read_order_file)  
print(order_data)
  print(os.time(),os.ts.time(),os.date(),os.date('%X'))
    
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
                             CSOS_ORD_HDR_NUM,
                             BUSINESS_UNIT,NO_OF_LINES,ORDER_CHANNEL,PO_DATE,PO_NUMBER,
                             SHIPTO_NUM,UNIQUE_TRANS_NUM,
                             ACTIVE_FLG,ROW_ADD_STP,ROW_ADD_USER_ID,ROW_UPDATE_STP,ROW_UPDATE_USER_ID
                           )
   VALUES
   (
   ]]..
      
       "'"..CSOS_ORD_HDR_NUM.."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText().."',".. 
      "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText().."',"..
       "\n   '"..order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText().."',"..
       "\n   '"..c.."',"..
       "\n   '"..os.date('%X').."',"..
       "\n   '"..os.date('%X').."',"..
       "\n   '"..os.date('%X').."',"..
       "\n   '"..os.date('%X').."'".. 
       '\n   )'
   
      
                      
      
      
      
      
local sql_csos_order_details =
      
      
                         [[
                           INSERT INTO csos_order_details
                           (
                            CSOS_ORD_DTL_NUM,CSOS_ORD_HDR_NUM,
                            BUYER_ITEM_NUM,FORM,LINE_NUM,NAME_OF_ITEM,NATIONAL_DRUG_CDE,
                            QUANTITY,DEA_SCHEDULE,SIZE_OF_PACKAGE,STRENGTH,SUPPLIER_ITEM_NUM,
                            ACTIVE_FLG,ROW_ADD_STP,ROW_ADD_USER_ID,ROW_UPDATE_STP,ROW_UPDATE_USER_ID
                           )
   VALUES
   (
   ]]..
      "'"..CSOS_ORD_DTL_NUM.."',"..
      "\n   '"..CSOS_ORD_HDR_NUM.."',".. 
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
      "\n   '"..c.."',"..
      "\n   '"..os.date('%X').."',"..
      "\n   '"..os.date('%X').."',"..
      "\n   '"..os.date('%X').."',"..  
      "\n   '"..os.date('%X').."'".. 
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