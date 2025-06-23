global class LWR_ProcessLIMSmessage implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        // Email Notification Flow Parameter Map
        Map<String, Object> inputs = new Map<String, Object>();
       // Messaging.InboundEmailResult.success == TRUE; //added
        result.success = true;
        String lwrNumber = email.subject.split('LWR-')[1];
        System.debug('--LWrnumber contents-->' + lwrNumber);
        try{
           List<LWR__c> lwrList = [SELECT Id,Status__c,Sections__c,Analytical_File_Uploaded__c,Applications_File_Uploaded__c, Paper_Making_File_Uploaded__c, Paper_Testing_File_Uploaded__c, Colorants_File_Uploaded__c, Pulp_File_Uploaded__c FROM LWR__c WHERE Name =:lwrNumber]; //added
            if(!lwrList.isEmpty())
            {
                // add lwr id to the flow parameter map
                inputs.put('recordId',lwrList[0].Id);
                
                //if received attachment type is Binary
                if(email.binaryAttachments != null){
                for (Messaging.Inboundemail.BinaryAttachment file : email.binaryAttachments) 
                {
                  addBinaryAttachment(file,lwrList[0].Id);
                }
                }
                 //if received attachment type is Text
                if(email.textAttachments != null){
                for (Messaging.Inboundemail.TextAttachment file : email.textAttachments) 
                {
                  addTextAttachment(file,lwrList[0].Id);
                }
                }
                 // Check the Analytical File Uploaded to true
                 List<String> multiPicklistValues = new List<String>(lwrList[0].Sections__c?.split(';'));
                if(multiPicklistValues.contains('Analytical')){
                    lwrList[0].Analytical_File_Uploaded__c = True;
                    update lwrList[0];
                }
                
                     // Update the status to 'Completed' Pure Analytical
                String previousStatus = lwrList[0].Status__c;
               if(previousStatus== 'Accepted/In Progress' && lwrList[0].Sections__c == 'Analytical'){
                lwrList[0].Status__c = 'Completed';
                lwrList[0].Date_Completed__c = System.today(); 
                update lwrList[0];
                }
                
                //create instance of Interview
                Flow.Interview.LWR_Attachments_Email_notification_Auto_Launch instance = new Flow.Interview.LWR_Attachments_Email_notification_Auto_Launch(inputs);
                
                //Invoke start method
                instance.start();
                
                    // Update the status to 'Completed'
                if(previousStatus== 'Accepted/In Progress' && multiPicklistValues.contains('Analytical')){
                List<String> selectedSections = lwrList[0].Sections__c.split(';');
                Boolean isStatusCompleted = false;
                
                if (selectedSections.size() == 2) {
                if (    (isAnalytical(selectedSections,lwrList[0]) && 
                            ( isPaperMaking(selectedSections,lwrList[0]) || 
                              isPaperTesting(selectedSections,lwrList[0]) || 
                              isPulp(selectedSections,lwrList[0]) || 
                              isColorants(selectedSections,lwrList[0]) || 
                              isApplications(selectedSections,lwrList[0]) )
                         ) 
                    )
                        {isStatusCompleted = true;}
                }
     
                if (selectedSections.size() == 3) {
                if (   (isAnalytical(selectedSections,lwrList[0]) && isApplications(selectedSections,lwrList[0]) &&
                          (   isPaperMaking(selectedSections,lwrList[0]) ||
                              isPaperTesting(selectedSections,lwrList[0]) ||
                              isPulp(selectedSections,lwrList[0]) || 
                              isColorants(selectedSections,lwrList[0]) 
                            ) 
                        ) ||   
                       (isAnalytical(selectedSections,lwrList[0]) && isPaperMaking(selectedSections,lwrList[0]) &&
                          (   isPaperTesting(selectedSections,lwrList[0]) ||
                              isPulp(selectedSections,lwrList[0]) || 
                              isColorants(selectedSections,lwrList[0]) 
                            )
                        ) || 
                       (isAnalytical(selectedSections,lwrList[0]) && isPaperTesting(selectedSections,lwrList[0]) &&
                          (   isColorants(selectedSections,lwrList[0]) || 
                              isPulp(selectedSections,lwrList[0])
                            )
                        ) || 
                        (isAnalytical(selectedSections,lwrList[0]) && isColorants(selectedSections,lwrList[0]) &&
                        isPulp(selectedSections,lwrList[0])
                        )    
                    ) 
                    { isStatusCompleted = true; }
                }
                    
                if (selectedSections.size() == 4) {
                    if (( isAnalytical(selectedSections,lwrList[0]) && 
                            isApplications(selectedSections,lwrList[0]) &&
                            isPaperMaking(selectedSections,lwrList[0]) &&
                           (  isPaperTesting(selectedSections,lwrList[0]) ||
                              isPulp(selectedSections,lwrList[0]) || 
                              isColorants(selectedSections,lwrList[0]) 
                            ) 
                         ) ||
                       (  isAnalytical(selectedSections,lwrList[0]) && 
                            isApplications(selectedSections,lwrList[0]) &&
                            isPaperTesting(selectedSections,lwrList[0]) &&
                           (  isPulp(selectedSections,lwrList[0]) || 
                              isColorants(selectedSections,lwrList[0]) 
                            )
                        ) ||
                        (isAnalytical(selectedSections,lwrList[0]) &&
                            isPaperMaking(selectedSections,lwrList[0])&&
                            isPaperTesting(selectedSections,lwrList[0]) &&
                           (  isPulp(selectedSections,lwrList[0]) || 
                              isColorants(selectedSections,lwrList[0]) 
                            ) 
                        ) ||
                        (isAnalytical(selectedSections,lwrList[0]) &&
                            isPulp(selectedSections,lwrList[0]) &&
                            isColorants(selectedSections,lwrList[0])&&
                           (  isPaperTesting(selectedSections,lwrList[0]) || 
                              isPaperMaking(selectedSections,lwrList[0]) ||
                              isApplications(selectedSections,lwrList[0])
                            ) 
                        ) 
                    ) 
                    {  isStatusCompleted = true; }
                }
                
                if (selectedSections.size() == 5) {
                    if ((isAnalytical(selectedSections,lwrList[0]) &&
                            isApplications(selectedSections,lwrList[0]) &&
                            isPaperMaking(selectedSections,lwrList[0]) &&
                            isPaperTesting(selectedSections,lwrList[0]) &&
                           (  isColorants(selectedSections,lwrList[0]) || 
                              isPulp(selectedSections,lwrList[0])
                            )
                        ) ||
                        (isAnalytical(selectedSections,lwrList[0]) &&
                            isApplications(selectedSections,lwrList[0]) &&
                            isColorants(selectedSections,lwrList[0]) &&
                            isPulp(selectedSections,lwrList[0]) &&
                           (   isPaperMaking(selectedSections,lwrList[0]) ||
                               isPaperTesting(selectedSections,lwrList[0])
                            )
                        ) ||
                        (isAnalytical(selectedSections,lwrList[0]) &&
                        isPaperMaking(selectedSections,lwrList[0]) &&
                        isPaperTesting(selectedSections,lwrList[0]) &&
                        isColorants(selectedSections,lwrList[0]) && 
                         isPulp(selectedSections,lwrList[0])) 
                    ) {   isStatusCompleted = true; }
                }
                                   
                if (selectedSections.size() == 6) {
                    if (( isAnalytical(selectedSections,lwrList[0]) && 
                          isApplications(selectedSections,lwrList[0]) &&
                          isPaperMaking(selectedSections,lwrList[0]) &&
                          isPaperTesting(selectedSections,lwrList[0]) &&
                          isColorants(selectedSections,lwrList[0]) && 
                          isPulp(selectedSections,lwrList[0]) )
                       ) {  isStatusCompleted = true;   }
                }
                
                if (isStatusCompleted) {
                    lwrList[0].Status__c = 'Completed';                     
                	lwrList[0].Date_Completed__c = System.today();                    
                }
                // Perform the update
                update lwrList[0];
                    
                }
            }
            //added
            else {
                result.success = false;
                // If processing fails, send email with attachments to another address
            if (result.success == false) {
                Messaging.SingleEmailMessage newEmail = new Messaging.SingleEmailMessage();
                newEmail.setToAddresses(new List<String>{ 'SFDC@solenis.com' });
                newEmail.setccAddresses(new List<String>{ 'cchampeau@solenis.com' });
                newEmail.setSubject('Email Processing Failed, No LWR record found');
                newEmail.setPlainTextBody('Please verify the LWR Number and details with LIMS and upload the report manually. Please find the original email details and attachments attached below.' +' \n Email subject:-'+ email.subject +'\n Email Content Details:- '+ email.plainTextBody);

                 // Attach original attachments (BinaryAttachments and TextAttachments)
                List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
                
                // Attach original attachments
             if(email.binaryAttachments != null){
                for (Messaging.InboundEmail.BinaryAttachment attachment : email.binaryAttachments) {
                    Messaging.EmailFileAttachment newAttachment = new Messaging.EmailFileAttachment();
                    newAttachment.setFileName(attachment.fileName);
                    newAttachment.setBody(attachment.body);
                    fileAttachments.add(newAttachment);
                }
              }
                
             if(email.textAttachments != null){
                for (Messaging.InboundEmail.TextAttachment attachment : email.textAttachments) {
                    Messaging.EmailFileAttachment newAttachment = new Messaging.EmailFileAttachment();
                    newAttachment.setFileName(attachment.fileName);
                    newAttachment.setBody(Blob.valueOf(attachment.body));
                    fileAttachments.add(newAttachment);
                }
              }
                // Set all file attachments
                newEmail.setFileAttachments(fileAttachments);
                // Send the email
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ newEmail });
            }
                //return result;
            }
                
        }
        catch(Exception ex){
            result.message = 'Exception occured while processing the LIMS email contents. Please try again, if issue happens again, please reach out to SFDC Team!';
            System.debug('--Exception occured while processing the LIMS email contents-->' + ex);
        }   
        
        return result;
    }
    //method for Binary Attachments
