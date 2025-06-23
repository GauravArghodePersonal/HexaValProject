@isTest
private class XREF_Country_to_SalesOrg_T {
/****************************************************************************
 * Test Class XREF_Country_to_SalesOrg_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - XREF_Country_to_SalesOrg Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
    //Test Settings
    
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	XREF_Country_to_SalesOrg__c newRec = new XREF_Country_to_SalesOrg__c();
    	newRec.Cust_ShipTo_Country_Code__c = 'TEST';
    	newRec.Cust_ShipTo_Country__c = 'TEST';
    	newRec.Sales_Org__c = '1234';
    	insert newRec;
    }
  
    private static void executeTest01() {
        // Execute Tests
		List<String> results = XREF_Country_to_SalesOrg.availableSalesOrgsForCountry('TEST');
    }
}