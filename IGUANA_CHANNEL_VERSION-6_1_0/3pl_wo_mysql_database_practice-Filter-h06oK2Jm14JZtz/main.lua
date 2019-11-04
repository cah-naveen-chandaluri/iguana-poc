-- The main function is the first function called from Iguana.
function main()
    --the below is the query to compare data in two tables if they are equal it will not store any thing in database and 
           --if they are not equal then it store data in database
   
   
   
   
   dbConnection = require("DBConnection")
   
   
   bool isValid = false;
   dbConnection.connectdb()
   
   Order_hdr_data_from_table=Conn:query('select * from csos_order_header where csos_order_hdr_num = 10')
      Order_details_data_from_table=Conn:query([[select * from csos_order_details where csos_order_hdr_num = 10]])
      
   B[i][col]
   
   for j=0,#Order_hdr_data_from_table do
   
   -- result1=Conn:query('select * from order_details where id=A[id][j] and name=A[id][j]')
    --result2=Conn:query('select * from order_header where id=B[id][j] and name=A[id][j]')
      
      
     if(Order_hdr_data_from_table[j][ORDER_HDR_NUM]==<data from xml related to CSOS_ORDR_HDR for ORDER_HDR_NUM> 
            and Order_hdr_data_from_table[j][BUSINESS_UNIT]==<data from xml related to CSOS_ORDR_HDR for BUSINESS_UNIT>
         and ..........) then
            
           --rest api 
         isValid = true;
            
            end
      else 
      isValid = false
      end
         
		end		
   
if(isValid === true)
   then
   
     for j=0,#Order_details_data_from_table do
   
   -- result1=Conn:query('select * from order_details where id=A[id][j] and name=A[id][j]')
    --result2=Conn:query('select * from order_header where id=B[id][j] and name=A[id][j]')
      
      
     if(Order_details_data_from_table[j][CSOS_ORD_DTL_NUM]==<data from xml related to CSOS_ORDR_DTL for CSOS_ORD_DTL_NUM> 
            and Order_details_data_from_table[j][ORDER_HDR_NUM]==<data from xml related to CSOS_ORDR_DTL for ORDER_HDR_NUM>
         and ..........) then
            
           --rest api 
         isValid = true;
            
            end
      else
      isValid = false;
      end
         
		end	
   end

if(isValid === true)
   'insert data'
   else
   'send mail'
				
   
   
   
   
   
  
   
   
   
   
   
  
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