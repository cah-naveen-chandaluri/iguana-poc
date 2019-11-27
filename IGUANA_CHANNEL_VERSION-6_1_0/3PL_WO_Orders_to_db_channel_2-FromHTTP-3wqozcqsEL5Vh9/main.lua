URL='https://spselitestg.cardinalhealth.net/stage_841/ws/DmsWebService'
net.http.respond{headers='',body='HELLO',persist=false,code=5}
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


    log_file = getLogFile(output_log_path)
    log_file:write(TIME_STAMP.."******* Iguana channel Started Running *******","\n")



    function DBConn()
        dbConnection.connectdb()
    end

    if pcall(DBConn) then
    --Join for header data
    --select csos_o_h.CSOS_ORD_HDR_NUM,csos_o_h.UNIQUE_TRANS_NUM,csos_o_h.PO_NUMBER,csos_o_h.PO_DATE,csos_o_h.SHIPTO_NUM,csos_o_h.CSOS_ORDER_HDR_STAT,o_h.ORDER_NUM,o_h.CUSTOMER_NUM,o_h.CSOS_ORDER_NUM,o_h.PO_NUM,o_h.PO_DTE, cust_bill_ship.SHIPTO_NUM from 3pl_sps_ordering.csos_order_header csos_o_h 
    --INNER JOIN 3pl_sps_ordering.order_header o_h ON o_h.CSOS_ORDER_NUM = csos_o_h.UNIQUE_TRANS_NUM 
    --INNER JOIN 3pl_sps_ordering.customer_billto_shipto cust_bill_ship ON cust_bill_ship.CUSTOMER_NUM = o_h.CUSTOMER_NUM 
    --where csos_o_h.CSOS_ORDER_HDR_STAT = 1 and csos_o_h.PO_NUMBER = o_h.PO_NUM
    --and csos_o_h.PO_DATE = o_h.PO_DTE and csos_o_h.SHIPTO_NUM = cust_bill_ship.SHIPTO_NUM
    --and csos_o_h.UNIQUE_TRANS_NUM = o_h.CSOS_ORDER_NUM;
       

