@isTest
private class SAP_Ultimate_Parent_T {

/****************************************************************************
 * Test Class SAP_Ultimate_Parent_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - SAP_Ultimate_Parent Apex Class
 *   - SAP_Ultimate_Parent_Trigger Trigger
 ****************************************************************************/
 
    //Test Data
    private static SAP_Ultimate_Parent__c newUP;
    private static SAP_Ultimate_Parent__c up;
    private static Account acct;
    
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
    	SAP_Ultimate_Parent_Settings__c settings = SAP_Ultimate_Parent_Settings.defaultSettings();
		settings.Account_Owner_Id__c = TestObjects.newUser().Id;
		settings.Account_Owner_Id_When_Deleted__c = TestObjects.newUser().Id;
		settings.SAP_Ultimate_Parent_Trigger_Enabled__c = true;
		update settings;

		up = TestObjects.newSAP_Ultimate_Parent();
    }
  
    private static void executeTest01() {
		/***********************************************************************************
		 * Add an SAP_Ultimate_Parent__c record and verify an associated Account is created
		 ***********************************************************************************/
		 
		// Refresh Results
		up = [SELECT Id, Account__c, Legal_Ultimate_Parent_Name__c, Legal_Ultimate_Parent_Number__c FROM SAP_Ultimate_Parent__c WHERE Id = :up.Id];
		acct = [SELECT Id, Name, AccountNumber, Account_Number__c, SAP_Customer_Number__c, OwnerId FROM Account WHERE Id = :up.Account__c];
		
		// Validate Results are as Expected
		System.assertEquals(up.Legal_Ultimate_Parent_Name__c,acct.Name);        
		System.assertEquals(up.Legal_Ultimate_Parent_Number__c,acct.SAP_Customer_Number__c);        
		System.assertEquals(up.Legal_Ultimate_Parent_Number__c,acct.AccountNumber);        
		System.assertEquals(SAP_Ultimate_Parent.generateUltimateParentKey(up.Legal_Ultimate_Parent_Number__c),acct.Account_Number__c);        
		System.assertEquals(acct.OwnerId,SAP_Ultimate_Parent_Settings__c.getValues('Default').Account_Owner_Id__c);        
		
		/*******************************************************************************************
		 * Update the SAP_Ultimate_Parent__c record and verify the update is applied to the Account
		 *******************************************************************************************/
		// Perform Actions 
		up.Legal_Ultimate_Parent_Name__c = 'TEST NAME 2';
		update up;
		
		// Refresh Results
		up = [SELECT Id, Account__c, Legal_Ultimate_Parent_Name__c, Legal_Ultimate_Parent_Number__c FROM SAP_Ultimate_Parent__c WHERE Id = :up.Id];
		acct = [SELECT Id, Name, AccountNumber, Account_Number__c, SAP_Customer_Number__c, OwnerId FROM Account WHERE Id = :up.Account__c];

			
		// Validate Results are as Expected
		System.assertEquals(up.Legal_Ultimate_Parent_Name__c,acct.Name);        

		/*******************************************************************************************
		 * Delete the SAP_Ultimate_Parent__c record and verify the owner on the Account has changed
		 *******************************************************************************************/
		// Perform Actions 
		Id holdAcctId = up.Account__c;
		delete up;
		
		// Refresh Results
		acct = [SELECT Id, Name, AccountNumber, Account_Number__c, SAP_Customer_Number__c, OwnerId FROM Account WHERE Id = :holdAcctId];
		
		// Validate Results are as Expected
		System.assertEquals(acct.OwnerId,SAP_Ultimate_Parent_Settings__c.getValues('Default').Account_Owner_Id_When_Deleted__c);        
		
		/*****************************************************************************************************
		 * Re-Add the SAP_Ultimate_Parent__c record and confirm it is re-associated with the existing Account
		 *****************************************************************************************************/
		// Perform Actions 
		String upName = up.Legal_Ultimate_Parent_Name__c;
		String upNumber = up.Legal_Ultimate_Parent_Number__c;
		
		up = TestObjects.newSAP_Ultimate_Parent(false);
		up.Legal_Ultimate_Parent_Name__c = upName;
		up.Legal_Ultimate_Parent_Number__c = upNumber;
		insert up;

		// Refresh Results
		up = [SELECT Id, Account__c, Legal_Ultimate_Parent_Name__c, Legal_Ultimate_Parent_Number__c FROM SAP_Ultimate_Parent__c WHERE Id = :up.Id];
		acct = [SELECT Id, Name, AccountNumber, Account_Number__c, SAP_Customer_Number__c, OwnerId FROM Account WHERE Id = :up.Account__c];

		// Validate Results are as Expected
		System.assertEquals(up.Account__c,holdAcctId);        
		
		/*******************************************************************************************************
		 * Delete the Account, the Update the SAP_Ultimate_Parent__c record.  The Account should be re-created.
		 *******************************************************************************************************/
		// Perform Actions 
		delete acct;
		up = [SELECT Id, Account__c, Legal_Ultimate_Parent_Name__c, Legal_Ultimate_Parent_Number__c FROM SAP_Ultimate_Parent__c WHERE Id = :up.Id];
		up.Legal_Ultimate_Parent_Name__c = 'TEST NAME 3';
		update up;

		// Refresh Results
		up = [SELECT Id, Account__c, Legal_Ultimate_Parent_Name__c, Legal_Ultimate_Parent_Number__c FROM SAP_Ultimate_Parent__c WHERE Id = :up.Id];
		acct = [SELECT Id, Name, AccountNumber, Account_Number__c, SAP_Customer_Number__c, OwnerId FROM Account WHERE Id = :up.Account__c];

		// Validate Results are as Expected
		System.assertEquals(up.Legal_Ultimate_Parent_Name__c,acct.Name);        
		
		/************************************************************************************************************************
		 * Delete the SAP_Ultimate_Parent__c record, and then undelete it.  It should be re-associated with the existing account
		 ************************************************************************************************************************/
		// Perform Actions 
		delete up;
		undelete up;
		
		// Refresh Results
		up = [SELECT Id, Account__c, Legal_Ultimate_Parent_Name__c, Legal_Ultimate_Parent_Number__c FROM SAP_Ultimate_Parent__c WHERE Id = :up.Id];
		acct = [SELECT Id, Name, AccountNumber, Account_Number__c, SAP_Customer_Number__c, OwnerId FROM Account WHERE Id = :up.Account__c];

		// Validate Results are as Expected
		System.assertEquals(up.Account__c,acct.Id);        
		System.assertEquals(acct.OwnerId,SAP_Ultimate_Parent_Settings__c.getValues('Default').Account_Owner_Id__c);        

		/***********************************************************************************************
		 * Delete the SAP_Ultimate_Parent__c record, Delete the associate account and then undelete it.  
		 * It should re-create the Account
		 ***********************************************************************************************/
		// Perform Actions 
		delete up;
		delete acct;
		undelete up;
		
		// Refresh Results
		up = [SELECT Id, Account__c, Legal_Ultimate_Parent_Name__c, Legal_Ultimate_Parent_Number__c FROM SAP_Ultimate_Parent__c WHERE Id = :up.Id];
		acct = [SELECT Id, Name, AccountNumber, Account_Number__c, SAP_Customer_Number__c, OwnerId FROM Account WHERE Id = :up.Account__c];

		// Validate Results are as Expected
		System.assertEquals(up.Legal_Ultimate_Parent_Number__c,acct.SAP_Customer_Number__c);        
		System.assertEquals(acct.OwnerId,SAP_Ultimate_Parent_Settings__c.getValues('Default').Account_Owner_Id__c);        
   }
}