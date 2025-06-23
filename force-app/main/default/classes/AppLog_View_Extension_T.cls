@isTest
private class AppLog_View_Extension_T {
/****************************************************************************
 * Test Class AppLog_View_Extension_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AppLog_View_Extension Apex Class
 ****************************************************************************/
 
    //Test Data
    public static AppLog__c applog;
    
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
    	applog = new AppLog__c();
    	applog.Application_Name__c = 'Test';
    	insert applog;
    	
    	Blob b = Blob.valueOf('Test');
    	Attachment att = new Attachment();
    	att.Name = 'snapshot.png';
    	att.ParentId = applog.Id;
    	att.Body = b;
    	insert att;
    }
  
    private static void executeTest01() {
        // Execute Tests
        ApexPages.currentpage().getparameters().put( 'id', applog.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(applog);
        AppLog_View_Extension e = new AppLog_View_Extension(sc);
        
        Attachment att = e.snapshotAttachment;
        String snapshot = e.snapshot;
    }
}