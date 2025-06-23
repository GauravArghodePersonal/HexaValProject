@isTest(seeAllData=True)
private class CaseTeamMemberHandlerTest {
    @isTest Private static void setup() {
   List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
     
     Account acct5 = new Account();
        acct5.Name = 'Test 5';
        acct5.ParentId = '0015000000tvxEv';
        acct5.Type = 'Prospect';
        acct5.AccountNumber = 'P704122';
        acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acct5.country_picklist__c = 'Afghanistan (AF)';
        acct5.Prospect_Division__c = 'AAFI (50)';
        acct5.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acct5.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acct5.Prospect_Sales_Group__c = 'AM ARG/URU';
        acct5.Prospect_Dist_Channel__c = 'AAFI (50)';
        acct5.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acct5.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acct5.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Price_Group_Desc__c = 'A';
        acct5.SAP_Country__c = 'US';
        acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acct5.PPE_Requirements__c='Hard Hat';
        acct5.Site_Access__c='Online Safety Training';
        acct5.Hours_of_Access__c='test';
        acct5.SAP_Customer_Number__c = '12345';
        acct5.Ship_To_Customer_Number__c = '12345';
        acct5.SAP_Sales_Office__c='IW31';
        acct5.SAP_SalesGroup__c='18I';        
        acct5.SAP_SalesDistrict__c='IWNA1';
        acct5.RecordTypeId = '01250000000HmZ3AAK';
    
        insert acct5; 
        
    Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APPL Inquiry').getRecordTypeId();
    system.debug('<<>>');
    Case cas = new Case();
        cas.AccountId = acct5.Id;
        cas.DZ_Number__c = '123456';
        cas.RecordTypeId = devRecordTypeId;
        cas.Status='New';
        cas.Specialties1__c='Boiler';
        cas.Sub_Specialties__c='High Pressure Boiler';
        cas.Description='Test';
        cas.Phone_Number__c='123456';
        cas.Subject = 'test case';
        cas.Submit_on_Save__c = false;
        
        system.debug('<<1>>'+cas.RecordTypeId);
        insert cas;
        system.debug('<<2>>');
        cas.DZ_Number__c = '1234567';
        update cas;
        system.debug('<<>>'+cas.ownerId);
      //  Test.stopTest();   
        }
}