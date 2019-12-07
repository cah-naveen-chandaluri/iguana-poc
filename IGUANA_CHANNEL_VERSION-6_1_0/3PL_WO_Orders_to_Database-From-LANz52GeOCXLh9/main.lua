-- This channel read the order files and store in the database
-- Version 1.0
function main()

    create_procedures=require("CreateProcedures")
    properties = require("properties")
    Validation = require("Validation")
    constants = require("Constants")
    mail=require("mail")

    create_procedures.createProcedure()
    properties.directory_path()
    properties.db_conn()
    constants.csos_order_header_size()
    constants.csos_order_details_size()
    constants.log_statements()
    constants.query_constants()
    constants.frequently_constants()
    constants.csos_addr_details_size()
    archived_table={}
    error_table={}

    log_file = getLogFile(output_log_path)
    log_file:write("\n",TIME_STAMP..CHANNEL_STARTED_RUNNING,"\n")

    if pcall(verifyAllDirectories) then

        -- Read the XML file from the Directory
        file_directory =io.popen([[dir "]]..input_directory_path..[[" /b]])

        -- Read order files
        total_count,error_count,archive_count=0,0,0
        for filename in file_directory:lines() do
            log_file:write(TIME_STAMP..filename.." - *** Started processing file ***","\n")
            order_file=input_directory_path..filename
            fileName_with_timestamp = GetFileName(filename).."_"..TIME_STAMP_FOR_FILE..GetFileExtension(filename)
            -- This is the default value of the column ACTIVE_FLAG in the database
            ACTIVE_FLG=active_flg_val
            ROW_ADD_USER_ID=user
            ROW_UPDATE_USER_ID=user

            if(GetFileExtension(order_file) == '.xml') then -- Validation file extension
                log_file:write(TIME_STAMP..filename..XML_FILE_TEST_SUCCESS,"\n")  --checking
                -- Open order file
                open_order_file = io.open(order_file, "r")

                if not open_order_file then log_file:write(TIME_STAMP..filename.." - "..UNABLE_OPEN_FILE..order_file,"\n") else
                    -- Read order file
                    read_order_file =  open_order_file:read('*a')
                    -- Close the file
                    open_order_file:close()
                    if pcall(Parser) then

                        local order_data = Parser()
                        local order_data_validation_status = validationForOrderData(order_data)
                        if(order_data_validation_status==true) then -- order validation if condition
                            log_file:write(TIME_STAMP..filename.." - "..DATA_VALIDATION_SUCCESS,"\n")   --checking
                            Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()
                            SIZE_OF_ORDERITEM=order_data.CSOSOrderRequest.CSOSOrder.Order:childCount("OrderItem")

                            tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
                            tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order

                            ts=os.time()
                            DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)
                            if pcall(Verify_DBConn) then
                                if pcall(Insertion) then
                                    archived_table[archive_count]= fileName_with_timestamp
                                    archive_count=archive_count+1

                                    log_file:write(TIME_STAMP..filename.." - "..INSERT_SUCCESS,"\n")   --checking
                                    os.rename(input_directory_path..filename, output_archived_path..fileName_with_timestamp)

                                    log_file:write(TIME_STAMP..filename.." - "..ARC_DIR_MOV..fileName_with_timestamp,"\n")  --checking
                                else
                                    error_table[error_count]=fileName_with_timestamp
                                    error_count=error_count+1  --a if insertion fails data in a

                                    log_file:write(TIME_STAMP..filename.." - "..INSERT_FAIL,"\n")
                                    os.rename(input_directory_path..filename, output_error_path..fileName_with_timestamp)

                                    print(error_table[error_count])
                                    log_file:write(TIME_STAMP..filename.." - "..ERR_DIR_MOV..fileName_with_timestamp,"\n")  --checking
                                end
                            else

                                error_table[error_count]=fileName_with_timestamp
                                error_count=error_count+1--if db connection fails data in b

                                log_file:write(TIME_STAMP..filename.." - "..DB_CON_ERROR,"\n")
                                os.rename(input_directory_path..filename, output_error_path..fileName_with_timestamp)
                                log_file:write(TIME_STAMP..filename.." - "..ERR_DIR_MOV..fileName_with_timestamp,"\n")  --checking
                            end
                        else
                            error_table[error_count]=fileName_with_timestamp
                            error_count=error_count+1

                            log_file:write(TIME_STAMP..filename.." - "..DATA_VALIDATION_FAIL,"\n")  --checking
                            os.rename(input_directory_path..filename, output_error_path..fileName_with_timestamp)
                            log_file:write(TIME_STAMP..filename.." - "..ERR_DIR_MOV..fileName_with_timestamp,"\n")
                        end -- end for validation
                    else
                        log_file:write(TIME_STAMP..filename.." - ".."Unable to parse the file","\n")
                    end
                end -- end for unable to open file
            else -- else for validation file extension

                error_table[error_count]=fileName_with_timestamp
                error_count=error_count+1

                log_file:write(TIME_STAMP..filename..":"..XML_FILE_TEST_FAIL,"\n")  --checking
                os.rename(input_directory_path..filename, output_error_path..fileName_with_timestamp)
            end -- end for if condition checking whether file is xml or not
            total_count=total_count+1
        end --end for for loop
        log_file:write(TIME_STAMP.."Total files : "..total_count,"\n")
        -- This loop for generate the logs for archive files count and their file names
        log_file:write(TIME_STAMP.."Total files  moved to archive directory : "..archive_count,"\n")
        for i=0,archive_count-1 do
            log_file:write(TIME_STAMP..archived_table[i].." file is moved to archive directory  ","\n")
        end
      
        -- This loop for generate the logs for error files count and their file names
        log_file:write(TIME_STAMP.."Total files  moved to error directory  "..error_count ,"\n")
        local error_table_list_temp = ''
        for i=0,error_count-1 do
            log_file:write(TIME_STAMP..error_table[i].." file is moved to error directory ","\n")
            error_table_list_temp = error_table_list_temp..error_table[i]..'\z\n'
        end
        if(error_count>0) then
            mail.send_email("3PL WO Iguana Channel1 - Error files and Not updated in the DB", "Hi All,".."\n\n"..
            "Below are the list of error files in the Iguana Channel 1 \n"..error_table_list_temp.."\n\n".."Thanks,\n 3PL WO Iguana Team")
        end
    else
        log_file:write(TIME_STAMP.."Not able to create or there is no OrderFile, ArchiveFiles and ErrorFiles folders")

    end


