local Validation =  {}
--[[function Validation.validate_value(order_value,column_size) --validation of data present in order files
      if(order_value == nil) then
	        return false
      elseif(type(order_value:nodeText())=='string' and #order_value<=column_size and #order_value>=0) then
         return true
      else
         return false
      end
end 
]]--
return Validation