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
    constants.log_statements()
    constants.query_constants()
    constants.frequently_constants()
   
   
    log_file = getLogFile(output_log_path)

    if pcall(verifyAllDirectories) then  --if 1

        -- Read the XML file from the Directory
        file_directory =io.popen([[dir "]]..input_directory_path..[[" /b]])

        for filename in file_directory:lines() do  --for 1
            local order_file=input_directory_path..filename

            -- This is the default value of the column ACTIVE_FLAG in the database
            ACTIVE_FLG=active_flg_val
            ROW_ADD_USER_ID=user
            ROW_UPDATE_USER_ID=user
            CSOS_ORD_HDR_NUM=1

            if(GetFileExtension(order_file) == '.xml') then  --if 2
                log_file:write(XML_FILE_TEST_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                -- Open order file
                local open_order_file = io.open(order_file, "r")

                if not open_order_file then log_file:write(UNABLE_OPEN_FILE..order_file.."\n") else  --if 3
                    -- Read order file
                    local read_order_file =  open_order_file:read('*a')
                    -- Close the file
                    open_order_file:close()

                    local order_data = xml.parse(read_order_file)
                    Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()

                    -- Validation
                    local order_data_validation_status = validationForOrderData(order_data)

                    if(order_data_validation_status==true) then  --if 4
                         tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
                    tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order
                        ts=os.time()
                        DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)

                        dbConnection.connectdb()
                        local sql_csos_order_header = "CALL AddCSOSOrder ("..
                        conn_dev:quote(tag_OrderSummary.BusinessUnit:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.NoOfLines:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.OrderChannel:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.PODate:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.PONumber:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.ShipToNumber:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.UniqueTransactionNumber:nodeText())..", "..
                        conn_dev:quote(ACTIVE_FLG)..", "..
                        conn_dev:quote( DATE_VALUE)..", "..
                        conn_dev:quote(ROW_ADD_USER_ID)..", "..
                        conn_dev:quote( DATE_VALUE)..", "..
                        conn_dev:quote(ROW_UPDATE_USER_ID)..
                        ")"
                    sql_csos_order_status,sql_csos_order_error =conn_dev:execute{sql=sql_csos_order_header, live=true};

                    local CSOS_ORD_HDR_NUM_UPDATE=conn_dev:query{sql=sel_head, live=true};

                    CSOS_ORD_HDR_NUM_UPDATE_VAL=tostring(CSOS_ORD_HDR_NUM_UPDATE[1]["max(CSOS_ORD_HDR_NUM)"])


                    for i=1,Size_Of_NoOfLines do  --for 2

                        local sql_csos_order_details = "CALL AddCSOSOrderdetails ("..
                            conn_dev:quote(CSOS_ORD_HDR_NUM_UPDATE_VAL)..", "..
                            conn_dev:quote(tag_order[i].BuyerItemNumber:nodeText())..", "..
                            conn_dev:quote(tag_order[i].Form:nodeText())..", "..
                            conn_dev:quote(tag_order[i].LineNumber:nodeText())..", "..
                            conn_dev:quote(tag_order[i].NameOfItem:nodeText())..", "..
                            conn_dev:quote(tag_order[i].NationalDrugCode:nodeText())..", "..
                            conn_dev:quote(tag_order[i].QuantityOrdered:nodeText())..", "..
                            conn_dev:quote(tag_order[i].Schedule:nodeText())..", "..
                            conn_dev:quote(tag_order[i].SizeOfPackages:nodeText())..", "..
                            conn_dev:quote(tag_order[i].Strength:nodeText())..", "..
                            conn_dev:quote(tag_order[i].SupplierItemNumber:nodeText())..", "..
                            conn_dev:quote(ACTIVE_FLG)..", "..
                            conn_dev:quote( DATE_VALUE)..", "..
                            conn_dev:quote(ROW_ADD_USER_ID)..", "..
                            conn_dev:quote( DATE_VALUE)..", "..
                            conn_dev:quote(ROW_UPDATE_USER_ID)..
                            ")"
                            sql_csos_detail_status,sql_csos_detail_error = conn_dev:execute{sql=sql_csos_order_details, live=true};
                        end  --end for 2

                        log_file:write(INSERT_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking

                        if(sql_csos_order_status == nil and sql_csos_detail_status == nil)  --if 5
                        then
                            os.rename(input_directory_path..filename, output_archived_path..filename)
                            log_file:write(ARC_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                        else
                            os.rename(input_directory_path..filename, output_error_path..filename)
                            log_file:write(ERR_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                        end  --end if 5
                    end -- end for validation  --end if 4
                end -- end for unable to open file  --end if 3
            else
                log_file:write(XML_FILE_TEST_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                os.rename(input_directory_path..filename, output_error_path..filename)
                log_file:write(DATA_VALIDATION_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
                log_file:write(INSERT_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
                log_file:write(ERR_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
            end -- end for if condition checking whether file is xml or not  --end if 2
        end --end for1
    else
        log_file:write("OrderFile, ArchiveFiles and ErrorFiles folders are not exists")
    end  --end if 1
end -- end for main() function

-- Validating the file extenstion format
function GetFileExtension(url)
    return url:match("^.+(%..+)$")
end  --end GetFileExtension() function


function verifyAllDirectories()
    result_ArchivedDirectory_Status=os.fs.access(output_archived_path)     --checking directory exist status
    result_ErrorDirectory_Status=os.fs.access(output_error_path)        --checking directory exist status
    result_OrderFileDirectory_Status=os.fs.access(input_directory_path)     --checking directory oder file status

    --Validating the directories of ArchivedFiles and ErrorFiles
    if(result_ArchivedDirectory_Status==false)   then   -- checking for directory exist or not  --if 6
        log_file:write(ARC_DIR_MISS..os.date('%x').." at :"..os.date('%X'),"\n") --checking
        os.fs.mkdir(output_archived_path)
        log_file:write(ARC_DIR_CREATE..os.date('%x').." at :"..os.date('%X'),"\n") --checking
    end  -- end if 6

    if(result_ErrorDirectory_Status==false)   then   -- checking for directory exist or not  --if 7
        log_file:write(ERR_DIR_MISS..os.date('%x').." at :"..os.date('%X'),"\n") --checking
        os.fs.mkdir(output_error_path)
        log_file:write(ERR_DIR_CREATE..os.date('%x').." at :"..os.date('%X'),"\n") --checking
    end  --end if 7

    if(result_OrderFileDirectory_Status==false)   then   -- checking for directory exist or not  if 8
        log_file:write(ORD_DIR_MISS..os.date('%x').." at :"..os.date('%X'),"\n") --checking
        os.fs.mkdir(input_directory_path)
        log_file:write(ORD_DIR_CREATE..os.date('%x').." at :"..os.date('%X'),"\n") --checking
    end  --end if 8
end  -- end verifyAllDirectories() function
-- Get the log file

function getLogFile(output_log_path)
    result_LogFileDirectory_Status=os.fs.access(output_log_path)

    if(result_LogFileDirectory_Status==false) then   -- checking for directory exist or not  --if 9
        os.fs.mkdir(output_log_path)
    end  --end if 9

    log_file_with_today_date = "logs_"..os.date("%m%d%Y")..".txt" --Today Date
    local log_file_verify=io.open(output_log_path..log_file_with_today_date,'r')

    if log_file_verify~=nil then  --if 10
        io.close(log_file_verify)
        return io.open(output_log_path..log_file_with_today_date,'a+')
    else
        return io.open(output_log_path..log_file_with_today_date,'w')
    end  --end if 10
end  --end getLogFile function()



-- Validating the order data

function validationForOrderData(order_data)
    tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
    tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order
    -- Validation for csos_order_header
    local validateion_status = false

    -- Task 1 : Write all the columns of csos_order_header and csos_order_details in the if condition
    if(Validation.validate_value(tag_OrderSummary.PODate,PO_DATE)   --if 11
        and Validation.validate_value(tag_OrderSummary.PONumber,PO_NUMBER)
        and Validation.validate_value(tag_OrderSummary.ShipToNumber,SHIPTO_NUM)
        and Validation.validate_value(tag_OrderSummary.BusinessUnit,BUSINESS_UNIT)
        and Validation.validate_value(tag_OrderSummary.OrderChannel, ORDER_CHANNEL)
        and Validation.validate_value(tag_OrderSummary.UniqueTransactionNumber,UNIQUE_TRANS_NUM)
        and Validation.validate_value(tag_OrderSummary.NoOfLines,NO_OF_LINES))
    then

        for i=1,Size_Of_NoOfLines do  --for 3

            if(Validation.validate_value(tag_order[i].LineNumber,LINE_NUM)   --if 12
                and Validation.validate_value(tag_order[i].NameOfItem,NAME_OF_ITEM)
                and Validation.validate_value(tag_order[i].NationalDrugCode,NATIONAL_DRUG_CDE)
                and Validation.validate_value(tag_order[i].SizeOfPackages,SIZE_OF_PACKAGE)
                and Validation.validate_value(tag_order[i].QuantityOrdered,QUANTITY)
                and Validation.validate_value(tag_order[i].Strength,STRENGTH)
                and Validation.validate_value(tag_order[i].Form,FORM)
                and Validation.validate_value(tag_order[i].Schedule,DEA_SCHEDULE)
                and Validation.validate_value(tag_order[i].SupplierItemNumber,SUPPLIER_ITEM_NUM)
                and Validation.validate_value(tag_order[i].BuyerItemNumber,BUYER_ITEM_NUM))
        then

            validateion_status = true

            log_file:write(DATA_VALIDATION_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
        end    --end  if 12

        end  --end for 3

    else
        validateion_status = false

        log_file:write(DATA_VALIDATION_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking

    end --end for if 11

    return validateion_status

end  --end validationForOrderData() function