end -- end for main function

-- Validating the file extenstion format

function GetFileExtension(filename)
    return filename:match("^.+(%..+)$")
end

function GetFileName(filename)
    return filename:match("(.+)%..+")
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
        result_ArchivedDirectory_Status=os.fs.access(output_archived_path)
    end

    if(result_ErrorDirectory_Status==false)   then   -- checking for directory exist or not
        log_file:write(TIME_STAMP..ERR_DIR_MISS,"\n") --checking
        os.fs.mkdir(output_error_path)
        log_file:write(TIME_STAMP..ERR_DIR_CREATE,"\n") --checking
        result_ErrorDirectory_Status=os.fs.access(output_error_path)
    end

    if(result_OrderFileDirectory_Status==false)   then   -- checking for directory exist or not
        log_file:write(TIME_STAMP..ORD_DIR_MISS,"\n") --checking
        os.fs.mkdir(input_directory_path)
        log_file:write(TIME_STAMP..ORD_DIR_CREATE,"\n") --checking
        result_OrderFileDirectory_Status=os.fs.access(input_directory_path)
    end

    if(result_ArchivedDirectory_Status and result_ErrorDirectory_Status and result_OrderFileDirectory_Status) then
        return true
    else
        return false
    end
end

function Parser()  --function for parsing xml
    return xml.parse(read_order_file)
end

function Verify_DBConn()  --function for validating db connection
    return conn:check()
end

