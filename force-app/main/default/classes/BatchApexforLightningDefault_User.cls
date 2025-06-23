global class BatchApexforLightningDefault_User implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
         Set<Id> records = new Set<Id>{'00e2J000001aa4P','00e2J000001aa5N','00e2J000001aa5S','00e2J000001aa4A','00e2J000001aa4B','00e2J000001aa4C',
                                                                                                '00e2J000001aa45','00e2J000001aa5X','00e2J000001aa4D','00e2J000001aa4E'};
     String query = 'SELECT FirstName,Full_Name__c,Id,IsActive,LastName,LastLoginDate,ProfileId,Name,Region__c,UserPreferencesLightningExperiencePreferred FROM User where UserPreferencesLightningExperiencePreferred=false and IsActive=true and profileid In:records';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<User> usrList) {
        
        // process each batch of records default size is 200
        for(User usr : usrList) {        
            // Update the User UserPreferencesLightningExperiencePreferred field to True 
            usr.UserPreferencesLightningExperiencePreferred = true;
        }
        try {
            // Update the User Record lightning default
            update usrList;
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}