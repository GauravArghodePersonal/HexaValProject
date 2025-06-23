/**
 * Contains test methods for the VIPortalAccessRequestController class.
 */
@IsTest
private class VIPortalAccessRequestControllerTest {
	/**
	 * Method to test the portal access request for both off book and on book users.
	 */
	static testMethod void portalAccessRequest() {
		
		VIPortalAccessRequestController portalRequest=new VIPortalAccessRequestController();
		portalRequest.init();
		// ensure the step is first after init
		System.assertEquals(portalRequest.getCurrentStep(), 1);
		portalRequest.step2();
		// ensure the step is 2 after calling step2 function
		System.assertEquals(portalRequest.getCurrentStep(), 2);
		
		portalRequest.step3();
		// ensure the step is 3 after calling step3 function
		System.assertEquals(portalRequest.getCurrentStep(), 3);
		
		//insert test account with the SAP number to emulate onbook registration process.
		  //insert test distributor
        Account testAccount = new Account();
        testAccount.AccountNumber='123456';
        testAccount.SAP_Street__c='Street Line1';
        testAccount.SAP_StreetSuppl1__c='Street Line2';
        testAccount.SAP_StreetSuppl2__c='Street Line3';
        testAccount.SAP_StreetSuppl3__c='Stree line4';
        testAccount.SAP_City__c='test city';
        testAccount.SAP_State__c='test state';
        testAccount.Phone='4332323323';
        testAccount.Fax='2332322233';
        testAccount.SAP_Customer_Number__c='1234789';
        testAccount.Name='test distributor';        
        insert testAccount;
        
         //set the same SAP number in the controller
         portalRequest.getCustomerNumber().setValue('1234789');
         
         // check the getter method to ensure the SAP customer number is correct         
         System.assertEquals(portalRequest.getCustomerNumber().getValue(),'1234789');
         
         // default value is 'Yes'
         System.assertEquals(portalRequest.getHasInvoice(),'Yes');
         
         //insert another account with same SAP customer number
        Account testAccountDuplicateSAPNumber = new Account();
        testAccountDuplicateSAPNumber.AccountNumber='123456';
        testAccountDuplicateSAPNumber.SAP_Street__c='Street Line1';
        testAccountDuplicateSAPNumber.SAP_StreetSuppl1__c='Street Line2';
        testAccountDuplicateSAPNumber.SAP_StreetSuppl2__c='Street Line3';
        testAccountDuplicateSAPNumber.SAP_StreetSuppl3__c='Stree line4';
        testAccountDuplicateSAPNumber.SAP_City__c='test city';
        testAccountDuplicateSAPNumber.SAP_State__c='test state';
        testAccountDuplicateSAPNumber.Phone='4332323323';
        testAccountDuplicateSAPNumber.Fax='2332322233';
        testAccountDuplicateSAPNumber.SAP_Customer_Number__c='1234789';
        testAccountDuplicateSAPNumber.Name='test distributor';        
        insert testAccountDuplicateSAPNumber;
        
         //submit. error thrown because of duplicate SAP Customer Number
         portalRequest.submit();
        
         testAccountDuplicateSAPNumber.SAP_Customer_Number__c='1234';
         update testAccountDuplicateSAPNumber;
         
         
         
		 //submit portal request
		 // required fields for lead such as last name and company are not populated.
		 portalRequest.submit();
		 
		 //populate the SAP customer number in controller with incorrect value		   
         portalRequest.getCustomerNumber().setValue('12');
          portalRequest.submit();
		
		// repopulate the SAP customer number with the correct value
		 portalRequest.getCustomerNumber().setValue('1234789');
		 portalRequest.getLead().LastName='test lead last Name';
		 portalRequest.getLead().Company='test company';
		 
		 //clear the page messages
		 Apexpages.getMessages().clear();
		 
		 //submit portal request
		 portalRequest.submit();
		 
		 
		 
		 // set SAP customer number as null
		 portalRequest.getCustomerNumber().setValue(null);
		 //set the off book customer name
		 portalRequest.getLead().LastName='test off-book name';
		 portalRequest.getLead().Company='test off-book';
		 // set the hasInvoice to false
		 portalRequest.setHasInvoice('No');
		 // No invoice. off book submit.
		 portalRequest.submit();
		
		
		// reinitialize controller and submit
		portalRequest=new VIPortalAccessRequestController();
		 // set SAP customer number as null
		 portalRequest.getCustomerNumber().setValue(null);
		 //set the off book customer name
		 portalRequest.getLead().LastName='test off-book name';
		 portalRequest.getLead().Company='test off-book';
		 // set the hasInvoice to false
		 portalRequest.setHasInvoice('No');
		 // No invoice. off book submit.
		 portalRequest.submit();
		 
		 portalRequest.cancel();
	}
}