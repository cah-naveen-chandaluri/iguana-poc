local Validation =  {}


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




--[[


function Validation.BuyerItemNumber(BuyerItemNumber,SizeOf_BuyerItemNumber)
       type_BuyerItemNumber=type(BuyerItemNumber)
   print(type_BuyerItemNumber,SizeOf_BuyerItemNumber)
   ref_BuyerItemNumber='string'
   ref_SizeOfBuyerItemNumber=45
  if(type_BuyerItemNumber==ref_BuyerItemNumber and SizeOf_BuyerItemNumber<=ref_SizeOfBuyerItemNumber) then
      return true
      end
end


function Validation.Form(Form,SizeOf_Form)
       type_Form=type(Form)
   print(type_Form,SizeOf_Form)
   ref_Form='string'
   ref_SizeOfForm=45
  if(type_Form==ref_Form and SizeOf_Form<=ref_SizeOfForm) then
      return true
      end
end

function Validation.LineNumber(LineNumber,SizeOf_LineNumber)
       type_LineNumber=type(LineNumber)
   print(type_LineNumber,SizeOf_LineNumber)
   ref_LineNumber='string'
   ref_SizeOfLineNumber=45
  if(type_LineNumber==ref_LineNumber and SizeOf_LineNumber<=ref_SizeOfLineNumber) then
      return true
      end
end


function Validation.NameOfItem(NameOfItem,SizeOf_NameOfItem)
       type_NameOfItem=type(NameOfItem)
   print(type_NameOfItem,SizeOf_NameOfItem)
   ref_NameOfItem='string'
   ref_SizeOfNameOfItem=45
  if(type_NameOfItem==ref_NameOfItem and SizeOf_NameOfItem<=ref_SizeOfNameOfItem) then
      return true
      end
end



function Validation.NationalDrugCode(NationalDrugCode,SizeOf_NationalDrugCode)
       type_NationalDrugCode=type(NationalDrugCode)
   print(type_NationalDrugCode,SizeOf_NationalDrugCode)
   ref_NationalDrugCode='string'
   ref_SizeOfNationalDrugCode=45
  if(type_NationalDrugCode==ref_NationalDrugCode and SizeOf_NationalDrugCode<=ref_SizeOfNationalDrugCode) then
      return true
      end
end


function Validation.QuantityOrdered(QuantityOrdered,SizeOf_QuantityOrdered)
       type_QuantityOrdered=type(QuantityOrdered)
   print(type_QuantityOrdered,SizeOf_QuantityOrdered)
   ref_QuantityOrdered='string'
   ref_SizeOfQuantityOrdered=45
  if(type_QuantityOrdered==ref_QuantityOrdered and SizeOf_QuantityOrdered<=ref_SizeOfQuantityOrdered) then
      return true
      end
end


function Validation.Schedule(Schedule,SizeOf_Schedule)
       type_Schedule=type(Schedule)
   print(type_Schedule,SizeOf_Schedule)
   ref_Schedule='string'
   ref_SizeOfSchedule=45
  if(type_Schedule==ref_Schedule and SizeOf_Schedule<=ref_SizeOfSchedule) then
      return true
      end
end


function Validation.SizeOfPackages(SizeOfPackages,SizeOf_SizeOfPackages)
       type_SizeOfPackages=type(SizeOfPackages)
   print(type_SizeOfPackages,SizeOf_SizeOfPackages)
   ref_SizeOfPackages='string'
   ref_SizeOfSizeOfPackages=45
  if(type_SizeOfPackages==ref_SizeOfPackages and SizeOf_SizeOfPackages<=ref_SizeOfSizeOfPackages) then
      return true
      end
end


function Validation.Strength(Strength,SizeOf_Strength)
       type_Strength=type(Strength)
   print(type_Strength,SizeOf_Strength)
   ref_Strength='string'
   ref_SizeOfStrength=45
  if(type_Strength==ref_Strength and SizeOf_Strength<=ref_SizeOfStrength) then
      return true
      end
end


function Validation.SupplierItemNumber(SupplierItemNumber,SizeOf_SupplierItemNumber)
       type_SupplierItemNumber=type(SupplierItemNumber)
   print(type_SupplierItemNumber,SizeOf_SupplierItemNumber)
   ref_SupplierItemNumber='string'
   ref_SizeOfSupplierItemNumber=45
  if(type_SupplierItemNumber==ref_SupplierItemNumber and SizeOf_SupplierItemNumber<=ref_SizeOfSupplierItemNumber) then
      return true
      end
end







--validation for csos_order_header


function Validation.BusinessUnit(BusinessUnit,SizeOf_BusinessUnit)
       type_BusinessUnit=type(BusinessUnit)
   print(type_BusinessUnit,SizeOf_BusinessUnit)
   ref_BusinessUnit='string'
   ref_SizeOfBusinessUnit=255
  if(type_BusinessUnit==ref_BusinessUnit and SizeOf_BusinessUnit<=ref_SizeOfBusinessUnit) then
      return true
      end
end


function Validation.NoOfLines(NoOfLines,SizeOf_NoOfLines)
       type_NoOfLines=type(NoOfLines)
   print(type_NoOfLines,SizeOf_NoOfLines)
   ref_NoOfLines='string'
   ref_SizeOfNoOfLines=45
  if(type_NoOfLines==ref_NoOfLines and SizeOf_NoOfLines<=ref_SizeOfNoOfLines) then
      return true
      end
end


function Validation.OrderChannel(OrderChannel,SizeOf_OrderChannel)
       type_OrderChannel=type(OrderChannel)
   print(type_OrderChannel,SizeOf_OrderChannel)
   ref_OrderChannel='string'
   ref_SizeOfOrderChannel=45
  if(type_OrderChannel==ref_OrderChannel and SizeOf_OrderChannel<=ref_SizeOfOrderChannel) then
      return true
      end
end


function Validation.PODate(PODate,SizeOf_PODate)
       type_PODate=type(PODate)
   print(type_PODate,SizeOf_PODate)
   ref_PODate='string'
   ref_SizeOfPODate=45
  if(type_PODate==ref_PODate and SizeOf_PODate<=ref_SizeOfPODate) then
      return true
      end
end


function Validation.PONumber(PONumber,SizeOf_PONumber)
       type_PONumber=type(PONumber)
   print(type_PONumber,SizeOf_PONumber)
   ref_PONumber='string'
   ref_SizeOfPONumber=45
  if(type_PONumber==ref_PONumber and SizeOf_PONumber<=ref_SizeOfPONumber) then
      return true
      end
end






function Validation.ShipToNumber(ShipToNumber,SizeOf_ShipToNumber)
       type_ShipToNumber=type(ShipToNumber)
   print(type_ShipToNumber,SizeOf_ShipToNumber)
   ref_ShipToNumber='string'
   ref_SizeOfShipToNumber=45
  if(type_ShipToNumber==ref_ShipToNumber and SizeOf_ShipToNumber<=ref_SizeOfShipToNumber) then
      return true
      end
end






function Validation.UniqueTransactionNumber(UniqueTransactionNumber,SizeOf_UniqueTransactionNumber)
       type_UniqueTransactionNumber=type(UniqueTransactionNumber)
   print(type_UniqueTransactionNumber,SizeOf_UniqueTransactionNumber)
   ref_UniqueTransactionNumber='string'
   ref_SizeOfUniqueTransactionNumber=45
  if(type_UniqueTransactionNumber==ref_UniqueTransactionNumber and SizeOf_UniqueTransactionNumber<=ref_SizeOfUniqueTransactionNumber) then
      return true
      end
end


]]--

return Validation