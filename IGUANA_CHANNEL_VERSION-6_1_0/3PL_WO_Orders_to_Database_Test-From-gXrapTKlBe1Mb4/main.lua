
-- This channel read the order files and store in the database
-- Version 1.0
function main()

    dbConnection = require("DBConnection")
    properties = require("properties")
    Validation_test = require("Validation_test")
    constants = require("Constants")

    properties.directory_path()
    constants.csos_order_header_size()
    constants.csos_order_details_size()
    constants.log_statements()
    constants.query_constants()
    constants.frequently_constants()


    log_file = getLogFile(output_log_path)

    if pcall(verifyAllDirectories) then

        -- Read the XML file from the Directory
        file_directory =io.popen([[dir "]]..input_directory_path..[[" /b]])

        for filename in file_directory:lines() do
            order_file=input_directory_path..filename

            -- This is the default value of the column ACTIVE_FLAG in the database
            ACTIVE_FLG=active_flg_val
            ROW_ADD_USER_ID=user
            ROW_UPDATE_USER_ID=user


            if(GetFileExtension(order_file) == '.xml') then
                log_file:write(filename..":"..XML_FILE_TEST_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                -- Open order file
                open_order_file = io.open(order_file, "r")

                if not open_order_file then log_file:write(UNABLE_OPEN_FILE..order_file.."\n") else
                    -- Read order file
                    read_order_file =  open_order_file:read('*a')
                    -- Close the file
                    open_order_file:close()
                    if pcall(Parser) then
                        -- local order_data = xml.parse(read_order_file)




                        order_data_validation_TAG_status=validationForTAG_Status(order_data)
                        print(order_data_validation_TAG_status)
                        if(order_data_validation_TAG_status==true) then

                            Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()
                            SIZE_OF_ORDERITEM=order_data.CSOSOrderRequest.CSOSOrder.Order:childCount("OrderItem")


                            -- Validation

                            local order_data_validation_status = validationForOrderData(order_data)

                            if(order_data_validation_status==true) then
                                tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
                                tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order

                                ts=os.time()
                                DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)
                                if pcall(DBConn) then
                                    -- dbConnection.connectdb()
                                    if pcall(Insertion) then
                                        log_file:write(filename..":"..INSERT_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking

                                        if(sql_csos_order_status == nil and sql_csos_detail_status == nil)
                                        then
                                            os.rename(input_directory_path..filename, output_archived_path..filename)
                                            log_file:write(filename..":"..ARC_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                                        else
                                            os.rename(input_directory_path..filename, output_error_path..filename)
                                            log_file:write(filename..":"..ERR_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                                        end

                                    else
                                        log_file:write("Insertion is not done on : "..os.date('%x').." at :"..os.date('%X'),"\n")
                                    end
                                else
                                    log_file:write("Database connection  is not exist on : "..os.date('%x').." at :"..os.date('%X'),"\n")
                                end
                            end -- end for validation
                        else
                            os.rename(input_directory_path..filename, output_error_path..filename)
                            log_file:write(filename..":"..ERR_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                        end
                    else
                        log_file:write("xml parsing is not done on : "..os.date('%x').." at :"..os.date('%X'),"\n")
                    end
                end -- end for unable to open file
            else
                log_file:write(filename..":"..XML_FILE_TEST_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                os.rename(input_directory_path..filename, output_error_path..filename)
                log_file:write(filename..":"..DATA_VALIDATION_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
                log_file:write(filename..":"..INSERT_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
                log_file:write(filename..":"..ERR_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
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
        log_file:write(ARC_DIR_MISS..os.date('%x').." at :"..os.date('%X'),"\n") --checking
        os.fs.mkdir(output_archived_path)
        log_file:write(ARC_DIR_CREATE..os.date('%x').." at :"..os.date('%X'),"\n") --checking
    end

    if(result_ErrorDirectory_Status==false)   then   -- checking for directory exist or not
        log_file:write(ERR_DIR_MISS..os.date('%x').." at :"..os.date('%X'),"\n") --checking
        os.fs.mkdir(output_error_path)
        log_file:write(ERR_DIR_CREATE..os.date('%x').." at :"..os.date('%X'),"\n") --checking
    end

    if(result_OrderFileDirectory_Status==false)   then   -- checking for directory exist or not
        log_file:write(ORD_DIR_MISS..os.date('%x').." at :"..os.date('%X'),"\n") --checking
        os.fs.mkdir(input_directory_path)
        log_file:write(ORD_DIR_CREATE..os.date('%x').." at :"..os.date('%X'),"\n") --checking
    end
end




function Parser()
    order_data = xml.parse(read_order_file)
end



function DBConn()
    dbConnection.connectdb()
end






function Insertion()
    if not conn_dev then
        conn_dev:execute{sql=[[ROLLBACK;]],live=true}
    end

    conn_dev:execute{sql=[[START TRANSACTION;]] ,live=true};

    sql_csos_order_header = "CALL AddCSOSOrder("..
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

    CSOS_ORD_HDR_NUM_UPDATE=conn_dev:query{sql=SEL_HEAD_MAX, live=true};


    CSOS_ORD_HDR_NUM_UPDATE_VAL=tostring(CSOS_ORD_HDR_NUM_UPDATE[1]["max(CSOS_ORD_HDR_NUM)"])

    -- conn_dev:execute{sql=[[COMMIT;]],live=true}

    --   if not conn_dev then
    --conn_dev:execute{sql=[[ROLLBACK;]],live=true}
    -- end
    --  conn_dev:execute{sql=[[START TRANSACTION;]],live=true};
    for i=1,Size_Of_NoOfLines do

        sql_csos_order_details = "CALL AddCSOSOrderdetails ("..
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
    end
    conn_dev:execute{sql=[[COMMIT;]],live=true}
    CSOS_ORD_HDR_NUM_EXTRACTED=conn_dev:execute{sql=SEL_DETAILS_MAX,live=true}
    CSOS_ORD_HDR_NUM_EXTRACTED_VALUE=tostring(CSOS_ORD_HDR_NUM_EXTRACTED[1]["max(CSOS_ORD_HDR_NUM)"])
    if (CSOS_ORD_HDR_NUM_UPDATE_VAL~=CSOS_ORD_HDR_NUM_EXTRACTED_VALUE) then
        conn_dev:execute{sql=[[ROLLBACK;]],live=true}
    end

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



function validationForTAG_Status(order_data)



    -- Validation for csos_order_header
    local validateion_tag_status = false


    if(order_data~=nil and order_data.CSOSOrderRequest~=nil and order_data.CSOSOrderRequest.CSOSOrder~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate~=nil and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PODate:nodeText()~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber~=nil and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.PONumber:nodeText()~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber~=nil and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.ShipToNumber:nodeText()~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit~=nil and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.BusinessUnit:nodeText()~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel~=nil and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.OrderChannel:nodeText()~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber~=nil and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.UniqueTransactionNumber:nodeText()~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines~=nil and order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()~=nil and
        order_data.CSOSOrderRequest.CSOSOrder.Order~=nil)
    then

        SIZE_OF_ORDERITEM=order_data.CSOSOrderRequest.CSOSOrder.Order:childCount("OrderItem")
        print(SIZE_OF_ORDERITEM,order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText())

        if(tostring(SIZE_OF_ORDERITEM)~=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText())
        then
            validateion_tag_status = false
            return validateion_tag_status
        end


        for i=1, SIZE_OF_ORDERITEM do

            if(order_data.CSOSOrderRequest~=nil and order_data.CSOSOrderRequest.CSOSOrder~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i]~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order.OrderItem~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].LineNumber~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].LineNumber:nodeText() ~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].NameOfItem~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].NameOfItem:nodeText() ~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].NationalDrugCode~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].NationalDrugCode:nodeText() ~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].SizeOfPackages~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].SizeOfPackages:nodeText() ~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].QuantityOrdered~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].QuantityOrdered:nodeText() ~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].Strength~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].Strength:nodeText()~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].Form~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].Form:nodeText() ~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].Schedule~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].Schedule:nodeText() ~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].SupplierItemNumber~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].SupplierItemNumber:nodeText() ~=nil and
                order_data.CSOSOrderRequest.CSOSOrder.Order[i].BuyerItemNumber~=nil and order_data.CSOSOrderRequest.CSOSOrder.Order[i].BuyerItemNumber:nodeText()~=nil
                )
            then

                validateion_tag_status = true

                log_file:write(TAGS_AVAILABLE..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
            else

                validateion_tag_status = false

                log_file:write(TAG_MISS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
                break

            end

        end

    else
        validateion_tag_status = false

        log_file:write(TAG_MISS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking

    end

    return validateion_tag_status

end


function validationForOrderData(order_data)
    tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
    tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order
    -- Validation for csos_order_header
    local validateion_status = false

    -- Task 1 : Write all the columns of csos_order_header and csos_order_details in the if condition
    if(Validation_test.validate_value(tag_OrderSummary.PODate:nodeText(),PO_DATE)
        and Validation_test.validate_value(tag_OrderSummary.PONumber:nodeText(),PO_NUMBER)
        and Validation_test.validate_value(tag_OrderSummary.ShipToNumber:nodeText(),SHIPTO_NUM)
        and Validation_test.validate_value(tag_OrderSummary.BusinessUnit:nodeText(),BUSINESS_UNIT)
        and Validation_test.validate_value(tag_OrderSummary.OrderChannel:nodeText(), ORDER_CHANNEL)
        and Validation_test.validate_value(tag_OrderSummary.UniqueTransactionNumber:nodeText(),UNIQUE_TRANS_NUM)
        and Validation_test.validate_value(tag_OrderSummary.NoOfLines:nodeText(),NO_OF_LINES))
    then

        for i=1,Size_Of_NoOfLines do

            if(Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].LineNumber:nodeText(),LINE_NUM)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].NameOfItem:nodeText(),NAME_OF_ITEM)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].NationalDrugCode:nodeText(),NATIONAL_DRUG_CDE)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].SizeOfPackages:nodeText(),SIZE_OF_PACKAGE)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].QuantityOrdered:nodeText(),QUANTITY)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].Strength:nodeText(),STRENGTH)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].Form:nodeText(),FORM)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].Schedule:nodeText(),DEA_SCHEDULE)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].SupplierItemNumber:nodeText(),SUPPLIER_ITEM_NUM)
                and Validation_test.validate_value(order_data.CSOSOrderRequest.CSOSOrder.Order[i].BuyerItemNumber:nodeText(),BUYER_ITEM_NUM))
            then

                validateion_status = true

                log_file:write(DATA_VALIDATION_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
            end

        end

    else
        validateion_status = false

        log_file:write(filename..":"..DATA_VALIDATION_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking

    end

    return validateion_status

end
