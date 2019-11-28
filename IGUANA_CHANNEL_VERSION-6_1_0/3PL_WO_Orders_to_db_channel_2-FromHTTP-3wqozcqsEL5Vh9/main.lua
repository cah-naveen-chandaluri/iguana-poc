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


    if pcall(DBConn) then

        csos_order_header_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,UNIQUE_TRANS_NUM,PO_NUMBER,PO_DATE,SHIPTO_NUM from 3pl_sps_ordering.csos_order_header where CSOS_ORDER_HDR_STAT='1';", live=true};

        for i=1,#csos_order_header_data do
           
           order_header_data=conn_dev:query{sql="select ELITE_ORDER,ELITE_ORDER_NUM,ORDER_NUM,CUSTOMER_NUM,CSOS_ORDER_NUM,PO_NUM,PO_DTE from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."';",live=true};

            customer_billto_shipto_data=conn_dev:query{sql="select BILLTO_NUM,ORG_CDE,CUSTOMER_NUM,SHIPTO_NUM FROM 3pl_sps_ordering.customer_billto_shipto WHERE CUSTOMER_NUM='"..order_header_data[i].CUSTOMER_NUM.."';",live=true};

                order_details_data=conn_dev:query{sql="select REQ_QTY,SHIP_UOM_DESC,PROD_NUM from 3pl_sps_ordering.order_detail where ORDER_HDR_NUM='"..order_header_data[i].ORDER_NUM.."';",live=true};

                prod_data=conn_dev:query{sql="select SKU_ITEM_ID,NDC_ID,DEA_SCHEDULE FROM 3pl_sps_ordering.prod where PROD_NAM='"..order_details_data[i].PROD_NUM.."';",live=true};

                csos_order_details_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,QUANTITY,BUYER_ITEM_NUM,NATIONAL_DRUG_CDE,DEA_SCHEDULE,SIZE_OF_PACKAGE FROM 3pl_sps_ordering.csos_order_details where CSOS_ORD_HDR_NUM='"..csos_order_header_data[i].CSOS_ORD_HDR_NUM.."';",live=true};
          end
           

      for i=1,#csos_order_header_data do 
     
         for j=1,#csos_order_header_data do
         
         
        if(csos_order_header_data[i].PO_NUMBER==order_header_data[j].PO_NUM and csos_order_header_data[i].PO_DATE==order_header_data[j].PO_DTE and
        csos_order_header_data[i].UNIQUE_TRANS_NUM==order_header_data[j].CSOS_ORDER_NUM and csos_order_header_data[i].SHIPTO_NUM==customer_billto_shipto_data[j].SHIPTO_NUM) then
      
   for i=1,#csos_order_header_data do
           for j=1,#csos_order_header_data do
                     
           if(csos_order_details_data[i].QUANTITY==order_details_data[j].REQ_QTY and csos_order_details_data[i].SIZE_OF_PACKAGE[i]==order_details_data[j].SHIP_UOM_DESC and
              csos_order_details_data[i].BUYER_ITEM_NUM==prod_data[j].SKU_ITEM_ID and csos_order_details_data[i].NATIONAL_DRUG_CDE==prod_data[j].NDC_ID 
              and csos_order_details_data[i].DEA_SCHEDULE==prod_data[j].DEA_SCHEDULE and csos_order_header_data[i].CSOS_ORD_HDR_NUM==csos_order_details_data[j].CSOS_ORD_HDR_NUM)
           then          
                        
                            soap.soaprequest()
               final_result=soap.getsoapresponsevalues(after_parsing)
                            print(final_result)

                if(final_result=='N') then
                    csos_order_header_update=conn_dev:query{sql="update 3pl_sps_ordering.csos_order_header set CSOS_ORDER_HDR_STAT ='2' where CSOS_ORDER_HDR_STAT='1' ;", live=true};
                    order_header_update=conn_dev:query{sql="update  3pl_sps_ordering.order_header set  ORDER_HDR_STAT_DESC='2' where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."' ;", live=true};
                else
                    mail.send_email()
                end
  
            else
                log_file:write("Data Present in csos_order_details and order_details tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
            end
                  end
                  end

        else
            log_file:write("Data Present in csos_order_header and order_header tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
        end
end
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

        log_file_with_today_date = "logs_"..os.date("%Y-%m-%d")..".txt" --Today Date
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


      --[[   cursor6=conn_dev:query{sql=
         select t1.CSOS_ORD_HDR_NUM,t1.UNIQUE_TRANS_NUM,t1.PO_NUMBER,t1.PO_DATE,t1.SHIPTO_NUM,
         t2.ORDER_NUM,t2.CUSTOMER_NUM,t2.CSOS_ORDER_NUM,
t2.PO_NUM,t2.PO_DTE,t3.CUSTOMER_NUM,t3.SHIPTO_NUM from 3pl_sps_ordering.csos_order_header t1 inner join 
3pl_sps_ordering.order_header t2 on (t1.CSOS_ORDER_HDR_STAT='1' and t2.CSOS_ORDER_NUM=t1.UNIQUE_TRANS_NUM
and t2.PO_NUM=t1.PO_NUMBER and t1.PO_DATE=t2.PO_DTE) inner join 3pl_sps_ordering.customer_billto_shipto t3 on
(t1.SHIPTO_NUM=t3.SHIPTO_NUM)
         ,live=true}; 
      ]]--
        --[[   select t1.CSOS_ORD_HDR_NUM,t1.UNIQUE_TRANS_NUM,t1.PO_NUMBER,t1.PO_DATE,t1.SHIPTO_NUM,t2.ORDER_NUM,t2.CUSTOMER_NUM,
t2.CSOS_ORDER_NUM,t2.PO_NUM,t2.PO_DTE,t3.CUSTOMER_NUM,t3.SHIPTO_NUM from 3pl_sps_ordering.csos_order_header t1 
full outer join 3pl_sps_ordering.order_header t2 on (t1.CSOS_ORDER_HDR_STAT='1' and
 t2.CSOS_ORDER_NUM=t1.UNIQUE_TRANS_NUM
and t2.PO_NUM=t1.PO_NUMBER and t1.PO_DTE=t2.PO_DATE) left outer join 3pl_sps_ordering.customer_billto_shipto on
(t1.SHIPTO_NUM=t3.SHIPTO_NUM) 
 
 union
 
select t1.CSOS_ORD_HDR_NUM,t1.UNIQUE_TRANS_NUM,t1.PO_NUMBER,t1.PO_DATE,t1.SHIPTO_NUM,t2.ORDER_NUM,t2.CUSTOMER_NUM,
t2.CSOS_ORDER_NUM,t2.PO_NUM,t2.PO_DTE,t3.CUSTOMER_NUM,t3.SHIPTO_NUM from 3pl_sps_ordering.csos_order_header t1 
full outer join 3pl_sps_ordering.order_header t2 on (t1.CSOS_ORDER_HDR_STAT='1' and
 t2.CSOS_ORDER_NUM=t1.UNIQUE_TRANS_NUM
and t2.PO_NUM=t1.PO_NUMBER and t1.PO_DTE=t2.PO_DATE) right outer join 3pl_sps_ordering.customer_billto_shipto on
(t1.SHIPTO_NUM=t3.SHIPTO_NUM)  
      ]]--
   
   
   
--[[
                table1,table2,table3,table4={},{},{},{}
                for i=1,#csos_order_header_data do

                    table1[i]=csos_order_header_data[i].CSOS_ORD_HDR_NUM
                    table2[i]=csos_order_header_data[i].UNIQUE_TRANS_NUM
                    table3[i]=csos_order_header_data[i].PO_NUMBER
                    table4[i]=csos_order_header_data[i].PO_DATE

                    table1[i]=order_header_data[i].ELITE_ORDER
                    table2[i]=order_header_data[i].ELITE_ORDER_NUM
                    table3[i]=customer_billto_shipto_data[i].ORG_CDE
                    table4[i]=customer_billto_shipto_data[i].BILLTO_NUM
                end

                print(table1,table2,table3,table4)
                table={table1,table2,table3,table4}
                print(table[1][1],table[2][1],table[3][1],table[4][1])


                --  soap.soaprequest(table)
]]--
   
   
                       --[[   a= string.gsub(soap_template ,'tecuser','tecuser')
      b=string.gsub(a,'supt2013','supt2013')
      c=string.gsub(b,'EP','EP')
      d=string.gsub(c,'141302','141304')
      e=string.gsub(d,'EP10023','EP10024')
      f=string.gsub(e,'52135534','52135536')
      g=string.gsub(f,'2019-11-15','2019-11-25')
     ]]--
                    
