-- This channel read the order files and store in the database
-- Version 1.0
function main()

    properties = require("properties")
    Validation = require("Validation")
    constants = require("Constants")

    properties.directory_path()
    properties.db_conn()
    constants.csos_order_header_size()
    constants.csos_order_details_size()
    constants.log_statements()
    constants.query_constants()
    constants.frequently_constants()

    log_file = getLogFile(output_log_path)
    log_file:write(TIME_STAMP.."******* Iguana channel Started Running *******","\n")

    if pcall(verifyAllDirectories) then    
        -- Read the XML file from the Directory
        file_directory =io.popen([[dir "]]..input_directory_path..[[" /b]])
        -- Read order files 
        for filename in file_directory:lines() do
            order_file=input_directory_path..filename
         
            -- This is the default value of the column ACTIVE_FLAG in the database
            ACTIVE_FLG=active_flg_val
            ROW_ADD_USER_ID=user
            ROW_UPDATE_USER_ID=user

            if(GetFileExtension(order_file) == '.xml') then -- Validation file extension
                log_file:write(TIME_STAMP..filename..":"..XML_FILE_TEST_SUCCESS,"\n")  --checking
                -- Open order file
                open_order_file = io.open(order_file, "r")

                if not open_order_file then log_file:write(TIME_STAMP..UNABLE_OPEN_FILE..order_file,"\n") else
                    -- Read order file
                    read_order_file =  open_order_file:read('*a')
                    -- Close the file
                    open_order_file:close()
                    if pcall(Parser) then
                     
                    local order_data = Parser()
                    local order_data_validation_status = validationForOrderData(order_data)
                    if(order_data_validation_status==true) then -- order validation if condition
                            Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()
                            SIZE_OF_ORDERITEM=order_data.CSOSOrderRequest.CSOSOrder.Order:childCount("OrderItem")
                    
                            tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
                            tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order

                            ts=os.time()
                            DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)
                                if pcall(Verify_DBConn) then                                    
                                    if pcall(Insertion) then
                                        log_file:write(TIME_STAMP..filename..":"..INSERT_SUCCESS,"\n")   --checking
                                        os.rename(input_directory_path..filename, output_archived_path..filename)
                                        log_file:write(TIME_STAMP..filename..":"..ARC_DIR_MOV,"\n")  --checking
                                    else
                                        os.rename(input_directory_path..filename, output_error_path..filename)
                                        log_file:write(TIME_STAMP..filename..":"..ERR_DIR_MOV,"\n")  --checking
                                        log_file:write(TIME_STAMP.."Insertion is not done on","\n")
                                    end
                                else
                                    log_file:write(TIME_STAMP.."Database connection  is not exist","\n")
	                                 os.rename(input_directory_path..filename, output_error_path..filename)
                                    log_file:write(TIME_STAMP..filename..":"..ERR_DIR_MOV,"\n")  --checking
                                end
                       else
                            os.rename(input_directory_path..filename, output_error_path..filename)
                            log_file:write(TIME_STAMP..DATA_VALIDATION_FAIL..filename..":"..ERR_DIR_MOV,"\n")  --checking
                       end -- end for validation                   
                     else
                        log_file:write(TIME_STAMP.."xml parsing is not done on","\n")
                    end
                end -- end for unable to open file
            else -- else for validation file extension
                log_file:write(TIME_STAMP..filename..":"..XML_FILE_TEST_FAIL,"\n")  --checking
                os.rename(input_directory_path..filename, output_error_path..filename)
            end -- end for if condition checking whether file is xml or not
        end --end for for loop

    else
        log_file:write(TIME_STAMP.."OrderFile, ArchiveFiles and ErrorFiles folders are not exists")
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
        log_file:write(TIME_STAMP..ARC_DIR_MISS,"\n") --checking
        os.fs.mkdir(output_archived_path)
        log_file:write(TIME_STAMP..ARC_DIR_CREATE,"\n") --checking
    end

    if(result_ErrorDirectory_Status==false)   then   -- checking for directory exist or not
        log_file:write(TIME_STAMP..ERR_DIR_MISS,"\n") --checking
        os.fs.mkdir(output_error_path)
        log_file:write(TIME_STAMP..ERR_DIR_CREATE,"\n") --checking
    end

    if(result_OrderFileDirectory_Status==false)   then   -- checking for directory exist or not
        log_file:write(TIME_STAMP..ORD_DIR_MISS,"\n") --checking
        os.fs.mkdir(input_directory_path)
        log_file:write(TIME_STAMP..ORD_DIR_CREATE,"\n") --checking
    end
end

function Parser()
     return xml.parse(read_order_file)
end

function Verify_DBConn()
    return conn:check()
end

