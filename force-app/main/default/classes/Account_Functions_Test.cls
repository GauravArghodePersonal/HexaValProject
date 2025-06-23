@isTest
private class Account_Functions_Test {

  private static void debug(String s) {System.debug(LoggingLevel.INFO, 'Account_Functions_Test : ' + s);}

  static testmethod void test01() {
  //Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        
        
        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        
        PriceFx__c p2 = new PriceFx__c();
        p2.allowed_recordtype_id__c = '01250000000HmZV';
        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p2.Name='callCustomerProductInfo2';
        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p2.password__c='Testuser@123';
        p2.username__c='sfdctestuser';
        pfxCustomList.add(p2);
        
        PriceFx__c p3 = new PriceFx__c();
        p3.allowed_recordtype_id__c = '01250000000HmZV';
        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p3.Name='callMaterialPlant2';
        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p3.password__c='Testuser@123';
        p3.username__c='sfdctestuser';
        pfxCustomList.add(p3);
        
        insert pfxCustomList;
      

    Test.startTest();
   testAccountAgeInDays();
    testAccountDelete('System Administrator');
    testAccountDelete('W-Standard User');
    Test.stopTest();
  }
  
  /* 
    static testMethod void test02() {
        Account a1 = new Account(Name='A1'), a2 = new Account(Name='A2');
        List<Account> alist = new List<Account>{a1, a2}; insert alist;
        List<Pricing_Condition> plist = PricingConditionFunctions_Test.getPclist();
        Pricing_Condition__c p1 = plist[0].pricingCondition; 
        p1.Account__c = a2.Id; update p1;
        merge a1 a2;
        for (Pricing_Condition__c p : [
            select Id, Name from Pricing_Condition__c
             where Account__c = :a1.Id]) {debug('p = ' + p);}
    }
*/

  private static void testAccountAgeInDays() {

    Account[] accts = new Account[]{}; 
    Account acct1 = new Account();
    Account acct2 = new Account();
    
    acct1.Name = 'Test 1';
    acct2.Name = 'Test 2';
      acct1.ParentId = null;
      acct1.BillingCountry = 'Canada';
      acct1.country_picklist__c = 'ABC';
    
   //acct1.RecordTypeId.Name = RecordType_Functions.LookupRecordTypeId('','Account');
   // acct1.Type = 'Prospect';
    //acct2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
    //acct2.Type = 'Customer';
    
    accts.add(acct1);
    accts.add(acct2);
    
    insert accts;

      
    
    Double age = Account_Functions.Calculate_Account_Age_in_Days(acct1.id);
    Boolean isnew1 = Account_Functions.isNewProspect(acct1.id);
    Boolean isnew2 = Account_Functions.isNewProspect(acct2.id);
  
    debug('isnew1 = ' + isnew1);
    debug('isnew2 = ' + isnew2);
    
    
  }
  
  private static void testAccountDelete(String profileName) {
    Merging_Record_Type__c mergeing = new Merging_Record_Type__c(ObjectName__c  = 'Account',RecordType__c = 'Water Prospect'); 
    insert mergeing;
    
    Merging_Record_Type__c mergeing1 = new Merging_Record_Type__c(ObjectName__c  = 'Account',RecordType__c = 'Drew Customer'); 
    insert mergeing1;
    
    Merging_Record_Type__c mergeing2 = new Merging_Record_Type__c(ObjectName__c  = 'Account',RecordType__c = 'Competitive Intel'); 
    insert mergeing2;
    
    /*SAP_Customer_Group5__c ss = new SAP_Customer_Group5__c(Customer_Group5_Code__c = '1a3',Language_Code__c ='E',Source_System_Id__c='wedfdgwejdnejhej');
    insert ss;*/
    
    Id prospectRecordTypeId = [select Id from RecordType 
                                where Name = 'Water Prospect' 
                                  and sObjectType = 'Account' limit 1].Id;
    
    Id accountRecordTypeId  = [select Id from RecordType 
                                where Name = 'Drew Customer' 
                                  and sObjectType = 'Account' limit 1].Id;
                                  
    Id competitiveRecordTypeId  = [select Id from RecordType 
                                where Name = 'Competitive Intel' 
                                  and sObjectType = 'Account' limit 1].Id;
    
    Account prospectAccount = new Account();
    prospectAccount.Name = 'Prospect';
    prospectAccount.RecordTypeId = prospectRecordTypeId;
    
    Account regularAccount = new Account();
    regularAccount.Name = 'Account';
    regularAccount.RecordTypeId = accountRecordTypeId;
    
    Account competitiveAccount = new Account();
    competitiveAccount.Name = 'Account1';
    competitiveAccount.RecordTypeId = competitiveRecordTypeId;
    
    Account[] aa = new Account[] {prospectAccount, regularAccount,competitiveAccount};
    insert aa;
    
    aa[0].Prospect_Sales_Org__c = '101';
    aa[1].Prospect_Sales_Org__c = '101';
    aa[2].Prospect_Sales_Org__c = '101';
    
    aa[0].Prospect_Division__c = '1';
    aa[1].Prospect_Division__c = '1';
    aa[2].Prospect_Division__c = '1';
    
    aa[0].Prospect_Customer_Group__c = '1';
    aa[1].Prospect_Customer_Group__c = '1';
    aa[2].Prospect_Customer_Group__c = '1';
    
    aa[0].Prospect_Sales_District__c = '1';
    aa[1].Prospect_Sales_District__c = '1';
    aa[2].Prospect_Sales_District__c = '1';
    
    aa[0].Prospect_Sales_Office__c= '1';
    aa[1].Prospect_Sales_Office__c = '1';
    aa[2].Prospect_Sales_Office__c = '1';
    
    aa[0].Prospect_Sales_Group__c = '1';
    aa[1].Prospect_Sales_Group__c = '1';
    aa[2].Prospect_Sales_Group__c = '1';
    
     aa[0].Prospect_Customer_Price_Group_Desc__c = 'ZT';
    aa[1].Prospect_Customer_Price_Group_Desc__c = 'ZT';
    aa[2].Prospect_Customer_Price_Group_Desc__c = 'ZT';
    
    aa[0].Prospect_Dist_Channel__c = '1';
    aa[1].Prospect_Dist_Channel__c = '1';
    aa[2].Prospect_Dist_Channel__c = '1';
    
    aa[0].Prospect_Customer_Group1__c = '1';
    aa[1].Prospect_Customer_Group1__c = '1';
    aa[2].Prospect_Customer_Group1__c = '1';
    
    aa[0].type = 'Marked for Deletion';
    aa[0].cis_prospect_status__c = 'Inactive';
    aa[1].SAP_Customer_Group_5__c = '154';
    
    
    
    update aa;
    
    Account_Functions.printAccounts(aa);
    
    Profile p = [select id from profile 
                  where name=:profileName];
                  
    User u;

    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        u = TestObjects.newUser(new Map<String,String>{'ProfileId'=>p.Id}); 
    }
  
    /*                  
    User u = [select id from user 
               where profileid = :p.Id
                 and isActive = true 
               limit 1];
    */
    
    if (u != null) {
        System.runAs(u) {
            try {
                delete prospectAccount;
                // merge regularAccount prospectAccount;
            } catch(Exception e) {
                debug(e.getMessage());
                //validateAndLogForDelete(aa);
            }
        }
    }
    
  }

}