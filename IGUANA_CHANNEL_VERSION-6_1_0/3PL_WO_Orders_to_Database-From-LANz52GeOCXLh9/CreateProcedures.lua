local CreateProcedures =  {}

properties = require("properties")    
dbConnection = require("DBConnection")
dbConnection.connectdb()
properties.directory_path()
properties.db_conn()
    
function CreateProcedures.createProcedure()  
   
   conn:execute{sql='DROP PROCEDURE IF EXISTS AddCSOSOrder',live=true}  --procedure to insert data into csos_order_header
   conn:execute{sql=[[CREATE PROCEDURE AddCSOSOrder( 
      IN BUSINESS_UNIT VARCHAR(255),
      IN NO_OF_LINES	VARCHAR(45),
      IN ORDER_CHANNEL VARCHAR(45),
      IN PO_DATE VARCHAR(45),
      IN PO_NUMBER VARCHAR(45),
      IN SHIPTO_NUM varchar(45),
      IN UNIQUE_TRANS_NUM varchar(45),
      IN ACTIVE_FLG char(1),
      IN ROW_ADD_STP	timestamp,
      IN ROW_ADD_USER_ID varchar(255),
      IN ROW_UPDATE_STP timestamp,
      IN ROW_UPDATE_USER_ID varchar(255)
   )
      BEGIN
      INSERT INTO csos_order_header(BUSINESS_UNIT, NO_OF_LINES, ORDER_CHANNEL, PO_DATE, PO_NUMBER, SHIPTO_NUM, UNIQUE_TRANS_NUM, ACTIVE_FLG, ROW_ADD_STP, ROW_ADD_USER_ID, ROW_UPDATE_STP, ROW_UPDATE_USER_ID  ) 
      VALUES(BUSINESS_UNIT, NO_OF_LINES, ORDER_CHANNEL, PO_DATE, PO_NUMBER, SHIPTO_NUM, UNIQUE_TRANS_NUM, ACTIVE_FLG, ROW_ADD_STP, ROW_ADD_USER_ID, ROW_UPDATE_STP, ROW_UPDATE_USER_ID );
   END]],
      live=true
      }
   
   conn:execute{sql='DROP PROCEDURE IF EXISTS AddCSOSOrderdetails',live=true}   --procedure to insert data into csos_order_details
   conn:execute{sql=[[CREATE PROCEDURE AddCSOSOrderdetails( 
	   IN CSOS_ORD_HDR_NUM bigint(19),
      IN BUYER_ITEM_NUM varchar(45) ,
      IN FORM varchar(45) ,
      IN LINE_NUM varchar(45) ,
      IN NAME_OF_ITEM varchar(45),
      IN NATIONAL_DRUG_CDE varchar(45),
      IN QUANTITY varchar(45),
      IN DEA_SCHEDULE varchar(45),
      IN SIZE_OF_PACKAGE varchar(45), 
      IN STRENGTH varchar(45),
	   IN SUPPLIER_ITEM_NUM varchar(45),
	   IN ACTIVE_FLG char(1),
      IN ROW_ADD_STP	timestamp,
      IN ROW_ADD_USER_ID varchar(255),
      IN ROW_UPDATE_STP timestamp,
      IN ROW_UPDATE_USER_ID varchar(255)
   )
      BEGIN
      INSERT INTO csos_order_details(CSOS_ORD_HDR_NUM,BUYER_ITEM_NUM, FORM, LINE_NUM, NAME_OF_ITEM, NATIONAL_DRUG_CDE, QUANTITY,DEA_SCHEDULE, SIZE_OF_PACKAGE,STRENGTH,SUPPLIER_ITEM_NUM,ACTIVE_FLG, ROW_ADD_STP, ROW_ADD_USER_ID, ROW_UPDATE_STP, ROW_UPDATE_USER_ID) 
      VALUES(CSOS_ORD_HDR_NUM,BUYER_ITEM_NUM, FORM, LINE_NUM, NAME_OF_ITEM, NATIONAL_DRUG_CDE, QUANTITY,DEA_SCHEDULE, SIZE_OF_PACKAGE,STRENGTH,SUPPLIER_ITEM_NUM,ACTIVE_FLG, ROW_ADD_STP, ROW_ADD_USER_ID, ROW_UPDATE_STP, ROW_UPDATE_USER_ID );
   END]],
   live=true
         }
        
   conn:execute{sql='DROP PROCEDURE IF EXISTS AddCSOSaddrsupplier',live=true}   --procedure to insert supplier details into csos_addr_details
   conn:execute{sql=[[CREATE PROCEDURE  AddCSOSaddrsupplier( 
	   IN CSOS_ORD_HDR_NUM bigint(19),
      IN ADDR_TYPE varchar(45) ,
      IN ADDR1 varchar(45) ,
      IN CITY varchar(45),
      IN DEA_NUMBER varchar(45),
      IN POSTAL_CDE varchar(45),
      IN STATE varchar(45), 
	   IN ACTIVE_FLG char(1),
      IN ROW_ADD_STP	timestamp,
      IN ROW_ADD_USER_ID varchar(255),
      IN ROW_UPDATE_STP timestamp,
      IN ROW_UPDATE_USER_ID varchar(255)
   )
BEGIN
     INSERT INTO csos_addr_details(CSOS_ORD_HDR_NUM,ADDR_TYPE, ADDR1, CITY, DEA_NUMBER,
    POSTAL_CDE, STATE,ACTIVE_FLG, ROW_ADD_STP, ROW_ADD_USER_ID, ROW_UPDATE_STP, ROW_UPDATE_USER_ID) 
    VALUES(CSOS_ORD_HDR_NUM,ADDR_TYPE, ADDR1, CITY, DEA_NUMBER,
    POSTAL_CDE, STATE,ACTIVE_FLG, ROW_ADD_STP, ROW_ADD_USER_ID, ROW_UPDATE_STP, ROW_UPDATE_USER_ID );
    END]],live=true  
      }
      
   conn:execute{sql='DROP PROCEDURE IF EXISTS AddCSOSaddrbuyer',live=true}  --procedure to insert buyer details into csos_addr_details
   conn:execute{sql=[[CREATE PROCEDURE AddCSOSaddrbuyer( 
	   IN CSOS_ORD_HDR_NUM bigint(19),
      IN ADDR_TYPE varchar(45) ,
      IN ADDR1 varchar(45) ,
      IN ADDR2 varchar(45) ,
      IN CITY varchar(45),
      IN DEA_SCHEDULLE varchar(45),
      IN DEA_NUMBER varchar(45),
      IN POSTAL_CDE varchar(45),
      IN STATE varchar(45), 
	   IN ACTIVE_FLG char(1),
      IN ROW_ADD_STP	timestamp,
      IN ROW_ADD_USER_ID varchar(255),
      IN ROW_UPDATE_STP timestamp,
      IN ROW_UPDATE_USER_ID varchar(255)
   )
BEGIN

    INSERT INTO csos_addr_details(CSOS_ORD_HDR_NUM,ADDR_TYPE, ADDR1, ADDR2, CITY,DEA_SCHEDULLE, DEA_NUMBER,
    POSTAL_CDE, STATE,ACTIVE_FLG, ROW_ADD_STP, ROW_ADD_USER_ID, ROW_UPDATE_STP, ROW_UPDATE_USER_ID) 
    VALUES(CSOS_ORD_HDR_NUM,ADDR_TYPE, ADDR1, ADDR2, CITY, DEA_SCHEDULLE, DEA_NUMBER,
    POSTAL_CDE, STATE,ACTIVE_FLG, ROW_ADD_STP, ROW_ADD_USER_ID, ROW_UPDATE_STP, ROW_UPDATE_USER_ID );
    END]],live=true
      }
end
   
return CreateProcedures