function Insertion()
    insertion_status = false
    conn:execute{sql=[[START TRANSACTION;]] ,live=true};

    sql_csos_order_header = "CALL AddCSOSOrder("..
        conn:quote(tag_OrderSummary.BusinessUnit:nodeText())..", "..
        conn:quote(tag_OrderSummary.NoOfLines:nodeText())..", "..
        conn:quote(tag_OrderSummary.OrderChannel:nodeText())..", "..
        conn:quote(tag_OrderSummary.PODate:nodeText())..", "..
        conn:quote(tag_OrderSummary.PONumber:nodeText())..", "..
        conn:quote(tag_OrderSummary.ShipToNumber:nodeText())..", "..
        conn:quote(tag_OrderSummary.UniqueTransactionNumber:nodeText())..", "..
        conn:quote(ACTIVE_FLG)..", "..
        conn:quote( DATE_VALUE)..", "..
        conn:quote(ROW_ADD_USER_ID)..", "..
        conn:quote( DATE_VALUE)..", "..
        conn:quote(ROW_UPDATE_USER_ID)..
        ")"
    sql_csos_order_header_status = conn:execute{sql=sql_csos_order_header, live=true};
    
    if(sql_csos_order_header_status == nil) then -- verifying the header inserted or not
       CSOS_ORD_HDR_NUM_UPDATE=conn:query{sql=SEL_HEAD_MAX, live=true};
       CSOS_ORD_HDR_NUM_UPDATE_VAL=tostring(CSOS_ORD_HDR_NUM_UPDATE[1]["max(CSOS_ORD_HDR_NUM)"])
       insertion_status = true
    else
       insertion_status = false
    end
    if(tonumber(CSOS_ORD_HDR_NUM_UPDATE_VAL)>=0 and insertion_status == true) then
    sql_csos_detail_status = nil
    for i=1,Size_Of_NoOfLines do
        if(insertion_status == true) then
        sql_csos_order_details = "CALL AddCSOSOrderdetails ("..
            conn:quote(CSOS_ORD_HDR_NUM_UPDATE_VAL)..", "..
            conn:quote(tag_order[i].BuyerItemNumber:nodeText())..", "..
            conn:quote(tag_order[i].Form:nodeText())..", "..
            conn:quote(tag_order[i].LineNumber:nodeText())..", "..
            conn:quote(tag_order[i].NameOfItem:nodeText())..", "..
            conn:quote(tag_order[i].NationalDrugCode:nodeText())..", "..
            conn:quote(tag_order[i].QuantityOrdered:nodeText())..", "..
            conn:quote(tag_order[i].Schedule:nodeText())..", "..
            conn:quote(tag_order[i].SizeOfPackages:nodeText())..", "..
            conn:quote(tag_order[i].Strength:nodeText())..", "..
            conn:quote(tag_order[i].SupplierItemNumber:nodeText())..", "..
            conn:quote(ACTIVE_FLG)..", "..
            conn:quote( DATE_VALUE)..", "..
            conn:quote(ROW_ADD_USER_ID)..", "..
            conn:quote( DATE_VALUE)..", "..
            conn:quote(ROW_UPDATE_USER_ID)..
            ")"
        sql_csos_detail_status = conn:execute{sql=sql_csos_order_details, live=true};
        if(sql_csos_detail_status == nil) then
            insertion_status = true
        else
            insertion_status = false
        end
        else
            insertion_status = false
        end
    end
    else
      insertion_status = false
    end
   
    if(insertion_status == true) then
      conn:execute{sql=[[COMMIT;]],live=true}
    else  
      conn:execute{sql=[[ROLLBACK;]],live=true}
    end
    return insertion_status
end

-- Get the log file
function getLogFile(output_log_path)
    result_LogFileDirectory_Status=os.fs.access(output_log_path)

    if(result_LogFileDirectory_Status==false) then   -- checking for directory exist or not
        os.fs.mkdir(output_log_path)
    end

    log_file_with_today_date = "logs_"..os.date("%Y-%m-%d")..".txt" --Today Date
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
    -- Validation for csos_order_header
    local validateion_status = false

    -- Task 1 : Write all the columns of csos_order_header and csos_order_details in the if condition
    if(order_data~=nil and order_data.CSOSOrderRequest~=nil and order_data.CSOSOrderRequest.CSOSOrder~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order~=nil
         and order_data.CSOSOrderRequest.CSOSOrder.Order.OrderItem~=nil
         and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate,PO_DATE)   --if 11
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber,PO_NUMBER)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber,SHIPTO_NUM)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit,BUSINESS_UNIT)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel, ORDER_CHANNEL)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber,UNIQUE_TRANS_NUM)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines,NO_OF_LINES))
    then
        Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()
        SIZE_OF_ORDERITEM=order_data.CSOSOrderRequest.CSOSOrder.Order:childCount("OrderItem")
    
        if(tostring(SIZE_OF_ORDERITEM)~=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText())
        then
            validateion_status = false
            return validateion_status
        end
        for i=1,Size_Of_NoOfLines do  --for 3
            if(order_data.CSOSOrderRequest~=nil and order_data.CSOSOrderRequest.CSOSOrder~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i]~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order.OrderItem~=nil and
                Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].LineNumber,LINE_NUM)   --if 12
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].NameOfItem,NAME_OF_ITEM)
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].NationalDrugCode,NATIONAL_DRUG_CDE)
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].SizeOfPackages,SIZE_OF_PACKAGE)
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].QuantityOrdered,QUANTITY)
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].Strength,STRENGTH)
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].Form,FORM)
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].Schedule,DEA_SCHEDULE)
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].SupplierItemNumber,SUPPLIER_ITEM_NUM)
                and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].BuyerItemNumber,BUYER_ITEM_NUM))
        then
            validateion_status = true
        else
            validateion_status = false
         end    --end  if 12   
        end  --end for 3
    else
        validateion_status = false
        log_file:write(TIME_STAMP..DATA_VALIDATION_FAIL..os.date('%x'),"\n")   --checking
    end --end for if 11
    return validateion_status
end  --end validationForOrderData() function