@TestVisible
    static void addBinaryAttachment(Messaging.Inboundemail.BinaryAttachment file, Id lwrId) {
        if(file != null){     

            List<ContentVersion> contentVersions = [SELECT ContentDocumentId FROM ContentVersion WHERE Title =:file.fileName ORDER BY CreatedDate DESC LIMIT 1];
            
            // Creates the new contentversion with previous content document id
            ContentVersion cv = new ContentVersion();
            cv.Title = file.fileName;
            cv.PathOnClient = file.fileName;
            cv.VersionData = file.body;
            cv.IsMajorVersion = true;
            cv.contentDocumentId = contentVersions.isEmpty()?null:contentVersions[0].ContentDocumentId;
            Insert cv;
            
            contentVersions = [SELECT ContentDocumentId FROM ContentVersion WHERE Title =:file.fileName ORDER BY CreatedDate DESC LIMIT 1];
            List<ContentDocumentLink> existingLinks = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :contentVersions[0].ContentDocumentId AND LinkedEntityId = :lwrId];

            if (existingLinks.isEmpty()) {
                // The link does not exist, proceed with insertion
                ContentDocumentLink conDocLink = new ContentDocumentLink();
                conDocLink.LinkedEntityId = lwrId;
                conDocLink.ContentDocumentId = contentVersions[0].ContentDocumentId;
                conDocLink.shareType = 'V';
                insert conDocLink;
            }
 
        }
    }
    //method for Text Attachments
