@isTest
private class OrgSettings_T {
/****************************************************************************
 * Test Class OrgSettings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - OrgSettings Apex Class
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
		String setting1 = OrgSettings.retrieveSetting('Test');
		Boolean exists1 = OrgSettings.settingExists('Test');
		
		Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get('OrgSettings__c');
		Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();
		
		Map<String, Schema.SObjectField> fMap = sobjectDescribe.fields.getMap();
		
		if (fMap.size() > 0) {
			List<Schema.SObjectField> fieldList = fMap.values();
			
			String fieldName = '';
			
			for (Schema.SObjectField field : fieldList) {
				String possiblefieldName = field.getDescribe().getName();
				if (possiblefieldName.right(3) == '__c') {
				   	fieldName = possiblefieldName;
				   	break;
				}
			}

			if (fieldName != '') {
				String setting2 = OrgSettings.retrieveSetting(fieldName);
				Boolean exists2 = OrgSettings.settingExists(fieldName);
			}
			
			System.debug('fieldName = ' + fieldName);
		} 
    }
}