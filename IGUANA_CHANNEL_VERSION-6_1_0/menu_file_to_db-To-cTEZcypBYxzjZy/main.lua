-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main(Data)
    local Msg = xml.parse(Data)  
   
   local Conn = db.connect{
      api=db.SQL_SERVER, 
      name='SQL SERVER',
      user='',      -- use empty string for integrated security
      password='',  -- use empty string for integrated security 
      use_unicode = true,
      live = true
   }

   -- (2) create insert query string
   
   for i=1,5,1 do
   
      local SqlInsert =
   [[
   INSERT INTO menu
   (
   name,
   price,
   description,
   calories
   )
   VALUES
   (
   ]]..
   "'"..Msg.breakfast_menu:child("food", i)["name"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["price"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["description"][1].."',"..
   "\n   '"..Msg.breakfast_menu:child("food", i)["calories"][1].."'".. 
   '\n   )'
   

    
      Conn:execute{sql=SqlInsert, live=true}
   
	end

   
end
