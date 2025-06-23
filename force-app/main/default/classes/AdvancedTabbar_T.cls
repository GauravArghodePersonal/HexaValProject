@isTest
private class AdvancedTabbar_T {
/****************************************************************************
 * Test Class AdvancedTabbar_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AdvancedTabbar Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Advanced_Tabbar_Definition__c def;
    public static Advanced_Tabbar_Section__c section; 
    public static Advanced_Tabbar_Section__c section2; 
    
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
        def = new Advanced_Tabbar_Definition__c();
        def.Name = 'test';
        def.Starting_Object_Name__c = 'Account';
        insert def;
        
        section = new Advanced_Tabbar_Section__c();
        section.Advanced_Tabbar_Definition__c = def.Id;
        section.Sort_Order__c = 1;
        section.Tab_Label__c = 'test';
        insert section;

        section2 = new Advanced_Tabbar_Section__c();
        section2.Advanced_Tabbar_Definition__c = def.Id;
        section2.Sort_Order__c = 2;
        section2.Tab_Label__c = 'test2';
        section2.Include_on_RecordTypes__c = 'test';
        section2.Exclude_from_RecordTypes__c = 'test2';
        insert section2;
    }
  
    private static void executeTest01() {
        // Execute Tests

        AdvancedTabbar tabbar = new AdvancedTabbar('test');
        tabbar.defaultStartingRollupSection();
        tabbar.rollupLabel();
        tabbar.availableSections('');
        tabbar.availableSections('test');
        
    }
}