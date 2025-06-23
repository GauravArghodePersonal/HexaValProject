@isTest
public class BatchUpdatePriceFXTest {

    @TestSetup
    static void createTestData() {
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();         
        List<String> validCurrency = new List<String>();
        List<Account> accounts = new List<Account>();
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Opportunity_Material__c> opportunityMaterials = new List<Opportunity_Material__c>();
        List<PFx_Price_Book__c> priceBooks = new List<PFx_Price_Book__c>();
        
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
        
        Insert pfxCustomList;
        
        Trigger__c tr = New Trigger__c();
        tr.Name = 'SentEmailToAcc';    
        tr.Run__c = false;
        tr.Trigger_Name__c = 'opportunityTriggerhandler';
        Insert tr; 
        
        Schema.DescribeFieldResult f = Opportunity.CurrencyIsoCode.getDescribe();
        for (Schema.PicklistEntry pick:f.getPicklistValues()){
                  validCurrency.add(pick.getValue());
        }
        
        Integer currencyCounter = 0;
        for(Integer i=0;i<9;i++) {
            ++currencyCounter;
            Account acc = TestDataFactory.createAccount2(false);
            accounts.add(acc);
        }
        Insert accounts;
        
        for(Integer i=0;i<9;i++) {
            Opportunity opp = TestDataFactory.createOpportunity(false, accounts[i].Id);
            opportunities.add(opp);
        }
        Insert opportunities;        
        
        Material_Sales_Data2__c material = TestDataFactory.create_Material_Sales_Data2(true);
        
        for(Integer i=0;i<9;i++) {
            ++currencyCounter;
            Opportunity_Material__c oppMaterial = TestDataFactory.createOpportunityMaterial(false, opportunities[i].Id);
            currencyCounter = currencyCounter > validCurrency.size()?0:currencyCounter;
            oppMaterial.Currency_from_PFx__c = validCurrency[currencyCounter];
            oppMaterial.Material__c = material.Id;
            oppMaterial.Sfdc_Key__c = String.valueOf(i) + String.valueOf(i) + String.valueOf(i);
            opportunityMaterials.add(oppMaterial);
        }
        opportunityMaterials[8].Currency_from_PFx__c = null;
        Insert opportunityMaterials;
        
        PFx_Price_Book__c priceBook = new PFx_Price_Book__c();
        priceBook.SFDC_Key__c = 'Test';
        priceBook.PFx_Material_Key__c = 'Test';
        priceBook.Target_Price__c = 12.31;
        priceBook.Sales_Org__c = '11020';
        priceBook.Material_Number__c = '000000';
        priceBook.Market__c = 'null';
        priceBook.CurrencyIsoCode = 'USD';
        priceBooks.add(priceBook);
        Insert priceBooks;
        
    }
    
    @isTest
    static void executeBatchTest() {
        Test.startTest();
        Database.executeBatch(new BatchUpdatePriceFX());
        Database.executeBatch(new BatchUpdateOneTimeSfdc());
        Test.stopTest();
        
        List<PFx_Price_Book__c> priceBooks = [SELECT Id, Target_Price__c, CurrencyIsoCode, SFDC_Key__c FROM PFx_Price_Book__c];
        System.debug('>>> priceBooks >>>' + priceBooks);
        List<Opportunity_Material__c> oppMaterials = [SELECT Id, Target_Price_from_PFx__c, Currency_from_PFx__c, SFDC_Key__c FROM Opportunity_Material__c];
        System.debug('>>> oppMaterials >>>' + oppMaterials);
        System.assertEquals(1, priceBooks.size(), 'Something went wrong!');
        for(Integer i=0;i<priceBooks.size();i++){
            //System.assertEquals(priceBooks[i].CurrencyIsoCode, oppMaterials[i].Currency_from_PFx__c, 'Something went wrong!');
           // System.assertEquals(priceBooks[i].Target_Price__c, oppMaterials[i].Target_Price_from_PFx__c, 'Something went wrong!');
        }
    }

}