local email_authentication =  {} 
function email_authentication.Email_auth()
smtpparams={
      header = {To = 'sripad091@gmail.com'; 
                From = 'sripad.dyavarshetty@cardinalhealth.com'; 
                Date = 'Thu, 23 Aug 2001 21:27:04 -0400';
                Subject = 'Test Subject';},
      username = 'user',
      password = 'password',
      server = 'smtp://domain.mailserver.com:25',
      -- note that the "to" param is actually what is used to send the email, 
      -- the entries in header are only used for display. 
      -- For instance, to do Bcc, add the address in the  'to' parameter but 
      -- omit it from the header.
      to = {'sripad091@gmail.com'},
      from = 'Test User <sripad.dyavarshetty@cardinalhealth.com>',
      body = 'This is the test body of the email',
      use_ssl = 'try'
   } 
 
  net.smtp.send(smtpparams)
end
return email_authentication