function Insertion()  --function for insertion
    insertion_status = false
    conn:execute{sql=[[START TRANSACTION;]] ,live=true};

    --insertion is done into csos_order_header

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
        sql_csos_order_header_status = nil

        --insertion is done in csos_addr_details as supplier

        sql_csos_addr_supplier = "CALL AddCSOSaddrsupplier ("..
            conn:quote(CSOS_ORD_HDR_NUM_UPDATE_VAL)..", "..
            conn:quote(supplier)..", "..
            conn:quote(tag_OrderSummary.Supplier.Address1:nodeText())..", "..
            conn:quote(tag_OrderSummary.Supplier.City:nodeText())..", "..
            conn:quote(tag_OrderSummary.Supplier.DEANumber:nodeText())..", "..
            conn:quote(tag_OrderSummary.Supplier.PostalCode:nodeText())..", "..
            conn:quote(tag_OrderSummary.Supplier.State:nodeText())..", "..
            conn:quote(ACTIVE_FLG)..", "..
            conn:quote( DATE_VALUE)..", "..
            conn:quote(ROW_ADD_USER_ID)..", "..
            conn:quote( DATE_VALUE)..", "..
            conn:quote(ROW_UPDATE_USER_ID)..
            ")"
        sql_csos_addr_supplier_status = conn:execute{sql=sql_csos_addr_supplier, live=true};
        if(sql_csos_addr_supplier_status == nil) then
            insertion_status = true
        else
            insertion_status = false
        end

    else
        insertion_status = false
    end

    if(tonumber(CSOS_ORD_HDR_NUM_UPDATE_VAL)>=0 and insertion_status == true) then
        sql_csos_addr_supplier_status = nil

        -- insertion is done into csos_addr_details as buyer

        sql_csos_addr_buyer = "CALL AddCSOSaddrbuyer ("..
            conn:quote(CSOS_ORD_HDR_NUM_UPDATE_VAL)..", "..
            conn:quote(buyer)..", "..
            conn:quote(tag_OrderSummary.Buyer.Address1:nodeText())..", "..
            conn:quote(tag_OrderSummary.Buyer.Address2:nodeText())..", "..
            conn:quote(tag_OrderSummary.Buyer.City:nodeText())..", "..
            conn:quote(tag_OrderSummary.Buyer.DEASchedule:nodeText())..", "..
            conn:quote(tag_OrderSummary.Buyer.DEANumber:nodeText())..", "..
            conn:quote(tag_OrderSummary.Buyer.PostalCode:nodeText())..", "..
            conn:quote(tag_OrderSummary.Buyer.State:nodeText())..", "..
            conn:quote(ACTIVE_FLG)..", "..
            conn:quote( DATE_VALUE)..", "..
            conn:quote(ROW_ADD_USER_ID)..", "..
            conn:quote( DATE_VALUE)..", "..
            conn:quote(ROW_UPDATE_USER_ID)..
            ")"
        sql_csos_addr_buyer_status = conn:execute{sql=sql_csos_addr_buyer, live=true};
        if(sql_csos_addr_buyer_status == nil) then
            insertion_status = true
        else
            insertion_status = false
        end
    else
        insertion_status = false
    end
    if(tonumber(CSOS_ORD_HDR_NUM_UPDATE_VAL)>=0 and insertion_status == true) then
        sql_csos_addr_buyer_status = nil

        --insertion is done into csos_order_details

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


    if(order_data~=nil and order_data.CSOSOrderRequest~=nil and order_data.CSOSOrderRequest.CSOSOrder~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order~=nil
        and order_data.CSOSOrderRequest.CSOSOrder.Order.OrderItem~=nil
        and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Supplier~=nil
        and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer~=nil
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate,PO_DATE)   --if 11
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber,PO_NUMBER)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber,SHIPTO_NUM)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit,BUSINESS_UNIT)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel, ORDER_CHANNEL)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber,UNIQUE_TRANS_NUM)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines,NO_OF_LINES)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Supplier.Name,NAME)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Supplier.Address1,ADDR1)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Supplier.City,CITY)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Supplier.State,STATE)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Supplier.PostalCode,POSTAL_CDE)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Supplier.DEANumber,DEA_NUMBER)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer.Name,NAME)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer.Address1,ADDR1)
        --and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer.Address2,ADDR2)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer.City,CITY)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer.State,STATE)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer.PostalCode,POSTAL_CDE)
        and Validation.validate_value(order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer.DEANumber,DEA_NUMBER)
        and Validation.validate_value( order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.Buyer.DEASchedule,DEA_SCHEDULLE)
        )
    then
        Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()
        SIZE_OF_ORDERITEM=order_data.CSOSOrderRequest.CSOSOrder.Order:childCount("OrderItem")

        if(tostring(SIZE_OF_ORDERITEM)~=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText())
        then
            validateion_status = false
            return validateion_status
        end
        for i=1,Size_Of_NoOfLines do

            -- validation for csos_order_details
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
            end    --end
        end  --end
    else
        validateion_status = false
    end --end
    return validateion_status
end  --end validationForOrderData() function
