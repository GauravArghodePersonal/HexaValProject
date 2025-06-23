@isTest
private class AdvancedDataTable_T {
/****************************************************************************
 * Test Class AdvancedDataTable_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AdvancedDataTable Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Advanced_Data_Table_Definition__c adtDef;
    public static Account a;
    public static Advanced_Data_Table_Custom_Filter__c f1;
    public static Advanced_Data_Table_Custom_Filter__c f2;
    public static Advanced_Data_Table_Column__c c1;
      
    //Test Settings
    
    
    private static testMethod void myUnitTest() {
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
        f1.Filter_Type__c = 'User Selectable';
        f1.Sort_Order__c = 1;
        insert f1;

        f2 = new Advanced_Data_Table_Custom_Filter__c();
        f2.Advanced_Data_Table_Definition__c = adtDef.Id;
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
        AdvancedDataTable adt = new AdvancedDataTable('Test'); 

        adt.retrieveSelectableCustomFilters();
        adt.retrieveUnselectableCustomFilters();
        adt.fieldMap();
        adt.fieldLabelMap();
        adt.visibleColumns();
        adt.fieldsToQuery();
        
        adt.retrieveCount(a.Id,'','','','','','','','',new List<String>());     
        adt.retrieveRelatedRecords(a.Id,1,0,new List<String>(),'','','','','','','','',new List<String>());     
        
    }
}