@isTest
private class UltimateParentDataAnalyzerController_T {
/****************************************************************************
* Test Class UltimateParentDataAnalyzerController_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - UltimateParentDataAnalyzerController Apex Class
****************************************************************************/
 
    //Test Data


    //Test Settings 


    private static testMethod void myUnitTest() {
    
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

        // Create Test Data
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }

    private static void createTestData() {
        // No Test Data Needed
    }

    private static void executeTest01() {
        // Execute Tests
        Account a = TestObjects.NewAccount();
        Account_Relationship__c ar = TestObjects.NewAccount_Relationship(new Map<String,String>{'Child_Account__c' =>a.Id});
        ApexPages.currentpage().getparameters().put( 'id' , a.Id);
        UltimateParentDataAnalyzerController c = new UltimateParentDataAnalyzerController();
        c.toggleShowAll();  
        c.rebuildAccountRelationshipsforAccount();
        c.deleteAccountRelationshipRecord();
        c.rebuildAccountRollupRecord();
        c.reprocessECOMCustRecords();
        
        UltimateParentDataAnalyzerController.AcctCompare acctCompare;
        String msg;  
        acctCompare = new UltimateParentDataAnalyzerController.AcctCompare(a.Id,a,ar);
        msg = acctCompare.message;
        acctCompare = new UltimateParentDataAnalyzerController.AcctCompare(a.Id,null,ar);
        msg = acctCompare.message;
        acctCompare = new UltimateParentDataAnalyzerController.AcctCompare(a.Id,a,null);
        msg = acctCompare.message;
    }
}