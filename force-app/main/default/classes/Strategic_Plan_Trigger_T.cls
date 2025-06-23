@isTest
private class Strategic_Plan_Trigger_T {
/****************************************************************************
 * Test Class Strategic_Plan_Trigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Strategic_Plan_Trigger Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
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
        // No Test Data Needed
    }
  
    private static void executeTest01() {
        // Execute Tests
 		Account a = TestObjects.NewAccount();
 		Strategic_Plan__c strategicPlan = TestObjects.NewStrategic_Plan(new Map<String,String>{'Account__c'=>a.Id});
 		Strategic_Plan__c strategicPlan2 = TestObjects.NewStrategic_Plan(new Map<String,String>{'Account__c'=>a.Id},false);
 		strategicPlan2.Active_Strategic_Plan__c = true;
 		insert strategicPlan2;
 		
 		strategicPlan2.Active_Strategic_Plan__c = false;
 		update strategicPlan2;
 		
 		delete strategicPlan;
 		delete strategicPlan2;
    }}