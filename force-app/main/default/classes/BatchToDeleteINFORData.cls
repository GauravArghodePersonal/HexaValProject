global class BatchToDeleteINFORData implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String soqlQuery = 'SELECT id From INFOR_Forecast__c';
        return Database.getQueryLocator(soqlQuery);
    }
     
    global void execute(Database.BatchableContext bc, List<INFOR_Forecast__c> scope){
         
        if(scope.size()>0){
            delete scope;
        }
    }
     
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email, ExtendedStatus
                            from AsyncApexJob where Id = :BC.getJobId()];
        
        // Email the Batch Job's submitter that the Job is finished.
        List<String> toAddresses = new List<String>();

        INFOR_Forecast_Metadata__mdt emaildata = INFOR_Forecast_Metadata__mdt.getInstance('Email_Ids');
        system.debug('emaildata++++' + emaildata);
        if(emaildata!=null){
            for(String email1 : emaildata.Emails__c.split(';')){
                toAddresses.add(email1);
            }
            
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(toAddresses);
        mail.setSubject('INFOR Deletion Job Status: ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures. Status: ' + a.Status);
        
        System.debug('mail+++++' + mail);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(exception e){
            System.debug('Got error in email+++');
        }
        
        
        
    }

    global void execute(SchedulableContext sc)
    {
        BatchToDeleteINFORData objClass = new BatchToDeleteINFORData();
        Database.executeBatch (objClass,2000);
    }
}