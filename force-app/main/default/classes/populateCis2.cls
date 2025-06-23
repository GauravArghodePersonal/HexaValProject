public class populateCis2{
     public static void populateSoldTo(List<Account> acc){
         Map<string,id> serchCIS = new map<string,id>();
         Map<id,string> accMap = new Map<id,string>();
         List<Account> accSource = new List<Account>();
         List<Account> accUpdate = new List<Account>();
         Set<id> accIds = new Set<id>();
         for(Account a : acc){
             //string searchString = '';
             //searchString = a.id+a.Account_Number__c+'Sold To';
             //serchCIS.put(searchString,a.id);
             accIds.add(a.id);
             System.debug('Vinu>>>populateCis2>>accIds>>>'+accIds);
         }
         List<CISRelationships__c> cisList = [select Ext_Unique_ID_c__c,Customer_Type__c,Customer_Number__c,Source_Customer__c from CISRelationships__c where Source_Customer__c IN : accIds];
         Map<string,CISRelationships__c> cisMap = new Map<string,CISRelationships__c>();
             System.debug('Vinu>>>cisList>>'+cisList);
             for(CISRelationships__c c : cisList){
                 if(c.Customer_Type__c == 'Sold To'){
                     cisMap.put(c.Source_Customer__c,c);    
                 }    
             }
             /*if(cisMap.size()>0 && !cisMap.isEmpty()){
                 
                 for(string s :cisMap.keySet()){
                    accMap.put(serchCIS.get(s),cisMap.get(s));
                 }
             }*/
             // Update the Account
             if(!cisMap.isEmpty() && cisMap.size()>0){
                 accSource = [select id,CIS_Sold_To__c,SAP_Customer_Number__c from Account where ID IN : cisMap.keySet()];
             }
             if(!accSource.isEmpty() && accSource.size()>0){
                 
                 for(Account a : accSource){
                     if(a.SAP_Customer_Number__c != cisMap.get(a.id).Customer_Number__c){
                         a.CIS_Sold_To__c = cisMap.get(a.id).Customer_Number__c;
                         accUpdate.add(a);
                     }
                 }    
             }
         System.debug('Vinu>>>cisList>>>'+cisList);
         RecursiveTriggerHandler.isFirstTime = false;
         update accUpdate;
     }
}