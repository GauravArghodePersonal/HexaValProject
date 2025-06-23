@isTest
private class AdvancedDataTableQueryBuilder_T {
/****************************************************************************
 * Test Class AdvancedDataTableQueryBuilder_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AdvancedDataTableQueryBuilder Apex Class
 ****************************************************************************/
 
   //Test Data
    public static Advanced_Data_Table_Definition__c adtDef;
    public static Account a;
    public static Advanced_Data_Table_Custom_Filter__c f1;
    public static Advanced_Data_Table_Custom_Filter__c f2;
    public static Advanced_Data_Table_Column__c c1;
    
    
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

        adtDef = new Advanced_Data_Table_Definition__c();
        adtDef.Name = 'Test';
        adtDef.Object_Name__c = 'Account';
        adtDef.Data_Table_Label__c = 'Test';
        insert adtDef;
        
        f1 = new Advanced_Data_Table_Custom_Filter__c();
        f1.Advanced_Data_Table_Definition__c = adtDef.Id;
        f1.Name = 'test1';
        f1.Filter_Type__c = 'User Selectable';
        f1.Sort_Order__c = 1;
        insert f1;

        f2 = new Advanced_Data_Table_Custom_Filter__c();
        f2.Advanced_Data_Table_Definition__c = adtDef.Id;
        f2.Name = 'test2';
        f2.Filter_Type__c = 'Auto Applied';
        f2.Sort_Order__c = 1;
        insert f2;
        
        c1 = new Advanced_Data_Table_Column__c();
        c1.Advanced_Data_Table_Definition__c = adtDef.Id;
        c1.Enabled__c = true;
        c1.Visible__c = true;
        insert c1;
    }
  
    private static void executeTest01() {
        // Execute Tests
        AdvancedDataTableQueryBuilder queryBuilder = new AdvancedDataTableQueryBuilder();
        
        queryBuilder.filterField1 = 'test';
        queryBuilder.filterField2 = 'test2';
        
        queryBuilder.fieldList .add('test');
        
        queryBuilder.customFilters.add('test');
        queryBuilder.customFilters.add('test');

        queryBuilder.orderByFields.add('test');
        queryBuilder.orderByFields.add('test');
        
        queryBuilder.queryStyle = 'Standard';
        queryBuilder.generateSOQL('COUNT');
        queryBuilder.generateSOQL('SELECT');

        queryBuilder.filterStyle = 'Normal';
        queryBuilder.generateSOQL('SELECT');

        queryBuilder.filterStyle = 'Include All Child Records';
        queryBuilder.generateSOQL('SELECT');

        queryBuilder.filterStyle = 'Include Starting Record and Child Records';
        queryBuilder.generateSOQL('SELECT');
        
        queryBuilder.queryStyle = 'Account Relationship Child Where Parent';
        queryBuilder.generateSOQL('COUNT');
        queryBuilder.generateSOQL('SELECT');

        queryBuilder.filterStyle = 'Normal';
        queryBuilder.generateSOQL('SELECT');

        queryBuilder.filterStyle = 'Include All Child Records';
        queryBuilder.generateSOQL('SELECT');

        queryBuilder.filterStyle = 'Include Starting Record and Child Records';
        queryBuilder.generateSOQL('SELECT');
        
    }
}