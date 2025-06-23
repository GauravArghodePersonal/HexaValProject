@isTest
private class resubscribe_Test {

// The following test methods provide adequate code coverage.
// There are two methods, one that does the testing
// with a valid "unsubcribe" in the subject line
// and one the does not contain "unsubscribe" in the
// subject line.

static testMethod void testResubscribe() {
        Test.startTest();

// Create a new email and envelope object.
Messaging.InboundEmail email = new Messaging.InboundEmail() ;
Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

// Create a new test lead and insert it in the test method.
Lead l = new lead(
Salutation = 'Mr.',
firstName='John',
lastName='Smith',
Company='Salesforce',
Email='user@acme.com',
HasOptedOutOfEmail=true);
insert l;

// Create a new test contact and insert it in the test method.
Contact c = new Contact(
Salutation = 'Mr.',
firstName='john',
lastName='smith',
Email='user@acme.com',
HasOptedOutOfEmail=true);
insert c;

// Test with the subject that matches the unsubscribe statement.
email.subject = 'test resubscribe test';
env.fromAddress = 'user@acme.com';

// Call the class and test it with the data in the testMethod.
resubscribe resubscribeObj = new resubscribe();
resubscribeObj.handleInboundEmail(email, env );

}

}