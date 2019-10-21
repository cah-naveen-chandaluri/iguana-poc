-- The main function is the first function called from Iguana.
function main()
    --the below is the query to compare data in two tables if they are equal it will not store any thing in database and 
           --if they are not equal then it store data in database
        local conn = db.connect
               {
                     api = db.MY_SQL,
                     name = 'test',
                     user = 'root',
                     password = '',
                     use_unicode=true,
                     live = true
               }
      
                         local X=Conn:query(
                        [[ SELECT BuyerItemNumber,Form,LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                           SizeOfPackages,Strength,SupplierItemNumber FROM 
                           (SELECT BuyerItemNumber,Form,LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                           SizeOfPackages,Strength,SupplierItemNumber FROM orders UNION ALL SELECT BuyerItemNumber,Form,
                           LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                           SizeOfPackages,Strength,SupplierItemNumber FROM dummyorder) tbl
                           GROUP BY BuyerItemNumber,Form,LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                           SizeOfPackages,Strength,SupplierItemNumber HAVING count(*) = 1 ]]
                          )
      
						  local C=#X   
   
   A=Conn:query([[select * from orders]])
   B=Conn:Query('select * from ordersummary')
   
   for i=1,10 do
   for j=1,10 do
   
    A[i]==Conn:query('select * from dummyorder where id=X[j]')
    B[i]==Conn:query('select * from dummyorder_summary where id=Y[j]')
     
         --rest api
		end				  
		end		
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   local Y=Conn:query(
                        [[ SELECT BuyerItemNumber,Form,LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                           SizeOfPackages,Strength,SupplierItemNumber FROM 
                           (SELECT BuyerItemNumber,Form,LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                           SizeOfPackages,Strength,SupplierItemNumber FROM orders UNION ALL SELECT BuyerItemNumber,Form,
                           LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                           SizeOfPackages,Strength,SupplierItemNumber FROM dummyorder) tbl
                           GROUP BY BuyerItemNumber,Form,LineNumber,NameOfItem,NationalDrugCode,QuantityOrdered,Schedule,
                           SizeOfPackages,Strength,SupplierItemNumber HAVING count(*) = 1 ]]
                          )
      
						  local D=#Y
        
		  --the above comparision query will be done for two times if we use the xml data as two different tables
		  
		  -- the sum of size of two different tables will be stored in 
		
		               local Z=C+D
          --Z will store the sum of two databases and if the sum is equal to zero then it will call the rest api
      
                     if (Z==0) then
          
         
         --here it will call the rest api
         
         
                    else
         
                        print("size is not equal to zero and data in tables and xml are not equal")
         
                    end
end