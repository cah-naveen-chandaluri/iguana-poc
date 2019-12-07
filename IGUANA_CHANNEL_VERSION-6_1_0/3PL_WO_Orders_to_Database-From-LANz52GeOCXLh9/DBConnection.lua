local DBConnection =  {}

function DBConnection.connectdb()
    if not conn_qa or conn_qa:check() then   --QA connection
        if conn_qa and conn_qa:check() then
            conn_qa:close() end
        conn_qa = db.connect{
            api=db.MY_SQL,
            name='3pl_sps_ordering@dqec0609plord01.cdhhdsjj0b0x.us-east-1.rds.amazonaws.com:3306',
            user='online_order_app_master',
            password='AppM@ster3Pl',
            use_unicode = true,
            live = true
        }
    end
    if not conn_dev or conn_dev:check() then  --dev connection
        if conn_dev and conn_dev:check() then
            conn_dev:close() end
        conn_dev = db.connect{
            api=db.MY_SQL,
            name='3pl_sps_ordering@ddec0609plord01.cdhhdsjj0b0x.us-east-1.rds.amazonaws.com:3306',
            user='online_order_app_master',
            password='Appmaster3pl',
            use_unicode = true,
            live = true
        }
    end
   if not conn_stg or conn_stg:check() then  --dev connection
        if conn_stg and conn_stg:check() then
            conn_stg:close() end
        conn_stg = db.connect{
            api=db.MY_SQL,
            name='3pl_sps_ordering@dsec0409plord01.cr045t37xfsw.us-east-1.rds.amazonaws.com:3306',
            user='online_order_app_master',
            password='App$tgM@ster3Pl',
            use_unicode = true,
            live = true
        }
    end
   if not conn_Elite_stg or conn_Elite_stg:check() then  --dev connection
        if conn_Elite_stg and conn_Elite_stg:check() then
            conn_Elite_stg:close() end
        conn_Elite_stg = db.connect{
            api=db.ORACLE_OCI,
            name='//lsec0409val1s01.cardinalhealth.net:1521/val1s/',
            user='sps_service',
            password='mickey222',
            use_unicode = true,
            live = true
        }
    end
end
return DBConnection