@isTest
private class leadTriggerHandlertest{
    @isTest 
    Private static void leadTriggerHandlerTest01(){
        Id LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Web Request').getRecordTypeId();
        Lead lstLead =   new Lead();
        lstLead.Company = 'Test Lead';
        lstLead.LastName = 'Test Lname';
        lstLead.Status = 'Open';    
        lstLead.Pool_Solution_Country__c='Canada (CA)';   
        lstLead.recordtypeid= LeadRecordTypeId;       
        insert lstLead;   
    }
     @isTest 
     Private static void leadTriggerHandlerTest02(){
         Id LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Web Request').getRecordTypeId();
        Lead lstLead =   new Lead();
        lstLead.Company = 'Test Lead0001';
        lstLead.LastName = 'Test Lname';
        lstLead.Status = 'Open';    
        lstLead.country='Canada';  
        lstLead.recordtypeid= LeadRecordTypeId;         
        insert lstLead;  
        update  lstLead;
    }
     @isTest 
    Private static void leadTriggerHandlerTest03(){
        Id LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Web Request').getRecordTypeId();
        Lead lstLead =   new Lead();
        lstLead.Company = 'Test Lead0002';
        lstLead.LastName = 'Test Lname';
        lstLead.Status = 'Open';    
        lstLead.country='Belarus'; 
        lstLead.recordtypeid= LeadRecordTypeId;          
        insert lstLead;  
        update  lstLead;
    }
     @isTest 
    Private static void leadTriggerHandlerTest04(){
        Id LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Web Request').getRecordTypeId();
        Lead lstLead =   new Lead();
        lstLead.Company = 'Test Lead0003';
        lstLead.LastName = 'Test Lname';
        lstLead.Status = 'Open';    
        lstLead.country='Colombia';
        lstLead.recordtypeid= LeadRecordTypeId;           
        insert lstLead;  
        update  lstLead;
    }
      @isTest 
    Private static void contactpoolsoltrigger(){
        Id conRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Pool_Solutions').getRecordTypeId();
        contact lstcon =   new Contact();
         lstcon.LastName='test';
        lstcon.Title='testss';
        lstcon.Primary_Role__c='end user';
        lstcon.Email='test@tst.com';
       //lstcon.MailingAddress='test';
        lstcon.MailingCity='test';
        lstcon.MailingCountry='Null';
        insert lstcon;
    }
     @isTest
     Private static void  opportunityupdatepoolsoltrigger(){
         
         Trigger__c Tr = New Trigger__c();
               Tr.Name='SentEmailToAcc';    
               Tr.Run__c=True;
               Tr.Trigger_Name__c='opportunityTriggerhandler';
           Insert Tr;     
           
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pool_Solutions').getRecordTypeId();
        opportunity opp =   new  opportunity();
        opp.Name = 'test';
        opp.StageName = 'Lost Business';
        //opp.CurrencyIsoCode ='';
        opp.closeDate =  Date.today();
        opp.RecordTypeId = oppRecordTypeId;
        
        insert opp; 
         
         opp.StageName = 'Won';
         opp.Business_Team__c='IC1D';
         update opp;
         
         
    }
}