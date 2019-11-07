-- This channel read the order files and store in the database
-- Version 1.0
function main()
   dbConnection = require("DBConnection")
   properties = require("properties")
    Validation = require("Validation")
   --Insertion=require("Insertion")
   
   
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

    --[[    newFile = io.open( "C:\\3PL_WO\\LogFiles\\Logfile.txt", "w+" )
	    newFile:write("fiel created on:-",os.date())
        newFile:write(iguana.logInfo(os.date()))
            
      
       
        newFile:close()
      ]]--
      
    
      
      
  
 
   if(GetFileExtension(order_file) == '.xml') then
   
     -- Open order file
     local open_order_file = io.open(order_file, "r")
     -- Read order file
     local read_order_file =  open_order_file:read('*a')
     -- Close the file
     open_order_file:close()
     
     local order_data = xml.parse(read_order_file)  
     print(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Form:nodeText())
         
         
         
         
         t={order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.BuyerItemNumber:nodeText(),order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Form:nodeText(),
order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.LineNumber:nodeText(),order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NameOfItem:nodeText(),
order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NationalDrugCode:nodeText(),order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.QuantityOrdered:nodeText(),
order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Schedule:nodeText(),order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SizeOfPackages:nodeText(),
order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Strength:nodeText(),order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SupplierItemNumber:nodeText(),
order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText(),order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText(),
order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText(),order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText(),
order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText(),order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText()
            }
      for i=1,#t do
      result_String=Validation.String(t[i])
            print(result_String)
         i=i+1 
      end
          print(result_String)
      
       --OR
         
         
         --validation for csos_order_details
         
         result_BuyerItemNumber=Validation.BuyerItemNumber(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.BuyerItemNumber:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.BuyerItemNumber:nodeText())
     print(result_BuyerItemNumber)    
         
          result_Form=Validation.Form(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Form:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Form:nodeText())
      print(result_Form)
         
          result_LineNumber=Validation.LineNumber(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.LineNumber:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.LineNumber:nodeText())
      print(result_LineNumber) 
                
         result_NameOfItem=Validation.NameOfItem(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NameOfItem:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NameOfItem:nodeText())
      print(result_NameOfItem)
         

         result_NationalDrugCode=Validation.NationalDrugCode(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NationalDrugCode:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.NationalDrugCode:nodeText())
      print(result_NationalDrugCode)
             
         result_QuantityOrdered=Validation.QuantityOrdered(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.QuantityOrdered:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.QuantityOrdered:nodeText())
      print(result_QuantityOrdered)
         
         
         result_Schedule=Validation.Schedule(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Schedule:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Schedule:nodeText())
      print(result_Schedule)
         
  
         result_SizeOfPackages=Validation.SizeOfPackages(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SizeOfPackages:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SizeOfPackages:nodeText())
      print(result_SizeOfPackages)

         result_Strength=Validation.Strength(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Strength:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.Strength:nodeText())
      print(result_Strength)
         

         result_SupplierItemNumber=Validation.SupplierItemNumber(order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SupplierItemNumber:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem.SupplierItemNumber:nodeText())
      print(result_SupplierItemNumber)
         

         --validation for csos_order_header
         
         
         result_BusinessUnit=Validation.BusinessUnit(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit:nodeText())
      print(result_BusinessUnit)
         
         result_NoOfLines=Validation.NoOfLines(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText())
      print(result_NoOfLines)
         
         result_OrderChannel=Validation.OrderChannel(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText())
      print(result_OrderChannel)
         
         result_PODate=Validation.PODate(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText())
      print(result_PODate)
         
         result_PONumber=Validation.PONumber(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText())
      print(result_PONumber)
         
         result_ShipToNumber=Validation.ShipToNumber(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText())
      print(result_ShipToNumber)
         
         result_UniqueTransactionNumber=Validation.UniqueTransactionNumber(order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText(),#order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText())
      print(result_UniqueTransactionNumber)
         
    
         
         
         if(result_BuyerItemNumber==true and result_Form==true  and result_LineNumber==true and result_NameOfItem==true and result_NationalDrugCode==true and result_QuantityOrdered==true and result_Schedule==true and result_SizeOfPackages==true and result_Strength==true and result_SupplierItemNumber==true and result_BusinessUnit and  result_NoOfLines and result_OrderChannel and result_PODate and result_PONumber and result_ShipToNumber and result_UniqueTransactionNumber ) then
         
     --  if(result_String==true and result_BusinessUnit==true) then
            
            
            
       --[[     result_ArchivedDirectory_Status=os.fs.access('C:\\3PL_WO\\ArchivedFiles\\')
            result_ErrorDirectory_Status=os.fs.access('C:\\3PL_WO\\ErrorFiles\\')
             result_LogDirectory_Status=os.fs.access('C:\\3PL_WO\\LogFiles\\')
            
            
            
            if(result_ArchivedDirectory_Status==true and result_ErrorDirectory_Status==true and result_LogDirectory_Status==true)   then
                
                   
            
                 else
                    os.fs.mkdir('C:\\3PL_WO\\ArchivedFiles\\')
                    os.fs.mkdir('C:\\3PL_WO\\ErrorFiles\\')
                     os.fs.mkdir('C:\\3PL_WO\\LogFiles\\')
      
                 end

            ]]--
             
            
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
      "'"..CSOS_ORD_HDR_NUM_UPDATE.."',".. 
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
   

            
       conn_dev:execute{sql=  [[ CREATE PROCEDURE ExecuteQueries
AS 
BEGIN
    -- Execute the sql statements   
    sql_csos_order_status,sql_csos_order_error = conn_dev:execute{sql=sql_csos_order_header, live=true};
             CSOS_ORD_HDR_NUM_UPDATE=conn_dev:query{sql='select max(CSOS_ORD_HDR_NUM) from csos_order_header', live=true};
            
    sql_csos_detail_status,sql_csos_detail_error = conn_dev:execute{sql=sql_csos_order_details, live=true};
  
END 
              ]],live=true
               
            }

              Sql = "CALL ExecuteQueries"
   trace(Sql)
   conn:execute{sql=Sql, live=true}
            
            
         
       
                        if(sql_csos_order_status == nil and sql_csos_detail_status == nil)
                             then
                                 os.rename(input_directory_path..filename, output_archived_path..filename)
                        else
                                 os.rename(input_directory_path..filename, output_error_path..filename)            
                        end
      
               
    else
         os.rename(input_directory_path..filename, output_error_path..filename)          
         print('File is not in the XML Format')
      end -- end for if condition checking whether file is xml or not

           
   end -- end for for loop 
      end --end for if condition for validation
end -- end for main function

-- Validating the file extenstion format
function GetFileExtension(url)
     return url:match("^.+(%..+)$")    
      

end