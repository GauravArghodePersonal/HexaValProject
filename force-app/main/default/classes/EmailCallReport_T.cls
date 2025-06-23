@isTest
private class EmailCallReport_T {
/****************************************************************************
 * Test Class EmailCallReport_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - EmailCallReport Apex Class
 ****************************************************************************/
 
    //Test Data
    static EmailCallReport e;
    static Contact contact;
    
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

		Account a = TestObjects.newAccount();
		
		contact = TestObjects.newContact(new Map<String,String>{'AccountId'=>a.Id,'FirstName'=>'contact1','Email'=>'test@test.test'});

        Call_Report__c c = new Call_Report__c();
        c.Account__c = a.Id;
        c.Contact__c = contact.Id;
        insert c;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User u;
        System.runAs ( thisUser ) {
            u = TestObjects.newUser(new Map<String,String>{'LastName'=>'contact1'}); 
        }
        
        List<Contact> cons = new List<Contact>();
        cons.add(contact);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        e = new EmailCallReport(sc);    
    }
  
    private static void executeTest01() {
        // Execute Tests

		e.getRecipientTypeItems();
		e.getAvblRecipientItems();
		e.getSelRecipientItems();

		e.recipientTypes = '';
		e.retrieveAvblRec();

		e.recipientTypes = 'User';
		e.retrieveAvblRec();

		e.recipientTypes = 'Related Contacts';
		e.retrieveAvblRec();

		e.filterNameVar = 'contact1';

		e.recipientTypes = 'User';
		e.retrieveAvblRec();

		e.recipientTypes = 'Related Contacts';
		e.retrieveAvblRec();
		
		e.avblRecipients = new List<String>();
		e.avblRecipients.add(contact.Email);
		e.selectedRecipients();
		
		e.selRecipients = new List<String>();
		e.selRecipients.add(contact.Email);
		e.deselectedRecipients();

		e.addtnlEmails = 'test@test.test';
		e.sendEmail();
		e.isAddnEmailFormatCorrect();

		e.addtnlEmails = '123';
		e.sendEmail();
		e.isAddnEmailFormatCorrect();
    }
}