@istest
public class ReleaseSaveWebServices_Test  {
     static  testMethod void ReleaseSaveWebServicesMethod(){
     
     List<String> recordIds = new List<String>();
     ART_Release__c rc = new ART_Release__c();
     insert rc;
     ART_Release__c rc1 = new ART_Release__c();
     insert rc1;

     List<Release_Instruction__c> ls = new List<Release_Instruction__c>();
     Release_Instruction__c re = new Release_Instruction__c();
     re.Release__c = rc.id;
     insert re;
     List<Release_Instruction__c> ls1 = new List<Release_Instruction__c>();
     Release_Instruction__c re1 = new Release_Instruction__c();
     re1.Release__c = rc1.id;
     insert re1;
     
     ReleaseSaveWebServices.deleteRecords('account',recordIds);
     ReleaseSaveWebServices.upsertRelease(rc,ls,ls1);
     }
 }