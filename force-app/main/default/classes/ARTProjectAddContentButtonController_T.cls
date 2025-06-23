@isTest
private class ARTProjectAddContentButtonController_T {
/****************************************************************************
 * Test Class ARTProjectAddContentButtonController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ARTProjectAddContentButtonController Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Blob b;
    
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
        b = Blob.valueOf('Test');

        
    }
  
    private static void executeTest01() {
        // Execute Tests

        ART_Project__c project = new ART_Project__c ();
        insert project;
       
        ApexPages.StandardController sc = new ApexPages.StandardController(project);
        ARTProjectAddContentButtonController c = new ARTProjectAddContentButtonController(sc);  

        //Test Null first
        c.upload();

        //Test with Real Data
        //c.newContent.PathOnClient = 'test.txt';
        //c.newContent.VersionData = b;
        c.upload();
        c.cancel();
    }
}