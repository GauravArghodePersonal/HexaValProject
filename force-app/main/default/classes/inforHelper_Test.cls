@isTest
public class inforHelper_Test {

   @TestSetup
   static void mySetup(){
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
      u.IsActive = true;
      insert u;
   }
		
    @isTest
     static void getInforecastTest(){
    
         try{
         //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User oUser = [SELECT ID FROM User WHERE LastName='Testing'];
   
        system.runAs(oUser){
            
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
             Account regularAccount = TestDataFactory.createAccount(false);
             regularAccount.Name = 'Account123';
             regularAccount.ownerId = oUser.id;
             regularAccount.RecordTypeId = accountRecordTypeId;
             regularAccount.AccountNumber = '19876';
             regularAccount.SAP_Sales_Org__c = '1020';
            regularAccount.ParentId = null;
            
            Insert regularAccount; 
            
            system.debug('Inserted regularAccount ++ ' + regularAccount);
             
            decimal ExchangeRate=1.0;
            INFOR_Forecast__c info = new INFOR_Forecast__c();
            info.Account_ID__c = regularAccount.Id;
            info.Opportunity_Name__c='Opportunity Name';
            info.Material_Description__c='Material Description';
            info.Unit_Price__c = 5;
            info.M_1__c=1;
            info.M_10__c=1;
            info.OF_M10__c=1;
            insert info;
            
            system.debug('Inserted infodata ++ ' + info);
            String updatedata = '{"a8O770000005rbpEAE":{"inforid":"a8O770000005rbpEAE","month3":"0","month4":"78","month5":"-1", "month6":"1", "month7":"10", "month8":"16", "month9":"-12", "month10":"17", "month11":"-21", "month12":"1"}}';
           
             inforHelper.getMonthsyear();
            String xx = inforHelper.getMonthYear( Date.today());
             inforHelper.getOpportunityMaterial(regularAccount.Id);
            System.debug(inforHelper.getInforecast(regularAccount.Id));
            inforHelper.updateforecastdata(updatedata);
        	}
     	}
          catch(Exception e)
         {
            System.debug(e.getStackTraceString());
         }
    }
    
    
     @isTest 
  	  static void getGrandTotalTest(){
        try{  
 		//User adminUser = [Select Id, Name From User Where Id =: UserInfo.getUserId()];
 		  User oUser = [SELECT ID FROM User WHERE LastName='Testing'];
         System.runAs(oUser){  
              Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
          Account regularAccount = TestDataFactory.createAccount(false);
          regularAccount.Name = 'Account123';
          regularAccount.ownerId = oUser.id;
          regularAccount.RecordTypeId = accountRecordTypeId;
          regularAccount.AccountNumber = '19876';
          regularAccount.SAP_Sales_Org__c = '0100';
             regularAccount.ParentId = null;
          Insert regularAccount;
          
               System.debug('++++++++Inserted regularAccount+++++++++++++++ ' + regularAccount);
         
       	
            INFOR_Forecast__c info = new INFOR_Forecast__c();
            info.Account_ID__c = regularAccount.Id;
            info.Opportunity_Name__c='Opportunity Name';
            info.Unit_Price__c = 5;
            info.Material_Description__c='Material Description';
            info.M_1__c=1;
            info.M_12__c = 1;
            Insert info;
             
              system.debug('++++++++Inserted infor+++++++++++++++ ' + info);
             
               System.debug(inforHelper.calculateTotalForOpportunityMaterial(regularAccount.Id));
               System.debug(inforHelper.getGrandTotal(regularAccount.Id));
           
        	 }
           
        }
        catch(Exception e)
         {
            System.debug(e.getStackTraceString());
         }
      }
}