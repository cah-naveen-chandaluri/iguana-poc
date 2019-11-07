local Constants =  {}

function Constants.csos_order_header_size()

           CSOS_ORD_HDR_NUM	= 19
           BUSINESS_UNIT	   = 255
           NO_OF_LINES	      = 45
           ORDER_CHANNEL	   = 45
           PO_DATE	         = 45
           PO_NUMBER	         = 45
           SHIPTO_NUM	      = 45
           UNIQUE_TRANS_NUM	= 45
           ACTIVE_FLG	      = 1
           --ROW_ADD_STP	timestamp
           ROW_ADD_USER_ID	   = 255 --varchar
           --ROW_UPDATE_STP	timestamp
           ROW_UPDATE_USER_ID	= 255 --varchar
   
end

function Constants.csos_order_details_size()

           CSOS_ORD_DTL_NUM   = 19 --bigint
           CSOS_ORD_HDR_NUM   = 19 --bigint
           BUYER_ITEM_NUM	   = 45 --varchar
           FORM	            = 45 --varchar
           LINE_NUM	         = 45 --varchar
           NAME_OF_ITEM	      = 45 --varchar
           NATIONAL_DRUG_CDE	= 45 --varchar
           QUANTITY           = 45 --varchar
           DEA_SCHEDULE	      = 45 --varchar
           SIZE_OF_PACKAGE    = 45 --varchar
           STRENGTH	         = 45 --varchar
           SUPPLIER_ITEM_NUM	= 45 --varchar
           ACTIVE_FLG	      = 1  -- char
           -- ROW_ADD_STP	timestamp
           ROW_ADD_USER_ID	   = 255 --varchar
           -- ROW_UPDATE_STP	timestamp
           ROW_UPDATE_USER_ID	= 255 --varchar
end


return Constants
