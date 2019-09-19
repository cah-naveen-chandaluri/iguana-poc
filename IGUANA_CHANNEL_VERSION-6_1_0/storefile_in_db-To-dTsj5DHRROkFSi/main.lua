-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main()
  local F = io.open('C:\\Program Files\\iNTERFACEWARE\\Iguana\\season\\storefile_in_db\\source\\menu.xml', "r")
   local Content =  F:read('*a')

   print(Content)
  
  local Conn = db.connect{
          api=db.SQL_SERVER, 
      name='SQL SERVER',
      user='',      -- use empty string for integrated security
      password='',  -- use empty string for integrated security 
      use_unicode = true,
      live = true
      }

   
    local SqlInsert =
   [[
   INSERT INTO menu4
   (
   
   VAL
 )
   VALUES
   (
  
   ]]..

   
  "'"..Content.."'"..
'\n   )'  
   Conn:execute{sql = SqlInsert,live=true}
  -- Conn:query('SELECT * FROM menu1')
F:close()
  
   end
