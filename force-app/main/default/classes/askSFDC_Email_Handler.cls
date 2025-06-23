global class askSFDC_Email_Handler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String userid;
        string phoneNo;
         list<user> usr = new list<user>();
         usr =[select id,email,Phone from user where isactive=true]; 
         system.debug('<<<email.fromAddress>>'+email.fromAddress);  
         for(user u: usr){
             if(email.fromAddress==u.email){
                 userid=u.id;  
                 phoneNo=u.Phone;          
             }
         }  
            if(userid=='' || userid==null){
                userid='00550000005tHlsAAE';
            }   
            system.debug('<<<userid>>'+userid);       
        Ask_SFDC__c Ask = New Ask_SFDC__c();
            ask.Short_Description__c = email.subject;
            ask.Detailed_Description__c = email.plainTextBody;
            ask.Phone__c=phoneNo;
            ask.Caller__c=userid;
            ask.Manual__c=false;
            
            insert ask;  
            
 if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {           
             List<ContentVersion>cvList = new List<ContentVersion>();
    List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
    for (Messaging.InboundEmail.BinaryAttachment binAttach : email.binaryAttachments) {
        ContentVersion testContentInsert = new ContentVersion();
        testContentInsert.Title = binAttach.fileName;
        testContentInsert.VersionData = binAttach.body;
        testContentInsert.PathOnClient = '/' + binAttach.fileName ;
        cvList.add(testContentInsert);

    }
    insert cvList;
    cvList = [select id, ContentDocumentId from ContentVersion WHERE Id in :cvList];
    for (ContentVersion cv : cvList) {
            ContentDocumentLink cl = new ContentDocumentLink();
            cl.ContentDocumentId = cv.ContentDocumentId;
            cl.LinkedEntityId = ask.id; //Shared with record ID
            cl.ShareType = 'V';
            cl.Visibility = 'AllUsers';
            cdlList.add(cl);



    }
    insert cdlList;
        
   }     
        
       
    result.success = true;
        return result;
    }

    
}