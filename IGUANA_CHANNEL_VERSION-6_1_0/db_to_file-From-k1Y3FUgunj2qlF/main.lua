-- The main function is the first function called from Iguana.
function main()
  local ConnSource = db.connect{   
      api=db.SQL_SERVER, 
      name='SQL SERVER',
      user='',      -- use empty string for integrated security
      password='',  -- use empty string for integrated security 
      use_unicode = true,
      live = true
   }
   
      local R = ConnSource.execute{
      api=db.SQL_SERVER, 
      name='SQL SERVER',
      user='',      -- use empty string for integrated security
      password='',  -- use empty string for integrated security
      use_unicode = true,
      
     sql='SELECT * FROM PRODUCT1 ',
      
      --(2)sql = 'Select * from production',
      -- (3)sql='Select * from student';
      
      live = true}
    print(R)
	  X = queue.push(R)    
    
end
