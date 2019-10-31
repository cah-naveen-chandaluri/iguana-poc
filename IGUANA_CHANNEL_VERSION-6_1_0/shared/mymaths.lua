local mymaths =  {}

function mymaths.connectdb()
   
     if not Conn or not Conn:check() then
          if Conn and Conn:check() then 
              Conn:close() 
          end 
               Conn = db.connect{
                     api = db.MY_SQL,
                     name = 'mydatabase@sripad:3306',
                     user = 'root',
                     password = 'dSrip@d2489',
                     use_unicode=true,
                     live = true
                    }
     end
end

return mymaths