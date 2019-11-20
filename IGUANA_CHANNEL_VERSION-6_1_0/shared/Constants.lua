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

function Constants.query_constants()
    SEL_HEAD_MAX='select max(CSOS_ORD_HDR_NUM) from csos_order_header'
   SEL_DETAILS_MAX='select max(CSOS_ORD_HDR_NUM) from csos_order_details'
end

function Constants.frequently_constants()
    active_flg_val="YES"
    user="IGUANA_USER"
end

function Constants.log_statements()
    TIME_STAMP=os.date('%x').." "..os.date('%X').."-"
    ARC_DIR_MISS="Archive directory is missing"
    ARC_DIR_CREATE="Archive directory is created"
    ERR_DIR_MISS="Error directory is missing"
    ERR_DIR_CREATE="Error directory is created"
    ORD_DIR_MISS="Order files directory is not existes"
    ORD_DIR_CREATE="Order files directory is created"
    ERR_DIR_MOV="The given file is moved to error folder"
    XML_FILE_TEST_SUCCESS="The given file is xml file tested"
    XML_FILE_TEST_FAIL="The given file is not xml file"
    INSERT_SUCCESS="Insertion is done"
    INSERT_FAIL="Insertion is not done"
    DATA_VALIDATION_FAIL="datatype Validation failed"
    DATA_VALIDATION_SUCCESS="datatype Validation success"
    TAG_MISS="tag is missing in xml"
    TAGS_AVAILABLE="all tags are available in xml"
   ARC_DIR_MOV="The given file is moved to archive folder"
   UNABLE_OPEN_FILE="No able to open file"
end

return Constants
