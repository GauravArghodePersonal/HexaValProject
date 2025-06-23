global class IdeaSummaryEmailBatch implements Database.Batchable<Sobject>, Schedulable{
         
    global IdeaSummaryEmailBatch(){
        System.debug('IdeaSummaryEmailBatch -->'); 
    }
         
    global Database.queryLocator start(Database.BatchableContext bc){
        System.debug('IdeaSummaryEmailBatch --> start --> timestamp:' + system.now()); 
        string query = 'Select Id,Email From User Where IsActive = true ';
        if(Test.isRunningTest()){
            query += ' limit 1 ';
        }
        return Database.getQueryLocator(query);
    }
        
    global void execute(Database.BatchableContext bc, List<User> scope){
        System.debug('IdeaSummaryEmailBatch --> execute --> timestamp:' + system.now());

        SET<Id> setUserId = new SET<Id>();  
        for(User u : scope){
            setUserId.add(u.Id);
        }    
        
        // For test method use
        if(Test.isRunningTest()){
            setUserId.add(UserInfo.getUserId());
        }
        
        DateTime dtLastUpdated = system.now().addHours(-24);
        
        MAP<Id,Id> mapUserIdea = new MAP<Id,Id>();
        for(Idea_Follower__c iFollow : [Select Id,User__c,Idea__c From Idea_Follower__c 
                                        Where User__c IN:setUserId AND Idea__r.LastModifiedDate >=: dtLastUpdated ]){
            mapUserIdea.put(iFollow.User__c, iFollow.Idea__c);
        }
        
        List<Messaging.SingleEmailMessage> listEmailMsg = new List<Messaging.SingleEmailMessage>();
        Id templateId;
        for(EmailTemplate t : [Select Id,Name From EmailTemplate Where DeveloperName = 'Idea_SummaryEmail' limit 1]){
            templateId = t.Id;
        }
        
        for(Id uId : mapUserIdea.keySet()){
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            //emailMessage.setToAddresses(new String[] {email});
            emailMessage.setTemplateId(templateId);
            emailMessage.setTargetObjectId(uId);
            emailMessage.setWhatId(mapUserIdea.get(uId)); 
            emailMessage.setSaveAsActivity(false);
            listEmailMsg.add(emailMessage); 
        }

        if(listEmailMsg.size() > 0){
            // Send Email Notifications
            Messaging.sendEmail(listEmailMsg);
        }
    }    

    global void execute(SchedulableContext sc) {
        System.debug('IdeaSummaryEmailBatch --> Scheduler --> timestamp:' + system.now());
        Database.executeBatch(new IdeaSummaryEmailBatch(), 50);
    }   
        
    global void finish(Database.BatchableContext bc){
        System.debug('IdeaSummaryEmailBatch --> finish --> timestamp:' + system.now());    
    }
}