@isTest(SeeAllData=true)
public class RelatedList_History_Component_Test {

  static testMethod void Method1() {
  	
  		// This test method uses SeeAllData because at the moment, there is no way to create AccountHistory records
  		// http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_testing_data_access.htm
  		// If this is ran in an empty org, to stop it from failing, an account is created, but even though 
  		// an update is made, no account history will exist for the account.
  	
        RelatedList_History_Component_Controller controller = new RelatedList_History_Component_Controller();
       
        system.assert(controller.getObjectHistory().size() == 0);
       
		Id accid;
		Boolean recFound = false;

		Account acct;
		try {
			AccountHistory historyRec = [select Accountid from accounthistory where isdeleted=false limit 1];
			accid = historyRec.AccountId;
			recFound = true; 
		}
		catch(Exception e) {
			acct = TestObjects.newAccount();
        	acct.Name = 'Test Name 2';
        	update acct;
			
			accid = acct.Id;
		}
       
        controller.ObjectName = [select id from Account where id=:accid];
        if (recFound) {
        	system.assert(controller.getObjectHistory().size() > 0);
        }
        else {
        	controller.getObjectHistory();
        }        
  }

}