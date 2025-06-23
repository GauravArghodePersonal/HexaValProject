@isTest
private class MessagingMethods_T {
/****************************************************************************
* Test Class MessagingMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - MessagingMethods Apex Class
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
    }

    private static void executeTest01() {
        // Execute Tests
 	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    mail.setToAddresses(new List<String>{'test@test.test'});
	    mail.setReplyTo('test@test.test');
	    mail.setSenderDisplayName('test');
	    mail.setSubject('test');
	    mail.setPlainTextBody('test');
	    mail.setHtmlBody('test');
        MessagingMethods.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }
}