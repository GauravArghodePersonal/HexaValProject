@isTest
private class Account_Trigger_Test_Class  {

//******************
//Test Method 
//******************
  static testMethod void TestMe() {
    
    Account acct1 = new Account();
    Account acct2 = new Account();
    Account acct3 = new Account();
    Account acct4 = new Account();
    Account acct5 = new Account();
    
    List<Account> accts = new List<Account>();
    
    acct1.Name = 'Test 1';
    acct2.Name = 'Test 2';
    acct3.Name = 'Test 3';
    acct4.Name = 'Test 4';
    acct5.Name = 'Test 5';
    acct5.ParentId = '0015000000tvxEv';
    acct5.VI_Account_Type__c = 'Facility';
    acct5.Type = 'Prospect';
    acct5.AccountNumber = 'P704122';
    acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
    acct2.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
    acct4.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
    acct5.country_picklist__c = 'Afghanistan (AF)';
    acct2.country_picklist__c = 'Afghanistan (AF)';
    acct4.country_picklist__c = 'Afghanistan (AF)';
    acct5.Prospect_Division__c = 'AAFI (50)';
    acct4.Prospect_Division__c = 'AAFI (50)';
    acct2.Prospect_Division__c = 'AAFI (50)';
    acct5.Prospect_Division__c = 'AAFI (50)';
    acct4.Prospect_Division__c = 'AAFI (50)';
    acct2.Prospect_Division__c = 'AAFI (50)';
    
    acct5.Prospect_Sales_District__c = 'ADDITIVES (11100)';
    acct4.Prospect_Sales_District__c = 'ADDITIVES (11100)';
    acct2.Prospect_Sales_District__c = 'ADDITIVES (11100)';
    
    acct5.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
    acct4.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
    acct2.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
    
    acct5.Prospect_Sales_Group__c = 'AM ARG/URU';
    acct4.Prospect_Sales_Group__c = 'AM ARG/URU';
    acct2.Prospect_Sales_Group__c = 'AM ARG/URU';
    
    acct5.Prospect_Dist_Channel__c = 'AAFI (50)';
    acct2.Prospect_Dist_Channel__c = 'AAFI (50)';
    acct4.Prospect_Dist_Channel__c = 'AAFI (50)';
    
    acct5.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
    acct4.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
    acct2.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
    
    acct5.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
    acct4.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
    acct2.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
    
    acct5.Prospect_Customer_Group__c = 'ADDITIVES (11)';
    acct4.Prospect_Customer_Group__c = 'ADDITIVES (11)';
    acct2.Prospect_Customer_Group__c = 'ADDITIVES (11)';
    
    acct5.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
    acct4.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
    acct2.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
    
    acct2.Prospect_Customer_Price_Group_Desc__c = 'ZL';
    acct4.Prospect_Customer_Price_Group_Desc__c = 'ZL';
    acct5.Prospect_Customer_Price_Group_Desc__c = 'A';
    
    
    acct1.SAP_Country__c = 'FR';
    acct2.SAP_Country__c = 'US';
    acct3.SAP_Country__c = 'FR';
    acct4.SAP_Country__c = 'US';
    acct5.SAP_Country__c = 'US';
    
    acct1.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
    acct4.BillingStreet = '';
    acct2.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
    acct3.BillingStreet = '';
    acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
    
    acct2.SAP_Customer_Number__c = '12345';
    
    acct3.Ship_To_Customer_Number__c = '12345';
    acct5.Ship_To_Customer_Number__c = '12345';
    
    acct1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Prospect','Account');
    acct2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    acct3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
    acct4.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Prospect','Account');
    acct5.RecordTypeId = '01250000000HmZ3AAK';

    accts.add(acct1);
    accts.add(acct2);
    accts.add(acct3);
    accts.add(acct4);
    accts.add(acct5);
    
    insert accts;
    update accts;
    delete accts;
  }

//The End
}