--URL='https://spselitestg.cardinalhealth.net/stage_841/ws/DmsWebService'
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

       

csos_order_header_data=conn_dev:query{sql="select UNIQUE_TRANS_NUM,PO_NUMBER,PO_DATE,SHIPTO_NUM from 3pl_sps_ordering.csos_order_header where CSOS_ORDER_HDR_STAT='1';", live=true};
      print(csos_order_header_data[1].UNIQUE_TRANS_NUM,csos_order_header_data[1].PO_NUMBER,csos_order_header_data[1].PO_DATE,csos_order_header_data[1].SHIPTO_NUM)
      
      
      for i=1,#csos_order_header_data do
     order_header_data=conn_dev:query{sql="select CUSTOMER_NUM,CSOS_ORDER_NUM,PO_NUM,PO_DTE from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."';",live=true};
print(order_header_data[1].CUSTOMER_NUM,order_header_data[1].PO_NUM,order_header_data[1].PO_DTE,order_header_data[1].CSOS_ORDER_NUM)
        customer_billto_shipto_data=conn_dev:query{sql="select CUSTOMER_NUM,SHIPTO_NUM FROM 3pl_sps_ordering.customer_billto_shipto WHERE CUSTOMER_NUM='"..order_header_data[i].CUSTOMER_NUM.."';",live=true};
         print(customer_billto_shipto_data[1].CUSTOMER_NUM,customer_billto_shipto_data[1].SHIPTO_NUM)
print(csos_order_header_data[2].UNIQUE_TRANS_NUM)

--cursor5=conn_dev:query{sql="select * from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."' and PO_NUM='"..csos_order_header_data[i].PO_NUMBER.."' and PO_DTE='"..csos_order_header_data[i].PO_DATE.."';", live=true};
  -- cursor6=conn_dev:query{sql="select * from csos_order_header where SHIPTO_NUM='"..customer_billto_shipto_data[i].SHIPTO_NUM.."';",live=true};
        
         end
      if(csos_order_header_data[1].PO_NUMBER==order_header_data[1].PO_NUM and csos_order_header_data[1].PO_DATE==order_header_data[1].PO_DTE and 
         csos_order_header_data[1].UNIQUE_TRANS_NUM==order_header_data[1].CSOS_ORDER_NUM and csos_order_header_data[1].SHIPTO_NUM==customer_billto_shipto_data[1].SHIPTO_NUM) then
         
         print("hello")
         
       -- cursor7== it will check comparision for csos_order_details and order_details
         
         if(cursor7~=nil) then
            
            
          
         
         
            
         --[[  newFile = io.open( "C:\\3PL_WO\\SOAP\\soapdata.txt", "w+" )
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
   
   
   ]]--
            
            else
                log_file:write("Data Present in csos_order_details and order_details tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
            end
         
         else 
         log_file:write("Data Present in csos_order_header and order_header tables are not equal "..os.date('%x').." at :"..os.date('%X'),"\n")
         end
   else
        log_file:write("Database connection  is not exist on : "..os.date('%x').." at :"..os.date('%X'),"\n")
    end



end
  
   
 

