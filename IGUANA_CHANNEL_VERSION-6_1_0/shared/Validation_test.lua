local Validation_test =  {}

function Validation_test.validate_value(xml_Value,ref_SizeOf_xml_Value)
       type_xml_Value=type(xml_Value)
 
   SizeOf_xml_Value=#xml_Value
   print(type_xml_Value,ref_SizeOf_xml_Value)
   ref_type_xml_Value='string'
  if(type_xml_Value==ref_type_xml_Value and SizeOf_xml_Value<=ref_SizeOf_xml_Value) then
      return true
      end
end
return Validation_test
