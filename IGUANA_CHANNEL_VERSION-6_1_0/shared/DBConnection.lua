local DBConnection =  {}

function DBConnection.connectdb()

  conn = db.connect{   
      api=db.MY_SQL, 
      name='3pl_sps_ordering@dqec0609plord01.cdhhdsjj0b0x.us-east-1.rds.amazonaws.com:3306',
      user='online_order_app_master', 
      password='AppM@ster3Pl',
      use_unicode = true,
      live = true
   }
end

return DBConnection
