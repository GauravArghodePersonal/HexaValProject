@IsTest 
public class inforhelperTest {
    
    
    @TestSetup static void inforhelperTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
          User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing123', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
          u.IsActive = true;
           insert u;    
     }
    
    static testMethod void getInforecastTest(){
    
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User oUser = [SELECT ID FROM User WHERE LastName='Testing123' limit 1];
   
        Test.startTest();
        
        
        
        system.runAs(oUser){
            
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
             Account regularAccount = TestDataFactory.createAccount(false);
             regularAccount.Name = 'Account123';
             regularAccount.ownerId = oUser.id;
             regularAccount.RecordTypeId = accountRecordTypeId;
             regularAccount.AccountNumber = '19876';
             regularAccount.SAP_Sales_Org__c = '1020';
             regularAccount.ParentId = null;
            regularAccount.Sap_partner_functions__c = 'Sold To,Ship To';
            
            Insert regularAccount; 
            
            system.debug('Inserted regularAccount ++ ' + regularAccount);
             
            
            INFOR_Forecast__c Info = new INFOR_Forecast__c();
            Info.Account_ID__c = regularAccount.Id;
            Info.Opportunity_Name__c='Opportunity Name';
            Info.Material_Description__c='Material Description';
            Info.Material_Number__c = '000000000345678';
            Info.M_1__c=1;
            Info.Unit_Price__c = 23.3455;
            Info.M_10__c=1;        
            Insert Info;
            
            system.debug('Inserted infodata ++ ' + Info);
            String updatedata = '{"a8O770000005rbpEAE":{"inforid":"a8O770000005rbpEAE","month3":"0","month4":"78","month5":"-1"}}';
            
            //Account acc = [SELECT Id From Account WHERE AccountNumber = '19876' and SAP_Sales_Org__c = '1020' LIMIT 1];
            system.debug('Inserted Account ++ ' + regularAccount);
            inforHelper.getInforecast(regularAccount.Id);
            inforHelper.calculateTotalForOpportunityMaterial(regularAccount.Id);
            //inforHelper.updateforecastdata(updatedata);
            inforHelper.getOpportunityMaterial(regularAccount.id);
            inforHelper.getGrandTotal(regularAccount.id);
            inforHelper.getMonthsyear();
            String xx = inforHelper.getMonthYear( Date.today());
        }
        Test.stopTest();
    }
    
  
    
    
    
    
}