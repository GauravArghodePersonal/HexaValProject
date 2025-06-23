@isTest
private class SetMethods_T {
/****************************************************************************
* Test Class SetMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - SetMethods Apex Class
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
	    SetMethods.newWithData(blobData);
	    
	    Boolean b;
	    SetMethods.newWithData(b);
	    
	    Date dateData;
	    SetMethods.newWithData(dateData);
	    
	    Datetime datetimeData;
	    SetMethods.newWithData(datetimeData);
	    
	    Decimal dec;
	    SetMethods.newWithData(dec);
	    
	    Double dbl;
	    SetMethods.newWithData(dbl);
	    
	    Id id = '001000000000000';
	    SetMethods.newWithData(id);
	    
	    Integer i;
	    SetMethods.newWithData(i);
	    
	    Long l;
	    SetMethods.newWithData(l);
	    
	    String s = '';
	    SetMethods.newWithData(s);
	    
	    Time timeData;
	    SetMethods.newWithData(timeData);
	    
	    Object obj;
	    SetMethods.newWithData(obj);
	    
	    sObject sobj;
	    SetMethods.newWithData(sobj);
    }
}