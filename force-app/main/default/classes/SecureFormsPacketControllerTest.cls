@isTest
public with sharing class SecureFormsPacketControllerTest {
    @TestSetup
   static void setUp(){
    List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
       PriceFx__c p = new PriceFx__c();
       p.allowed_recordtype_id__c = '01250000000HmZV';
       p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
       p.Name='callAccount';
       p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
       p.password__c='Testuser@123';
       p.username__c='sfdctestuser';
       pfxCustomList.add(p);
       insert pfxCustomList;
       
       Account acc = new Account();
       acc.Name = 'Test 5';
       acc.Type = 'Prospect';
       acc.AccountNumber = 'P704122';
       acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
       acc.country_picklist__c = 'Afghanistan (AF)';
       acc.Prospect_Division__c = 'AAFI (50)';
       acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
       acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
       acc.Prospect_Sales_Group__c = 'AM ARG/URU';
       acc.Prospect_Dist_Channel__c = 'AAFI (50)';
       acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
       acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
       acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
       acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
       acc.Prospect_Customer_Price_Group_Desc__c = 'A';
       acc.SAP_Country__c = 'US';
       acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
       acc.SAP_Customer_Number__c = '12345';
       acc.Ship_To_Customer_Number__c = '12345';
       acc.SAP_Sales_Office__c='IW31';
       acc.SAP_SalesGroup__c='18I';        
       acc.SAP_SalesDistrict__c='IWNA1';
       acc.RecordTypeId = '01250000000HmZ3AAK';
       insert acc;
       
       SecureFormLink__c link = new SecureFormLink__c();
       link.Account__c = acc.Id;
       link.ToAddress__c = 'link@test.com';
       link.Body__c = 'test';
       insert link;   
   }

   @isTest 
   static void getCustomertTest(){
    SecureFormLink__c link = [SELECT Id 
                                FROM SecureFormLink__c
                                LIMIT 1];
    test.startTest();
    Account acc = SecureFormsInfoPacketController.getCustomerCreationRequest(link.Id);
    system.assert(acc!= null, 'accounts not exist');
    test.stopTest();
   }

   @isTest
   static void insertCustomerRequestTest(){
    Customer_Information_Packet__c packet = new Customer_Information_Packet__c();
    packet.SF_Customer_Legal_Name__c = 'Test 5';
    SecureFormLink__c link = [SELECT Id, Account__c 
                                FROM SecureFormLink__c
                                LIMIT 1];
    test.startTest();
    String IdPacket = SecureFormsInfoPacketController.insertCustomerCreationRequest(packet, link.Account__c);
    system.assert(IdPacket!= null, 'Packet not exist');
    test.stopTest();
   }

}