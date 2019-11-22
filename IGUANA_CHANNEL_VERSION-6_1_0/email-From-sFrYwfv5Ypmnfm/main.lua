function main()
   -- Set up the parameters to be used with sending an email
   local smtpparams={
      header = {To = 'sales@interfaceware.com'; 
                From = '<your email name>'; 
                Date = '';
                Subject = 'Test Subject';},
      username = '<your mail username>',
      password = '<your mail password>',
      server = '<your smtp mail server name>', 
      -- note that the "to" param is actually what is used to send the email, 
      -- the entries in header are only used for display. 
      -- For instance, to do Bcc, add the address in the  'to' parameter but 
      -- omit it from the header.
      to = {'sales@interfaceware.com','admin@interfaceware.com'},
      from = 'Test User ',
      body = 'This is the test body of the email',
      use_ssl = 'try',
      --live = true -- uncomment to run in the editor
   } 
 
  net.smtp.send(smtpparams)
end