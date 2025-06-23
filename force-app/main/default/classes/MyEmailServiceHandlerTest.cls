@isTest
private class MyEmailServiceHandlerTest {
    
    static testMethod void testInboundEmailHandler() {
        
         // Insert a COC__C record for testing
         Contract_lab__c newContractLab = new Contract_lab__c();
        newContractLab.Name = 'test';
        insert newContractLab;
        
        COC__C newCOC = new COC__C();
        newCOC.Contract_lab__c = newContractLab.Id;
        insert newCOC;
        String cocName = [select Id,Name from COC__c where Id =: newCOC.Id].Name;
        // Create a test email message
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Email Subject'+'"'+cocName+'"';
        // Create a test binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.fileName = 'TestAttachment.txt';
        attachment.body = Blob.valueOf('This is a test attachment.');
        email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ attachment };
            
            
        
        // Call the email handler
        MyEmailServiceHandler emailHandler = new MyEmailServiceHandler();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(email, envelope);
        
        // Verify that the attachment was inserted
        System.assertEquals(1, [SELECT count() FROM Attachment]);
        
        // Clean up test data
        delete newCOC;
    }
}