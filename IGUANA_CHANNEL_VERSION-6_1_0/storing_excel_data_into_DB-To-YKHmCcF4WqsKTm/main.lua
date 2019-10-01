
 
function main(Data)
  

  
d= Data
 f=parse(d)
a = f[2][2]
   print(a)
   end




 function parse(line,sep)

   
   local Rows = line:split("\n")
   print(Rows)
   for i=1, #Rows do
   
      Rows[i] = Rows[i]:split(",")
        
      print(Rows[i])
      for j=1, #Rows[i] do
       
           Rows[i][j] = Rows[i][j]
      end
   end
   Rows[#Rows] = nil
   return Rows
end
