@isTest
private class BatchUpdateOppTest {

    @TestSetup
    static void createTestData() {
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
        
        Insert pfxCustomList;
        
        Trigger__c tr = New Trigger__c();
        tr.Name = 'SentEmailToAcc';    
        tr.Run__c = false;
        tr.Trigger_Name__c = 'opportunityTriggerhandler';
        Insert tr;   
        
        List<String> validCurrency = new List<String>();
        Schema.DescribeFieldResult f = Opportunity.CurrencyIsoCode.getDescribe();
        for (Schema.PicklistEntry pick:f.getPicklistValues()){
                  validCurrency.add(pick.getValue());
        }
        List<Account> accounts = new List<Account>();
        List<Opportunity> opportunities = new List<Opportunity>();
        Material_Sales_Data2__c material = TestDataFactory.create_Material_Sales_Data2(true);
        List<Opportunity_Material__c> opportunityMaterials = new List<Opportunity_Material__c>();
        
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
        
        for(Integer i=0;i<9;i++) {
            ++currencyCounter;
            Opportunity_Material__c oppMaterial = TestDataFactory.createOpportunityMaterial(false, opportunities[i].Id);
            currencyCounter = currencyCounter > validCurrency.size()?0:currencyCounter;
            oppMaterial.Currency_from_PFx__c = validCurrency[currencyCounter];
            oppMaterial.Material__c = material.Id;
            opportunityMaterials.add(oppMaterial);
        }
        opportunityMaterials[8].Currency_from_PFx__c = null;
        INFOR_Forecast_Service.IsUpdateOppMat = false;
        Insert opportunityMaterials;
    }
    
    @isTest
    static void executeBatchTest() {
        Test.startTest();
        Database.executeBatch(new BatchUpdateOpp());
        Database.executeBatch(new BatchUpdateOneTimeSfdc());
        Test.stopTest();
        List<Opportunity_Material__c> opportunityMaterials = [SELECT Id, CurrencyIsoCode, Currency_from_PFx__c FROM Opportunity_Material__c WHERE CurrencyIsoCode != null AND Currency_from_PFx__c != null ORDER BY CurrencyIsoCode ASC];
        System.assertEquals(8, opportunityMaterials.size(), 'Something went wrong!');
        for(Integer i=0;i<opportunityMaterials.size();i++){
          //  System.assertEquals(opportunityMaterials[i].CurrencyIsoCode, opportunityMaterials[i].Currency_from_PFx__c, 'Something went wrong!');
        }
    }
}