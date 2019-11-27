local soap={}

function soap.soaprequest(username,password,orderID,org)
   newFile = io.open( "C:\\3PL_WO\\SOAP\\soapdata", "w+" )
   
    read_order_file='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsc="wsclient.dms.tecsys.com"><soapenv:Header/><soapenv:Body><wsc:update><arg0><userName>'..username..'</userName><password>'..password..'</password><sessionId>0</sessionId><transactions><action>update</action><data><DmsOrd-Update-OrderHoldWebordering><Organization>EP</Organization><Division>01</Division><Order>141302</Order><Customer>EP10023</Customer><DmsOrdHoldWebordering><Line><OrderId>52135534</OrderId><HoldSequence>1</HoldSequence><HoldCode>CSWB</HoldCode><OnHold>N</OnHold><DateAndTimeOrderReleasedFromHold>2019-11-15</DateAndTimeOrderReleasedFromHold><ReleaseComment>validated</ReleaseComment></Line></DmsOrdHoldWebordering></DmsOrd-Update-OrderHoldWebordering></data></transactions></arg0></wsc:update></soapenv:Body></soapenv:Envelope>'

 --[[  X =xml.parse{data=read_order_file}
   print(X)
print(type(X))

   username=tostring(X["soapenv:Envelope"]["soapenv:Body"]["wsc:update"].arg0.userName:nodeText())
   password=tostring(X["soapenv:Envelope"]["soapenv:Body"]["wsc:update"].arg0.password:nodeText())
   organization=tostring(X["soapenv:Envelope"]["soapenv:Body"]["wsc:update"].arg0.transactions.data["DmsOrd-Update-OrderHoldWebordering"].Organization:nodeText())
  order=tostring(X["soapenv:Envelope"]["soapenv:Body"]["wsc:update"].arg0.transactions.data["DmsOrd-Update-OrderHoldWebordering"].Order:nodeText())
  customer=tostring(X["soapenv:Envelope"]["soapenv:Body"]["wsc:update"].arg0.transactions.data["DmsOrd-Update-OrderHoldWebordering"].Customer:nodeText()) 
  order_Id=tostring(X["soapenv:Envelope"]["soapenv:Body"]["wsc:update"].arg0.transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OrderId:nodeText()) 
   date_and_time=tostring(X["soapenv:Envelope"]["soapenv:Body"]["wsc:update"].arg0.transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.DateAndTimeOrderReleasedFromHold:nodeText())
   print(type(username))
 
]]--
      a= string.gsub(read_order_file ,'tecuser','tecuser')
      b=string.gsub(a,'supt2013','supt2013')
      c=string.gsub(b,'EP','EP')
      d=string.gsub(c,'141302','141304')
      e=string.gsub(d,'EP10023','EP10024')
      f=string.gsub(e,52135534,52135536)
      g=string.gsub(f,2019-11-15,2019-11-25)
     
 
 print(g)
     R = net.http.post{response_headers_format='raw',body=g,url=URL,live=true}
   print(R)
   aa =xml.parse{data=R}
   print(aa)
     --c=net.http.respond{headers='',body=aa["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OnHold:nodeText(),persist=false,code=5}
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


        fp = io.open("C:\\3PL_WO\\SOAP\\soapdataresult.txt", "w+" )
        for i = 1, #content do
            fp:write( string.format( "%s\n", content[i] ) )
        end
        fp:close()

    end

    remove('C:\\3PL_WO\\SOAP\\soapdata.txt',1,10)



    fp = io.open("C:\\3PL_WO\\SOAP\\soapdataresult.txt", "r+" )
     Content =  fp:read('*a')
    print(Content)
   
   
   
   end
return soap