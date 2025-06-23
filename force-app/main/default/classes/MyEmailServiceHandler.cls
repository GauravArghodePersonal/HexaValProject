global class MyEmailServiceHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        // Parse the subject to extract the record ID
        String subject = email.subject;
        String recordId = extractRecordIdFromSubject(subject);
        List<Attachment> attList = new List<Attachment>();
        // This will extract all blob attachments from email
        // For text type attachment Messaging.Inboundemail.TextAttachment can be used
        for (Messaging.Inboundemail.BinaryAttachment file : email.binaryAttachments) 
        {
            Attachment attachment = new Attachment();
            attachment.Name = file .fileName;
            attachment.Body = file .body;
            // some hardcoded or id extracted from email reference
            attachment.ParentId = [select Id,Name from COC__C where Name =:recordId LIMIT 1]?.Id;
            attList .add(attachment);
        }
        if(attList .size()>0)
        {
            insert attList;
        } 
        
        
        return result;
    }
    
    // Add a method to extract the record ID from the subject
    private String extractRecordIdFromSubject(String subject) {
        
        String extractedValue='';
        // Find the first occurrence of a double quote
        Integer firstQuoteIndex = subject.indexOf('"');
        
        if (firstQuoteIndex >= 0) {
            // Find the next occurrence of a double quote after the first one
            Integer secondQuoteIndex = subject.indexOf('"', firstQuoteIndex + 1);
            
            if (secondQuoteIndex >= 0) {
                // Extract the text between the first and second double quotes
                extractedValue = subject.substring(firstQuoteIndex + 1, secondQuoteIndex);
            } else {
            }
        } else {
        }
        
        return extractedValue;
    }
}