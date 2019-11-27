URL='https://spselitestg.cardinalhealth.net/stage_841/ws/DmsWebService'
net.http.respond{headers='',body='HELLO',persist=false,code=5}
function main()

    properties = require("properties")
    Validation = require("Validation")
    constants = require("Constants")
   
   mail=require("mail")
   --soap=require("file_soap")
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

       

csos_order_header_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,UNIQUE_TRANS_NUM,PO_NUMBER,PO_DATE,SHIPTO_NUM from 3pl_sps_ordering.csos_order_header where CSOS_ORDER_HDR_STAT='1';", live=true};

      
      
      for i=1,#csos_order_header_data do
     order_header_data=conn_dev:query{sql="select ELITE_ORDER,ELITE_ORDER_NUM,ORDER_NUM,CUSTOMER_NUM,CSOS_ORDER_NUM,PO_NUM,PO_DTE from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."';",live=true};

        customer_billto_shipto_data=conn_dev:query{sql="select BILLTO_NUM,ORG_CDE,CUSTOMER_NUM,SHIPTO_NUM FROM 3pl_sps_ordering.customer_billto_shipto WHERE CUSTOMER_NUM='"..order_header_data[i].CUSTOMER_NUM.."';",live=true};
     

cursor5=conn_dev:query{sql="select * from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..csos_order_header_data[i].UNIQUE_TRANS_NUM.."' and PO_NUM='"..csos_order_header_data[i].PO_NUMBER.."' and PO_DTE='"..csos_order_header_data[i].PO_DATE.."';", live=true};
  cursor6=conn_dev:query{sql="select * from csos_order_header where SHIPTO_NUM='"..customer_billto_shipto_data[i].SHIPTO_NUM.."';",live=true};
        
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
      
   if(cursor5~=nil and cursor6~=nil) then
         
        -- if(cursor~=nil) then
     -- if(csos_order_header_data[1].PO_NUMBER==order_header_data[1].PO_NUM and csos_order_header_data[1].PO_DATE==order_header_data[1].PO_DTE and 
       --  csos_order_header_data[1].UNIQUE_TRANS_NUM==order_header_data[1].CSOS_ORDER_NUM and csos_order_header_data[1].SHIPTO_NUM==customer_billto_shipto_data[1].SHIPTO_NUM) then
         
         for i=1,#csos_order_header_data do
         order_details_data=conn_dev:query{sql="select REQ_QTY,SHIP_UOM_DESC,PROD_NUM from 3pl_sps_ordering.order_detail where ORDER_HDR_NUM='"..order_header_data[i].ORDER_NUM.."';",live=true};

         prod_data=conn_dev:query{sql="select SKU_ITEM_ID,NDC_ID,DEA_SCHEDULE FROM 3pl_sps_ordering.prod where PROD_NAM='"..order_details_data[i].PROD_NUM.."';",live=true};
       
         csos_order_details_data=conn_dev:query{sql="select QUANTITY,BUYER_ITEM_NUM,NATIONAL_DRUG_CDE,DEA_SCHEDULE,SIZE_OF_PACKAGE FROM 3pl_sps_ordering.csos_order_details where CSOS_ORD_HDR_NUM='"..csos_order_header_data[i].CSOS_ORD_HDR_NUM.."';",live=true};
     
               cursor7=conn_dev:query{sql="select * from  3pl_sps_ordering.order_detail where REQ_QTY='"..csos_order_details_data[i].QUANTITY.."' and SHIP_UOM_DESC='"..csos_order_details_data[i].SIZE_OF_PACKAGE.."';",live=true};
         cursor8=conn_dev:query{sql="select * from 3pl_sps_ordering.prod where SKU_ITEM_ID='"..csos_order_details_data[i].BUYER_ITEM_NUM.."' and NDC_ID='"..csos_order_details_data[i].NATIONAL_DRUG_CDE.."' and DEA_SCHEDULE='"..csos_order_details_data[i].DEA_SCHEDULE.."';",live=true};
            end 
         
         if(cursor7~=nil and cursor8~=nil) then
            

               
table1,table2,table3,table4={},{},{},{}
for i=1,#csos_order_header_data do
      
      table1[i]=csos_order_header_data[i].CSOS_ORD_HDR_NUM
     table2[i]=csos_order_header_data[i].UNIQUE_TRANS_NUM
      table3[i]=csos_order_header_data[i].PO_NUMBER
      table4[i]=csos_order_header_data[i].PO_DATE
      
      --table1[i]=order_header_data[i].ELITE_ORDER
      --table2[i]=order_header_data[i].ELITE_ORDER_NUM
      --table3[i]=customer_billto_shipto_data[i].ORG_CDE
      --table4[i]=customer_billto_shipto_data[i].BILLTO_NUM
      end
   
   print(table1,table2,table3,table4)
   table={table1,table2,table3,table4}
print(table[1][1],table[2][1],table[3][1],table[4][1])
   
 
         --  soap.soaprequest(table)
            
               
         function soaprequest(table)
   print(table)
   --function sopa.soaprequest(table1,table2,table3,table4)
   soap_template='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsc="wsclient.dms.tecsys.com"><soapenv:Header/><soapenv:Body><wsc:update><arg0><userName>tecuser</userName><password>supt2013</password><sessionId>0</sessionId><transactions><action>update</action><data><DmsOrd-Update-OrderHoldWebordering><Organization>'..table[1][1]..'</Organization><Division>01</Division><Order>'..table[2][1]..'</Order><Customer>'..table[3][1]..'</Customer><DmsOrdHoldWebordering><Line><OrderId>'..table[4][1]..'</OrderId><HoldSequence>1</HoldSequence><HoldCode>CSWB</HoldCode><OnHold>N</OnHold><DateAndTimeOrderReleasedFromHold>'..os.date()..'</DateAndTimeOrderReleasedFromHold><ReleaseComment>validated</ReleaseComment></Line></DmsOrdHoldWebordering></DmsOrd-Update-OrderHoldWebordering></data></transactions></arg0></wsc:update></soapenv:Body></soapenv:Envelope>'
--soap_template='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsc="wsclient.dms.tecsys.com"><soapenv:Header/><soapenv:Body><wsc:update><arg0><userName>tecuser</userName><password>supt2013</password><sessionId>0</sessionId><transactions><action>update</action><data><DmsOrd-Update-OrderHoldWebordering><Organization>'..csos_order_header_data[i].CSOS_ORD_HDR_NUM..'</Organization><Division>01</Division><Order>'..csos_order_header_data[i].UNIQUE_TRANS_NUM..'</Order><Customer>'..csos_order_header_data[i].PO_NUMBER..'</Customer><DmsOrdHoldWebordering><Line><OrderId>'..csos_order_header_data[i].PO_DATE..'</OrderId><HoldSequence>1</HoldSequence><HoldCode>CSWB</HoldCode><OnHold>N</OnHold><DateAndTimeOrderReleasedFromHold>'..os.date()..'</DateAndTimeOrderReleasedFromHold><ReleaseComment>validated</ReleaseComment></Line></DmsOrdHoldWebordering></DmsOrd-Update-OrderHoldWebordering></data></transactions></arg0></wsc:update></soapenv:Body></soapenv:Envelope>'
      --soap_template='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsc="wsclient.dms.tecsys.com"><soapenv:Header/><soapenv:Body><wsc:update><arg0><userName>tecuser</userName><password>supt2013</password><sessionId>0</sessionId><transactions><action>update</action><data><DmsOrd-Update-OrderHoldWebordering><Organization>'..customer_billto_shipto_data[1].ORG_CDE..'</Organization><Division>01</Division><Order>'..order_header_data[1].ELITE_ORDER..'</Order><Customer>'..customer_billto_shipto_data[1].BILLTO_NUM..'</Customer><DmsOrdHoldWebordering><Line><OrderId>'..order_header_data[1].ELITE_ORDER_NUM..'</OrderId><HoldSequence>1</HoldSequence><HoldCode>CSWB</HoldCode><OnHold>N</OnHold><DateAndTimeOrderReleasedFromHold>'..os.date()..'</DateAndTimeOrderReleasedFromHold><ReleaseComment>validated</ReleaseComment></Line></DmsOrdHoldWebordering></DmsOrd-Update-OrderHoldWebordering></data></transactions></arg0></wsc:update></soapenv:Body></soapenv:Envelope>'
   --[[   a= string.gsub(soap_template ,'tecuser','tecuser')
      b=string.gsub(a,'supt2013','supt2013')
      c=string.gsub(b,'EP','EP')
      d=string.gsub(c,'141302','141304')
      e=string.gsub(d,'EP10023','EP10024')
      f=string.gsub(e,'52135534','52135536')
      g=string.gsub(f,'2019-11-15','2019-11-25')
     ]]--
 print(soap_template)
     Response = net.http.post{response_headers_format='raw',body=soap_template,url=URL,live=true}
   print(Response)
   after_parsing =xml.parse{data=Response}
   print(after_parsing)
     net.http.respond{headers='',body='',persist=false,code=5}

      end
   
soaprequest(table)
   
function getsoapresponsevalues(after_parsing)
     result=after_parsing["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OnHold:nodeText()
  return result
   end

  final_result=getsoapresponsevalues(after_parsing)
   print(final_result)
   
if(final_result=='N') then
   print("successful")
   else
    mail.send_email()
end
   
   
               
  
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
  
   
 

