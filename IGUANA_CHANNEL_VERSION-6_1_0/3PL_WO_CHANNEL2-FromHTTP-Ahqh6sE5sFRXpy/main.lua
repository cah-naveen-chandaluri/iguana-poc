URL='https://spselitestg.cardinalhealth.net/stage_841/ws/DmsWebService'
net.http.respond{headers='',body='HELLO',persist=false,code=5}
function main()

    properties = require("properties")
    constants = require("Constants")
    mail=require("mail")
    soap=require("file_soap")

    properties.directory_path()
    properties.db_conn()
    constants.csos_order_header_size()
    constants.csos_order_details_size()
    constants.log_statements()
    constants.query_constants()
    constants.frequently_constants()

    log_file = getLogFile(output_log_path)
    log_file:write(TIME_STAMP.."******* Iguana channel Started Running *******","\n")

    if pcall(DBConn) then   --if 1
        selection_status = false
        conn_dev:execute{sql=[[START TRANSACTION;]] ,live=true};
        csos_order_header_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,UNIQUE_TRANS_NUM,PO_NUMBER,PO_DATE,SHIPTO_NUM from 3pl_sps_ordering.csos_order_header where CSOS_ORDER_HDR_STAT='1';", live=true};
        if(#csos_order_header_data>0) then  --if 2
            selection_status = true
        else
            selection_status = false
        end                                  --end if 2
        if(#csos_order_header_data>0 and selection_status == true) then   --if 3
            for i=1,#csos_order_header_data,1 do  --for 1
                print(csos_order_header_data[i].UNIQUE_TRANS_NUM)
                order_header_data=conn_dev:query{sql="select ELITE_ORDER,ELITE_ORDER_NUM,ORDER_NUM,CUSTOMER_NUM,CSOS_ORDER_NUM,PO_NUM,PO_DTE from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..tostring(csos_order_header_data[i].UNIQUE_TRANS_NUM).."';",live=true};
                customer_billto_shipto_data=conn_dev:query{sql="select BILLTO_NUM,ORG_CDE,CUSTOMER_NUM,SHIPTO_NUM FROM 3pl_sps_ordering.customer_billto_shipto WHERE CUSTOMER_NUM='"..tostring(order_header_data[i].CUSTOMER_NUM).."';",live=true};
                print(order_header_data[1].PO_NUM,order_header_data[1].PO_DTE,order_header_data[1].CSOS_ORDER_NUM,customer_billto_shipto_data[1].SHIPTO_NUM)
                if(#order_header_data>0 and #customer_billto_shipto_data>0) then  --if 4
                    selection_status = true
                    print(csos_order_header_data[i].PO_NUMBER,order_header_data[1].PO_NUM,csos_order_header_data[i].UNIQUE_TRANS_NUM,order_header_data[1].CSOS_ORDER_NUM)
                    if(tostring(csos_order_header_data[i].PO_NUMBER)==tostring(order_header_data[1].PO_NUM)
                        and tostring(csos_order_header_data[i].PO_DATE)==tostring(order_header_data[1].PO_DTE)
                        and tostring(csos_order_header_data[i].UNIQUE_TRANS_NUM)==tostring(order_header_data[1].CSOS_ORDER_NUM)
                        and tostring(csos_order_header_data[i].SHIPTO_NUM)==tostring(customer_billto_shipto_data[1].SHIPTO_NUM)
                        )
                    then  --if 5
                        order_details_data=conn_dev:query{sql="select REQ_QTY,SHIP_UOM_DESC,PROD_NUM from 3pl_sps_ordering.order_detail where ORDER_HDR_NUM='"..tostring(order_header_data[i].ORDER_NUM).."';",live=true};
                        if(#order_details_data>0) then  --if 6
                            selection_status=true
                            prod_data={}
                            for j=1,#order_details_data do  -- for 2
                                prod_data[j]=conn_dev:query{sql="select SKU_ITEM_ID,NDC_ID,DEA_SCHEDULE FROM 3pl_sps_ordering.prod where PROD_NUM='"..tostring(order_details_data[j].PROD_NUM).."';",live=true};
                            end  --end for 2
                            print(order_details_data[1].PROD_NUM,order_details_data[2].PROD_NUM)
                            csos_order_details_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,QUANTITY,BUYER_ITEM_NUM,NATIONAL_DRUG_CDE,DEA_SCHEDULE,SIZE_OF_PACKAGE FROM 3pl_sps_ordering.csos_order_details where CSOS_ORD_HDR_NUM='"..tostring(csos_order_header_data[i].CSOS_ORD_HDR_NUM).."';",live=true};
                            print(#csos_order_details_data,prod_data[1][1].SKU_ITEM_ID,prod_data[2][1].NDC_ID,order_details_data[1],order_details_data[2])
                            matched_order_details_status=0
                            for k=1,#csos_order_details_data do  --for 3
                                if(tostring(csos_order_details_data[k].QUANTITY)==tostring(order_details_data[k].REQ_QTY) and
                                    tostring(csos_order_details_data[k].SIZE_OF_PACKAGE)==tostring(order_details_data[k].SHIP_UOM_DESC) and
                                    tostring(csos_order_details_data[k].BUYER_ITEM_NUM)==tostring(prod_data[k][1].SKU_ITEM_ID) and
                                    tostring(csos_order_details_data[k].NATIONAL_DRUG_CDE)==tostring(prod_data[k][1].NDC_ID)
                                    and tostring(csos_order_details_data[k].DEA_SCHEDULE)==tostring(prod_data[k][1].DEA_SCHEDULE) )
                            then  --if 7
                                matched_order_details_status=matched_order_details_status+1
                            end  --end if 7
                            end  --end for 3
                            if(matched_order_details_status==#order_details_data and matched_order_details_status==#csos_order_details_data )
                            then  --if 8
                                soap.soaprequest()
                                final_result=soap.getsoapresponsevalues(after_parsing)
                                print(final_result)
                                if(final_result=='N') then  --if 9
                                    -- csos_order_header_update=conn_dev:execute{sql="update 3pl_sps_ordering.csos_order_header set CSOS_ORDER_HDR_STAT ='2' where UNIQUE_TRANS_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."' ;", live=true};
                                    --  order_header_update=conn_dev:execute{sql="update  3pl_sps_ordering.order_header set  ORDER_HDR_STAT_DESC='2' where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."' ;", live=true};
                                    -- if(csos_order_header_update==nil and order_header_update==nil) then  --if 10
                                    --    log_file:write("Data updation in database is successfull  "..os.date('%x').." at :"..os.date('%X'),"\n")
                                    --    conn_dev:execute{sql=[[COMMIT;]],live=true}
                                    --   else
                                    --      conn_dev:execute{sql=[[ROLLBACK;]],live=true}
                                    UNIQUE_TRANS_NUM=csos_order_header_data[i].UNIQUE_TRANS_NUM
                                    print(UNIQUE_TRANS_NUM)
                                    updation_status = false
                                    conn_dev:execute{sql=[[START TRANSACTION;]] ,live=true};
                                    sql_update = "CALL Update_Procedure("
                                        ..conn:quote(tostring(csos_order_header_data[i].UNIQUE_TRANS_NUM))..
                                        ")"
                                    sql_update_status = conn_dev:execute{sql=sql_update, live=true};
                                    if(sql_update_status == nil) then  --if 10 -- verifying updation
                                        updation_status = true
                                        log_file:write("Data updation in database is successfull  "..os.date('%x').." at :"..os.date('%X'),"\n")
                                        conn_dev:execute{sql=[[COMMIT;]],live=true}
                                    else
                                        updation_status = false
                                        conn_dev:execute{sql=[[ROLLBACK;]],live=true}
                                    end  --end if 10
                                else
                                    mail.send_email()
                                end  --end if 9
                            else
                                conn_dev:execute{sql=[[ROLLBACK;]],live=true}
                                log_file:write("Data Present in csos_order_details and order_details tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
                                mail.send_email()
                            end -- end if 8
                        else
                            selection_status = false
                            log_file:write("Data Present in order_details_data is empty  "..os.date('%x').." at :"..os.date('%X'),"\n")
                            mail.send_email()
                        end  --end if 6
                    else
                        log_file:write("Data Present in csos_order_header and order_header tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
                        mail.send_email()
                    end  --end if 5
                else
                    log_file:write("Data Present in order_header_data or customer_billto_shipto_data is empty  "..os.date('%x').." at :"..os.date('%X'),"\n")
                    selection_status = false
                    mail.send_email()
                end   --end if 4
        end  --end for 1
        else
            selection_status = false
            log_file:write("Data Present in csos_order_header is empty "..os.date('%x').." at :"..os.date('%X'),"\n")
        end  --end if 3
    else
        log_file:write("Database connection  is not exist on : "..os.date('%x').." at :"..os.date('%X'),"\n")
        mail.send_email()
    end  --end if 1
end



function getLogFile(output_log_path)  -- function getLogFile
    result_LogFileDirectory_Status=os.fs.access(output_log_path)
    if(result_LogFileDirectory_Status==false) then  --if 11 -- checking for directory exist or not
        os.fs.mkdir(output_log_path)
    end   --end if 11
    log_file_with_today_date = "logs_2nd_channel_"..os.date("%Y-%m-%d")..".txt" --Today Date
    local log_file_verify=io.open(output_log_path..log_file_with_today_date,'r')
    if log_file_verify~=nil then  --if 12
        io.close(log_file_verify)
        return io.open(output_log_path..log_file_with_today_date,'a+')
    else
        return io.open(output_log_path..log_file_with_today_date,'w')
    end  --end if 12
end  --end function getLogFile



function DBConn() --function DBConn
    dbConnection.connectdb()
end  --end function DBConn
