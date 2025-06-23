global class CreditHoldUpdate implements Database.Batchable<sObject>{
    private String query;
    String s = 'B';

    global CreditHoldUpdate(String query) {
        this.query = query;
        //'select id,CreditFlag2__c,Credit_Start_Date2__c,EmailAcctOwnerInit1__c from Open_Orders__c where Credit_Release_Status_Code__c = s and CreditHoldFlag1__c = True and CreditFlag2__c = False and Credit_Start_date1__c = YESTERDAY and Credit_Start_Date2__c = null';

                          }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Open_Orders__c> scope){
         List<Open_Orders__c> OrdersToUpdate = new List<Open_Orders__c>();
       for(Open_Orders__c a : scope){ 
           a.CreditFlag2__c = True; 
           a.Credit_Start_Date2__c = System.Today();
           a.EmailAcctOwnerInit1__c = True; 
           OrdersToUpdate .add(a); 
       } 
       update OrdersToUpdate;    }

    global void finish(Database.BatchableContext BC){
    }
}