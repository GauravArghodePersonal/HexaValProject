@isTest
private class ListMethods_T {
/****************************************************************************
* Test Class ListMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - ListMethods Apex Class
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
        Blob blobData;
		ListMethods.newWithData(blobData);
		
		Boolean b;
		ListMethods.newWithData(b);
		
		Date dateData;
		ListMethods.newWithData(dateData);
		
		Datetime datetimeData;
		ListMethods.newWithData(datetimeData);
		
		Decimal dec;
		ListMethods.newWithData(dec);
		
		Double dbl;
		ListMethods.newWithData(dbl);
		
		Id id = '001000000000000';
		ListMethods.newWithData(id);
		
		Integer i;
		ListMethods.newWithData(i);
		
		Long l;
		ListMethods.newWithData(l);
		
		String s = '';
		ListMethods.newWithData(s);
		
		Time timeData;
		ListMethods.newWithData(timeData);
		
		Object obj;
		ListMethods.newWithData(obj);
		
		sObject sobj;
		ListMethods.newWithData(sobj);
		
		
		List<sObject> sobjs = new List<sObject>();
		sobjs.add(new Account());
		ListMethods.extractSetId(sobjs,'Id');
    }
}