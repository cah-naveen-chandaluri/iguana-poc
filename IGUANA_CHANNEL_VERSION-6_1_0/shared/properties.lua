local Properties =  {}

function Properties.directory_path()

  input_directory_path  = "C:\\3PL_WO\\OrderFiles\\"
  output_archived_path  = "C:\\3PL_WO\\ArchivedFiles\\"
  output_error_path = "C:\\3PL_WO\\ErrorFiles\\"
  xmldata_C_O_D="order_data.root.CSOSOrderRequest.CSOSOrder.Order.OrderItem."
   xmldata_C_O_H="order_data.root.CSOSOrderRequest.CSOSOrder.OrderSummary."
end

return Properties