@TestVisible
    static void addTextAttachment(Messaging.Inboundemail.TextAttachment file, Id lwrId) {
        if(file != null){     

            List<ContentVersion> contentVersions = [SELECT ContentDocumentId FROM ContentVersion WHERE Title =:file.fileName ORDER BY CreatedDate DESC LIMIT 1];
            
            // Creates the new contentversion with previous content document id
            ContentVersion cv = new ContentVersion();
            cv.Title = file.fileName;
            cv.PathOnClient = file.fileName ;
            cv.VersionData = Blob.valueof(file.body);
            cv.IsMajorVersion = true;
            cv.contentDocumentId = contentVersions.isEmpty()?null:contentVersions[0].ContentDocumentId;
            Insert cv;
            
            contentVersions = [SELECT ContentDocumentId FROM ContentVersion WHERE Title =:file.fileName ORDER BY CreatedDate DESC LIMIT 1];
           
             List<ContentDocumentLink> existingLinks = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :contentVersions[0].ContentDocumentId AND LinkedEntityId = :lwrId];

            if (existingLinks.isEmpty()) {
                // The link does not exist, proceed with insertion
                ContentDocumentLink conDocLink = new ContentDocumentLink();
                conDocLink.LinkedEntityId = lwrId;
                conDocLink.ContentDocumentId = contentVersions[0].ContentDocumentId;
                conDocLink.shareType = 'V';
                insert conDocLink;
            }
            
        }
    }

@TestVisible
private static Boolean isAnalytical(List<String> selectedSections, LWR__c lwr){

    return selectedSections.contains('Analytical') && lwr.Analytical_File_Uploaded__c;
}

@TestVisible
private static Boolean isApplications(List<String> selectedSections, LWR__c lwr){

    return selectedSections.contains('Applications') && lwr.Applications_File_Uploaded__c;
}

@TestVisible
private static Boolean isPaperMaking(List<String> selectedSections, LWR__c lwr){

    return selectedSections.contains('Paper Making') && lwr.Paper_Making_File_Uploaded__c;
}

@TestVisible
private static Boolean isPaperTesting(List<String> selectedSections, LWR__c lwr){

    return selectedSections.contains('Paper Testing') && lwr.Paper_Testing_File_Uploaded__c;
}

@TestVisible
private static Boolean isColorants(List<String> selectedSections, LWR__c lwr){

    return selectedSections.contains('Colorants') && lwr.Colorants_File_Uploaded__c;
}
    
@TestVisible
private static Boolean isPulp(List<String> selectedSections, LWR__c lwr){

    return selectedSections.contains('Pulp') && lwr.Pulp_File_Uploaded__c;
}
}