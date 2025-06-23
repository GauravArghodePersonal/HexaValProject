@isTest
private class WebMethodsInterface_T {
/****************************************************************************
 * Test Class APEXCLASS_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - APEXCLASS Apex Class
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

		WebMethodsInterface.createAshlandWebSiteLead(TestObjects.newLead(false));
		
		SAP_Ultimate_Parent__c s = new SAP_Ultimate_Parent__c();
		s.Legal_Ultimate_Parent_Number__c = '0';
		WebMethodsInterface.upsertSAPUltimateParent(s);
		WebMethodsInterface.deleteSAPUltimateParent(s);
		
		SAP_ECOM_Customer__c e = new SAP_ECOM_Customer__c();
		WebMethodsInterface.upsertSAPECOMCustomer(e);
		WebMethodsInterface.deleteSAPECOMCustomer(e);
		
		WebMethodsInterface.GetAllTSRData();
		
		WebMethodsInterface.updateCasesFromCaseNumbers('000');
    }
}