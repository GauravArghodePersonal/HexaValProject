@isTest(SeeAlldata=true)
public class PricingServiceTest {
    @isTest static void Testmethod1(){
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        acct2.Prospect_Sales_Org__c = 'Solenis LLC(1020)'; 
        acct2.country_picklist__c = 'Afghanistan (AF)'; 
        acct2.Prospect_Division__c = 'AAFI (50)'; 
        acct2.Prospect_Division__c = 'AAFI (50)'; 
        acct2.Prospect_Sales_District__c = 'ADDITIVES (11100)'; 
        acct2.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)'; 
        acct2.Prospect_Sales_Group__c = 'AM ARG/URU'; 
        acct2.Prospect_Dist_Channel__c = 'AAFI (50)'; 
        acct2.Prospect_Customer_Group1__c = 'AFFILIATE (412)'; 
        acct2.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)'; 
        acct2.Prospect_Customer_Group__c = 'ADDITIVES (11)'; 
        acct2.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)'; 
        acct2.Prospect_Customer_Price_Group_Desc__c = 'ZL'; 
        acct2.SAP_Country__c = 'US'; 
        acct2.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4'; 
        acct2.SAP_Customer_Number__c = '12345'; 
        acct2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account'); 
        insert acct2; 
        
        PricingService ps = new PricingService();
        
        Pricing__c Pricing =  new Pricing__c();
        pricing.Account__c = acct2.id;
        Pricing.Status__c='APPROVED';
        Pricing.Pricing_Type__c= 'Equipment Pricing';
       
        insert Pricing;
       
        Pricing__c Pricing1 =  new Pricing__c();
        //Pricing__c pricing = Pricing.getPricing(pricingId);
        //Pricing1 = [SELECT Id,Name,Status__c from Pricing__c ];
        PricingService.updatePricing(Pricing.Id);
        System.assertEquals('APPROVED',Pricing.Status__c );
  }  
}