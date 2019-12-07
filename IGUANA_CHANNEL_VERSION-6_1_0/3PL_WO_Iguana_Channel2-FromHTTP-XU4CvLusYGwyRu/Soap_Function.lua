local Soap_Function={}

function Soap_Function.soaprequest()
    net.http.respond{headers='',body='',persist=false,code=5}
    soap_template='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsc="wsclient.dms.tecsys.com"><soapenv:Header/><soapenv:Body><wsc:update><arg0><userName>tecuser</userName><password>supt2013</password><sessionId>0</sessionId><transactions><action>update</action><data><DmsOrd-Update-OrderHoldWebordering><Organization>'..customer_billto_shipto_data[1].ORG_CDE..'</Organization><Division>01</Division><Order>'..order_header_data[1].ELITE_ORDER..'</Order><Customer>'..customer_billto_shipto_data[1].BILLTO_NUM..'</Customer><DmsOrdHoldWebordering><Line><OrderId>'..order_header_data[1].ELITE_ORDER_NUM..'</OrderId><HoldSequence>'..SEQ_CODE[1].SEQ..'</HoldSequence><HoldCode>CSWB</HoldCode><OnHold>N</OnHold><DateAndTimeOrderReleasedFromHold>'..os.date()..'</DateAndTimeOrderReleasedFromHold><ReleaseComment>validated</ReleaseComment></Line></DmsOrdHoldWebordering></DmsOrd-Update-OrderHoldWebordering></data></transactions></arg0></wsc:update></soapenv:Body></soapenv:Envelope>'
    log_file:write(soap_template,"\n")
    URL='https://spselitestg.cardinalhealth.net/stage_841/ws/DmsWebService'
    Response = net.http.post{response_headers_format='raw',body=soap_template,url=URL,live=true}
    soapResponse =xml.parse{data=Response}
   --log_file:write(after_parsing,"\n")
    
end

function Soap_Function.getsoapresponsestatus(soapResponse)
   if(Soap_Function.validationSoapResponse(soapResponse) == true) then
    -- Retriving soap and transation status code and description and onhold status
    local status_code=soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].status.code:nodeText()
    local status_description=soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].status.description:nodeText()
    local transaction_code=soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.status.code:nodeText()
    local transaction_description=soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.status.description:nodeText()
    local onhold_result=soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OnHold:nodeText()
   
    local status_result = false
    if(status_code==0 and status_description=="Successful" and transaction_code==0 and transaction_description=="Successful" 
      and onhold_result=='N') then
      return true
    else
      return false
    end
   else
      return false
   end
end

function Soap_Function.validationSoapResponse(soapResponse)
    
   if(soapResponse~=nil and soapResponse["soap:Envelope"]~=nil and soapResponse["soap:Envelope"]["soap:Body"] ~= nil
      and soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"] ~=nil 
      and soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"] ~= nil
      and soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].status.code ~= nil 
      and soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].status.description ~=nil
      and soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.status.code ~= nil
      and soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.status.description ~= nil
      and soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OnHold ~= nil
      and soapResponse["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.Errors == nil
      ) then 
      return true
   else
      return false
   end  
end

return Soap_Function