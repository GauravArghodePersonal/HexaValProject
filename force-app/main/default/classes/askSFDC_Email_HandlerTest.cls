@isTest
private class askSFDC_Email_HandlerTest{
    static testMethod void testUnsubscribe() 
    {
      
       
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();    
       
       // Test with the subject that matches the unsubscribe statement.
       email.subject = 'Test Contact Email';
       //email.plainTextBody = 'Test Contact Email';
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
          attachment.body = blob.valueOf('my attachment text');
          attachment.fileName = 'textfile.txt';
          attachment.mimeTypeSubType = 'text/plain';
   
          email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };

       env.fromAddress = 'Srinivasan.Muthu@TechMahindra.com';
       askSFDC_Email_Handler obj= new askSFDC_Email_Handler();
       obj.handleInboundEmail(email, env );
                            
    }
     
}