function main()
   
     local url = "C:\\3PL\\XMLdata.xml"
   
     function GetFileExtension(url)
        return url:match("^.+(%..+)$")
     end
   
   --calling function GetFileExtension()
   
     c=GetFileExtension(url)
   
        print(c)
   
     local a='.xml'
        print(a,c)
     if(c==a) then
      
            --reading data from a file
      
               local F = io.open('C:\\3PL\\XMLdata.xml', "r")
               local Content =  F:read('*a')
               F:close()
               local Msg = xml.parse(Content)  
               print(Msg)  
      
            --Here we are giving the database connection
      
               local conn = db.connect
               {
                     api = db.MY_SQL,
                     name = 'test',
                     user = 'root',
                     password = '',
                     use_unicode=true,
                     live = true
               }
     
            --Inserting data into the orders table
      
               for i=1,n do
         
               local SqlInsert =
                    [[
                      INSERT INTO orders
                          (
   
                          BuyerItemNumber,Form,LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                          SizeOfPackages,Strength,SupplierItemNumber
                          )
                      VALUES
                         (
  
                          ]]..
  
      
             --Here i am going to insert values this can be done after database connection is established 
             --The below commented lines has to be replaced by new one
      
      
                           --[["'"..Msg.patients.patient.id.."',"..
                               "\n   '"..Msg.patients.patient["first-name"][1].."',"..
                               "\n   '"..Msg.patients.patient["last-name"][1].."',"..
                               "\n   '"..Msg.patients.patient["social-security-no"][1].."'"..
                               '\n   )'  ]]--
   
                              -- "'"..Content.."')"
             -- Insert data into database
                        Conn:execute{sql=SqlInsert, live=true} 
                        print(os.date("%x"))         --this will give the current date
         
                end
                        Conn:execute('SELECT * FROM orders')
     
 
             --inserting data into the order_summary table
      
                 for i=1,n do
  
                 local SqlInsert2 =
                         [[
                          INSERT INTO order_summary
                          (
   
                           BusinessUnit, BAddress1, BAddress2, BCity,  BDEANumber,  BDEASchedule, BName,BPostalCode,BState, NoOfLines, OrderChannel1, 
                           PODate,PONumber, ShipToNumber, SAddress1, SAddress2, SCity, SDEANumber,SName,  SPostalCode, SState, UniqueTransactionNumber
                           )
                           VALUES
                           (
  
                         ]]..
  
   
           --Here i am going to insert values this can be done after database connection is established 
           --The below commented lines has to be replaced by new one
      
      
                        --[["'"..Msg.patients.patient.id.."',"..
                            "\n   '"..Msg.patients.patient["first-name"][1].."',"..
                            "\n   '"..Msg.patients.patient["last-name"][1].."',"..
                            "\n   '"..Msg.patients.patient["social-security-no"][1].."'"..
                            '\n   )'  
                         ]]--
                            -- "'"..Content.."')"
                            -- Insert data into database
                            Conn:execute{sql=SqlInsert2, live=true} 
                            print(os.date("%x"))   --this will give the current date
                end
                            Conn:execute('SELECT * FROM order_summary')
      
      
          
      else
              print(" the given file is not xml ")
      end
end