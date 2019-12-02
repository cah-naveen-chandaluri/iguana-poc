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

    count=1
    if pcall(DBConn) then
        selection_status = false
        conn_dev:execute{sql=[[START TRANSACTION;]] ,live=true};
        csos_order_header_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,UNIQUE_TRANS_NUM,PO_NUMBER,PO_DATE,SHIPTO_NUM from 3pl_sps_ordering.csos_order_header where CSOS_ORDER_HDR_STAT='1';", live=true};
        if(#csos_order_header_data>0) then
            selection_status = true
        else
            selection_status = false
        end
        if(#csos_order_header_data>0 and selection_status == true) then
            for i=1,#csos_order_header_data do
                order_header_data=conn_dev:query{sql="select ELITE_ORDER,ELITE_ORDER_NUM,ORDER_NUM,CUSTOMER_NUM,CSOS_ORDER_NUM,PO_NUM,PO_DTE from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."';",live=true};
                customer_billto_shipto_data=conn_dev:query{sql="select BILLTO_NUM,ORG_CDE,CUSTOMER_NUM,SHIPTO_NUM FROM 3pl_sps_ordering.customer_billto_shipto WHERE CUSTOMER_NUM='"..order_header_data[i].CUSTOMER_NUM.."';",live=true};
            print(order_header_data[1].PO_NUM,order_header_data[1].PO_DTE,order_header_data[1].CSOS_ORDER_NUM,customer_billto_shipto_data[1].SHIPTO_NUM)
            if(#order_header_data>0 and #customer_billto_shipto_data>0) then
                    selection_status = true
                   -- for j=1,#order_header_data do
                        if(csos_order_header_data[i].PO_NUMBER==order_header_data[1].PO_NUM and csos_order_header_data[i].PO_DATE==order_header_data[1].PO_DTE and
                            csos_order_header_data[i].UNIQUE_TRANS_NUM==order_header_data[1].CSOS_ORDER_NUM and csos_order_header_data[i].SHIPTO_NUM==customer_billto_shipto_data[1].SHIPTO_NUM
                            and selection_status==true) 
                        then
                            order_details_data=conn_dev:query{sql="select REQ_QTY,SHIP_UOM_DESC,PROD_NUM from 3pl_sps_ordering.order_detail where ORDER_HDR_NUM='"..order_header_data[i].ORDER_NUM.."';",live=true};
                            if(#order_details_data>0) then
                                selection_status=true
                                for l=1,#order_details_data do
                                    prod_data=conn_dev:query{sql="select SKU_ITEM_ID,NDC_ID,DEA_SCHEDULE FROM 3pl_sps_ordering.prod where PROD_NUM='"..order_details_data[l].PROD_NUM.."';",live=true};
                                end
                                csos_order_details_data=conn_dev:query{sql="select count(CSOS_ORD_HDR_NUM),CSOS_ORD_HDR_NUM,QUANTITY,BUYER_ITEM_NUM,NATIONAL_DRUG_CDE,DEA_SCHEDULE,SIZE_OF_PACKAGE FROM 3pl_sps_ordering.csos_order_details where CSOS_ORD_HDR_NUM='"..csos_order_header_data[i].CSOS_ORD_HDR_NUM.."';",live=true};
                                for k=1,#csos_order_details_data[i]["count(CSOS_ORD_HDR_NUM)"] do
                                    --[[if(csos_order_details_data[k].QUANTITY==order_details_data[k].REQ_QTY and csos_order_details_data[k].SIZE_OF_PACKAGE==order_details_data[k].SHIP_UOM_DESC and
                                                csos_order_details_data[k].BUYER_ITEM_NUM==prod_data[k].SKU_ITEM_ID and csos_order_details_data[k].NATIONAL_DRUG_CDE==prod_data[k].NDC_ID
                                                 and csos_order_details_data[k].DEA_SCHEDULE==prod_data[k].DEA_SCHEDULE )
                                                          then]]--
                                    order_detail_result=conn_dev:query{sql="select * from 3pl_sps_ordering.order_detail where REQ_QTY='"..csos_order_details_data[k].QUANTITY.."' and SHIP_UOM_DESC='"..csos_order_details_data[k].SIZE_OF_PACKAGE.."';",live=true};
                                    prod_result= conn_dev:query{sql="select * from 3pl_sps_ordering.prod where SKU_ITEM_ID='"..csos_order_details_data[k].BUYER_ITEM_NUM.."' and NDC_ID='"..csos_order_details_data[k].NATIONAL_DRUG_CDE.."' and DEA_SCHEDULE='"..csos_order_details_data[k].DEA_SCHEDULE.."';",live=true};
                                end
                                if(#prod_data>0 and #csos_order_details_data>0 and #order_detail_result>0 and #prod_result>0) then
                                    soap.soaprequest()
                                    final_result=soap.getsoapresponsevalues(after_parsing)
                                    print(final_result)
                                    if(final_result=='N') then
                                        csos_order_header_update=conn_dev:query{sql="update 3pl_sps_ordering.csos_order_header set CSOS_ORDER_HDR_STAT ='2' where CSOS_ORDER_HDR_STAT='1' ;", live=true};
                                        order_header_update=conn_dev:query{sql="update  3pl_sps_ordering.order_header set  ORDER_HDR_STAT_DESC='2' where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."' ;", live=true};
                                        if(#csos_order_header_update>0 and #order_header_update>0) then
                                            conn_dev:execute{sql=[[COMMIT;]],live=true}
                                        else
                                            conn_dev:execute{sql=[[ROLLBACK;]],live=true}
                                        end
                                    else
                                        mail.send_email()
                                    end
                                else
                                    conn_dev:execute{sql=[[ROLLBACK;]],live=true}
                                    log_file:write("Data Present in csos_order_details and order_details tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
                                end
                            else
                                selection_status = false
                                log_file:write("Data Present in order_details_data is empty  "..os.date('%x').." at :"..os.date('%X'),"\n")
                            end
                        else
                            log_file:write("Data Present in csos_order_header and order_header tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
                        end
                    --end

                else

                    log_file:write("Data Present in order_header_data or customer_billto_shipto_data is empty  "..os.date('%x').." at :"..os.date('%X'),"\n")
                    selection_status = false


                end

            end
        else
            conn_dev:execute{sql=[[ROLLBACK;]],live=true}
        end
    else
        log_file:write("Database connection  is not exist on : "..os.date('%x').." at :"..os.date('%X'),"\n")
    end
end



function getLogFile(output_log_path)
    result_LogFileDirectory_Status=os.fs.access(output_log_path)
    if(result_LogFileDirectory_Status==false) then   -- checking for directory exist or not
        os.fs.mkdir(output_log_path)
    end
    log_file_with_today_date = "logs_2nd_channel_"..os.date("%Y-%m-%d")..".txt" --Today Date
    local log_file_verify=io.open(output_log_path..log_file_with_today_date,'r')
    if log_file_verify~=nil then
        io.close(log_file_verify)
        return io.open(output_log_path..log_file_with_today_date,'a+')
    else
        return io.open(output_log_path..log_file_with_today_date,'w')
    end
end



function DBConn()
    dbConnection.connectdb()
end
