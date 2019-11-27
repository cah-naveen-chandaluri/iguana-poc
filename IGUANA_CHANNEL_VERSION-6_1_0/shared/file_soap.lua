local file_soap={}

function file_soap.soaprequest(table)
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
 
     Response = net.http.post{response_headers_format='raw',body=soap_template,url=URL,live=true}
   print(Response)
   after_parsing =xml.parse{data=Response}
   print(after_parsing)
     net.http.respond{headers='',body='',persist=false,code=5}

      end
   
file_soap.soaprequest(table)
   
function file_soap.getsoapresponsevalues(after_parsing)
     result=after_parsing["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OnHold:nodeText()
  return result
   end

  final_result=file_soap.getsoapresponsevalues(after_parsing)
   print(final_result)
   
if(final_result=='N') then
   print("successful")
   else
    mail.send_email()
end
   
  

return file_soap