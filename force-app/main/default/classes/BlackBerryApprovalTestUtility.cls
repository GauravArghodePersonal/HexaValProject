/*
* Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
*/
 
/**
* Aux class to generate the items needed for code coverage tests.
* @author Bruno Fagundez
*/ 
public with sharing class BlackBerryApprovalTestUtility {
	
	/**
	* Method to generate the enviroment to run tests on empty orgs.
	*/ 
	@isTest public static void genApproval()
	{
		try {
		// Insert a dummy Account 
		Account acct = new Account();
		acct.Name = 'Test Method Account';
		insert acct;
		
		// Insert a dummy Contact
		Contact contact = new Contact();
		contact.AccountId = acct.id;
		contact.LastName = 'Test Method Contact';
		insert contact;
		
		// Insert 2 Approval proccesses.
		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
		req1.setComments('lorem ipsum');
		req1.setObjectId(acct.Id);
		req1.setNextApproverIds(new Id[] {Userinfo.getUserId()});
		
		Approval.ProcessResult result = Approval.process(req1);
		
		Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
		req2.setComments('lorem ipsum');
		req2.setObjectId(contact.Id);
		req2.setNextApproverIds(new Id[] {Userinfo.getUserId()});
		
		Approval.ProcessResult result2 = Approval.process(req2);
		
		List<Id> newWorkItemIds = result.getNewWorkitemIds();
		 
		BlackBerryApprovalTestUtil.workitemId = newWorkItemIds[0];
		} catch(Exception e) {} 
	}
}