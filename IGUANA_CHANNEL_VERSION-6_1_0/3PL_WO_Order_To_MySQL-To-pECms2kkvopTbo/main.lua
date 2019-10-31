function main()
   mymodule=require("mymaths")
   
     local url = "C:\\3PL\\XMLdata.xml"
   --first we have to check whether it is a file or not
   c=os.fs.stat(url)
   print(c.isdir,c.isreg)
   
   print(os.time())
   
   --it the fiven path contains a file then it will check whether it is a xml file or not
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
      
       -- calling the function which contains dbconnection and the function is present in shared folder file called mymaths.lua
  
      
      mymodule.connectdb()
 
 
     -- conn:execute{sql='SELECT * FROM orders', live=true} 
      local function Tabl1eCreation()
         
            Conn:execute{sql=[[
                  CREATE TABLE IF NOT EXISTS orders (
                  CSOS_ORD_DTL_NUM bigint(19) primary key,CSOS_ORD_HDR_NUM bigint(19),BUYER_ITEM_NUM varchar(45),
                  FORM varchar(45),LINE_NUM varchar(45),NAME_OF_ITEM varchar(45),NATIONAL_DRUG_CDE varchar(45),
                  QUANTITY varchar(45),DEA_SCHEDULE varchar(45),
                  SIZE_OF_PACKAGE varchar(45),STRENGTH varchar(45),SUPPLIER_ITEM_NUM varchar(45));
            ]],
             live = true}
         
    end
      --calling function to create table if the table doesnot exist in database
      
 Table1Creation()
      
       local function  Table2Creation()
         
           Conn:execute{sql=[[
               CREATE TABLE IF NOT EXISTS order_summary (
               BusinessUnit varchar(45), BAddress1 varchar(45), BAddress2 varchar(45), BCity varchar(45),
               BDEANumber varchar(45),  BDEASchedule varchar(45), BName varchar(45),
               BPostalCode varchar(45),BState varchar(45), NoOfLines varchar(45), OrderChannel1 varchar(45), 
               PODate varchar(45),PONumber varchar(45), ShipToNumber varchar(45),
               SAddress1 varchar(45), SAddress2 varchar(45), SCity varchar(45), SDEANumber varchar(45),SName varchar(45), 
               SPostalCode varchar(45), SState varchar(45), UniqueTransactionNumber varchar(45));
          ]],
           live = true}
         
    end
      --calling the function to create table if the table does not exist in database
      
 Table2Creation()
      
            --Inserting data into the orders table
      

               local SqlInsert =
                    [[
                      INSERT INTO orders
                          (
                         CSOS_ORD_DTL_NUM,CSOS_ORD_HDR_NUM,BUYER_ITEM_NUM,FORM,LINE_NUM,
                         NAME_OF_ITEM,NATIONAL_DRUG_CDE,
                         QUANTITY,DEA_SCHEDULE,
                         SIZE_OF_PACKAGE,STRENGTH,SUPPLIER_ITEM_NUM
                          
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
         
                
                        Conn:execute('SELECT * FROM orders')

             --inserting data into the order_summary table

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
                
                            Conn:execute('SELECT * FROM order_summary')
   
      Conn:close() 
          
      else
              print(" the given file is not xml ")
      end
end

