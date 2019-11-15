local Validation =  {}

function Validation.validate_value(xml_column,ref_SizeOf_xml_column)
    type_xml_column=type(xml_column)
    print(xml_column,#xml_column)
    SizeOf_xml_column=#xml_column
    print(type_xml_column,SizeOf_xml_column)
    ref_type_xml_column='string'
    if(type_xml_column==ref_type_xml_column and SizeOf_xml_column<=ref_SizeOf_xml_column) then
        return true
    end
end
return Validation

--validation for csos_order_details

--[[function Validation.String(t)

      print(#t)

    
      d=type(t)
      c=#t
      print(c)
      ref_type='string'
      ref_size=45
       if(d==ref_type and c<=ref_size) then
      return true
      end
     
end


]]--

--[[

--validation for csos_order_details

function Validation.validate_BuyerItemNumber(xml_BuyerItemNumber,ref_SizeOf_xml_BuyerItemNumber)
       type_xml_BuyerItemNumber=type(xml_BuyerItemNumber)
 
   SizeOf_xml_BuyerItemNumber=#xml_BuyerItemNumber
   print(type_xml_BuyerItemNumber,SizeOf_xml_BuyerItemNumber)
   ref_type_xml_BuyerItemNumber='string'
  if(type_xml_BuyerItemNumber==ref_type_xml_BuyerItemNumber and SizeOf_xml_BuyerItemNumber<=ref_SizeOf_xml_BuyerItemNumber) then
      return true
      end
end



function Validation.validate_Form(xml_Form,ref_SizeOf_xml_Form)
       type_xml_Form=type(xml_Form)
   print(xml_Form,#xml_Form)
   SizeOf_xml_Form=#xml_Form
   print(type_xml_Form,SizeOf_xml_Form)
   ref_type_xml_Form='string'
  if(type_xml_Form==ref_type_xml_Form and SizeOf_xml_Form<=ref_SizeOf_xml_Form) then
      return true
      end
end



function Validation.validate_LineNumber(xml_LineNumber,ref_SizeOf_xml_LineNumber)
       type_xml_LineNumber=type(xml_LineNumber)
   print(xml_LineNumber,#xml_LineNumber)
   SizeOf_xml_LineNumber=#xml_LineNumber
   print(type_xml_LineNumber,SizeOf_xml_LineNumber)
   ref_type_xml_LineNumber='string'
  if(type_xml_LineNumber==ref_type_xml_LineNumber and SizeOf_xml_LineNumber<=ref_SizeOf_xml_LineNumber) then
      return true
      end
end




function Validation.validate_NameOfItem(xml_NameOfItem,ref_SizeOf_xml_NameOfItem)
       type_xml_NameOfItem=type(xml_NameOfItem)
   print(xml_NameOfItem,#xml_NameOfItem)
   SizeOf_xml_NameOfItem=#xml_NameOfItem
   print(type_xml_NameOfItem,SizeOf_xml_NameOfItem)
   ref_type_xml_NameOfItem='string'
  if(type_xml_NameOfItem==ref_type_xml_NameOfItem and SizeOf_xml_NameOfItem<=ref_SizeOf_xml_NameOfItem) then
      return true
      end
end




function Validation.validate_NationalDrugCode(xml_NationalDrugCode,ref_SizeOf_xml_NationalDrugCode)
       type_xmlNationalDrugCode_column=type(xml_NationalDrugCode)
   print(xml_NationalDrugCode,#xml_NationalDrugCode)
   SizeOf_xml_NationalDrugCode=#xml_NationalDrugCode
   print(type_xml_NationalDrugCode,SizeOf_xml_NationalDrugCode)
   ref_type_xml_NationalDrugCode='string'
  if(type_xml_NationalDrugCode==ref_type_xml_NationalDrugCode and SizeOf_xml_NationalDrugCode<=ref_SizeOf_xml_NationalDrugCode) then
      return true
      end
end




function Validation.validate_QuantityOrdered(xml_QuantityOrdered,ref_SizeOf_xml_QuantityOrdered)
       type_xml_QuantityOrdered=type(xml_QuantityOrdered)
   print(xml_QuantityOrdered,#xml_QuantityOrdered)
   SizeOf_xml_QuantityOrdered=#xml_QuantityOrdered
   print(type_xml_QuantityOrdered,SizeOf_xml_QuantityOrdered)
   ref_type_xml_QuantityOrdered='string'
  if(type_xml_QuantityOrdered==ref_type_xml_QuantityOrdered and SizeOf_xml_QuantityOrdered<=ref_SizeOf_xml_QuantityOrdered) then
      return true
      end
end



function Validation.validate_Schedule(xml_Schedule,ref_SizeOf_xml_Schedule)
       type_xml_Schedule=type(xml_Schedule)
   print(xml_Schedule,#xml_Schedule)
   SizeOf_xml_Schedule=#xml_Schedule
   print(type_xml_Schedule,SizeOf_xml_Schedule)
   ref_type_xml_Schedule='string'
  if(type_xml_Schedule==ref_type_xml_Schedule and SizeOf_xml_Schedule<=ref_SizeOf_xml_Schedule) then
      return true
      end
end


function Validation.validate_SizeOfPackages(xml_SizeOfPackages,ref_SizeOf_xml_SizeOfPackages)
       type_xml_SizeOfPackages=type(xml_SizeOfPackages)
   print(xml_SizeOfPackages,#xml_SizeOfPackages)
   SizeOf_xml_SizeOfPackages=#xml_SizeOfPackages
   print(type_xml_SizeOfPackages,SizeOf_xml_SizeOfPackages)
   ref_type_xml_SizeOfPackages='string'
  if(type_xml_SizeOfPackages==ref_type_xml_SizeOfPackages and SizeOf_xml_SizeOfPackages<=ref_SizeOf_xml_SizeOfPackages) then
      return true
      end
end



function Validation.validate_Strength(xml_Strength,ref_SizeOf_xml_Strength)
       type_xml_Strength=type(xml_Strength)
   print(xml_Strength,#xml_Strength)
   SizeOf_xml_Strength=#xml_Strength
   print(type_xml_Strength,SizeOf_xml_Strength)
   ref_type_xml_Strength='string'
  if(type_xml_Strength==ref_type_xml_Strength and SizeOf_xml_Strength<=ref_SizeOf_xml_Strength) then
      return true
      end
end



function Validation.validate_SupplierItemNumber(xml_SupplierItemNumber,ref_SizeOf_xml_SupplierItemNumber)
       type_xml_SupplierItemNumber=type(xml_SupplierItemNumber)
   print(xml_SupplierItemNumber,#xml_SupplierItemNumber)
   SizeOf_xml_SupplierItemNumber=#xml_SupplierItemNumber
   print(type_xml_SupplierItemNumber,SizeOf_xml_SupplierItemNumber)
   ref_type_xml_SupplierItemNumber='string'
  if(type_xml_SupplierItemNumber==ref_type_xml_SupplierItemNumber and SizeOf_xml_SupplierItemNumber<=ref_SizeOf_xml_SupplierItemNumber) then
      return true
      end
end






--validation for csos_order_header




function Validation.validate_BusinessUnit(xml_BusinessUnit,ref_SizeOf_xml_BusinessUnit)
       type_xml_BusinessUnit=type(xml_BusinessUnit)
   print(xml_BusinessUnit,#xml_BusinessUnit)
   SizeOf_xml_BusinessUnit=#xml_BusinessUnit
   print(type_xml_BusinessUnit,SizeOf_xml_BusinessUnit)
   ref_type_xml_BusinessUnit='string'
  if(type_xml_BusinessUnit==ref_type_xml_BusinessUnit and SizeOf_xml_BusinessUnit<=ref_SizeOf_xml_BusinessUnit) then
      return true
      end
end



function Validation.validate_NoOfLines(xml_NoOfLines,ref_SizeOf_xml_NoOfLines)
       type_xml_NoOfLines=type(xml_NoOfLines)
   print(xml_NoOfLinesn,#xml_NoOfLines)
   SizeOf_xml_NoOfLines=#xml_NoOfLines
   print(type_xml_NoOfLines,SizeOf_xml_NoOfLines)
   ref_type_xml_NoOfLines='string'
  if(type_xml_NoOfLines==ref_type_xml_NoOfLines and SizeOf_xml_NoOfLines<=ref_SizeOf_xml_NoOfLines) then
      return true
      end
end



function Validation.validate_OrderChannel(xml_OrderChannel,ref_SizeOf_xml_OrderChannel)
       type_xml_OrderChannel=type(xml_OrderChannel)
   print(xml_OrderChannel,#xml_OrderChannel)
   SizeOf_xmlOrderChannel=#xml_OrderChannel
   print(type_xml_OrderChannel,SizeOf_xml_OrderChannel)
   ref_type_xml_OrderChannel='string'
  if(type_xml_OrderChannel==ref_type_xml_OrderChannel and SizeOf_xml_OrderChannel<=ref_SizeOf_xml_OrderChannel) then
      return true
      end
end



function Validation.validate_PODate(xml_PODate,ref_SizeOf_xml_PODate)
       type_xml_PODate=type(xml_PODate)
   print(xml_PODate,#xml_PODate)
   SizeOf_xml_PODate=#xml_PODate
   print(type_xml_PODate,SizeOf_xml_PODate)
   ref_type_xml_PODate='string'
  if(type_xml_PODate==ref_type_xml_PODate and SizeOf_xml_PODate<=ref_SizeOf_xml_PODate) then
      return true
      end
end



function Validation.validate_PONumber(xml_PONumber,ref_SizeOf_xml_PONumber)
       type_xml_PONumber=type(xml_PONumber)
   print(xml_PONumber,#xml_PONumber)
   SizeOf_xml_PONumber=#xml_PONumber
   print(type_xml_PONumber,SizeOf_xml_PONumber)
   ref_type_xml_PONumber='string'
  if(type_xml_PONumber==ref_type_xml_PONumber and SizeOf_xml_PONumber<=ref_SizeOf_xml_PONumber) then
      return true
      end
end






function Validation.validate_ShipToNumber(xml_ShipToNumber,ref_SizeOf_xml_ShipToNumber)
       type_xml_ShipToNumber=type(xml_ShipToNumber)
   print(xml_ShipToNumber,#xml_ShipToNumber)
   SizeOf_xml_ShipToNumber=#xml_ShipToNumber
   print(type_xml_ShipToNumber,SizeOf_xml_ShipToNumber)
   ref_type_xml_ShipToNumber='string'
  if(type_xml_ShipToNumber==ref_type_xml_ShipToNumber and SizeOf_xml_ShipToNumber<=ref_SizeOf_xml_ShipToNumber) then
      return true
      end
end






function Validation.validate_UniqueTransactionNumber(xml_UniqueTransactionNumber,ref_SizeOf_xml_UniqueTransactionNumber)
       type_xml_UniqueTransactionNumber=type(xml_UniqueTransactionNumber)
   print(xml_UniqueTransactionNumber,#xml_UniqueTransactionNumber)
   SizeOf_xml_UniqueTransactionNumber=#xml_UniqueTransactionNumber
   print(type_xml_UniqueTransactionNumber,SizeOf_xml_UniqueTransactionNumber)
   ref_type_xml_UniqueTransactionNumber='string'
  if(type_xml_v==ref_type_xml_PONumber and SizeOf_xml_UniqueTransactionNumber<=ref_SizeOf_xml_UniqueTransactionNumber) then
      return true
      end
end




return Validation
]]--