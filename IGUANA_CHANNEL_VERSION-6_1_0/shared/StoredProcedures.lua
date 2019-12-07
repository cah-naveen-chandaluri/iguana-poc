local StoredProcedures =  {}
properties = require("properties")
    
function StoredProcedures.updateProcedure()   --creting update procedure
   properties.directory_path()
   properties.db_conn()
    
   conn:execute{sql='DROP PROCEDURE IF EXISTS Update_Procedure',live=true}
   conn:execute{sql=[[CREATE PROCEDURE Update_Procedure( 
    IN UNIQUE_TRANS_NU varchar(45)
   )
      BEGIN
     update 3pl_sps_ordering.csos_order_header set CSOS_ORDER_HDR_STAT ='2' where UNIQUE_TRANS_NUM=UNIQUE_TRANS_NU;
     update 3pl_sps_ordering.order_header set  ORDER_HDR_STAT_DESC='2' where CSOS_ORDER_NUM=UNIQUE_TRANS_NU;
   
    END]],
      live=true
       } 
      
      
end
   
   
   
return StoredProcedures