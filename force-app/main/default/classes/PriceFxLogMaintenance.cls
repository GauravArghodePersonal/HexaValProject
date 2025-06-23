/***********

Class Name : PriceFxLogMaintenance
Description : This Class used to delete and reprocess the PriceFx data

***********/
global class PriceFxLogMaintenance implements Database.Batchable<sObject>{
    global String [] email = new String[] {'vinu.sankaralingam@techmahindra.com'};
    global Database.QueryLocator start(Database.BatchableContext BC){
        Database.QueryLocator query;
        //query = Database.getQueryLocator([select id,CreatedDate,Status_of_the_Process__c,Name,Re_Processed__c from PriceFx_Webservice_Logs__c where Status_of_the_Process__c= 'Success' OR Re_Processed__c =True ORDER BY CreatedDate]);
       // query = Database.getQueryLocator([select id,CreatedDate,Status_of_the_Process__c,Name,Re_Processed__c from PriceFx_Webservice_Logs__c where createdDate < 2020-02-15T00:00:00.000+0000 ORDER BY CreatedDate]);
          query = Database.getQueryLocator([select id,CreatedDate,Status_of_the_Process__c,Name,Re_Processed__c from PriceFx_Webservice_Logs__c where CreatedDate < LAST_MONTH limit 2000000]);

        return query;
    }
    
    global void execute(Database.BatchableContext BC, List<PriceFx_Webservice_Logs__c> scope) {
        if(!scope.isEmpty()){
            System.debug('scope - which is going to be deleted>>>>>'+scope);
            delete scope;   
            Database.emptyRecycleBin(scope);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      
      // Below code will fetch the job Id
      AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
      a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
      a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
      
      // get the job Id
      System.debug('$$$ Jobid is'+BC.getJobId());
      
      // below code will send an email to User about the status
      mail.setToAddresses(email);
      mail.setReplyTo('test@test.com'); // Add here your email address
      mail.setSenderDisplayName('Apex Batch Processing Module');
      mail.setSubject('Batch Processing '+a.Status);
      mail.setPlainTextBody('The Batch Apex job processed'+ a.TotalJobItems+'batches with '+a.NumberOfErrors+'failures'+'Job Item processed are'+a.JobItemsProcessed);
      Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }
}