@isTest
private class AdvancedTabbarController_T {
/****************************************************************************
 * Test Class APEXCLASS_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - APEXCLASS Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Account a;
    public static Advanced_Tabbar_Definition__c def;
    public static Advanced_Tabbar_Section__c section; 
    public static Advanced_Tabbar_Section__c section2; 
    
    
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
        a = TestObjects.NewAccount();

        def = new Advanced_Tabbar_Definition__c();
        def.Name = 'test';
        def.Starting_Object_Name__c = 'Account';
        insert def;
        
        section = new Advanced_Tabbar_Section__c();
        section.Advanced_Tabbar_Definition__c = def.Id;
        section.Name = 'test';
        section.Sort_Order__c = 1;
        section.Tab_Label__c = 'test';
        insert section;

        section2 = new Advanced_Tabbar_Section__c();
        section2.Advanced_Tabbar_Definition__c = def.Id;
        section2.Name = 'test2';
        section2.Sort_Order__c = 2;
        section2.Tab_Label__c = 'test2';
        section2.Include_on_RecordTypes__c = 'test';
        section2.Exclude_from_RecordTypes__c = 'test2';
        insert section2;
    }
  
    private static void executeTest01() {
        // Execute Tests
        AdvancedTabbarController c = new AdvancedTabbarController();    
        c.rollupDefinitionName = 'test';
        c.recordTypeName = 'test';
        c.startingId = a.Id;
        c.newSectionSelected = 'test';
        
        c.processNewSectionSelected();
    }
}