csos_order_header_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,UNIQUE_TRANS_NUM,PO_NUMBER,PO_DATE,SHIPTO_NUM from 3pl_sps_ordering.csos_order_header where CSOS_ORDER_HDR_STAT='1';", live=true};

      
      
      for i=1,#csos_order_header_data do
     order_header_data=conn_dev:query{sql="select ORDER_NUM,CUSTOMER_NUM,CSOS_ORDER_NUM,PO_NUM,PO_DTE from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."';",live=true};

        customer_billto_shipto_data=conn_dev:query{sql="select CUSTOMER_NUM,SHIPTO_NUM FROM 3pl_sps_ordering.customer_billto_shipto WHERE CUSTOMER_NUM='"..order_header_data[i].CUSTOMER_NUM.."';",live=true};
        end
      for i=1,#csos_order_header_data do

cursor5=conn_dev:query{sql="select * from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."' and PO_NUM='"..csos_order_header_data[i].PO_NUMBER.."' and PO_DTE='"..csos_order_header_data[i].PO_DATE.."';", live=true};
  cursor6=conn_dev:query{sql="select * from csos_order_header where SHIPTO_NUM='"..customer_billto_shipto_data[i].SHIPTO_NUM.."';",live=true};
        
end    
   if(cursor5~=nil and cursor6~=nil) then
     -- if(csos_order_header_data[1].PO_NUMBER==order_header_data[1].PO_NUM and csos_order_header_data[1].PO_DATE==order_header_data[1].PO_DTE and 
       --  csos_order_header_data[1].UNIQUE_TRANS_NUM==order_header_data[1].CSOS_ORDER_NUM and csos_order_header_data[1].SHIPTO_NUM==customer_billto_shipto_data[1].SHIPTO_NUM) then
         
         for i=1,#csos_order_header_data do
         order_details_data=conn_dev:query{sql="select REQ_QTY,SHIP_UOM_DESC,PROD_NUM from 3pl_sps_ordering.order_detail where ORDER_HDR_NUM='"..order_header_data[i].ORDER_NUM.."';",live=true};

         prod_data=conn_dev:query{sql="select SKU_ITEM_ID,NDC_ID,DEA_SCHEDULE FROM 3pl_sps_ordering.prod where PROD_NAM='"..order_details_data[i].PROD_NUM.."';",live=true};
       
         csos_order_details_data=conn_dev:query{sql="select QUANTITY,BUYER_ITEM_NUM,NATIONAL_DRUG_CDE,DEA_SCHEDULE,SIZE_OF_PACKAGE FROM 3pl_sps_ordering.csos_order_details where CSOS_ORD_HDR_NUM='"..csos_order_header_data[i].CSOS_ORD_HDR_NUM.."';",live=true};
        end
            for i=1,#csos_order_header_data do
               cursor7=conn_dev:query{sql="select * from  3pl_sps_ordering.order_detail where REQ_QTY='"..csos_order_details_data[i].QUANTITY.."' and SHIP_UOM_DESC='"..csos_order_details_data[i].SIZE_OF_PACKAGE.."';",live=true};
         cursor8=conn_dev:query{sql="select * from 3pl_sps_ordering.prod where SKU_ITEM_ID='"..csos_order_details_data[i].BUYER_ITEM_NUM.."' and NDC_ID='"..csos_order_details_data[i].NATIONAL_DRUG_CDE.."' and DEA_SCHEDULE='"..csos_order_details_data[i].DEA_SCHEDULE.."';",live=true};
            if(cursor7~=nil and cursor8~=nil) then
            
            

          newFile = io.open( "C:\\3PL_WO\\SOAP\\soapdata.txt", "w+" )
    --local R =net.http.post{url=URL,live=true}
   F=io.open("C:\\3PL_WO\\SOAP\\soaprequest.txt","r")
          Data =  F:read('*a')
         F:close()
    --local R = net.http.post{response_headers_format='raw',body='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsc="wsclient.dms.tecsys.com"><soapenv:Header/><soapenv:Body><wsc:update><arg0><userName>tecuser</userName><password>supt2013</password><sessionId>0</sessionId><transactions><action>update</action><data><DmsOrd-Update-OrderHoldWebordering><Organization>EP</Organization><Division>01</Division><Order>141302</Order><Customer>EP10023</Customer><DmsOrdHoldWebordering><Line><OrderId>52135534</OrderId><HoldSequence>1</HoldSequence><HoldCode>CSWB</HoldCode><OnHold>N</OnHold><DateAndTimeOrderReleasedFromHold>2019-11-15</DateAndTimeOrderReleasedFromHold><ReleaseComment>validated</ReleaseComment></Line></DmsOrdHoldWebordering></DmsOrd-Update-OrderHoldWebordering></data></transactions></arg0></wsc:update></soapenv:Body></soapenv:Envelope>',url=URL,live=true}
   R = net.http.post{response_headers_format='raw',body=Data,url=URL,live=true}
     X =xml.parse{data=R}


    c=net.http.respond{headers='',body=X["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OnHold:nodeText(),persist=false,code=5}
    print(c)

    newFile:write(c)

    newFile:close()



    function remove( filename, starting_line, num_lines )

         fp = io.open( filename, "r" )
        if fp == nil then
            return nil
        end
        content = {}
        i = 1;
        for line in fp:lines() do
            if i < starting_line or i >= starting_line + num_lines then
                content[#content+1] = line
            end
            i = i + 1
        end
        --print(content)
        if i > starting_line and i < starting_line + num_lines then
            print( "Warning: Tried to remove lines after EOF." )
        end
        fp:close()


        fp = io.open("C:\\3PL_WO\\SOAP\\soapdatacopy.txt", "w+" )
        for i = 1, #content do
            fp:write( string.format( "%s\n", content[i] ) )
        end
        fp:close()

    end

    remove('C:\\3PL_WO\\SOAP\\soapdata.txt',1,10)



    fp = io.open("C:\\3PL_WO\\SOAP\\soapdatacopy.txt", "r+" )
     Content =  fp:read('*a')
    print(Content)
 
            else
                log_file:write("Data Present in csos_order_details and order_details tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
            end
               end
         
         else 
         log_file:write("Data Present in csos_order_header and order_header tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
         end
    
   else
        log_file:write("Database connection  is not exist on : "..os.date('%x').." at :"..os.date('%X'),"\n")
    end



end
  
   
 

