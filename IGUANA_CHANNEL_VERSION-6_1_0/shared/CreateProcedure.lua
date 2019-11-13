local CreateProcedure =  {}
dbConnection = require("DBConnection")
   
function CreateProcedure.createProcedure()
   
   conn_dev:execute{sql='DROP PROCEDURE IF EXISTS AddCSOSOrder',live=true}
   conn_dev:execute{sql=[[CREATE PROCEDURE AddCSOSOrder( 
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
end

return CreateProcedure